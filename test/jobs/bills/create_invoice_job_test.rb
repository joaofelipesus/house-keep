# frozen_string_literal: true

require 'test_helper'

class Bills::CreateInvoiceJobTest < ActiveJob::TestCase
  setup do
    travel_to Date.new(2026, 5, 1)
  end

  teardown do
    travel_back
  end

  test 'creates invoice for active recurring bill without a current-month invoice' do
    assert_difference -> { bills(:phone).invoices.count }, 1 do
      Bills::CreateInvoiceJob.perform_now
    end
  end

  test 'skips bill that already has a current-month invoice' do
    assert_no_difference -> { bills(:internet).invoices.count } do
      Bills::CreateInvoiceJob.perform_now
    end
  end

  test 'skips inactive recurring bills' do
    assert_no_difference -> { bills(:streaming).invoices.count } do
      Bills::CreateInvoiceJob.perform_now
    end
  end

  test 'skips non-recurring bills' do
    assert_no_difference -> { bills(:gym).invoices.count } do
      Bills::CreateInvoiceJob.perform_now
    end
  end
end
