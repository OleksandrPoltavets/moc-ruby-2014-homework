class AddArchiveIdToExchangeRates < ActiveRecord::Migration
  def change
    add_column :exchange_rates, :archive_id, :integer
  end
end
