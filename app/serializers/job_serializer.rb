class JobSerializer < ActiveModel::Serializer
  attributes :id, :title, :company_name, :status, :applied_date, :notes,
             :responded_at, :user_id, :resume_id, :created_at, :updated_at

  has_many :tags
  belongs_to :resume
end
