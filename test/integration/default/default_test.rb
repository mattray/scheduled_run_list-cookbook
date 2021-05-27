describe file('/tmp/kitchen/nodes/default-centos-7.json') do
  its('content') { should match(/processed/) }
  its('content') { should match(/test_cookbook::run_list/) }
end

describe json('/tmp/kitchen/nodes/default-centos-7.json') do
  its(['default', 'scheduled_run_list']) { should include('processed') }
  its(['default', 'scheduled_run_list', 'year']) { should eq 2021 }
  its(['default', 'test_cookbook']) { should include('run_list') }
  its(['default', 'test_cookbook']) { should_not include('run_list2') }
  its(['default', 'test_cookbook', 'run_list']) { should be true }
end
