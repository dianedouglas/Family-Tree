class AddMother < ActiveRecord::Migration
  def change
    add_column :people, :mother_id, :int
  end
end
