class CreateResponse < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.integer :answer_choice_id
      t.integer :user_id
      
      t.timestamps
    end
    
    #should we uniqueness constraints to user and answer?
    add_index :responses, :answer_choice_id
    add_index :responses, :user_id
  end
end
