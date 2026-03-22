class AllowDueDateToBeNil < ActiveRecord::Migration[8.1]
  def change
    change_column_null :bills, :due_date, true
  end
end
