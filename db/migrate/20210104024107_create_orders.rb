class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.datetime :paid_at
      t.datetime :cancled_at
      t.integer :status
      t.integer :total
      t.references :user, null: false, foreign_key: true
      t.string :number
      t.string :zipcode
      t.string :address1
      t.string :address2

      t.timestamps
    end
    add_index :orders, :number
  end
end
