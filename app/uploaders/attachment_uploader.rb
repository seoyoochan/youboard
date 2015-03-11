# encoding: utf-8
require 'carrierwave/processing/mime_types'

class AttachmentUploader < CarrierWave::Uploader::Base

  # include CarrierWaveDirect::Uploader

  include CarrierWave::MiniMagick
  include CarrierWave::MimeTypes
  process :set_content_type
  process :save_content_type_and_size
  process :store_dimensions
  after :remove, :delete_empty_upstream_dirs

  if Rails.env.development? || Rails.env.test?
    storage :file
    # This store_dir is only used when Rails run in development or test
    # Override the directory where uploaded files will be stored.
    # This is a sensible default for uploaders that are meant to be mounted:
    def store_dir
      "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end
  else
    storage :fog
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    # For Rails 3.1+ asset pipeline compatibility:
    # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))

    # "/images/fallback/" + [version_name, "default.png"].compact.join('_')
    # 'default_avatar.png' #rails will look at 'app/assets/images/default_avatar.png'
  end


  # Create different versions of your uploaded files:
  version :large, if: :image? do
    process :resize_to_fill => [300, 300]
  end

  version :medium, if: :image? do
    process :resize_to_fill => [150, 150]
  end

  # version :small, if: :image? do
  #   process :resize_to_fill => [42, 42]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png bmp tif pdf html mp4 mkv avi flv wmv asf mpg mp2 mpeg mpe mpv m4v 3gp 3g2 mov ogg ogv webm m3u mp3 mmf m4p wma zip pptx smi srt psb sami ssa sub smil usf vtt txt)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  def filename
    "#{model.original_name}"
  end

  private

  def save_content_type_and_size
    model.content_type = file.content_type if file.content_type
    model.file_size = file.size

    model.overall_content_type = "image" if content_type.include? "image"
    model.overall_content_type = "video" if content_type.include? "video"
    model.overall_content_type = "audio" if content_type.include? "audio"
    model.overall_content_type = "text" if content_type.include? "text"
    model.overall_content_type = "application" if content_type.include? "application"

  end

  def store_dimensions
      model.width, model.height = ::MiniMagick::Image.open(file.file)[:dimensions] if file && model && image?(file)
  end

  def image?(new_file)
    new_file.content_type.include? "image"
  end

  def delete_empty_upstream_dirs
    path = ::File.expand_path(store_dir, root)
    Dir.delete(path) # fails if path not empty dir

    path = ::File.expand_path("uploads/#{model.class.to_s.underscore}/#{mounted_as}", root)
    Dir.delete(path) # fails if path not empty dir
  rescue SystemCallError
    true # nothing, the dir is not empty
  end

end
