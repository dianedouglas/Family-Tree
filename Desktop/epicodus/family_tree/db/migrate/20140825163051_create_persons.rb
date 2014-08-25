class CreatePersons < ActiveRecord::Migration
  def change
    create_table :persons do |t|
      t.column :name, :string
      t.column :spouse_id, :int
    end
  end
end
