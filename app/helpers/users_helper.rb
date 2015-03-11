module UsersHelper

  def subscribed?(obj)
    self.subscriptions.where(user_id: self.id, subscribable_type: obj.class.to_s.capitalize, subscribable_id: obj.id).first
  end

  def scrapped?(obj)
    self.scraps.where(user_id: self.id, post_id: obj.id).first
  end

  def reported?(obj)
    self.reports.where(user_id: self.id, reportable_id: obj.id, reportable_type: obj.class.name).first
  end

  def age(person)
    now = Date.today
    if person.birthday.blank?
      nil
    else
      now.year - person.birthday.year - (now.strftime('%m%d') < person.birthday.strftime('%m%d') ? 1 : 0)
    end
  end

  def online?
    updated_at > 1.minutes.ago
  end

  # bypass re-entering current password for edit
  def update_with_password(params={})
    params.delete(:current_password)

    if params[:password].blank?
      params.delete(:password)
      params.delete(:password_confirmation) if params[:password_confirmation].blank?
    end
    update_attributes(params)

  end

  def to_param
    username
  end

  def has_blocked?(other_user)
    # blocked_friends.include?(other_user)
    Friendship.find(user_id: current_user.id, friend_id: other_user.id, state: 'blocked') ? true : false
  end

  def boards?
    self.boards.blank? ? false : true
  end

  def posts?
    self.posts.blank? ? false : true
  end

  def comments?
    self.comments.blank? ? false : true
  end

  def fullname
    return nil if self.nil?

    # 1. user's name exists?
    if self.name.present?
      return self.name
    else
      # 2. then his locale exists?
      eastern_format = "#{self.last_name}#{self.first_name}" if self.locale == "ko"
      western_format = "#{self.first_name} #{self.last_name}" if self.locale == "en"
      return eastern_format if eastern_format.present?
      return western_format if western_format.present?
    end
  end

end
