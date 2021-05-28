# parse JSON to get run list and time

url = node['scheduled_run_list']['download']

if url.nil?
  log "No download JSON URL provided."
else
  file = Chef::Config[:file_cache_path] + "/scheduled_run_list.json"

  remote_file file do
    source url
    sensitive true
    mode '400'
    compile_time true
  end.run_action(:create)

  # parse the JSON
  json = JSON.parse(::File.read(file))
  node.override['scheduled_run_list']['year'] = json['year']
  node.override['scheduled_run_list']['month'] = json['month']
  node.override['scheduled_run_list']['day'] = json['day']
  node.override['scheduled_run_list']['time-start'] = json['time-start']
  node.override['scheduled_run_list']['time-end'] = json['time-end']
  node.override['scheduled_run_list']['run_list'] = json['run_list']
end
