# frozen_string_literal: true

require 'test_helper'

class BillTest < ActiveSupport::TestCase
  test 'presence validations' do
    bill = Bill.new

    assert_not bill.valid?
    assert_equal bill.errors[:title], ['não pode ficar em branco']
    assert_equal bill.errors[:due_date], ['não pode ficar em branco']
  end

  test 'value is required' do
    bill = Bill.new(title: 'Test', recurring: false, due_date: Date.current)

    assert_not bill.valid?
    assert_equal bill.errors[:value], ['não pode ficar em branco']
  end

  test 'unique validations' do
    bill = Bill.new
    bill.title = bills(:internet).title

    assert_not bill.valid?

    assert_equal bill.errors[:title], ['já está em uso']
  end

  test 'defaults recurring_status to active' do
    bill = Bill.new

    assert_equal 'active', bill.recurring_status
  end

  test 'recurring_status enum values' do
    assert_equal({ 'active' => 'active', 'inactive' => 'inactive' }, Bill.recurring_statuses)
  end
end
