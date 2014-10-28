# The Capistrano tasks will use your **working copy**, compile the assets and deploy them to the server_address
# Execute one of the following to deploy into staging or production:
#   $ AUDIENCE=[internal|external] bundle exec cap [staging|production] deploy
# Rollback one step:
#   $ AUDIENCE=[internal|external] bundle exec cap [staging|production] deploy:rollback

require 'capistrano/ext/multistage'
require 'fileutils'

set :server_address, 'assets.malmo.se'
server server_address, :web
set :use_sudo, false

set :stages, %w(staging production)
set :audiences, %w(external internal)
set :audience, ENV["AUDIENCE"]

set :application, "assets"

set :deploy_via, :copy # Use local copy, be sure to update the stuff you want to deploy
set :copy_exclude, ["log/*", "**/.git*", "tmp/*", "doc", "bootstrap", "**/.DS_Store",
  "**/*.example", "config/database.yml*", "config/app_config.yml*",
  ".bundle", ".ruby-version", ".gitignore", ".rspec", ".bowerrc", "package.json"]

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set(:user) do
   Capistrano::CLI.ui.ask "Username for #{server_address}: "
end

before "deploy", "deploy:continue", "build"
after "deploy", "deploy:create_symlink", "deploy:cleanup", "build:cleanup"

namespace :deploy do
  desc "Deploy assets to server"
  task :default do
    run_locally "cd public && tar -jcf assets.tar.bz2 assets"
    top.upload "public/assets.tar.bz2", "#{releases_path}", :via => :scp
    run "cd #{releases_path} && tar -jxf assets.tar.bz2 && rm assets.tar.bz2 && mv assets #{release_name}"
  end

  task :continue do
    if audience.nil? || !audiences.include?(audience)
      puts "\033[1;31mYou must set to AUDIENCE=internal or AUDIENCE=external in your command, e.g.:\033[0m"
      puts "  \033[0;32m$ AUDIENCE=internal bundle exec cap staging deploy\033[0m"
      Kernel.exit(1)
    end
    puts ""
    puts "Audience:    \033[0;32m#{audience}\033[0m"
    puts "Environment: \033[0;32m#{rails_env}\033[0m"
    puts ""
    puts "This will use your \033[0;32mworking copy\033[0m, compile the assets and deploy them to:"
    puts "  \033[0;32m#{server_address} #{releases_path}/#{release_name}\033[0m"
    puts ""
    continue = Capistrano::CLI.ui.ask "Do you want to continue [y/n]: "
    if continue.downcase != 'y' && continue.downcase != 'yes'
      Kernel.exit(1)
    end
  end
end

namespace :build do
  desc "Precompile assets locally"
  task :default do
    run_locally("AUDIENCE=#{audience} RAILS_ENV=#{rails_env} rake build:masthead")
    run_locally("AUDIENCE=#{audience} RAILS_ENV=#{rails_env} rake build:footer")
    run_locally("AUDIENCE=#{audience} RAILS_ENV=#{rails_env} rake assets:clobber assets:precompile assets:remove_digests")
  end

  desc "Remove locally compiled assets"
  task :cleanup do
    run_locally("rake assets:clobber")
    run_locally("rm public/assets.tar.bz2")
  end
end
