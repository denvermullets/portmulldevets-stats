class ChangeVisitsToEvents < ActiveRecord::Migration[7.1]
  def change
    rename_table :visits, :events
  end
end
