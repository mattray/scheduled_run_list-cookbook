describe json('/tmp/kitchen/nodes/noop-centos-7.json') do
  its(['default', 'scheduled_run_list', 'processed']) { should be {} }
  its(['default']) { should_not include('test_cookbook') }
end
