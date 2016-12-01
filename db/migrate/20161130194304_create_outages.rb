class CreateOutages < ActiveRecord::Migration[5.0]
  def change
    create_table :outages do |t|
      t.references :service, foreign_key: true
      t.integer :codes, array: true

      t.timestamps
    end
  end
end
