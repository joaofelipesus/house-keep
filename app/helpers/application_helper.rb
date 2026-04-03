# frozen_string_literal: true

module ApplicationHelper
  def display_value(value)
    return '-' if value.blank?

    value
  end
end
