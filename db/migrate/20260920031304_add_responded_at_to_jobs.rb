class AddRespondedAtToJobs < ActiveRecord::Migration[6.0]
  def change
    add_column :jobs, :responded_at, :datetime
  end
end
