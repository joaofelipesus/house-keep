# frozen_string_literal: true

require 'test_helper'

class BillTest < ActiveSupport::TestCase
  test 'presence validations' do
    bill = Bill.new

    assert_not bill.valid?
    assert_equal bill.errors[:title], ['não pode ficar em branco']
    assert_equal bill.errors[:due_date], ['não pode ficar em branco']
  end

  test 'unique validations' do
    bill = Bill.new
    bill.title = bills(:internet).title

    assert_not bill.valid?

    assert_equal bill.errors[:title], ['já está em uso']
  end
end
