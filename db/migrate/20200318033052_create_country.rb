class CreateCountry < ActiveRecord::Migration[6.0]
  def change
    create_table :countries do |t|
      t.string :name
      t.string :slug
      t.integer :confirmed
      t.integer :recovered
      t.integer :deaths

      t.timestamps null: false
    end
  end
end
