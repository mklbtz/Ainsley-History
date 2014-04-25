class CreateEvents < ActiveRecord::Migration
  def up
    create_table :events do |t|
      t.string "action", :null => false
      t.string "door", :null => false
      t.datetime "created_at"
      # t.timestamps
    end
  end

  def down
    drop_table :events
  end
end
