APP_CONFIG = YAML.load(File.read File.join(Rails.root, "/config/application_#{ENV['AUDIENCE']}.yml"))[Rails.env]
