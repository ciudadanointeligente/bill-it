# encoding: UTF-8
require 'billit_representers/representers/bill_representer'
require 'billit_representers/representers/bills_representer'

class BillsController < ApplicationController
  include Roar::Rails::ControllerAdditions
  represents :json, :entity => Billit::BillRepresenter, :collection => Billit::BillsRepresenter
  respond_to :json
  # GET /bills
  # GET /bills.json
  def index
    @bills = Bill.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @bills }
    end
  end

  # GET /bills/1.json
  def show
    @bill = Bill.find_by(uid: params[:id])
    respond_with @bill, :represent_with => Billit::BillRepresenter
  end

  # GET /bills/search.json?q=search_string
  def search
    # Sunspot.remove_all(Bill)   # descomentar para reindexar,
    # Sunspot.index!(Bill.all)   # en caso de cambio en modelo
    search = results_for(params)

    @bills = []
    if search.hits.empty?
      key = ''
    else
      search.hits.each do |hit|
        @bills.push Bill.find_by(id: hit.primary_key)
      end
    end
    respond_with @bills, represent_with: Billit::BillsRepresenter
  end

  # GET /bills/new
  # GET /bills/new.json
  def new
    @bill = Bill.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @bill }
    end
  end

  # GET /bills/1/edit
  def edit
    @bill = Bill.find(params[:id])
  end

  # POST /bills
  # POST /bills.json
  def create
    @bill = Bill.new
    @bill.extend(Billit::BillRepresenter)
    @bill.from_json(params[:bill])
    @bill.save
    respond_with @bill, :represent_with => Billit::BillRepresenter
  end

  # PUT /bills/1
  # PUT /bills/1.json
  def update
    @bill = Bill.find(params[:id])

    respond_to do |format|
      if @bill.update_attributes(params[:bill])
        format.html { redirect_to @bill, notice: 'Bill was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @bill.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bills/1
  # DELETE /bills/1.json
  def destroy
    @bill = Bill.find(params[:id])
    @bill.destroy

    respond_to do |format|
      format.html { redirect_to bills_url }
      format.json { head :no_content }
    end
  end

  def filter_conditions(conditions)
    @mongoid_attribute_names = ["_id", "created_at", "updated_at"] #Fix should probably have a greater scope
    @search_attribute_names = ["q"]
    @range_field_types = [Time]
    @range_modifier_min = "_min"
    @range_modifier_max = "_max"

    bill_range_fields = Bill.fields.dup
    @range_field_types.each do |type|
      bill_range_fields.reject! {|field_name, metadata| metadata.options[:type]!= type}
    end
    bill_range_attributes = bill_range_fields.keys

    bill_public_attributes = Bill.attribute_names - @mongoid_attribute_names

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

  def results_for(conditions)
    filtered_conditions = filter_conditions(conditions)

    search = Sunspot.search(Bill) do
      # search over all fields
      if filtered_conditions[:equivalence_conditions].key?("q")
        fulltext filtered_conditions[:equivalence_conditions]["q"]
        filtered_conditions[:equivalence_conditions].delete("q")
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
    end
    search
  end

  def last_update
    @date = Bill.max(:updated_at).strftime("%d/%m/%Y")
    render :text => @date
  end

end
