class CreateBills < ActiveRecord::Migration[8.1]
  def change
    create_table :bills do |t|
      t.timestamps

      t.boolean :recurring, comment: 'Define if the bill is paid every month'
      t.decimal :value, precision: 10, scale: 2, null: false, comment: 'bill value'
      t.string :title, null: false, comment: 'a simple description'
      t.date :due_date, null: false, comment: 'when the bill is charged'
      t.text :description, comment: 'an optional text with a detailed description'
      t.string :payment_method, comment: 'An enum with the payment method, e.g. credit card, or pix'
    end

    add_index :bills, :title, unique: true
  end
end
