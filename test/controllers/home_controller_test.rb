# frozen_string_literal: true

require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as users(:one)
  end

  test 'should get index' do
    get root_path
    assert_response :success
  end

  test 'lists unpaid invoices from past months alongside the current ones' do
    travel_to Date.new(2026, 5, 25) do
      get root_path

      assert_response :success

      due_dates = assigns_open_invoices.map(&:due_date)

      # pending_invoice (05/20) and delayed_invoice (04/17) are both still owed.
      assert_includes due_dates, Date.new(2026, 5, 20)
      assert_includes due_dates, Date.new(2026, 4, 17)
    end
  end

  test 'excludes paid invoices and invoices due after the current month' do
    invoice = invoices(:pending_invoice)

    travel_to Date.new(2026, 5, 25) do
      invoice.update!(due_date: Date.new(2026, 6, 20))

      get root_path

      due_dates = assigns_open_invoices.map(&:due_date)

      # paid_invoice (05/10) is settled, and 06/20 is not due yet.
      assert_not_includes due_dates, Date.new(2026, 5, 10)
      assert_not_includes due_dates, Date.new(2026, 6, 20)
    end
  end

  test 'orders invoices by due date' do
    travel_to Date.new(2026, 5, 25) do
      get root_path

      due_dates = assigns_open_invoices.map(&:due_date)

      assert_equal due_dates.sort, due_dates
    end
  end

  private

  def assigns_open_invoices
    @controller.view_assigns['open_invoices']
  end
end
