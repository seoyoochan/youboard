class ArchivesController < ApplicationController
  before_filter :authenticate_user!

  def index
    begin
      @archives = Post.archives(current_user.id)

      respond_to do |format|
        format.js
      end

    rescue => e
      logger.error "Exception occurred: #{e}"

    end
  end

  def create
    begin

    title = params[:title].present? ? params[:title] : nil
    body = params[:body].present? ? params[:body] : nil
    board_id = params[:board_id].present? ? params[:board_id] : nil
    allow_comment = params[:allow_comment].present? ? params[:allow_comment] : nil
    publication = params[:publication].present? ? params[:publication] : nil
    tag_list = params[:tag_list].present? ? params[:tag_list].split(",").map(&:strip) : nil
    attachment_token = params[:attachment_token].present? ? params[:attachment_token] : nil

    post = Post.new(user_id: current_user.id, title: title, body: body, board_id: board_id, allow_comment: allow_comment, publication: publication, tag_list: tag_list, archived: true, attachment_token: attachment_token)
    post.save!
    ArchivesWorker.perform_in(1.week, post.id) unless post.nil?

    attachment = Attachment.where(user_id: current_user.id, attachment_token: post.attachment_token).first
    if attachment
      attachment.attachable_type = "Post"
      attachment.attachable_id = post.id
      attachment.save!
    else
      attachment = Attachment.new(user_id: current_user.id, attachment_token: post.attachment_token, attachable_id: post.id, attachable_type: "Post")
      attachment.save!
      AttachmentsWorker.perform_in(1.week, attachment.id) unless attachment.nil?
    end

    archives_count = Post.archives(current_user.id).count

    respond_to do |format|
      format.json { render json: { archives_count: archives_count, message: t("archives.flash.success.create") }, status: :created }
    end

    rescue ActiveRecord::RecordInvalid => e

      respond_to do |format|
        format.json { render json: { message: t("archives.flash.error.create", reason: "#{e}") }, status: :unprocessable_entity }
      end

    rescue => e
      logger.error "Exception occurred: #{e}"

      respond_to do |format|
        format.json { render json: { message: t("default.flash.exception", reason: "#{e}") }, status: :unprocessable_entity }
      end

    end

  end

  def destroy

    begin

      checked_counts = params[:checked_values] ? params[:checked_values].count : 0

      if checked_counts >= 1
        params[:checked_values].each do |val|
          Post.find(val).delete
        end

        archives_count = Post.archives(current_user.id).count
      end

      respond_to do |format|
        if checked_counts > 1
          format.json { render json: { count: archives_count, message: t("archives.flash.success.destroy.many") }, status: :ok }
        elsif checked_counts == 1
          format.json { render json: { count: archives_count, message: t("archives.flash.success.destroy.one") }, status: :ok }
        else
          format.json { render json: { message: t("archives.flash.error.destroy.empty") }, status: :unprocessable_entity }
        end

      end

    rescue => e
      logger.error "Exception occurred: #{e}"
      respond_to do |format|
        format.json { render json: { message: t("default.flash.exception", reason: "#{e}") }, status: :unprocessable_entity }
      end
    end
  end

  def insert
    begin

      if params[:checked_values]
        checked_counts = params[:checked_values].count
        checked_values = params[:checked_values]
      else
        checked_counts = 0
      end

      respond_to do |format|

        if checked_counts == 1
          archive = Post.find_by(id: checked_values)
          attachment = Attachment.where(attachment_token: archive.attachment_token, user_id: archive.user_id).first
          file_ids = AttachedFile.where(attachment_id: attachment.id).map { |i| i.id } if attachment

          format.json { render json: { archive: archive.to_json, tag_list: archive.tag_list.join(",").to_json, attachment_id: attachment.id, file_ids: file_ids.to_json, message: t("archives.flash.success.insert") }, status: :ok }
        elsif checked_counts > 1
          format.json { render json: { message: t("archives.flash.error.insert.too_many") }, status: :unprocessable_entity }
        else
          format.json { render json: { message: t("archives.flash.error.insert.empty") }, status: :unprocessable_entity }
        end

      end
    rescue => e
      logger.error "Exception occurred: #{e}"
    end
  end


end
