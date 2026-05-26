require "test_helper"

class CurrentIncomesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @current_income = current_incomes(:active_income)
  end

  test "should get index" do
    get current_incomes_url
    assert_response :success
  end

  test "should get new" do
    get new_current_income_url
    assert_response :success
  end

  test "should create current_income" do
    assert_difference("CurrentIncome.count", 1) do
      post current_incomes_url, params: { current_income: { value: 6000 } }
    end
    assert_redirected_to current_incomes_url
  end

  test "should not create with invalid params" do
    assert_no_difference("CurrentIncome.count") do
      post current_incomes_url, params: { current_income: { value: nil } }
    end
    assert_response :unprocessable_entity
  end

  test "creating a new income outdates the previous active one" do
    assert @current_income.active?

    post current_incomes_url, params: { current_income: { value: 6000 } }

    assert @current_income.reload.outdated?
  end
end
