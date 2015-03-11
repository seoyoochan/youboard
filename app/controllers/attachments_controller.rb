class AttachmentsController < ApplicationController
  before_filter :authenticate_user!, only: [:file_upload, :destroy, :error_messages]
  before_filter :find_file, only: [:destroy, :download]

  def file_upload

    begin

      attachment_token = params[:attachment_token] ? params[:attachment_token] : nil

      # If any post was created without its attachment and then it needs attachment,
      # Search the same attachment token in the all of posts
      object = Post.find_by(attachment_token: attachment_token)

      object_type = object.nil? ? nil : object.class.to_s
      object_id = object.nil? ? nil : object.id

      user_file = params[:file] unless params[:file].nil?

      attachment = Attachment.where(user_id: current_user.id, attachment_token: attachment_token).first
      attachment = Attachment.create!(user_id: current_user.id, attachment_token: attachment_token, attachable_id: object_id, attachable_type: object_type) if attachment.nil?
      new_file = attachment.attached_files.build
      new_file.file = user_file
      new_file.original_name = params[:file].instance_variable_get("@original_filename")
      new_file.update_extension
      new_file.save!

      AttachmentsWorker.perform_in(1.day, attachment.id) unless attachment.nil?

      render json: new_file, status: :ok

    rescue ActiveRecord::RecordInvalid
      logger.error($!.to_s)
      flash[:error] = "#{$!.to_s}"
      render json: {error: "#{$!.to_s}"}, status: :unprocessable_entity
    end

  end

  def file_locale
    @file = AttachedFile.find(params[:id])
  end

  def destroy
    @attachment = Attachment.find(@file.attachment_id)

    if @attachment && (@attachment.user_id == current_user.id)
      @file_id_to_destroy = @file.id
      @file.destroy!
    else
      flash[:error] = "You are unauthorized to delete the file"
      go_back
    end

    respond_to do |format|
      format.js
    end

  end

  def error_messages
    flash = if params[:error_messages][:reason] == "size"
              t("attachments.flash.error.size", name: params[:error_messages][:file_name])
            else
              t("attachments.flash.error.type", name: params[:error_messages][:file_name], type: params[:error_messages][:file_type])
            end

    render json: {message: flash}, status: :ok
  end

  def download
    send_file @file.file.path, type: @file.content_type, disposition: 'attachment'
  end

  private
  def find_file
    @file = AttachedFile.find(params[:file])
  end

end
