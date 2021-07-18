# InSpec test for recipe gitea::default

# The Chef InSpec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec/resources/

unless os.windows?
  # This is an example test, replace with your own test.
  describe user('root'), :skip do
    it { should exist }
  end
end

# This is an example test, replace it with your own test.
describe port(80), :skip do
  it { should_not be_listening }
end

describe package('git') do
  it { should be_installed }
end

describe package('inxi') do
  it { should be_installed }
end

describe group('git') do
  it { should exist }
end

describe user('git') do
  it { should exist }
end

describe service('gitea') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe os_env('$GITEA_WORK_DIR') do
  its('content') { should eq '/var/lib/gitea' }
end