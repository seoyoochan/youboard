class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :user_id, :board_id, :publication, :allow_comment, :archived

  has_many :comments
  has_many :views
  has_many :images
  has_many :videos
  # has_one :attachment

  url :post
end
