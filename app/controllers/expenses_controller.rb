# frozen_string_literal: true

class ExpensesController < ApplicationController
  before_action :set_expense, only: %i[edit update destroy]

  # GET /expenses
  def index
    @expenses = Expense.recent_first
  end

  # GET /expenses/new
  def new
    @expense = Expense.new(spent_on: Date.current)
  end

  # GET /expenses/1/edit
  def edit; end

  # POST /expenses
  def create
    @expense = Expense.new(expense_params)

    return render :new, status: :unprocessable_content unless @expense.save

    # From the home modal there is no page to navigate to: the stream drops a confirmation in,
    # refreshes the month totals and the Stimulus controller closes the modal.
    if modal_request?
      @statement = MonthlyStatement.new

      return render :create, formats: :turbo_stream
    end

    redirect_to statement_path(month: month_param_for(@expense)), notice: t('.created')
  end

  # PATCH/PUT /expenses/1
  def update
    if @expense.update(expense_params)
      redirect_to statement_path(month: month_param_for(@expense)), notice: t('.updated'), status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  # DELETE /expenses/1
  def destroy
    @expense.destroy!

    redirect_to expenses_path, notice: t('.destroyed'), status: :see_other
  end

  private

  def set_expense
    @expense = Expense.find(params.expect(:id))
  end

  def expense_params
    params.expect(expense: %i[title value spent_on category payment_method description])
  end

  # Sends the user to the statement the expense actually landed on, not necessarily today's.
  def month_param_for(expense)
    expense.spent_on.strftime('%Y-%m')
  end
end
