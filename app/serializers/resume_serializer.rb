class ResumeSerializer < ActiveModel::Serializer
  attributes :id, :name, :user_id, :created_at, :updated_at
end
