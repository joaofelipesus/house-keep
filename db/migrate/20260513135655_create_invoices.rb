class CreateInvoices < ActiveRecord::Migration[8.1]
  def change
    create_table :invoices, comment: 'Invoices related to a bill, is the model that store the act of payment' do |t|
      t.timestamps

      t.belongs_to :bill, null: false, foreign_key: true
      t.string :payment_status, null: false, default: 'pending', comment: 'A enum with the payment status of the invoice (pending, paid, delayed)'
      t.date :payment_date, comment: 'The date when the bill was paid'
      t.text :comment, comment: 'A optional description of the invoice'
    end
  end
end
