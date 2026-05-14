# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @pending_invoices = Invoice.pending
                               .where(due_date: Date.current.all_month)
                               .includes(:bill)
                               .order(:due_date)
  end
end
