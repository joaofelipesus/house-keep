# frozen_string_literal: true

module ApplicationHelper
  def display_value(value)
    return '-' if value.blank?

    value
  end

  # Every amount in the app is BRL, so the formatting options live here instead of being repeated
  # on each view.
  def money(value)
    number_to_currency(value, unit: 'R$', separator: ',', delimiter: '.')
  end

  # "agosto de 2026" / "August 2026", capitalised for use as a heading.
  def month_title(date)
    l(date, format: :month_year).capitalize
  end
end
