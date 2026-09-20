class Resume < ApplicationRecord
    belongs_to :user
    has_many :jobs, dependent: :nullify

    validates :name, presence: true
end
