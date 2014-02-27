require 'bundler/capistrano'
set :gituser,     'greigm'
set :user,        'ruakura'
set :domain,      'rails.hs.net.nz'
set :application, 'clubfare'
set :ssh_options, { :forward_agent => false }

# For RVM
set :rvm_type,        :user
set :rvm_ruby_string, 'ruby-2.1.0p0'

# File paths
set :repository,  "https://#{gituser}@github.com/#{gituser}/#{application}.git"
set :deploy_to,   "/data/apps/#{application}"
set :shared_path, "#{deploy_to}/shared"

role :web, domain                        # Your HTTP server, Apache/etc
role :app, domain                        # This may be the same as your `Web` server
role :db,  "#{domain}", :primary => true # This is where Rails migrations will run

# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"

default_environment['PATH']='/home/ruakura/.rvm/gems/ruby-2.1.0/bin:/home/ruakura/.rvm/gems/ruby-2.1.0@global/bin:/home/ruakura/.rvm/rubies/ruby-2.1.0/bin:/home/ruakura/.rvm/bin:/usr/local/bin:/usr/bin:/bin'
default_environment['GEM_PATH']='/home/ruakura/.rvm/gems/ruby-2.1.0:/home/ruakura/.rvm/gems/ruby-2.1.0@global'
default_environment['GEM_HOME']='/home/ruakura/.rvm/gems/ruby-2.1.0'
default_environment['MY_RUBY_HOME']='/home/ruakura/.rvm/rubies/ruby-2.1.0'
default_environment['rvm_path']='/home/ruakura/.rvm'
default_environment['rvm_prefix']='/home/ruakura'
default_environment['rvm_version']='1.25.19'
default_environment['rvm_bin_path']='/home/ruakura/.rvm/bin'
default_environment['RUBY_VERSION']='ruby-2.1.0'

# miscellaneous options.

set :deploy_via,                 :remote_cache
set :scm,                        'git'
set :branch,                     'master'
set :scm_verbose,                true
set :use_sudo,                   false
set :normalize_asset_timestamps, false
set :rails_env,                  :production
set :stage,                      :production
set :runner,                     :user
set :app_server,                 :puma

before "deploy:assets:precompile", 'deploy:symlink_db'

namespace :deploy do

	desc "Symlink the secure config files"
		task :symlink_db do
			run ["cp -a #{shared_path}/config/database.yml #{release_path}/config/database.yml",
				"cp -a #{shared_path}/db/seeds.rb #{release_path}/db/seeds.rb"
			].join(" && ")
			run "mkdir -p #{shared_path}/app/tmp/#{application}"
		end

	desc "cause Passenger to initiate a restart"
		task :restart do
			run "touch #{current_path}/tmp/restart.txt"
		end

	desc "reload the database with seed data"
		task :seed do
			deploy.migrations
			run "cd #{current_path}; rake db:seed RAILS_ENV=#{rails_env}"
		end 	

end
