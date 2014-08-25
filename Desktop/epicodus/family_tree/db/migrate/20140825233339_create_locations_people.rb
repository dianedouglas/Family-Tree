class CreateLocationsPeople < ActiveRecord::Migration
  def change
    create_table :locations_people do |t|
      t.column :person_id, :int
      t.column :location_id, :int
    end
  end
end
