# frozen_string_literal: true

class CreateIncomes < ActiveRecord::Migration[8.1]
  def change
    create_table :incomes do |t|
      t.string :title, null: false
      t.decimal :value, precision: 10, scale: 2, null: false
      t.date :received_on, null: false
      t.string :category, null: false, default: 'other'
      t.text :description

      t.timestamps
    end

    add_index :incomes, :received_on
  end
end
