class InvoicesController < ApplicationController
  before_action :set_invoice, only: %i[ show edit update destroy ]

  # GET /invoices or /invoices.json
  def index
    @invoices = Invoice.all
  end

  # GET /invoices/1 or /invoices/1.json
  def show
  end

  # GET /invoices/1/edit
  def edit
  end

  # PATCH/PUT /invoices/1 or /invoices/1.json
  def update
    if @invoice.update(invoice_params)
      respond_to do |format|
        format.turbo_stream { head :ok }
        format.html { redirect_to root_path, status: :see_other }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /invoices/1 or /invoices/1.json
  def destroy
    @invoice.destroy!

    redirect_to invoices_path, notice: "Invoice was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invoice
      @invoice = Invoice.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def invoice_params
      params.expect(invoice: [ :bill_id, :payment_status, :payment_date, :payment_amount, :comment, :due_date ])
    end
end
