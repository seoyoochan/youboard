class VotesController < ApplicationController
  before_filter :authenticate_user!, only: [:vote, :unvote]
  before_filter :set_obj, only: [:vote, :unvote]

  def vote
    if current_user.voted_on?(@obj)
      flash[:warning] = "이미 추천했습니다."
    else
      current_user.vote_for(@obj)
      flash[:success] = "추천 했습니다."
    end
    go_back
  end

  def unvote
    if current_user.voted_on?(@obj)
      current_user.unvote_for(@obj)
      flash[:success] = "비추천 했습니다."
    else
      flash[:warning] = "추천한 상태가 아닙니다."
    end
    go_back
  end

  private
  def set_obj
    @obj = if params[:post_id] && params[:comment_id].nil?
            Post.find(params[:post_id])
          elsif params[:comment_id] && params[:post_id]
            Comment.find(params[:comment_id])
          end
  end

end
