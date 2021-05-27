describe file('/tmp/kitchen/nodes/passed-centos-7.json') do
  its('content') { should match(/processed/) }
  its('content') { should match(/test_cookbook::run_list/) }
end

describe json('/tmp/kitchen/nodes/passed-centos-7.json') do
  its(['default', 'scheduled_run_list', 'processed']) { should be {} }
  its(['normal', 'scheduled_run_list', 'year']) { should eq 2020 }
  its(['default']) { should_not include('test_cookbook') }
end
