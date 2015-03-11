class ReportsController < ApplicationController
  before_filter :authenticate_user!, only: [:create, :destroy]

  def create
    if params[:post_id] && params[:comment_id].nil?
      Report.create(user_id: current_user.id, reportable_type: "Post", reportable_id: params[:post_id])
    elsif params[:comment_id] && params[:post_id]
      Report.create(user_id: current_user.id, reportable_type: "Comment", reportable_id: params[:comment_id])
    end
    flash[:success] = "신고접수 완료."
    go_back
  end

  def destroy
    obj =
    if params[:post_id] && params[:comment_id].nil?
      Report.where(user_id: current_user.id, reportable_type: "Post", reportable_id: params[:post_id]).first
    elsif params[:comment_id] && params[:post_id]
      Report.where(user_id: current_user.id, reportable_type: "Comment", reportable_id: params[:comment_id]).first
    end
    obj.destroy
    flash[:success] = "신고접수가 취소되었습니다."
    go_back
  end
end
