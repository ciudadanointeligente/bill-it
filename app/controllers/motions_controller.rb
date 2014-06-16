# encoding: UTF-8
# require 'billit_representers/models/motion'
# require 'billit_representers/models/motion_page'
require 'billit_representers/representers/motion_representer'
# require 'billit_representers/representers/bill_representer'
# require 'billit_representers/representers/motion_page_representer'
# Dir['./app/models/billit/*'].each { |model| require model }

class MotionsController < InheritedResources::Base
  include Roar::Rails::ControllerAdditions
  respond_to :json, :xml, :html
  def show
    # if params[:fields]
    #   fields = params[:fields].split(',')
    #   @bill = Bill.only(fields).find_by(uid: params[:id])
    #   # render json: @bill.to_json(only: fields)
    #   respond_with @bill, :callback => params['callback'], :represent_with => Billit::BillBasicRepresenter
    # else
      @motion = Motion.find(params[:id])
      if @motion.nil?
        render text: "", :status => 404
      else
        respond_with @motion, :represent_with => Billit::MotionRepresenter
        # respond_with @motion, :callback => params['callback'], :represent_with => Billit::MotionRepresenter
      end
    # end
  end
end
