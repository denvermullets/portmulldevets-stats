class UsersController < ApplicationController
  def index
    users = User.joins(:events)
                .where(created_at: 30.days.ago..Time.now)
                .distinct

    respond_to do |format|
      format.html { render :index, locals: { users: } }
      format.json { render json: users }
    end
  end
end
