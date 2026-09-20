class UpdateJobColumns < ActiveRecord::Migration[6.0]
  def up
    rename_column :jobs, :employer_replies, :notes
    change_column :jobs, :notes, :text

    rename_column :jobs, :date, :applied_date
    change_column :jobs, :applied_date, :date, using: "applied_date::date"

    remove_column :jobs, :tags, :string
    remove_column :jobs, :applied, :string
  end

  def down
    add_column :jobs, :applied, :string
    add_column :jobs, :tags, :string

    change_column :jobs, :applied_date, :string
    rename_column :jobs, :applied_date, :date

    change_column :jobs, :notes, :string
    rename_column :jobs, :notes, :employer_replies
  end
end
