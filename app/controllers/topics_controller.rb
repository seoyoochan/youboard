class TopicsController < ApplicationController
  respond_to :html

  def filter
    begin
      request_index = params[:filter]
      board_ids = []
      board_subscribers = []
      if request_index


        # Find boards about the topic
        boards = Board.where(topic: request_index, publication: 0)

        if boards.present?
          # Collect subscribers and board ids about the topic
          boards.each do |board|
            board_id = board.id
            board_ids << board_id
            subscriptions = Subscription.where(subscribable_type: "Board", subscribable_id: board_id)
            board_subscribers << subscriptions.count
          end

          # Sort subscribers and board ids in the biggest number of subscribers order
          unless board_subscribers.blank?

            board_subscribers.each_with_index do |current_value, index|
              board_subscribers.each_with_index do |next_value, next_index|
                if current_value < next_value
                  next
                elsif current_value == next_value
                  next
                else
                  temp_subscriber = board_subscribers[index] # subscriber
                  board_subscribers[index] = next_value # subscriber
                  board_subscribers[next_index] = temp_subscriber # subscriber

                  temp_board_id = board_ids[index]  # board
                  board_ids[index] = board_ids[next_index] # board
                  board_ids[next_index] = temp_board_id # board
                end
              end
            end

            @boards = board_ids.map { |id| Board.find(id) }
            @subscribers = board_subscribers
            respond_to do |format|
              format.html { render "filter" }
            end
          end



        else
          # There is no board about the topic just yet
          flash[:error] = "아직까지 해당 주제에 대한 게시판이 없습니다."
          respond_to do |format|
            format.html { redirect_to root_url }
          end
        end
      end

    rescue => e
      logger.error " 에러 : #{e} "
      respond_to do |format|
        format.html { redirect_to root_url }
      end
    end
  end

end