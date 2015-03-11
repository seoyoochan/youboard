class Attachment < ActiveRecord::Base
  resourcify

  belongs_to :attachable, polymorphic: true
  has_many :attached_files, dependent: :delete_all
  accepts_nested_attributes_for :attached_files, allow_destroy: true, reject_if: :blank?

  def blank?(attr)
    attr[:name].blank?
  end

  def build_each_file
    self.attached_files.nil? ? self.attached_files.build : nil
  end

  def destroy?(current_user)
     (self.user_id == current_user.id) ? true : false
  end


end
