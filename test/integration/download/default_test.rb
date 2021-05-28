describe file('/tmp/kitchen/nodes/download-centos-7.json') do
  its('content') { should match(/processed/) }
  its('content') { should match(/test_cookbook::run_list/) }
  its('content') { should match(/test_cookbook::run_list2/) }
end

describe json('/tmp/kitchen/nodes/download-centos-7.json') do
  its(['default', 'scheduled_run_list', 'year']) { should eq 2021 } # from Policyfile
  its(['default', 'scheduled_run_list', 'month']) { should eq 05 } # from Policyfile
  its(['default', 'scheduled_run_list', 'day']) { should eq 28 } # from Policyfile
  its(['default', 'scheduled_run_list', 'time-start']) { should eq 400 } # from Policyfile
  its(['default', 'scheduled_run_list', 'time-end']) { should eq 1500 } # from Policyfile
  its(['normal', 'scheduled_run_list', 'year']) { should eq 2020 } # verify it's set from kitchen.yml
  its(['override', 'scheduled_run_list', 'year']) { should eq 2021 } # overridden by JSON
  its(['override', 'scheduled_run_list', 'month']) { should eq 05 } # overridden by JSON
  its(['override', 'scheduled_run_list', 'day']) { should eq 28 } # overridden by JSON
  its(['override', 'scheduled_run_list', 'time-start']) { should eq 200 } # overridden by JSON
  its(['override', 'scheduled_run_list', 'time-end']) { should eq 2100 } # overridden by JSON
  its(['default', 'scheduled_run_list', 'processed']) { should include('20210528-200-2100') }
  its(['default', 'test_cookbook']) { should include('run_list') }
  its(['default', 'test_cookbook']) { should include('run_list2') }
  its(['default', 'test_cookbook', 'run_list']) { should be true }
  its(['default', 'test_cookbook', 'run_list2']) { should be true }
end

# cache file exists
describe file('/tmp/kitchen/cache/scheduled_run_list/20210528-200-2100') do
  its('content') { should match(/test_cookbook::run_list/) }
end
