# frozen_string_literal: true

# Base controller for the Solid Queue dashboard mounted at /jobs. It inherits the
# application's session authentication, so only a signed in user reaches the dashboard.
class JobsDashboardController < ApplicationController
  private

  # Route helpers resolve against the mounted engine's routes here, so the sign in
  # redirect has to be qualified with main_app.
  def request_authentication
    session[:return_to_after_authenticating] = request.url

    redirect_to main_app.new_session_path
  end
end
