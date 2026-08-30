# frozen_string_literal: true

# Money that actually came in on a given date: a salary deposit, a freelance payment, a refund.
# Unlike CurrentIncome - which holds the single expected monthly income shown on the navbar -
# every record here is a one-off entry that belongs to the month it was received in.
class Income < ApplicationRecord
  validates :title, :value, :received_on, presence: true

  enum(
    :category,
    {
      salary: 'salary',
      freelance: 'freelance',
      investment: 'investment',
      refund: 'refund',
      gift: 'gift',
      other: 'other'
    },
    default: :other
  )

  scope :received_in, ->(period) { where(received_on: period) }
  scope :recent_first, -> { order(received_on: :desc, id: :desc) }
end
