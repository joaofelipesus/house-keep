# frozen_string_literal: true

require 'test_helper'

class BillsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as users(:one)
    @bill = bills(:internet)
  end

  test 'should get index' do
    get bills_url
    assert_response :success
  end

  test 'should get new' do
    get new_bill_url
    assert_response :success
  end

  test 'should create bill' do
    assert_difference('Bill.count') do
      post(
        bills_url,
        params: {
          bill: {
            description: '',
            due_date: nil,
            payment_method: nil,
            recurrent_due_day: 15,
            recurring: '1', # checked value
            title: 'Light',
            value: 45
          }
        }
      )
    end

    assert_redirected_to bill_url(Bill.last)
  end

  test 'should show bill' do
    get bill_url(@bill)
    assert_response :success
  end

  test 'should get edit' do
    get edit_bill_url(@bill)
    assert_response :success
  end

  test 'should update bill' do
    patch(
      bill_url(@bill),
      params: {
        bill: {
          description: @bill.description,
          due_date: @bill.due_date,
          payment_method: @bill.payment_method,
          recurring: @bill.recurring,
          title: @bill.title,
          value: @bill.value
        }
      }
    )

    assert_redirected_to bill_url(@bill)
  end

  test 'should sync the open invoice when updating the recurrent due day' do
    travel_to Date.new(2026, 5, 1) do
      bill = bills(:streaming)
      invoice = invoices(:pending_invoice)

      assert_no_difference('Invoice.count') do
        patch(
          bill_url(bill),
          params: {
            bill: {
              recurrent_due_day: 25,
              recurring: '1',
              title: bill.title,
              value: 59.90
            }
          }
        )
      end

      assert_redirected_to bill_url(bill)

      invoice.reload

      assert_equal Date.new(2026, 5, 25), invoice.due_date
      assert_equal 59.90, invoice.payment_amount.to_f
    end
  end

  test 'should destroy bill' do
    assert_difference('Bill.count', -1) do
      delete bill_url(@bill)
    end

    assert_redirected_to bills_url
  end
end
