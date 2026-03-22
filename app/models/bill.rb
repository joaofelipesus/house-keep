# frozen_string_literal: true

class Bill < ApplicationRecord
  has_one_attached :company_logo

  validates :title, :value, :due_date, presence: true
  validates :title, uniqueness: true
end
