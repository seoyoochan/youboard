class CommentPolicy < Struct.new(:user, :comment)
  def owned?
    if user.nil?
      false
    else
      comment.user_id == user.id
    end
  end

  def admin?
    user.has_role? :admin unless user.nil?
  end

  def edit?
    owned? || admin?
  end

  def update?
    owned? || admin?
  end

  def destroy?
    owned? || admin?
  end
end