class AttachmentsWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(attachment_id)
    attachment = Attachment.find(attachment_id)
    attachment.destroy if attachment.attachable_type.nil?
  end

end