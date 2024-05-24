class AddTagToEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :tag, :string
    add_column :events, :target, :string
  end
end
