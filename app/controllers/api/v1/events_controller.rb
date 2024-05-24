class Api::V1::EventsController < ApplicationController
  protect_from_forgery with: :null_session

  def create
    user = AddressInfo::Locate.call(ip_address: request.remote_ip)

    # mass assignment for params but need to add id
    Event.create(event_params.merge(user_id: user.id))

    render json: { message: 'message ok' }, status: :ok
  end

  private

  def event_params
    event_params = params.require(:event)

    event_params.permit(
      :browser, :operating_system, :screen_size,
      :referrer, :device_type, :name, :tag, :target
    )
  end
end
