module AttachmentsHelper

  def new_uploader
    self.build_attachment.attached_files.build
  end

  def attachment_new?
    self.attachment.new_record?
  end

  def attachment_persisted?
    !self.attachment.nil? && self.attachment.persisted?
  end

  def edit_uploaded_files
    self.attachment.build_each_file if self.attachment_persisted?
  end


  def save_attachment(files=nil,user=nil)

    if self.attachment_persisted?
      persisted_files = self.attachment.attached_files.name
      if self.attachment.attached_files.name_changed?
        persisted_files.each do |file|
          each = attachment.attached_files.build
          each.name = file
          each.save!
        end
      end
    else
      attachment = self.build_attachment

      files.each do |file|
        each = attachment.attached_files.build
        each.name = file
        each.save!
      end

      attachment.user_id = user.id
      attachment.save!
    end

  end

  def uploaded_files
    self.attachment.attached_files.each_with_index
  end

end
