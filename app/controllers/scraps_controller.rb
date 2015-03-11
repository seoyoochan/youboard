class ScrapsController < ApplicationController
  before_filter :authenticate_user!, only: [:create, :destroy]

  def create
    Scrap.create(user_id: current_user.id, post_id: params[:post_id])
    flash[:success] = "#{params[:post_id]}번 글을 스크랩 했습니다."
    go_back
  end

  def destroy
    scrap = Scrap.where(user_id: current_user.id, post_id: params[:post_id]).first
    scrap.destroy
    go_back
    flash[:success] = "#{params[:post_id]}번 글을 스크랩에서 삭제했습니다."
  end
end
