# parse JSON to get run list and time


remote_file node['scheduled_run_list']['download_json']


# parse the JSON

# /var/cache/chef/2021-04-15-1545-1600
# -> stick in an attribute
# node[ '2021-04-15-1545-1600', '2021-04-16-1545-1600']

# parse in cache files
# node['scheduled_run_list']['processed'] = []
