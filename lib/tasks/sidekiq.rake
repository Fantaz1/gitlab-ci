namespace :sidekiq do
  desc "GITLAB | Stop sidekiq"
  task :stop do
    system "bundle exec sidekiqctl stop #{pidfile}"
  end

  desc "GITLAB | Start sidekiq"
  task :start do
    system "nohup bundle exec sidekiq -q runner,common,default -e #{Rails.env} -P #{pidfile} >> #{Rails.root.join("log", "sidekiq.log")} 2>&1 &"
  end

  def pidfile
    '/home/deployer/gitlab_ci/shared/pids/sidekiq.pid'
  end
end
