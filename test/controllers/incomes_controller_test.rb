# frozen_string_literal: true

require 'test_helper'

class IncomesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as users(:one)
    @income = incomes(:may_salary)
  end

  test 'should get index' do
    get incomes_url

    assert_response :success
  end

  test 'should get new' do
    get new_income_url

    assert_response :success
  end

  test 'should get edit' do
    get edit_income_url(@income)

    assert_response :success
  end

  test 'should create income' do
    assert_difference('Income.count', 1) do
      post incomes_url, params: {
        income: { title: 'Bônus', value: 900, received_on: '2026-07-10', category: 'salary' }
      }
    end

    assert_redirected_to statement_url(month: '2026-07')
  end

  test 'new renders only the modal frame when opened from the home modal' do
    get new_income_url(modal: true)

    assert_response :success
    assert_select 'turbo-frame#modal-frame form'
    assert_select '.page-header', count: 0
  end

  test 'creating from the modal answers with a turbo stream instead of redirecting' do
    assert_difference('Income.count', 1) do
      post incomes_url(modal: true), params: {
        income: { title: 'Bônus', value: 900, received_on: '2026-07-10', category: 'salary' }
      }, as: :turbo_stream
    end

    assert_response :success
    assert_equal Mime[:turbo_stream], response.media_type
    assert_match 'Entrada criada com sucesso.', response.body
  end

  test 'creating from the modal refreshes the home statement totals' do
    post incomes_url(modal: true), params: {
      income: { title: 'Bônus', value: 900, received_on: '2026-07-10', category: 'salary' }
    }, as: :turbo_stream

    assert_response :success
    assert_match 'home-statement', response.body
  end

  test 'a failed create from the modal re-renders the form inside the frame' do
    assert_no_difference('Income.count') do
      post incomes_url(modal: true), params: { income: { title: '', value: nil, received_on: nil } }
    end

    assert_response :unprocessable_entity
    assert_select 'turbo-frame#modal-frame .form-errors'
  end

  test 'should not create income with invalid params' do
    assert_no_difference('Income.count') do
      post incomes_url, params: { income: { title: '', value: nil, received_on: nil } }
    end

    assert_response :unprocessable_entity
  end

  test 'should update income' do
    patch income_url(@income), params: { income: { value: 5500 } }

    assert_redirected_to statement_url(month: '2026-05')
    assert_equal 5500, @income.reload.value
  end

  test 'should not update income with invalid params' do
    patch income_url(@income), params: { income: { title: '' } }

    assert_response :unprocessable_entity
    assert_equal 'Salário', @income.reload.title
  end

  test 'should destroy income' do
    assert_difference('Income.count', -1) do
      delete income_url(@income)
    end

    assert_redirected_to incomes_url
  end

  test 'requires authentication' do
    sign_out

    get incomes_url

    assert_redirected_to new_session_url
  end
end
