class CreateAnswerChoice < ActiveRecord::Migration
  def change
    create_table :answer_choices do |t|
      t.text :answer #changed to answer_choice
      t.integer :question_id
      
      t.timestamps
    end
  end
end
