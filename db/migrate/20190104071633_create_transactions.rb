class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.references :credit, foreign_key: true
      t.references :e_wallet, foreign_key: true
      t.integer :amount
      t.string :confirmation_code
      t.integer :code_status, default: 0
      t.integer :transaction_status, default: 0
      t.string :content

      t.timestamps
    end
  end
end
