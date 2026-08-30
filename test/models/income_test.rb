# frozen_string_literal: true

require 'test_helper'

class IncomeTest < ActiveSupport::TestCase
  test 'requires title, value and received_on' do
    income = Income.new

    assert_not income.valid?
    assert_includes income.errors[:title], 'não pode ficar em branco'
    assert_includes income.errors[:value], 'não pode ficar em branco'
    assert_includes income.errors[:received_on], 'não pode ficar em branco'
  end

  test 'is valid with title, value and received_on' do
    income = Income.new(title: 'Salário', value: 100, received_on: Date.current)

    assert income.valid?
  end

  test 'default category is other' do
    assert_equal 'other', Income.new.category
  end

  test 'category enum values' do
    assert_equal %w[salary freelance investment refund gift other], Income.categories.keys
  end

  test 'received_in only returns incomes inside the period' do
    result = Income.received_in(Date.new(2026, 5, 1).all_month)

    assert_includes result, incomes(:may_salary)
    assert_includes result, incomes(:may_freelance)
    assert_not_includes result, incomes(:april_salary)
  end

  test 'recent_first orders by received_on descending' do
    received_dates = Income.recent_first.map(&:received_on)

    assert_equal received_dates.sort.reverse, received_dates
  end
end
