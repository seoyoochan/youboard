class BoardPolicy < Struct.new(:user, :board)

  def owned?
    board.user_id == user.id
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