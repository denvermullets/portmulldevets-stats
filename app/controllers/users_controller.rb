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
  end
end
