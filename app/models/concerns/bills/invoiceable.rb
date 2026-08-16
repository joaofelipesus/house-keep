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

    def update_bill_with_invoices(bill_params)
      transaction do
        update!(bill_params)
        sync_open_invoice!
      rescue ActiveRecord::RecordInvalid => e
        errors.add(:base, e.message) if errors.empty?

        raise ActiveRecord::Rollback
      end

      errors.empty?
    end

    def create_invoice!
      return if invoices.where(due_date: Date.current.all_month).any?

      invoice = Invoice.new(bill: self, payment_status: :pending, payment_amount: value)
      invoice.due_date = next_invoice_due_date

      invoice.save!
    end

    private

    # Keeps the bill's open invoice aligned with the bill after an update. When there is no open
    # invoice left to move (all of them were paid or belong to past months) a new one is created,
    # which covers changing the due day to a day that is still on time for the current month.
    def sync_open_invoice!
      invoice = open_invoice

      return create_invoice! if invoice.nil?

      invoice.update!(due_date: next_invoice_due_date, payment_amount: value)
    end

    # The invoice an update is allowed to move: still pending and not from a past month, so
    # unpaid invoices from previous months are kept untouched as outstanding debt.
    def open_invoice
      invoices
        .pending
        .where(due_date: Date.current.beginning_of_month..)
        .order(:due_date)
        .first
    end

    def next_invoice_due_date
      non_recurring? ? due_date : next_recurring_due_date
    end

    def next_recurring_due_date
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
