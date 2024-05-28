class UsersController < ApplicationController
  include Pagy::Backend

  def index
    @start_date = params[:start_date] ? Date.parse(params[:start_date]) : 30.days.ago.to_date
    @end_date = params[:end_date] ? Date.parse(params[:end_date]) : Date.today

    @pagy, users = pagy(User.where(created_at: @start_date..@end_date))

    respond_to do |format|
      format.html { render :index, locals: { users: } }
      format.json { render json: users }
    end
  end

  def show
    @start_date = params[:start_date] ? Date.parse(params[:start_date]) : 30.days.ago.to_date
    @end_date = params[:end_date] ? Date.parse(params[:end_date]) : Date.today

    user = User.find(params[:id])

    @pagy, events = pagy(Event.where(user:, created_at: @start_date..@end_date).order(created_at: :asc))

    respond_to do |format|
      format.html { render :show, locals: { user:, events: } }
      format.json { render json: users }
    end
  end
end
