class ChangeEventColumnToName < ActiveRecord::Migration[7.1]
  def change
    rename_column :events, :event, :name
  end
end
