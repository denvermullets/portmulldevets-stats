class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :address, null: false
      t.string :timezone
      t.string :region
      t.string :postal
      t.string :org
      t.string :loc
      t.string :hostname
      t.string :country
      t.string :city

      t.timestamps
    end
  end
end
