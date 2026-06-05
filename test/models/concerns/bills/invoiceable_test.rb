# frozen_string_literal: true

require 'test_helper'

class BillsTest < ActiveSupport::TestCase
  test 'creates invoice for non-recurring bill' do
    bill = Bill.create_bill_with_invoices(
      title: 'Água',
      value: 80.00,
      recurring: false,
      due_date: Date.new(2026, 6, 10)
    )

    invoice = Invoice.find_by(bill: bill)

    assert bill.persisted?
    assert_not_nil invoice
    assert_equal Date.new(2026, 6, 10), invoice.due_date
    assert_equal 80.00, invoice.payment_amount.to_f
  end

  test 'creates invoice for recurring bill' do
    travel_to Date.new(2026, 5, 1) do
      bill = Bill.create_bill_with_invoices(
        title: 'Streaming',
        value: 45.90,
        recurring: true,
        recurrent_due_day: 28
      )

      invoice = Invoice.find_by(bill: bill)

      assert bill.persisted?
      assert_not_nil invoice
      assert_equal Date.new(2026, 5, 28), invoice.due_date
      assert_equal 45.90, invoice.payment_amount.to_f
    end
  end

  test 'returns bill with errors when params are invalid' do
    bill = Bill.create_bill_with_invoices(
      value: 50.00,
      recurring: false,
      due_date: Time.zone.today
    )

    assert_not bill.persisted?
    assert_equal ['não pode ficar em branco'], bill.errors[:title]
  end
end
