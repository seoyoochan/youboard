unless Rails.env.development? || Rails.env.test?
  require 'raven'

  Raven.configure do |config|
    config.dsn = 'https://17f2e2202da443728aa841cab77b0180:21602f03a8894ec2b9691db5a83e15cf@app.getsentry.com/35780'
  end
end