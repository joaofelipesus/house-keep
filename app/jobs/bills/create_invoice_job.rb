# frozen_string_literal: true

class Bills::CreateInvoiceJob < ApplicationJob
  queue_as :default

  def perform
    Bill.active.where(recurring: true).find_each do |bill|
      bill.create_invoice!
    end
  end
end
