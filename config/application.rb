require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MyApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.

    # config.time_zone = 'Beijing'
    # config.i18n.enforce_available_locales = false
    # config.i18n.available_locales = :zh_CN
    # config.i18n.default_locale = :zh_CN
    config.autoload_paths += Dir[Rails.root.join('app', 'services', '*')]

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
