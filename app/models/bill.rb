# frozen_string_literal: true

# Represents a bill template or scheduled.
class Bill < ApplicationRecord
  has_one_attached :company_logo

  validates :title, :due_date, presence: true
  validates :title, uniqueness: true
end
