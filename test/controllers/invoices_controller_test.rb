# frozen_string_literal: true

require 'test_helper'

class InvoicesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @invoice = invoices(:delayed_invoice)
  end

  test 'should get index' do
    get invoices_url
    assert_response :success
  end

  test 'should show invoice' do
    get invoice_url(@invoice)
    assert_response :success
  end

  test 'should get edit' do
    get edit_invoice_url(@invoice)
    assert_response :success
  end

  test 'should update invoice' do
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

  test 'should update invoice payment_status' do
    patch(
      invoice_url(@invoice),
      params: {
        invoice: {
          payment_status: 'paid',
          payment_date: Date.current,
          payment_amount: @invoice.payment_amount
        }
      }
    )

    assert_redirected_to root_url
    assert_equal 'paid', @invoice.reload.payment_status
  end

  test 'settles the invoice even when the form does not send a payment status' do
    patch(
      invoice_url(@invoice),
      params: {
        invoice: {
          payment_date: Date.current,
          payment_amount: @invoice.payment_amount
        }
      }
    )

    assert_equal 'paid', @invoice.reload.payment_status
  end

  test 'confirmed invoice is gone from the home page' do
    invoice = invoices(:pending_invoice)

    travel_to Date.new(2026, 5, 25) do
      patch(
        invoice_url(invoice),
        params: { invoice: { payment_date: Date.current, payment_amount: invoice.payment_amount } }
      )

      get root_path

      assert_response :success
      assert_no_match(/#{invoice.bill.title}/, response.body)
    end
  end

  test 'the turbo stream response re-renders the open invoice list without the settled invoice' do
    invoice = invoices(:pending_invoice)

    travel_to Date.new(2026, 5, 25) do
      patch(
        invoice_url(invoice),
        params: { invoice: { payment_date: Date.current, payment_amount: invoice.payment_amount } },
        as: :turbo_stream
      )

      assert_response :success
      assert_match 'open-invoices', response.body
      assert_no_match(/#{invoice.bill.title}/, response.body)
    end
  end

  test 'should list invoices paid on the current month' do
    travel_to Date.new(2026, 5, 25) do
      get paid_invoices_url

      assert_response :success
      # paid_invoice was paid on 05/10, delayed_invoice was never paid.
      assert_match(/#{invoices(:paid_invoice).bill.title}/, response.body)
    end
  end

  test 'paid list ignores invoices paid on other months' do
    travel_to Date.new(2026, 6, 25) do
      get paid_invoices_url

      assert_response :success
      assert_match(/#{I18n.t('invoices.paid.no_invoices')}/, response.body)
    end
  end

  test 'should destroy invoice' do
    assert_difference('Invoice.count', -1) do
      delete invoice_url(@invoice)
    end

    assert_redirected_to invoices_url
  end
end
