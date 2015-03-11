class ApplicationController < ActionController::Base

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  include Pundit
  include ApplicationHelper

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format.json? }

  before_filter :configure_devise_params, if: :devise_controller?
  before_filter :setting_auto_user_locale, if: :human?
  before_filter :set_time_zone
  before_filter :current_or_guest_user
  before_filter :menu_list

  helper_method :accessible?

  def menu_list
    @menu_list = I18n.t("topics.list")
  end

  def accessible?(item)
    return true if user_signed_in? && ( current_user.has_role?(:admin) || current_user.own?(item.user) )

    # if (item.has_attribute?(:publication)) && (item.class.to_s != "Comment")
    if item.has_attribute?(:publication)
      case item.publication
        when 0 # Public
          return true
        when 1 # Secret
          # flash[:error] = "비공개이므로 접근할 수 없습니다."
          if item.obj.user == current_user
            return true # exceptionally the owner of the item can view its comments
          else
            return false
          end
        when 2 # Friends only
          # flash[:error] = "친구만 접근할 수 있습니다."
          return current_user.friends?(item.user)
      end
    end

  end

  def go_back
    redirect_to :back
  rescue ActionController::RedirectBackError
    redirect_to root_path
  end

  def set_time_zone
    client_time_zone = cookies["jstz_time_zone"]
    if client_time_zone.present?
      Time.zone = client_time_zone
    else
      Time.zone
    end
  end

  def human?
    robot = (request.env["HTTP_USER_AGENT"].match(/\(.*https?:\/\/.*\)/)) || (request.env["HTTP_USER_AGENT"].match(/Twitterbot\/1.0/))
    if robot
      false
    else
      true
    end
  end

  private

  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore

    flash[:error] = I18n.t "pundit.#{policy_name}.#{exception.query}",
                           default: 'You cannot perform this action.'
    go_back
  end

  def configure_devise_params
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:email, :password, :password_confirmation, :current_password, :first_name, :last_name, :username, :birthday, :locale, :gender, :website, :avatar, :avatar_cache, :remove_avatar, :job, :description, :location, :phone, :facebook_account_url, :twitter_account_url, :googleplus_account_url, :github_account_url, :linkedin_account_url, :address, :remove_avatar, :avatar_cache, :name) }
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :password, :password_confirmation, :first_name, :last_name, :username, :agreement, :birthday, :gender, :locale, :avatar, :avatar_cache, :remove_avatar, :current_sign_in_ip, :last_sign_in_ip) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:email, :password, :remember_me) }
  end

  def current_or_guest_user
    if current_user
      if session[:guest_user_id]
        # logging_in
        find_guest_user.destroy
        session[:guest_user_id] = nil
      end
    else
      guest_user
    end
  end

  # find guest_user object associated with the current session,
  # creating one as needed
  def guest_user
    # Cache the value the first time it's gotten.
    guest_user = find_guest_user
    @cached_guest_user = guest_user ? guest_user : create_guest_user

  rescue ActiveRecord::RecordNotFound # if session[:guest_user_id] invalid
    session[:guest_user_id] = nil
    guest_user
  end

  # called (once) when the user logs in, insert any code your application needs
  # to hand off from guest_user to current_user.
  def logging_in
    # For example:
    # guest_comments = guest_user.comments.all
    # guest_comments.each do |comment|
    # comment.user_id = current_user.id
    # comment.save!
    # end
  end

  def find_guest_user
    User.find(session[:guest_user_id]) if session[:guest_user_id]
  end

  def create_guest_user
    u = User.new(username: "guest#{Time.now.to_i}#{rand(1000)}", email: "guest_#{Time.now.to_i}#{rand(9000)}@example.com", current_sign_in_ip: "#{request.remote_ip}", last_sign_in_ip: "#{request.remote_ip}")
    u.skip_confirmation!
    u.save!(:validate => false)
    session[:guest_user_id] = u.id
    u
  end

end
