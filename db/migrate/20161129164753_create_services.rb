class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.string :name, null: false
      t.string :url, null: false
      t.boolean :active, default: true
      t.integer :allowed_codes, array: true

      t.timestamps null: false
    end
  end
end
