module BoardsHelper
  def user_board_name
    User.find_by(username: params[:username]).boards.find(params[:id]).name
  end

  def user_board_posts
    User.find_by(username: params[:username]).boards.find(params[:id]).posts
  end
end
