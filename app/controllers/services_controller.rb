class ServicesController < ApplicationController
  def index
    @active_services = Service.active
    @inactive_services = Service.inactive
  end

  def show
    @service = Service.find(params[:id])
  end

  def new
    @service = Service.new
  end

  def create
    @service = Service.new(service_params)

    if @service.save
      flash[:notice] = "Service registered with success"
      redirect_to @service
    else
      flash[:alert] = "Oops, please check your input"
      redirect_to new_service_path
    end
  end

  private

  def service_params
    params[:service].permit(:name, :url)
  end
end
