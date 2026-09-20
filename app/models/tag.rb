class Tag < ApplicationRecord
    has_many :jobs_tags, dependent: :destroy
    has_many :jobs, through: :jobs_tags

    validates :name, presence: true, uniqueness: { case_sensitive: false }
end
