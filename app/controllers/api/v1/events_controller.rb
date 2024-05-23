class Api::V1::EventsController < ApplicationController
  protect_from_forgery with: :null_session

  def create
    user = AddressInfo::Locate.call(ip_address: request.remote_ip)

    Event.create(
      user_id: user.id,
      name: event_params[:name],
      operating_system: event_params[:operating_system],
      screen_size: event_params[:screen_size],
      referrer: event_params[:referrer],
      browser: event_params[:browser],
      device_type: event_params[:device_type]
    )

    render json: { message: 'message ok' }, status: :ok
  end

  private

  def event_params
    event_params = params.require(:event)

    event_params.permit(:browser, :operating_system, :screen_size, :referrer, :device_type, :name)
  end
end
