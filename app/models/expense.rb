# frozen_string_literal: true

# A one-off spend that is not worth a Bill: groceries, a dinner, a tax, a repair. Bills model
# something that repeats and generates invoices month after month; an expense happens once, on
# a single date, and shows up only on that month's statement.
class Expense < ApplicationRecord
  validates :title, :value, :spent_on, presence: true

  enum(
    :category,
    {
      groceries: 'groceries',
      food: 'food',
      taxes: 'taxes',
      transport: 'transport',
      health: 'health',
      home: 'home',
      household_items: 'household_items',
      leisure: 'leisure',
      education: 'education',
      other: 'other'
    },
    default: :other
  )

  enum(
    :payment_method,
    {
      credit_card: 'credit_card',
      debit_card: 'debit_card',
      pix: 'pix',
      bank_slip: 'bank_slip',
      cash: 'cash'
    }
  )

  scope :spent_in, ->(period) { where(spent_on: period) }
  scope :recent_first, -> { order(spent_on: :desc, id: :desc) }
end
