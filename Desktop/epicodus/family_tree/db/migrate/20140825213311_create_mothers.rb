class CreateMothers < ActiveRecord::Migration
  def change
    create_table :mothers do |t|
      t.column :name, :string
    end
  end
end
