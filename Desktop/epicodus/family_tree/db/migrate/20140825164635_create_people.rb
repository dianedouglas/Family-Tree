class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.column :name, :string
      t.column :spouse_id, :int
    end
  end
end
