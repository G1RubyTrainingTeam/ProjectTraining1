class CreateEWallets < ActiveRecord::Migration[5.2]
  def change
    create_table :e_wallets do |t|
      t.references :user, foreign_key: true
      t.integer :balances, default: 0

      t.timestamps
    end
  end
end
