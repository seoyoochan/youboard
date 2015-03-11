class ArchivesWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(archive_id)
    post = Post.find(archive_id)
    post.destroy unless post.archived.nil?
  end

end