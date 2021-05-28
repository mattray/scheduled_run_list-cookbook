#
# Cookbook:: scheduled_run_list
# Recipe:: default
#

run_list = node['scheduled_run_list']['run_list']

srl_dir = "#{Chef::Config[:file_cache_path]}/scheduled_run_list"

directory srl_dir  do
  compile_time true
end.run_action(:create)

# parse already run run lists
Dir.entries(srl_dir).each do |cached_srl_file|
  next unless File.fnmatch?('2*-*-*', cached_srl_file)
  node.default['scheduled_run_list']['processed'][::File.basename(cached_srl_file)] = ::File.read("#{srl_dir}/#{cached_srl_file}")
end

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

  timestamp = "#{date}-#{start}-#{finish}"

  if node['scheduled_run_list']['processed'].keys.include?(timestamp)
    log "Scheduled Run List:ALREADY EXECUTED"
  elsif current_date < date
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
      srl_file = srl_dir + "/" + timestamp
      rl = run_list.to_s
      # write out cache file indicating work done
      file srl_file do
        content rl
      end
      ruby_block "Scheduled Run List:COMPLETED" do
        block do
          node.default['scheduled_run_list']['processed'][timestamp] = rl
          throw :end_client_run_early
        end
      end
    end
  end
end
