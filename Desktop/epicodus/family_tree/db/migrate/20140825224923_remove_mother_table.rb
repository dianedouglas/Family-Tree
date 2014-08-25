class RemoveMotherTable < ActiveRecord::Migration
  def change
    drop_table :mothers
  end
end
