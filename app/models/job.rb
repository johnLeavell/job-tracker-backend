class Job < ApplicationRecord
    belongs_to :user
    belongs_to :resume, optional: true

    has_many :jobs_tags, dependent: :destroy
    has_many :tags, through: :jobs_tags

    enum status: {
        applied: 0,
        phone_screen: 1,
        interviewing: 2,
        offer: 3,
        rejected: 4,
        withdrawn: 5
    }

    validates :company_name, presence: true
    validates :title, presence: true

    before_save :set_responded_at

    RESPONDED_STATUSES = %w[phone_screen interviewing offer rejected].freeze
    INTERVIEWED_STATUSES = %w[interviewing offer].freeze

    scope :responded, -> { where(status: RESPONDED_STATUSES) }

    private

    def set_responded_at
      if status_changed? && status != "applied" && responded_at.nil?
        self.responded_at = Time.current
      end
    end
end
