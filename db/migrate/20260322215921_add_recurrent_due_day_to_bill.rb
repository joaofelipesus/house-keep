class AddRecurrentDueDayToBill < ActiveRecord::Migration[8.1]
  def change
    add_column(
      :bills,
      :recurrent_due_day,
      :integer,
      comment: 'The day where the bill must be paied, it\'s used only on recurrent bills'
    )
  end
end
