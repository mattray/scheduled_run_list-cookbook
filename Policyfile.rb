name 'scheduled_run_list'

# Where to find external cookbooks:
default_source :supermarket

cookbook 'scheduled_run_list', path: '.'
cookbook 'test_cookbook', path: 'test/integration/test_cookbook/'

run_list 'scheduled_run_list', 'test_cookbook::normal'
named_run_list :download, 'scheduled_run_list::download', 'scheduled_run_list', 'test_cookbook::normal'

default['scheduled_run_list']['run_list'] = ['test_cookbook::run_list']
default['scheduled_run_list']['year'] = 2021
default['scheduled_run_list']['month'] = 05
default['scheduled_run_list']['day'] = 27
# Vagrant is UTC, 10 hours behind Sydney
default['scheduled_run_list']['time-start'] = 400
default['scheduled_run_list']['time-end'] = 1500
