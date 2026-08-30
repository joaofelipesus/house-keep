# frozen_string_literal: true

require 'test_helper'

class MonthlyStatementTest < ActiveSupport::TestCase
  MAY = Date.new(2026, 5, 1)

  test 'for parses a YYYY-MM param' do
    assert_equal MAY, MonthlyStatement.for('2026-05').month
  end

  test 'for falls back to the current month when the param is missing' do
    travel_to Date.new(2026, 5, 25) do
      assert_equal MAY, MonthlyStatement.for(nil).month
    end
  end

  test 'for falls back to the current month when the param is malformed' do
    travel_to Date.new(2026, 5, 25) do
      assert_equal MAY, MonthlyStatement.for('not-a-month').month
      assert_equal MAY, MonthlyStatement.for('2026-13').month
      assert_equal MAY, MonthlyStatement.for('2026-5').month
    end
  end

  test 'initialize normalises any date to the first day of its month' do
    assert_equal MAY, MonthlyStatement.new(Date.new(2026, 5, 25)).month
  end

  test 'incomes only include the ones received in the month' do
    statement = MonthlyStatement.new(MAY)

    assert_equal [incomes(:may_salary), incomes(:may_freelance)], statement.incomes
  end

  test 'expenses only include the ones spent in the month' do
    statement = MonthlyStatement.new(MAY)

    assert_equal [expenses(:may_groceries), expenses(:may_dinner)], statement.expenses
  end

  test 'invoices include paid and unpaid ones due in the month' do
    statement = MonthlyStatement.new(MAY)

    assert_includes statement.invoices, invoices(:paid_invoice)
    assert_includes statement.invoices, invoices(:pending_invoice)
    assert_not_includes statement.invoices, invoices(:delayed_invoice)
  end

  test 'totals sum each section' do
    statement = MonthlyStatement.new(MAY)

    assert_equal 6200.00, statement.incomes_total
    assert_equal 199.80, statement.invoices_total
    assert_equal 590.00, statement.expenses_total
  end

  test 'outcomes_total adds invoices and expenses' do
    statement = MonthlyStatement.new(MAY)

    assert_equal 789.80, statement.outcomes_total
  end

  test 'balance is what is left after every outcome' do
    statement = MonthlyStatement.new(MAY)

    assert_equal 5410.20, statement.balance
  end

  test 'balance is negative when outcomes are bigger than incomes' do
    Income.where(id: [incomes(:may_salary).id, incomes(:may_freelance).id]).destroy_all

    assert_predicate MonthlyStatement.new(MAY).balance, :negative?
  end

  test 'an invoice without payment_amount does not break the total' do
    invoices(:pending_invoice).update_columns(payment_amount: nil)

    assert_equal 99.90, MonthlyStatement.new(MAY).invoices_total
  end

  test 'prev_month and next_month step one month at a time' do
    statement = MonthlyStatement.new(MAY)

    assert_equal Date.new(2026, 4, 1), statement.prev_month
    assert_equal Date.new(2026, 6, 1), statement.next_month
  end

  test 'current? is true only for the running month' do
    travel_to Date.new(2026, 5, 25) do
      assert_predicate MonthlyStatement.new(MAY), :current?
      assert_not_predicate MonthlyStatement.new(Date.new(2026, 4, 1)), :current?
    end
  end

  test 'empty? is true when the month has nothing at all' do
    assert_predicate MonthlyStatement.new(Date.new(2020, 1, 1)), :empty?
    assert_not_predicate MonthlyStatement.new(MAY), :empty?
  end

  test 'to_param round-trips through for' do
    statement = MonthlyStatement.new(MAY)

    assert_equal '2026-05', statement.to_param
    assert_equal MAY, MonthlyStatement.for(statement.to_param).month
  end
end
