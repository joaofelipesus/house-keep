# frozen_string_literal: true

class CurrentIncome < ApplicationRecord
  validates :value, presence: true

  # can be only one active income
  before_create :outdate_previous_active

  enum :status, { active: 'active', outdated: 'outdated' }, default: 'active'

  private

  # rubocop:disable Rails/SkipsModelValidations
  def outdate_previous_active
    CurrentIncome.active.update_all(status: 'outdated')
  end
  # rubocop:enable Rails/SkipsModelValidations
end
