require File.expand_path('../boot', __FILE__)

require "action_controller/railtie"
require "sprockets/railtie"

if defined?(Bundler)
  Bundler.require(:default, Rails.env)
end

module AssetsContainer
  class Application < Rails::Application
    config.time_zone = 'Stockholm'
    config.i18n.default_locale = :en
    I18n.config.enforce_available_locales = true

    config.encoding = "utf-8"
    config.filter_parameters += [:password]

    config.assets.enabled = true
    config.assets.version = '1.0'
    config.assets.precompile += %w(
      *.png *.jpg *.jpeg *.gif *.eot *.svg *.ttf *.woff *.map
      malmo.js
      malmo.css
      malmo_without_jquery.js
      masthead_standalone.css
      masthead_standalone.js
      masthead_standalone_without_jquery.js
      google_analytics.js
      html5shiv-printshiv.js
      legacy/ie8.css
      icons.fallback.css
    )
    config.assets.paths += [
      Rails.root.join("assets", "icons").to_s,
      Rails.root.join("vendor", "malmo_shared_assets", "stylesheets").to_s,
      Rails.root.join("vendor", "malmo_shared_assets", "stylesheets", "shared").to_s,
      Rails.root.join("vendor", "malmo_shared_assets", "stylesheets", "external").to_s
    ]
  end
end

AssetsContainer::Application.config.secret_token = 'Not_used_in_this_app_but_required_by_rails'
AssetsContainer::Application.config.secret_key_base = 'Not_used_in_this_app_but_required_by_rails'
