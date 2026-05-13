# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @pending_invoices = Invoice.pending
                               .where(due_date: Date.current.beginning_of_month..Date.current.end_of_month)
                               .includes(:bill)
                               .order(:due_date)
  end
end
