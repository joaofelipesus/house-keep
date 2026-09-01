# frozen_string_literal: true

require 'test_helper'

class ExpenseTest < ActiveSupport::TestCase
  test 'requires title, value and spent_on' do
    expense = Expense.new

    assert_not expense.valid?
    assert_includes expense.errors[:title], 'não pode ficar em branco'
    assert_includes expense.errors[:value], 'não pode ficar em branco'
    assert_includes expense.errors[:spent_on], 'não pode ficar em branco'
  end

  test 'is valid with title, value and spent_on' do
    expense = Expense.new(title: 'Mercado', value: 100, spent_on: Date.current)

    assert expense.valid?
  end

  test 'payment_method is optional' do
    expense = Expense.new(title: 'Mercado', value: 100, spent_on: Date.current, payment_method: nil)

    assert expense.valid?
  end

  test 'default category is other' do
    assert_equal 'other', Expense.new.category
  end

  test 'category enum values' do
    expected = %w[groceries food taxes transport health home household_items leisure education other]

    assert_equal expected, Expense.categories.keys
  end

  test 'payment_method enum values' do
    assert_equal %w[credit_card debit_card pix bank_slip cash], Expense.payment_methods.keys
  end

  test 'spent_in only returns expenses inside the period' do
    result = Expense.spent_in(Date.new(2026, 5, 1).all_month)

    assert_includes result, expenses(:may_groceries)
    assert_includes result, expenses(:may_dinner)
    assert_not_includes result, expenses(:april_taxes)
  end

  test 'recent_first orders by spent_on descending' do
    spent_dates = Expense.recent_first.map(&:spent_on)

    assert_equal spent_dates.sort.reverse, spent_dates
  end
end
