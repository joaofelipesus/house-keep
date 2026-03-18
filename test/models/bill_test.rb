# frozen_string_literal: true

require 'test_helper'

class BillTest < ActiveSupport::TestCase
  test 'presence validations' do
    bill = Bill.new

    assert_not bill.valid?
    assert_equal bill.errors[:value], ['can\'t be blank']
    assert_equal bill.errors[:title], ['can\'t be blank']
    assert_equal bill.errors[:due_date], ['can\'t be blank']
  end

  test 'unique validations' do
    bill = Bill.new
    bill.title = bills(:internet).title

    assert_not bill.valid?

    assert_equal bill.errors[:title], ['has already been taken']
  end
end
