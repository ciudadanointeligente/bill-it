require 'billit_representers/representers/bill_representer'
require 'billit_representers/representers/bills_representer'

class BillsController < ApplicationController
  include Roar::Rails::ControllerAdditions
  represents :json, :entity => Billit::BillRepresenter, :collection => Billit::BillsRepresenter
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
    @bill = Bill.new(params[:bill])

    respond_to do |format|
      if @bill.save
        format.html { redirect_to @bill, notice: 'Bill was successfully created.' }
        format.json { render json: @bill, status: :created, location: @bill }
      else
        format.html { render action: "new" }
        format.json { render json: @bill.errors, status: :unprocessable_entity }
      end
    end
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
    mongoid_attribute_names = ["_id", "created_at", "updated_at"] #Fix should probably have a greater scope
    search_attribute_names = ["q"]
    filtered_conditions = {}
    conditions.each do |key, value|
        if !value.nil?() && value != "" && search_attribute_names.include?(key)
          filtered_conditions[key] = value
        end
    end
    filtered_conditions
  end

  def results_for(conditions)
    filtered_conditions = filter_conditions(conditions)
    search = Sunspot.search(Bill) do
      # search over all fields
      if filtered_conditions.key?("q")
        fulltext conditions["q"]
        filtered_conditions.delete("q")
      end
    end
    search
  end

end
