require 'billit_representers/representers/paperwork_collection_representer'
class PaperworksController < ApplicationController
  respond_to :json, :xml
  # GET /paperworks
  # GET /paperworks.json
  def index
    @paperworks = Paperwork.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @paperworks }
    end
  end

  # GET /paperworks/1
  # GET /paperworks/1.json
  def show
    @paperwork = Paperwork.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @paperwork }
    end
  end

  # GET /paperworks/new
  # GET /paperworks/new.json
  def new
    @paperwork = Paperwork.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @paperwork }
    end
  end

  # GET /paperworks/1/edit
  def edit
    @paperwork = Paperwork.find(params[:id])
  end

  # POST /paperworks
  # POST /paperworks.json
  def create
    @paperwork = Paperwork.new(params[:paperwork])

    respond_to do |format|
      if @paperwork.save
        format.html { redirect_to @paperwork, notice: 'Paperwork was successfully created.' }
        format.json { render json: @paperwork, status: :created, location: @paperwork }
      else
        format.html { render action: "new" }
        format.json { render json: @paperwork.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /paperworks/1
  # PUT /paperworks/1.json
  def update
    @paperwork = Paperwork.find(params[:id])

    respond_to do |format|
      if @paperwork.update_attributes(params[:paperwork])
        format.html { redirect_to @paperwork, notice: 'Paperwork was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @paperwork.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /paperworks/1
  # DELETE /paperworks/1.json
  def destroy
    @paperwork = Paperwork.find(params[:id])
    @paperwork.destroy

    respond_to do |format|
      format.html { redirect_to paperworks_url }
      format.json { head :no_content }
    end
  end

  # GET paperworks/search.json?q=search_string
  def search
    require 'will_paginate/array'
    # Sunspot.remove_all(Paperwork)   # descomentar para reindexar,
    # Sunspot.index!(Paperwork.all)   # en caso de cambio en modelo
    search = search_for(params)
    @paperworks = search.results
    @paperworks.extend(Billit::PaperworkCollectionRepresenter)
    respond_with @paperworks.to_json(params), represent_with: Billit::PaperworkCollectionRepresenter
  end

  def filter_conditions(conditions)
    @mongoid_attribute_names = ["_id", "created_at"] #FIX should probably have a greater scope
    @search_attribute_names = ["q", "bill_id", "law_text"]
    @range_field_types = [DateTime]
    @range_modifier_min = "_min"
    @range_modifier_max = "_max"

    bill_range_fields = Paperwork.fields.dup
    @range_field_types.each do |type|
      bill_range_fields.reject! {|field_name, metadata| metadata.options[:type]!= type}
    end
    bill_range_attributes = bill_range_fields.keys

    bill_public_attributes = Paperwork.attribute_names - @mongoid_attribute_names

    equivalence_attributes = bill_public_attributes + @search_attribute_names
    range_attributes_min = bill_range_attributes.map {|attribute| attribute + @range_modifier_min}
    range_attributes_max = bill_range_attributes.map {|attribute| attribute + @range_modifier_max}

    filtered_conditions = {}
    equivalence_conditions = {}
    range_conditions_min = {}
    range_conditions_max = {}
    conditions.each do |key, value|
      next if value.nil?() || value == ""
      if equivalence_attributes.include?(key)
        equivalence_conditions[key] = value
      elsif range_attributes_min.include?(key)
        range_conditions_min[key.gsub(@range_modifier_min, "")] = value
      elsif range_attributes_max.include?(key)
        range_conditions_max[key.gsub(@range_modifier_max, "")] = value
      end
    end

    return {equivalence_conditions: equivalence_conditions,\
      range_conditions_min: range_conditions_min, range_conditions_max: range_conditions_max}
  end

  def search_for(conditions)
    filtered_conditions = filter_conditions(conditions)

    search = Sunspot.search(Paperwork) do
      # FIX the equivalence conditions settings should be in a conf file
      # search over all fields
      if filtered_conditions[:equivalence_conditions].key?("q")
        fulltext filtered_conditions[:equivalence_conditions]["q"] do
          # boost_fields :tags => 3.0
          # boost_fields :subject_areas => 2.9
          # boost_fields :title => 2.5
          # boost_fields :abstract => 2.0
        end
        filtered_conditions[:equivalence_conditions].delete("q")
      end
      # search over bill identifiers, both uid and short uid
      if filtered_conditions[:equivalence_conditions].key?("bill_id")
        text_fields do
          any_of do
            with(:uid, filtered_conditions[:equivalence_conditions]["bill_id"])
            with(:short_uid, filtered_conditions[:equivalence_conditions]["bill_id"])
          end
        end
        filtered_conditions[:equivalence_conditions].delete("bill_id")
      end
      #search over specific fields
      text_fields do
        all_of do
          filtered_conditions[:equivalence_conditions].each do |key, value|
            any_of do
              value.split("|").each do |term|
                with(key, term)
              end
            end
          end
        end
      end

      all_of do
        #range_conditions_min might be asdf_min instead of asdf
        filtered_conditions[:range_conditions_min].each do |key, value|
          with(key).greater_than(value)
        end
        filtered_conditions[:range_conditions_max].each do |key, value|
          with(key).less_than(value)
        end
      end

      paginate page:conditions[:page], per_page:conditions[:per_page]
    end
    search
  end

end
