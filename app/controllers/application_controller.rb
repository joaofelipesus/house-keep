# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Authentication

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  helper_method :modal_request?

  private

  # New/create can be reached either as a full page or from the home page modal. The flag rides
  # along on the URL so it survives the form submit, which is what tells create whether to answer
  # with a redirect or with a turbo stream that leaves the user on the home page.
  def modal_request?
    params[:modal].present?
  end
end
