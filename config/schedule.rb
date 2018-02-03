set :environment, "development"
set :output, {:error => "log/cron_error_log.log", :standard => "log/cron_log.log"}
env :PATH, ENV['PATH']

every :minute do
  runner "Organization.each(&:update_payload)"
end
