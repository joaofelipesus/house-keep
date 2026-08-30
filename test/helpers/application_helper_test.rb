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

  test 'money formats a value as BRL' do
    assert_equal 'R$ 1.234,50', money(1234.5)
  end

  test 'money formats a negative value' do
    assert_equal '-R$ 80,00', money(-80)
  end

  test 'month_title renders a capitalised month and year' do
    assert_equal 'Agosto de 2026', month_title(Date.new(2026, 8, 30))
  end
end
