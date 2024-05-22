class EventsController < ApplicationController
  def index
    events = Event.where(created_at: 30.days.ago..Time.now)
                  .order(:created_at)
                  .includes(:user)

    respond_to do |format|
      format.html { render :index, locals: { events: } }
      format.json { render json: events.to_json(include: :user) }
    end
  end
end
