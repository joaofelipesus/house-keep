# frozen_string_literal: true

class BillsController < ApplicationController
  before_action :set_bill, only: %i[show edit update destroy]

  # GET /bills or /bills.json
  def index
    @bills = Bill.all
  end

  # GET /bills/1 or /bills/1.json
  def show; end

  # GET /bills/new
  def new
    @bill = Bill.new
  end

  # GET /bills/1/edit
  def edit; end

  # POST /bills or /bills.json
  def create
    @bill = Bill.create_bill_with_invoices(bill_params)

    if @bill.valid?
      redirect_to @bill, notice: 'Bill was successfully created.'
    else
      render :new, status: :unprocessable_content
    end
  end

  # PATCH/PUT /bills/1 or /bills/1.json
  def update
    if @bill.update_bill_with_invoices(bill_params)
      redirect_to @bill, notice: 'Bill was successfully updated.', status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  # DELETE /bills/1 or /bills/1.json
  def destroy
    @bill.destroy!

    redirect_to bills_path, notice: 'Bill was successfully destroyed.', status: :see_other
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_bill
    @bill = Bill.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def bill_params
    params
      .expect(bill: %i[recurring value title due_date description payment_method company_logo recurrent_due_day])
      .merge(recurring: ActiveModel::Type::Boolean.new.cast(params[:bill][:recurring]))
  end
end
