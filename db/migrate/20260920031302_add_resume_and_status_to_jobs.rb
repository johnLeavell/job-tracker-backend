class AddResumeAndStatusToJobs < ActiveRecord::Migration[6.0]
  def change
    add_reference :jobs, :resume, null: true, foreign_key: true
    add_column :jobs, :status, :integer, null: false, default: 0
    add_index :jobs, :status
  end
end
