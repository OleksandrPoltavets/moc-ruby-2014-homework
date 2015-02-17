class CreateArchivesTable < ActiveRecord::Migration
  def change
    create_table :archives do |t|
      t.date :request_date
      t.string :base_currency
      t.timestamps null: false
    end
  end
end
