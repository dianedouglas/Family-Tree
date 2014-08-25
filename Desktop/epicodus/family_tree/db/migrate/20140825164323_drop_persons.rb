class DropPersons < ActiveRecord::Migration
  def change
    drop_table :persons
  end
end
