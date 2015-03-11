require 'action_view'
# https://github.com/carrierwaveuploader/carrierwave/wiki/How-to:-Validate-attachment-file-size
require 'file_size_validator'

class AttachedFile < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper

  resourcify
  mount_uploader :file, AttachmentUploader
  validates_integrity_of  :file
  validates_processing_of :file
  belongs_to :attachment

  validates :file, file_size: { maximum: 20.megabytes.to_i }


  def filesize
    number_to_human_size(self.file_size, precision: 4, seperator: ",")
  end

  def update_extension
    self.extension = MIME::Types.type_for(self.file.url).first.extensions.first
  end

  def parent
    Attachment.find(self.attachment_id)
  end

end
