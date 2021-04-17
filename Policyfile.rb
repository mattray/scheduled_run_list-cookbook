name 'scheduled_run_list'

# Where to find external cookbooks:
default_source :supermarket

cookbook 'scheduled_run_list', path: '.'
cookbook 'test_cookbook', path: 'test/integration/test_cookbook/'

# timezone is set for testing correctness
run_list 'test_cookbook::timezone', 'scheduled_run_list', 'test_cookbook::normal'

default['scheduled_run_list']['run_list'] = ['test_cookbook::run_list']
default['scheduled_run_list']['year'] = 2021
default['scheduled_run_list']['month'] = 04
default['scheduled_run_list']['day'] = 17
default['scheduled_run_list']['time-start'] = 900
default['scheduled_run_list']['time-end'] = 1200
