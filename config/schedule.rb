set :output, "/var/log/monitoreo_cron.log"

every 10.minutes do
  runner "Service.check_all"
end
