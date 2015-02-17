class CreateExchangeRatesTable < ActiveRecord::Migration
  def change
    create_table :exchange_rates do |t|
      t.string :currency
      t.float :sale_rate_nb
      t.float :purchase_rate_nb
      t.float :sale_rate
      t.float :purchase_rate
      t.timestamps null: false
    end
  end
end
