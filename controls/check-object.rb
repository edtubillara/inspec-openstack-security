
swift_conf_dir = '/etc/swift'

default_config_files = %w(
  swift.conf
  api-paste.ini
  policy.json
  rootwrap.conf
)

config_files = attribute('swift_config_files', default: default_config_files, description: 'Swift configuration files')

control 'check-swift-01' do
  title 'Swift config files should be owned by root user and swift group.'
  config_files.each do |swift_conf_file|
    describe file("#{swift_conf_dir}/#{swift_conf_file}")
      it { should be_owned_by 'root' }
      its('group') { should eq 'swift' }
    end
  end
end

control 'check-swift-02' do
  title 'Strict permissions should be set for all Swift config files.'
  config_files.each do |swift_conf_file|
    describe file("#{swift_conf_dir}/#{swift_conf_file}") do
      its('mode') { should cmp '0640' }
      it { should exist }
    end
  end
end

# Default listening ports for the various storage services
describe port(6002) do
  it { should be_listening }
  its('protocol') {should eq 'tcp'}
end

describe port(6001) do
  it { should be_listening }
  its('protocol') {should eq 'tcp'}
end

describe port(6000) do
  it { should be_listening }
  its('protocol') {should eq 'tcp'}
end

describe port(873) do
  it { should be_listening }
  its('protocol') {should eq 'tcp'}
end
