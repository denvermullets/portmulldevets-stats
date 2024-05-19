class Api::V1::VisitController < ApplicationController
  protect_from_forgery with: :null_session

  def create
    user = AddressInfo::Locate.call(ip_address: request.remote_ip)

    Visit.create(
      user_id: user.id,
      event: visit_params[:event],
      operating_system: visit_params[:operating_system],
      screen_size: visit_params[:screen_size],
      referrer: visit_params[:referrer],
      browser: visit_params[:browser],
      device_type: visit_params[:device_type]
    )

    render json: { message: 'message ok' }, status: :ok
  end

  private

  def visit_params
    visit_params = params.require(:visit)

    visit_params.permit(:browser, :operating_system, :screen_size, :referrer, :device_type, :event)
  end
end
