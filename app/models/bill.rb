# frozen_string_literal: true

# Represents a bill template or scheduled.
class Bill < ApplicationRecord
  has_one_attached :company_logo

  validates :title, presence: true
  validates :title, uniqueness: true

  validates :recurrent_due_day, presence: true, if: :recurring?
  validates :due_date, presence: true, if: :non_recurring?

  private

  def non_recurring?
    !recurring?
  end
end
