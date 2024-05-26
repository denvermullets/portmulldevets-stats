module ApplicationHelper
  include Pagy::Frontend

  def turbo_pagy_nav(pagy, start_date, end_date)
    render partial: 'shared/pagy_nav', locals: { pagy:, start_date:, end_date: }
  end
end
