# frozen_string_literal: true

module Bills
  class CreateInvoiceJob < ApplicationJob
    queue_as :default

    def perform
      Bill.active.where(recurring: true).find_each(&:create_invoice!)
    end
  end
end
