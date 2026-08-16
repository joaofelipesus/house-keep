# frozen_string_literal: true

class InvoicesController < ApplicationController
  before_action :set_invoice, only: %i[show edit update destroy]

  # GET /invoices or /invoices.json
  def index
    @invoices = Invoice.all
  end

  # GET /invoices/1 or /invoices/1.json
  def show; end

  # GET /invoices/1/edit
  def edit; end

  # GET /invoices/paid
  def paid
    @invoices = Invoice.paid_this_month.includes(:bill)
  end

  # PATCH/PUT /invoices/1 or /invoices/1.json
  # The home modal is a payment confirmation, so saving it always settles the invoice. Without
  # this the status stayed as it was and the invoice kept showing up on the home page.
  def update
    if @invoice.confirm_payment(invoice_params)
      @open_invoices = Invoice.open_this_month.includes(:bill)

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to root_path, status: :see_other }
      end
    else
      render :edit, status: :unprocessable_content
    end
  end

  # DELETE /invoices/1 or /invoices/1.json
  def destroy
    @invoice.destroy!

    redirect_to invoices_path, notice: 'Invoice was successfully destroyed.', status: :see_other
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_invoice
    @invoice = Invoice.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def invoice_params
    params.expect(invoice: %i[bill_id payment_status payment_date payment_amount comment due_date])
  end
end
