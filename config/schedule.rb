# set :output, "/path/to/my/cron_log.log"

every 1.hours do
  runner "Service.check_all"
end
