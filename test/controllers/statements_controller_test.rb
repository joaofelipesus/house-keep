# frozen_string_literal: true

require 'test_helper'

class StatementsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as users(:one)
  end

  test 'should get show for the current month by default' do
    travel_to Date.new(2026, 5, 25) do
      get statement_url

      assert_response :success
      assert_equal Date.new(2026, 5, 1), statement.month
    end
  end

  test 'shows the requested month' do
    get statement_url(month: '2026-04')

    assert_response :success
    assert_equal Date.new(2026, 4, 1), statement.month
  end

  test 'falls back to the current month on a malformed param' do
    travel_to Date.new(2026, 5, 25) do
      get statement_url(month: 'whatever')

      assert_response :success
      assert_equal Date.new(2026, 5, 1), statement.month
    end
  end

  test 'lists the incomes, invoices and expenses of the month' do
    get statement_url(month: '2026-05')

    assert_response :success
    assert_select '.table-title', text: 'Projeto freelance'
    assert_select '.table-title', text: 'Jantar de aniversário'
    assert_select '.table-title', text: 'Streaming Service'
  end

  test 'requires authentication' do
    sign_out

    get statement_url

    assert_redirected_to new_session_url
  end

  private

  def statement
    @controller.view_assigns['statement']
  end
end
