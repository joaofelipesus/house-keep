# frozen_string_literal: true

class CreateExpenses < ActiveRecord::Migration[8.1]
  def change
    create_table :expenses do |t|
      t.string :title, null: false
      t.decimal :value, precision: 10, scale: 2, null: false
      t.date :spent_on, null: false
      t.string :category, null: false, default: 'other'
      t.string :payment_method
      t.text :description

      t.timestamps
    end

    add_index :expenses, :spent_on
  end
end
