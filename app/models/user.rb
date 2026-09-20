class User < ApplicationRecord
    has_many :jobs, dependent: :destroy
    has_many :resumes, dependent: :destroy

    has_secure_password
    validates :username, presence: true, uniqueness: { case_sensitive: false }
end
