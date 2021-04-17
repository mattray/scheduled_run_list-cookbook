#
# Cookbook:: scheduled_runlist
# Recipe:: default
#

run_list = node['scheduled_run_list']['run_list']

# check if there is a run list set
if run_list.nil?
  log "NO SCHEDULED RUN LIST"
else
  current_date = Time.now.localtime.strftime("%Y%m%d").to_i
  current_time = Time.now.localtime.strftime("%H%M").to_i

  date = Time.local(node['scheduled_run_list']['year'], node['scheduled_run_list']['month'], node['scheduled_run_list']['day']).strftime("%Y%m%d").to_i
  start = node['scheduled_run_list']['time-start'].to_i
  finish = node['scheduled_run_list']['time-end'].to_i

  log "Scheduled Run List:#{run_list}"
  log "Scheduled Run List:#{date} between #{start} and #{finish}:currently #{current_date}-#{current_time} "

  if current_date < date
    log "Scheduled Run List:PENDING"
  elsif date < current_date
    log "Scheduled Run List:ENDED"
    # test to see if executed or not
  else
    if (start <= current_time) && (current_time <= finish)
      log "Scheduled Run List:EXECUTING"
      run_list.each do |recipe|
        include_recipe recipe
      end
      ruby_block "Scheduled Run List:COMPLETED" do
        block do
          throw :end_client_run_early
        end
      end
    end
  end
end
