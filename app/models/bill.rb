class Bill < ApplicationRecord
  validates :title, :value, :due_date, presence: true
  validates :title, uniqueness: true
end
