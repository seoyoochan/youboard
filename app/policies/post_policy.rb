class PostPolicy < Struct.new(:user, :post)
  def owned?
    post.user_id == user.id
  end

  def admin?
    user.has_role? :admin
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