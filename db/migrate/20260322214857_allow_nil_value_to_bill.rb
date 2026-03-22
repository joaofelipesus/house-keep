class AllowNilValueToBill < ActiveRecord::Migration[8.1]
  def change
    change_column_null :bills, :value, true
  end
end
