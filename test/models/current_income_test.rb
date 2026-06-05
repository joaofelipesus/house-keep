# frozen_string_literal: true

require 'test_helper'

class CurrentIncomeTest < ActiveSupport::TestCase
  test 'requires value' do
    income = CurrentIncome.new(value: nil)
    assert_not income.valid?
    assert_includes income.errors[:value], 'não pode ficar em branco'
  end

  test 'default status is active' do
    income = CurrentIncome.new(value: 5000)
    assert_equal 'active', income.status
  end

  test 'status enum values' do
    assert_equal %w[active outdated], CurrentIncome.statuses.keys
  end

  test 'creating a new income outdates previous active incomes' do
    active = current_incomes(:active_income)
    assert active.active?

    CurrentIncome.create!(value: 6000)

    assert active.reload.outdated?
  end

  test 'creating a new income does not affect already outdated records' do
    outdated = current_incomes(:outdated_income)
    assert outdated.outdated?

    CurrentIncome.create!(value: 6000)

    assert outdated.reload.outdated?
  end
end
