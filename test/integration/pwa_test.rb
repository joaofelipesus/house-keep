# frozen_string_literal: true

require 'test_helper'

class PwaTest < ActionDispatch::IntegrationTest
  # The browser fetches both of these before there is any session to authenticate with, so an
  # auth redirect here would silently make the app non-installable.
  test 'manifest is served without a session' do
    get pwa_manifest_path(format: :json)

    assert_response :success

    manifest = response.parsed_body

    assert_equal 'standalone', manifest['display']
    assert_equal '/', manifest['start_url']
    assert_equal 'HouseKeep', manifest['name']
    assert(manifest['icons'].any? { |icon| icon['purpose'] == 'maskable' })
  end

  test 'service worker is served without a session as javascript' do
    get pwa_service_worker_path

    assert_response :success
    assert_equal 'text/javascript', response.media_type
  end

  test 'signed in layout links the manifest and the apple touch icon' do
    sign_in_as users(:one)

    get root_path

    assert_select 'link[rel=manifest][href=?]', '/manifest.json'
    assert_select 'link[rel=apple-touch-icon][href=?]', '/icon-180.png'
    assert_select 'meta[name=theme-color][content=?]', '#4f46e5'
    assert_select 'meta[name=viewport][content*=?]', 'viewport-fit=cover'
  end
end
