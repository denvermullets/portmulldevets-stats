class CreateVisits < ActiveRecord::Migration[7.1]
  def change
    create_table :visits do |t|
      t.string :event
      t.string :browser
      t.string :operating_system
      t.string :screen_size
      t.string :referrer
      t.string :device_type
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
