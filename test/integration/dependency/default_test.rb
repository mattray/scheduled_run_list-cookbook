describe file('/tmp/kitchen/nodes/dependency-centos-7.json') do
  its('content') { should match(/processed/) }
  its('content') { should match(/test_cookbook::run_list/) }
  its('content') { should match(/test_cookbook::run_list2/) }
end

describe json('/tmp/kitchen/nodes/dependency-centos-7.json') do
  its(['default', 'scheduled_run_list']) { should include('processed') }
  its(['default', 'scheduled_run_list', 'year']) { should eq 2021 }
  its(['default', 'test_cookbook']) { should include('run_list') }
  its(['default', 'test_cookbook']) { should include('run_list2') }
  its(['default', 'test_cookbook', 'run_list']) { should be true }
  its(['default', 'test_cookbook', 'run_list2']) { should be true }
end
