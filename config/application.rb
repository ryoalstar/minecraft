require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RailsDevise
  class Application < Rails::Application
    #config.cache_store = :redis_store, "redis://rediscloud:v8bJOqrsCa6dhjxz@pub-redis-17285.us-east-1-2.5.ec2.garantiadata.com:17285/0/cache", { expires_in: 90.minutes }
    config.solvemedia.ckey = "QpAz.2b2VFFWtPqzeGaLfPS0NjY1oBcz"
    config.solvemedia.vkey = "IEbWquLALaR6nmACWPm4Z46Kvexp7VMG"
    config.solvemedia.hkey = "IfHkZ8bX0Fgr5p-Wxj7H7vUj0bNFgSno"

    Recaptcha.configure do |config|
    config.private_key = "6LcWqicTAAAAAHJ-o-GqIY0mXpGNGa7Lns0h596R"
    config.public_key = "6LcWqicTAAAAAGW_iZkPUvB9i7kkDRldNOkqLX3D"
    end


    config.generators do |g|
      g.test_framework :rspec,
        fixtures: true,
        view_specs: false,
        helper_specs: false,
        routing_specs: false,
        controller_specs: false,
        request_specs: false
      g.fixture_replacement :factory_girl, dir: "spec/factories"
    end

    DisqusRails.setup do |config|
      config::SHORT_NAME = "Minecraft-PE-Servers"
      config::SECRET_KEY = "dG8PyPQcmqn4YAyJr4EO2kCmxPulZEiljIbHbDxyl50Uqy5ID8VZcjnhHsB8az1A"
      config::PUBLIC_KEY = "haCmka8o4lyJVhpENwtURXc0qEHVGRgZrBbA4lh7ITqpmXCy3a3H6TWMDVBbYLVH"
      config::ACCESS_TOKEN = "c33b8fc0d6474cea9ce1bd897952d511" #you got it, right? ;-)
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true
  end
end
