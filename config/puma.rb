rails_env = ENV['RAILS_ENV'] || 'development'

threads 16,64

bind  "unix:///data/apps/clubfare/shared/tmp/puma/clubfare-puma.sock"
pidfile "/data/apps/clubfare/current/tmp/puma/pid"
state_path "/data/apps/clubfare/current/tmp/puma/state"

activate_control_app
