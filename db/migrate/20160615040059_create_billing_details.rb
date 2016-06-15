class CreateBillingDetails < ActiveRecord::Migration
  def change
    create_table :billing_details do |t|
      t.string :event
      t.date :paid_date
      t.text :location
      t.decimal :total_amount
      t.string :name
      t.decimal :amount

      t.timestamps null: false
    end
  end
end
