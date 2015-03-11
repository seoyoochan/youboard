class PostsController < ApplicationController
  include PublicationsHelper
  before_action :set_object, only: [:show, :update, :destroy]
  before_action :set_user_board_post, only: [:edit]
  before_filter :authenticate_user!, except: [:index, :show]


  # GET /posts
  # GET /posts.json
  def index
    user = User.where(username: params[:username]).first
    if user.nil?
      flash[:error] = "해당 사용자가 존재하지 않습니다."
      go_back
    else
      @posts = user.posts
    end

  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @comment = Comment.build_from(@post, current_user.id, nil) if signed_in?

    redirect_to user_board_post_path(@post.user.username, @post.board_id, @post) unless @post.board_id.nil?
  end

  # GET /posts/new
  def new
    if current_user.boards.blank?
      flash[:error] = "게시판이 없습니다. 글을 쓰려면 게시판을 생성해야합니다."
      redirect_to new_board_path
    else
      @post = Post.new
      @archives = Post.archives(current_user.id)
      @post.build_attachment.attached_files.build
      @attachment_token = SecureRandom.uuid

      do_publication
    end
  end


  # GET /posts/1/edit
  def edit
    authorize @post
    do_publication
    @archives = Post.archives(current_user.id)
    @post.build_attachment.attached_files.build if @post.attachment.nil?

  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(permitted_params)
    @post.user_id = current_user.id

    respond_to do |format|
      if @post.save!

        attachment = Attachment.where(user_id: current_user.id, attachment_token: @post.attachment_token).first
        unless attachment.nil?
          attachment.attachable_type = "Post"
          attachment.attachable_id = @post.id
          attachment.save!
        end

        format.html { redirect_to @post, success: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        do_publication
        format.html { go_back }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end

  rescue ActiveRecord::RecordInvalid
    flash[:error] = @post.errors.full_messages
    return go_back

  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    authorize @post
    do_publication

    respond_to do |format|
      if @post.update(permitted_params)
        attachment = Attachment.where(user_id: current_user.id, attachment_token: @post.attachment_token).first
        unless attachment.nil?
          attachment.attachable_type = "Post"
          attachment.attachable_id = @post.id
          attachment.save!
        end
        format.html { redirect_to @post, success: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end

  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    authorize @post
    @post.destroy
    respond_to do |format|
      format.html { redirect_to user_posts_path(current_user.username), success: "삭제성공" }
      format.json { head :no_content }
    end
  end

  private

    def set_object
      begin
      @post = Post.find(params[:id])
      rescue => e
        logger.error "We can't find the ##{params[:id]} post"
        flash[:error] = "The post doesn't exist"
        go_back
      end
    end

    def set_user_board_post
      begin
        @post = Post.find(params[:post_id])
      rescue => e
        logger.error "We can't find the ##{params[:post_id]} post"
        flash[:error] = "The post doesn't exist"
        go_back
      end
    end

    def permitted_params
      params.require(:post).permit(:title, :body, :user_id, :category_id, :board_id, :publication, :tag_list, :allow_comment, :archived, :attachment_token)
    end


end
