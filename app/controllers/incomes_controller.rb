# frozen_string_literal: true

class IncomesController < ApplicationController
  before_action :set_income, only: %i[edit update destroy]

  # GET /incomes
  def index
    @incomes = Income.recent_first
  end

  # GET /incomes/new
  def new
    @income = Income.new(received_on: Date.current)
  end

  # GET /incomes/1/edit
  def edit; end

  # POST /incomes
  def create
    @income = Income.new(income_params)

    return render :new, status: :unprocessable_content unless @income.save

    # From the home modal there is no page to navigate to: the stream drops a confirmation in,
    # refreshes the month totals and the Stimulus controller closes the modal.
    if modal_request?
      @statement = MonthlyStatement.new

      return render :create, formats: :turbo_stream
    end

    redirect_to statement_path(month: month_param_for(@income)), notice: t('.created')
  end

  # PATCH/PUT /incomes/1
  def update
    if @income.update(income_params)
      redirect_to statement_path(month: month_param_for(@income)), notice: t('.updated'), status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  # DELETE /incomes/1
  def destroy
    @income.destroy!

    redirect_to incomes_path, notice: t('.destroyed'), status: :see_other
  end

  private

  def set_income
    @income = Income.find(params.expect(:id))
  end

  def income_params
    params.expect(income: %i[title value received_on category description])
  end

  # Sends the user to the statement the income actually landed on, not necessarily today's.
  def month_param_for(income)
    income.received_on.strftime('%Y-%m')
  end
end
