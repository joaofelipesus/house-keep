class AddDueDateToInvoices < ActiveRecord::Migration[8.1]
  def change
    add_column :invoices, :due_date, :date, null: false, comment: "The date when the invoice is due"
  end
end
