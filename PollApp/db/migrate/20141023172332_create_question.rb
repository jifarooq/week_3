class CreateQuestion < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.text :question, null: false
      t.integer :poll_id
      
      t.timestamps
    end
  end
end
