class CurrentIncome < ApplicationRecord
  validates :value, presence: true

  # can be only one active income
  before_create :outdate_previous_active

  enum :status, { active: "active", outdated: "outdated" }, default: "active"

  private

  def outdate_previous_active
    CurrentIncome.active.update_all(status: "outdated")
  end
end
