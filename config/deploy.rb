require 'bundler/capistrano'

set :application, "gitlab-ci"
set :repository,  "git@github.com:Fantaz1/gitlab-ci.git"

server "192.168.33.10", :web, :app, :db, primary: true

set :user, :deployer
set :deploy_to, "/home/#{user}/#{application}"

set :rails_env, :production

set :branch, :'2-0-stable'

set :scm,             :git
set :deploy_via,      :remote_cache
set :keep_releases,   5

ssh_options[:forward_agent] = true
default_run_options[:pty] = true
ssh_options[:paranoid] = false 

set :default_environment, {
  'PATH' => "/usr/local/rvm/gems/ruby-1.9.3-p327/bin:/usr/local/rvm/gems/ruby-1.9.3-p327@global/bin:/usr/local/rvm/rubies/ruby-1.9.3-p327/bin:/usr/local/rvm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/opt/vagrant_ruby/bin",
  'RUBY_VERSION' => 'ruby 1.9.3-p327',
  'GEM_HOME'     => "/usr/local/rvm/gems/ruby-1.9.3-p327",
  'GEM_PATH'     => "/usr/local/rvm/gems/ruby-1.9.3-p327:/usr/local/rvm/gems/ruby-1.9.3-p327@global",
  'BUNDLE_PATH'  => "/usr/local/rvm/gems/ruby-1.9.3-p327"
}

namespace :gitlabci do
  %w(start stop restart).each do |command|
    desc "#{command} gitlab-ci"
    task command, roles: :app do
      run "#{try_sudo} service gitlab_ci #{command}"
    end
  end

  after "deploy:cold", "gitlabci:start"
  after "deploy:restart", "gitlabci:restart"
end

namespace :database do
  desc "Symlink the database.yml file into latest release"
  task :symlink, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
  after "deploy:create_symlink", "database:symlink"

  desc "Run rake db:seed"
  task :seed do
    run "cd #{current_path} && RAILS_ENV=production rake db:seed"
  end
  after "deploy:cold", "database:seed"
end