# frozen_string_literal: true

module Bills
  module Invoiceable
    extend ActiveSupport::Concern

    class_methods do
      def create_bill_with_invoices(bill_params)
        bill = Bill.new(bill_params)

        transaction do
          bill.save!
          bill.create_invoice!
        rescue ActiveRecord::RecordInvalid => e
          bill.errors.add(:base, e.message) if bill.errors.empty?
        end

        bill
      end
    end

    def create_invoice!
      return if invoices.where(due_date: Date.current.all_month).any?

      invoice = Invoice.new(bill: self, payment_status: :pending, payment_amount: value)

      invoice.due_date = if non_recurring?
                           due_date
                         else
                           next_invoice_non_recurring_due_date
                         end

      invoice.save!
    end

    private

    def next_invoice_non_recurring_due_date
      if recurrent_due_day > Date.current.day
        # Haven't reached the due day this month yet - use current month
        Date.current.change(day: recurrent_due_day)
      else
        # Already passed the due day this month - use next month
        Date.current.next_month.change(day: recurrent_due_day)
      end
    end
  end
end
