class CreateTrades < ActiveRecord::Migration[6.1]
  def change
    create_table :trades do |trade|
      trade.integer :portfolio_id
      trade.integer :crypto_id
      trade.integer :count
    end
  end
end
