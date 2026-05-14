# frozen_string_literal: true

class Bills::CreateInvoiceJob < ApplicationJob
  queue_as :default

  def perform
    Bill.active.where(recurring: true).find_each do |bill|
      next if bill.invoices.where(due_date: Date.current.all_month).any?

      bill.create_invoices!
    end
  end
end
