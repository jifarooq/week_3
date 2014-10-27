class ChangeAnswerColumn < ActiveRecord::Migration
  def change
    rename_column :answer_choices, :answer, :answer_choice
  end
end
