# frozen_string_literal: true

class Invoice < ApplicationRecord
  belongs_to :bill

  validates :due_date, :payment_amount, presence: true

  enum(
    :payment_status,
    { pending: 'pending', paid: 'paid', delayed: 'delayed' },
    default: 'pending'
  )

  # Everything still owed, no matter which month it was due on.
  scope :unpaid, -> { where(payment_status: %i[pending delayed]) }
  scope :due_until, ->(date) { where(due_date: ..date) }

  # What the home page owes the user: still unpaid and already due (or due before the month ends),
  # which keeps invoices carried over from previous months visible until they are settled.
  scope :open_this_month, -> { unpaid.due_until(Date.current.end_of_month).order(:due_date) }

  # Counterpart of open_this_month: what was settled during the current month.
  scope :paid_this_month, -> { paid.where(payment_date: Date.current.all_month).order(payment_date: :desc) }

  def confirm_payment(attributes = {})
    update(attributes.merge(payment_status: :paid))
  end

  def show_current_payment_status
    status_key = due_date < Date.current ? 'delayed' : 'pending'

    I18n.t("activerecord.attributes.invoice.payment_statuses.#{status_key}")
  end
end
