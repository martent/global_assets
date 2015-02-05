APP_CONFIG = YAML.load(File.read File.join(Rails.root, "/config/application_#{ENV['AUDIENCE']}.yml"))[Rails.env]


if Rails.env.development?

  # Rebuild masthead and footer when launching server in development mode
  require 'rake'
  Rake::Task.clear
  AssetsContainer::Application.load_tasks
  Rake::Task["build:masthead"].invoke
  Rake::Task["build:footer"].invoke

  # Clear cache so that erb assets are reloaded on server start
  Rails.cache.clear
end
