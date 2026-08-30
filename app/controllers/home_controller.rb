# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @open_invoices = Invoice.open_this_month.includes(:bill)
    @statement = MonthlyStatement.new
  end
end
