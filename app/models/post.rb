class Post < ActiveRecord::Base

  include ActiveModel::Validations
  include VotesHelper
  include PublicationsHelper
  include AttachmentsHelper

  resourcify
  acts_as_commentable
  acts_as_voteable
  acts_as_taggable

  belongs_to :user
  belongs_to :board
  belongs_to :scrap
  belongs_to :report
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :views, as: :viewable, dependent: :destroy
  has_one :attachment, as: :attachable, dependent: :destroy

  validates :board_id, presence: { message: "%{value}을 선택해주세요" }, on: [:create, :update]
  validates :title, presence: { message: "%{value}을 작성해주세요" }
  validates :body, presence: { message: "%{value}을 작성해주세요" }, on: [:create, :update]
  validates :publication, presence: { message: "%{value}을 선택해주세요" }, on: [:create, :update]

  scope :archives, ->(id) { where(archived: true, user_id: id) }

  def board
    Board.find(self.board_id)
  end

  def self.expire_archives
    self.destroy if self.archived.nil?
  end


end
