class DashboardController < ApplicationController
  include Pagy::Backend

  def index
    data = GenerateGraph::Dashboard.call(start_date: params[:start_date], end_date: params[:end_date])

    unique_users_by_day = data[:unique_users_by_day]
    events_by_day = data[:events_by_day]
    page_views_by_day = data[:page_views_by_day]

    @pagy, events_by_range = pagy(data[:events_by_range])

    respond_to do |format|
      format.html do
        render :index, locals: {
          unique_users_by_day:, events_by_day:, page_views_by_day:, events_by_range:
        }
      end
      format.json do
        render json: { unique_users_by_day:, events_by_day:, page_views_by_day:, events_by_range: }
      end
    end
  end
end
