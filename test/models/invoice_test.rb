# frozen_string_literal: true

require 'test_helper'

class InvoiceTest < ActiveSupport::TestCase
  test 'requires a bill' do
    invoice = Invoice.new(payment_status: :pending, due_date: Time.zone.today)

    assert_not invoice.valid?
    assert_equal invoice.errors[:bill], ['é obrigatório(a)']
  end

  test 'requires a due_date' do
    invoice = Invoice.new(payment_status: :pending)

    assert_not invoice.valid?
    assert_equal invoice.errors[:due_date], ['não pode ficar em branco']
  end

  test 'requires a payment_amount' do
    invoice = Invoice.new(payment_status: :pending)

    assert_not invoice.valid?
    assert_equal invoice.errors[:payment_amount], ['não pode ficar em branco']
  end

  test 'defaults payment_status to pending' do
    invoice = Invoice.new
    assert invoice.pending?
  end

  test 'payment_status enum values' do
    assert_equal Invoice.payment_statuses, { 'pending' => 'pending', 'paid' => 'paid', 'delayed' => 'delayed' }
  end

  test '.show_current_payment_status' do
    invoice = Invoice.new

    invoice.due_date = 3.days.ago
    assert_equal invoice.show_current_payment_status, I18n.t('activerecord.attributes.invoice.payment_statuses.delayed')

    invoice.due_date = 3.days.from_now
    assert_equal invoice.show_current_payment_status, I18n.t('activerecord.attributes.invoice.payment_statuses.pending')
  end
end
