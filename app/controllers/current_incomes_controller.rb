# frozen_string_literal: true

class CurrentIncomesController < ApplicationController
  def index
    @current_incomes = CurrentIncome.order(created_at: :desc)
  end

  def new
    @current_income = CurrentIncome.new
  end

  def create
    @current_income = CurrentIncome.new(current_income_params)
    if @current_income.save
      redirect_to current_incomes_path
    else
      render :new, status: :unprocessable_content
    end
  end

  private

  def current_income_params
    params.expect(current_income: [:value])
  end
end
