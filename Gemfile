source 'https://rubygems.org'

ruby '2.1.5'

gem 'rails', '4.2.0'

gem 'jquery-rails'
gem 'turbolinks'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

gem 'active_model_serializers', github: 'rails-api/active_model_serializers'
gem 'htmlentities'
gem 'sanitize'
gem 'koala', '~> 1.10.0rc'
gem 'jquery-turbolinks' # To make jQuery.ready() function work when using turbolinks gem
gem 'devise'
gem 'authority'
gem 'rolify'
gem 'pundit' #https://github.com/elabs/pundit
gem 'simple_form' #https://github.com/plataformatec/simple_form
gem 'will_paginate', '~> 3.0.6' #https://github.com/mislav/will_paginate
gem 'acts-as-taggable-on', '~> 3.4' #https://github.com/mbleigh/acts-as-taggable-on
gem 'acts_as_commentable_with_threading' #https://github.com/elight/acts_as_commentable_with_threading
gem 'font-awesome-rails'
gem 'mini_magick' # photo resizing
gem 'carrierwave'
gem 'fog' # for aws cloud storage
gem 'thumbs_up', git: 'https://github.com/bouchard/thumbs_up.git'
gem 'faye-rails'
gem 'public_activity'
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-github'
gem 'omniauth-google-oauth2'
gem 'omniauth-linkedin'
gem 'omniauth-twitter'
gem 'semantic-ui-sass', git: 'https://github.com/doabit/semantic-ui-sass.git', branch: 'v1.0beta'
gem 'jquery.fileupload-rails'
gem 'sidekiq', '~> 3.3.0'
gem 'redis', '~> 3.2.0'
gem 'sentry-raven', git: 'https://github.com/getsentry/raven-ruby.git' # error log monitoring service, free
# gem 'bugsnag' # Error log monitoring service, for serious startup
gem 'haml'

# Puma for our main server concurrently
gem 'puma'

# Thin for running faye server
gem 'thin'

group :test, :development do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

end

group :test do
  gem 'sqlite3'
  gem 'capybara' # Simulates user activity
end

group :development do
  gem 'mysql2'
  gem 'better_errors'
  gem 'quiet_assets'
  gem 'mailcatcher'
end

group :production do
  gem 'rails_12factor'
  gem 'pg'
  gem 'mandrill_mailer'
  gem 'mandrill-api'
end


