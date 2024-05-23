class DashboardController < ApplicationController
  def index
    data = GenerateGraph::Dashboard.call(start_date: params[:start_date], end_date: params[:end_date])

    unique_users_by_day = data[:unique_users_by_day]
    events_by_day = data[:events_by_day]
    page_views_by_day = data[:page_views_by_day]

    respond_to do |format|
      format.html { render :index, locals: { unique_users_by_day:, events_by_day:, page_views_by_day: } }
      format.json { render json: { unique_users_by_day:, events_by_day:, page_views_by_day: } }
    end
  end
end
