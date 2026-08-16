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

  test 'creates the invoice when the new due day is still on time and no open invoice exists' do
    travel_to Date.new(2026, 5, 20) do
      bill = Bill.create(title: 'Energia', value: 70.00, recurring: true, recurrent_due_day: 10)

      assert_empty bill.invoices

      assert_difference('Invoice.count', 1) do
        assert bill.update_bill_with_invoices(recurrent_due_day: 28)
      end

      assert_equal Date.new(2026, 5, 28), bill.invoices.sole.due_date
    end
  end

  test 'moves the open invoice instead of creating a second one' do
    travel_to Date.new(2026, 5, 1) do
      bill = Bill.create_bill_with_invoices(
        title: 'Streaming', value: 45.90, recurring: true, recurrent_due_day: 28
      )

      assert_equal Date.new(2026, 5, 28), bill.invoices.sole.due_date

      assert_no_difference('Invoice.count') do
        assert bill.update_bill_with_invoices(recurrent_due_day: 15, value: 50.00)
      end

      invoice = bill.invoices.sole

      assert_equal Date.new(2026, 5, 15), invoice.due_date
      assert_equal 50.00, invoice.payment_amount.to_f
    end
  end

  test 'keeps unpaid invoices from past months untouched' do
    travel_to Date.new(2026, 5, 20) do
      bill = Bill.create(title: 'Água', value: 80.00, recurring: true, recurrent_due_day: 10)
      overdue = bill.invoices.create!(payment_status: :pending, payment_amount: 80.00, due_date: Date.new(2026, 4, 10))

      assert_difference('Invoice.count', 1) do
        assert bill.update_bill_with_invoices(recurrent_due_day: 25)
      end

      assert_equal Date.new(2026, 4, 10), overdue.reload.due_date
      assert_equal Date.new(2026, 5, 25), bill.invoices.order(:due_date).last.due_date
    end
  end

  test 'rolls back and keeps errors when update params are invalid' do
    bill = bills(:internet)

    assert_no_difference('Invoice.count') do
      assert_not bill.update_bill_with_invoices(title: '')
    end

    assert_equal ['não pode ficar em branco'], bill.errors[:title]
    assert_equal 'Internet Bill', bill.reload.title
  end
end
