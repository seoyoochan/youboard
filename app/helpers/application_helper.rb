module ApplicationHelper

  def unaccessible_blockers
    return redirect_to root_path if user_signed_in? && current_user.any_blocked?(@user)
  end

  def my_locales
    @locales = {"en" => "English (US)" , "ko" => "한국어",}
  end

  def current_locale
    my_locales[I18n.locale.to_s]
  end

  def browser_locale
    @browser_locale = request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first.to_sym
  end

  def setting_locale
    browser_locale
    if @locales.include?(@browser_locale)
      I18n.locale = @browser_locale.to_s
    else
      I18n.locale = :en
    end
  end

  def setting_auto_user_locale
    my_locales
    setting_locale unless signed_in?
    current_user.locale = I18n.locale.to_s if signed_in? && current_user.locale.nil?
    I18n.locale = current_user.locale.to_sym if signed_in? && current_user.locale.present?
  end

  # make the devise resource mapping available and understandable in places other than the devise views.
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def name_mapper(current_user=nil)
    if current_user.nil?
      return nil
    end

    # 1. user's name exists?
    if current_user.name.present?
      return current_user.name
    else
      # 2. then his locale exists?
      eastern_format = "#{current_user.last_name}#{current_user.first_name}" if current_user.locale == "ko"
      western_format = "#{current_user.first_name} #{current_user.last_name}" if current_user.locale == "en"
      return eastern_format if eastern_format.present?
      return western_format if western_format.present?
    end
  end

  alias_method :fullname, :name_mapper

  def custom_flash(type)
    case type
      when "notice" then "yellow"
      when "info" then "yellow"
      when "success" then "blue"
      when "error" then "red"
      when "warning" then "error"
      else type.to_s
    end
  end

  def summarize(body, length)
    simple_format(truncate(body.gsub(/<\/?.*?>/,  ""), :length => length)).gsub(/<\/?.*?>/,  "")
  end


end
