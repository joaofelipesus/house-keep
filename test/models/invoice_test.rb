require "test_helper"

class InvoiceTest < ActiveSupport::TestCase
  test "requires a bill" do
    invoice = Invoice.new(payment_status: :pending, due_date: Date.today)

    assert_not invoice.valid?
    assert_equal invoice.errors[:bill], ["é obrigatório(a)"]
  end

  test "requires a due_date" do
    invoice = Invoice.new(payment_status: :pending)

    assert_not invoice.valid?
    assert_equal invoice.errors[:due_date], ["não pode ficar em branco"]
  end

  test "defaults payment_status to pending" do
    invoice = Invoice.new
    assert invoice.pending?
  end

  test "payment_status enum values" do
    assert_equal Invoice.payment_statuses, { 'pending' =>  "pending", 'paid' => "paid", 'delayed' => "delayed" }
  end
end
