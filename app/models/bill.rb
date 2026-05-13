# frozen_string_literal: true

# Represents a bill template or scheduled.
class Bill < ApplicationRecord
  include Bills::Invoiceable

  has_many :invoices, dependent: :destroy

  has_one_attached :company_logo

  enum(
    :payment_method,
    { credit_card: "credit_card", pix: "pix", bank_slip: "bank_slip" }
  )

  validates :title, presence: true
  validates :title, uniqueness: true

  validates :recurrent_due_day, presence: true, if: :recurring?
  validates :due_date, presence: true, if: :non_recurring?

  private

  def non_recurring?
    !recurring?
  end
end
