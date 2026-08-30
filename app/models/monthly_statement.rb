# frozen_string_literal: true

# Read-only view of a single month. Nothing is persisted here: the statement is rebuilt from the
# incomes received, the bill invoices due and the one-off expenses spent inside the month, so that
# a single page can answer "what came in, what went out and what is left".
class MonthlyStatement
  MONTH_PARAM = /\A(\d{4})-(\d{2})\z/

  attr_reader :month

  # The months the navigation arrows point at.
  delegate :prev_month, :next_month, to: :month

  # Builds a statement from a "YYYY-MM" param, falling back to the current month when the param
  # is missing or does not describe a real month.
  def self.for(month_param)
    new(parse_month(month_param))
  end

  def self.parse_month(value)
    match = MONTH_PARAM.match(value.to_s)

    return Date.current.beginning_of_month if match.nil?

    Date.new(match[1].to_i, match[2].to_i, 1)
  rescue Date::Error
    Date.current.beginning_of_month
  end
  private_class_method :parse_month

  def initialize(month = Date.current)
    @month = month.beginning_of_month
  end

  def period
    month.all_month
  end

  def incomes
    @incomes ||= Income.received_in(period).order(:received_on, :id).to_a
  end

  # Bill invoices are grouped by due date: an invoice belongs to the month it is charged on,
  # whether or not it has been paid yet.
  def invoices
    @invoices ||= Invoice.due_in(period).includes(:bill).order(:due_date, :id).to_a
  end

  def expenses
    @expenses ||= Expense.spent_in(period).order(:spent_on, :id).to_a
  end

  def incomes_total
    @incomes_total ||= incomes.sum(&:value)
  end

  def invoices_total
    @invoices_total ||= invoices.sum { |invoice| invoice.payment_amount || 0 }
  end

  def expenses_total
    @expenses_total ||= expenses.sum(&:value)
  end

  def outcomes_total
    invoices_total + expenses_total
  end

  def balance
    incomes_total - outcomes_total
  end

  def current?
    month == Date.current.beginning_of_month
  end

  def empty?
    incomes.empty? && invoices.empty? && expenses.empty?
  end

  def to_param
    month.strftime('%Y-%m')
  end
end
