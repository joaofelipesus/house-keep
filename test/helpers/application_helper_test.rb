# frozen_string_literal: true

require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test 'display_value returns the value when present' do
    assert_equal 'foo', display_value('foo')
  end

  test 'display_value returns - when value is nil' do
    assert_equal '-', display_value(nil)
  end

  test 'display_value returns - when value is blank string' do
    assert_equal '-', display_value('')
  end
end
