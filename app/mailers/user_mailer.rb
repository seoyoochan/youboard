class UserMailer < ActionMailer::Base
  # default from: "from@example.com"

  def friend_requested(friendship_id)
    friendship = Friendship.find(friendship_id)
    @user  = friendship.user
    @friend = friendship.friend

    mail to: @friend.email,
         from: @user.email,
         subject: "#{@user.fullname} wants to be friends on Youboard"
  end

  def friend_request_accepted(friendship_id)
    friendship = Friendship.find(friendship_id)
    @user  = friendship.user
    @friend = friendship.friend

    mail to: @friend.email,
         from: @user.email,
         subject: "#{@user.fullname} has accepted your friend request."
  end

end
