class Invoice < ApplicationRecord
  belongs_to :bill

  enum :payment_status, { pending: "pending", paid: "paid", delayed: "delayed" }, default: "pending"
end
