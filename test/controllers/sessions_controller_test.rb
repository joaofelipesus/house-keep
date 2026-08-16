require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup { @user = User.take }

  test "new" do
    get new_session_path
    assert_response :success
  end

  test "signed out navbar has no links, no income and no sign out button" do
    get new_session_path

    assert_select 'nav.navbar'
    assert_select 'nav.navbar a', count: 0
    assert_select '.navbar-links', count: 0
    assert_select '.navbar-income', count: 0
    assert_select '.navbar-signout', count: 0
  end

  test "signed in navbar has the links, the income and a sign out button" do
    sign_in_as @user

    get root_path

    assert_select '.navbar-links a', count: 2
    assert_select '.navbar-income-value'
    assert_select ".navbar-signout[action=?]", session_path do
      assert_select "input[name=_method][value=delete]", count: 1
      assert_select "button", text: 'Sair'
    end
  end

  test "create with valid credentials" do
    post session_path, params: { email_address: @user.email_address, password: "password" }

    assert_redirected_to root_path
    assert cookies[:session_id]
  end

  test "create with invalid credentials" do
    post session_path, params: { email_address: @user.email_address, password: "wrong" }

    assert_redirected_to new_session_path
    assert_nil cookies[:session_id]
    assert_equal 'E-mail ou senha inválidos.', flash[:alert]
  end

  test "destroy" do
    sign_in_as(User.take)

    delete session_path

    assert_redirected_to new_session_path
    assert_empty cookies[:session_id]
  end
end
