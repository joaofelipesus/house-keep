# frozen_string_literal: true

require 'test_helper'

class ExpensesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as users(:one)
    @expense = expenses(:may_groceries)
  end

  test 'should get index' do
    get expenses_url

    assert_response :success
  end

  test 'should get new' do
    get new_expense_url

    assert_response :success
  end

  test 'should get edit' do
    get edit_expense_url(@expense)

    assert_response :success
  end

  test 'should create expense' do
    assert_difference('Expense.count', 1) do
      post expenses_url, params: {
        expense: {
          title: 'Jantar',
          value: 150,
          spent_on: '2026-07-10',
          category: 'food',
          payment_method: 'pix'
        }
      }
    end

    assert_redirected_to statement_url(month: '2026-07')
  end

  test 'should create expense without a payment method' do
    assert_difference('Expense.count', 1) do
      post expenses_url, params: {
        expense: { title: 'IPTU', value: 1200, spent_on: '2026-07-15', category: 'taxes', payment_method: '' }
      }
    end

    assert_nil Expense.last.payment_method
  end

  test 'new renders only the modal frame when opened from the home modal' do
    get new_expense_url(modal: true)

    assert_response :success
    assert_select 'turbo-frame#modal-frame form'
    assert_select '.page-header', count: 0
  end

  test 'creating from the modal answers with a turbo stream instead of redirecting' do
    assert_difference('Expense.count', 1) do
      post expenses_url(modal: true), params: {
        expense: { title: 'Jantar', value: 150, spent_on: '2026-07-10', category: 'food' }
      }, as: :turbo_stream
    end

    assert_response :success
    assert_equal Mime[:turbo_stream], response.media_type
    assert_match 'Gasto criado com sucesso.', response.body
  end

  test 'creating from the modal refreshes the home statement totals' do
    post expenses_url(modal: true), params: {
      expense: { title: 'Jantar', value: 150, spent_on: '2026-07-10', category: 'food' }
    }, as: :turbo_stream

    assert_response :success
    assert_match 'home-statement', response.body
  end

  test 'a failed create from the modal re-renders the form inside the frame' do
    assert_no_difference('Expense.count') do
      post expenses_url(modal: true), params: { expense: { title: '', value: nil, spent_on: nil } }
    end

    assert_response :unprocessable_entity
    assert_select 'turbo-frame#modal-frame .form-errors'
  end

  test 'should not create expense with invalid params' do
    assert_no_difference('Expense.count') do
      post expenses_url, params: { expense: { title: '', value: nil, spent_on: nil } }
    end

    assert_response :unprocessable_entity
  end

  test 'should update expense' do
    patch expense_url(@expense), params: { expense: { value: 450 } }

    assert_redirected_to statement_url(month: '2026-05')
    assert_equal 450, @expense.reload.value
  end

  test 'should not update expense with invalid params' do
    patch expense_url(@expense), params: { expense: { title: '' } }

    assert_response :unprocessable_entity
    assert_equal 'Mercado', @expense.reload.title
  end

  test 'should destroy expense' do
    assert_difference('Expense.count', -1) do
      delete expense_url(@expense)
    end

    assert_redirected_to expenses_url
  end

  test 'requires authentication' do
    sign_out

    get expenses_url

    assert_redirected_to new_session_url
  end
end
