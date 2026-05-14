# frozen_string_literal: true

class Invoice < ApplicationRecord
  belongs_to :bill

  validates :due_date, :payment_amount, presence: true

  enum(
    :payment_status,
    { pending: 'pending', paid: 'paid', delayed: 'delayed' },
    default: 'pending'
  )

  def show_current_payment_status
    status_key = due_date < Date.current ? 'delayed' : 'pending'

    I18n.t("activerecord.attributes.invoice.payment_statuses.#{status_key}")
  end
end
