class AddPaymentAmountToInvoices < ActiveRecord::Migration[8.1]
  def change
    add_column :invoices, :payment_amount, :decimal, precision: 10, scale: 2, comment: "The actual amount paid for the invoice"
  end
end
