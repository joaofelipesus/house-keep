class CreateCurrentIncomes < ActiveRecord::Migration[8.1]
  def change
    create_table :current_incomes do |t|
      t.decimal :value, precision: 10, scale: 2, null: false, comment: "Monthly income amount"
      t.string :status, null: false, default: "active", comment: "active | outdated"

      t.timestamps
    end
  end
end
