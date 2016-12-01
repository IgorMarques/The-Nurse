class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.integer :code, null: false
      t.references :service, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
