class SubscriptionsController < ApplicationController

  before_filter :set_object, only: [:show, :update]
  before_filter :authenticate_user!, except: [:index]

  def index

  end

  def show

  end

  def new

  end

  def create

    begin
      object = params[:type].capitalize.constantize.find(params[:id])
      if object
        Subscription.create!(user_id: current_user.id, subscribable_type: object.class.to_s, subscribable_id: object.id)
        flash[:success] = "구독완료"
        respond_to do |format|
          format.html { go_back }
          format.js {}
          format.json {  }
        end
      else
        flash[:error] = "구독실패"
        respond_to do |format|
          format.html { go_back }
          format.js {}
          format.json {  }
        end
      end

    rescue => e
      flash[:error] = "예상치 못한 문제가 나타났다."
      go_back
    end

  end


  def edit

  end

  def update

  end

  def destroy
    begin
      object = params[:type].capitalize.constantize.find(params[:id])
      if object
        subscription = Subscription.where(user_id: current_user.id, subscribable_type: object.class.to_s, subscribable_id: object.id).first

        if subscription
          subscription.destroy!
          flash[:success] = "구독 취소되었습니다."
          respond_to do |format|
            format.html { go_back }
            format.js {}
            format.json {  }
          end
        else
          flash[:error] = "현재 구독중이 아닙니다."
          respond_to do |format|
            format.html { go_back }
            format.js {}
            format.json {  }
          end
        end

      end
    rescue => e
      flash[:error] = "예상치 못한 문제가 나타났다."
      go_back
    end
  end

  def deactivate

  end

  def reactivate

  end

  private

  def set_object
    @object = Subscription.find(params[:id])
  end



end
