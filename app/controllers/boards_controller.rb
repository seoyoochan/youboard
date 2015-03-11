class BoardsController < ApplicationController
  include PublicationsHelper
  before_action :set_board, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, only: [:new, :edit, :destroy, :create, :update]

  # GET /boards
  # GET /boards.json
  def index
    @boards = Board.all
  end

  # GET /boards/1
  # GET /boards/1.json
  def show
  end

  # GET /boards/new
  def new
    @board = Board.new
    do_publication
  end

  # GET /boards/1/edit
  def edit
    authorize @board
    do_publication
  end

  # POST /boards
  # POST /boards.json
  def create
    @board = Board.new(board_params)
    @board.user_id = current_user.id
    @board.topic = params[:board][:topic]

    respond_to do |format|
      if @board.save
        flash[:success] = t("boards.flash.success.create")
        format.html { redirect_to @board }
        format.json { render :show, status: :created, location: @board }
      else
        format.html { render :new }
        format.json { render json: @board.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /boards/1
  # PATCH/PUT /boards/1.json
  def update
    authorize @board
    respond_to do |format|
      if @board.update(board_params)
        flash[:success] = t("boards.flash.success.update")
        format.html { redirect_to @board }
        format.json { render :show, status: :ok, location: @board }
      else
        format.html { render :edit }
        format.json { render json: @board.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /boards/1
  # DELETE /boards/1.json
  def destroy
    authorize @board

    @board.destroy
    respond_to do |format|
      flash[:success] = t("boards.flash.success.destroy")
      format.html { redirect_to boards_url }
      format.json { head :no_content }
    end
  end

  def user_boards
    begin
      @user = User.find_by(username: params[:username])
      if @user.nil?
        flash[:error] = "찾으시는 사용자가 없습니다."
        return go_back
      else
        @boards = @user.boards
      end
    rescue ActiveRecord::RecordNotFound
      flash[:error] = t("boards.flash.error.no_boards")
      go_back
    end
  end

  def user_board
    begin
      @board = User.find_by(username: params[:username]).boards.find(params[:id])
      if !accessible?(@board)
        go_back
      else
        @posts = @board.posts
      end
    rescue ActiveRecord::RecordNotFound
      flash[:error] = t("boards.flash.error.no_requested_board")
      go_back
    end

  end

  def user_board_post
    begin
      @post = Post.find(params[:post_id])
      if !accessible?(@post)
        go_back
      else
        @comment = Comment.build_from(@post, current_user.id, nil) if signed_in?
        @comments = @post.root_comments.paginate(:page => params[:comments_page], :per_page => 10).order('updated_at DESC')

        do_publication

        # Count Views
        if signed_in?
          @post.views.create(user_id: current_user.id, created_at: Time.now, updated_at: Time.now, ip: current_user.current_sign_in_ip) if (@post.views.where(user_id: current_user.id).blank?) && (@post.views.where(ip: current_user.current_sign_in_ip).blank?)
        else
          @post.views.create(user_id: @cached_guest_user.id, created_at: Time.now, updated_at: Time.now, ip: guest_user.current_sign_in_ip) if (@post.views.where(user_id: @cached_guest_user.id).blank?) && (@post.views.where(ip: @cached_guest_user.current_sign_in_ip).blank?)
          return redirect_to root_path if @cached_guest_user.nil?
        end

      end
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "존재하지 않는 게시물입니다."
      go_back
    end

  end

  private
    def set_board

      begin
        @board = Board.find(params[:id])
      rescue => e
        logger.error "We can't find the ##{params[:id]} board"
        flash[:error] = "The board doesn't exist"
        go_back
      end

    end

    def board_params
      params.require(:board).permit(:name, :user_id, :topic, :publication, :description)
    end

end
