require "test_helper"

class InvoicesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @invoice = invoices(:delayed_invoice)
  end

  test "should get index" do
    get invoices_url
    assert_response :success
  end

  test "should show invoice" do
    get invoice_url(@invoice)
    assert_response :success
  end

  test "should get edit" do
    get edit_invoice_url(@invoice)
    assert_response :success
  end

  test "should update invoice" do
    patch(
      invoice_url(@invoice),
      params: {
        invoice: {
          bill_id: @invoice.bill_id,
          comment: @invoice.comment,
          payment_date: @invoice.payment_date,
          payment_status: @invoice.payment_status
        }
      }
    )

    assert_redirected_to root_url
  end

  test "should destroy invoice" do
    assert_difference("Invoice.count", -1) do
      delete invoice_url(@invoice)
    end

    assert_redirected_to invoices_url
  end
end
