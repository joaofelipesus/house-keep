class AddRecurringStatusToBill < ActiveRecord::Migration[8.1]
  def change
    add_column(
      :bills,
      :recurring_status,
      :string,
      default: 'active',
      null: false,
      comment: 'current status of the bill, used on recurring bills as active and inactive'
    )
  end
end
