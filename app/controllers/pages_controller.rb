class PagesController < ApplicationController
  def home

  end

  def profile
    @user = User.find_by(username: "#{params[:username]}")
    if @user.blank?
      render :unfound
    else
      unaccessible_blockers
      @boards = @user.boards.paginate(:page => params[:boards_page], :per_page => 5).order('updated_at DESC')
      @posts = @user.posts.paginate(:page => params[:posts_page], :per_page => 5).order('updated_at DESC')
      @comments = @user.comments.paginate(:page => params[:comments_page], :per_page => 5).order('updated_at DESC')
    end
  end

  def unfound
    render "unfound"
  end

  def recipe

  end
end
