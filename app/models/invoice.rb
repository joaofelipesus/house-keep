class Invoice < ApplicationRecord
  belongs_to :bill

  validates :due_date, presence: true

  enum(
    :payment_status,
    { pending: "pending", paid: "paid", delayed: "delayed" },
    default: "pending"
  )
end
