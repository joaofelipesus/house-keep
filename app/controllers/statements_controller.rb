# frozen_string_literal: true

class StatementsController < ApplicationController
  # GET /statement?month=YYYY-MM
  def show
    @statement = MonthlyStatement.for(params[:month])
  end
end
