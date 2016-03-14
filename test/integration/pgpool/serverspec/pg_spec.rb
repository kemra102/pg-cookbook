require 'serverspec'

set :backend, :exec

%w(postgresql95 pgpool-II-95).each do |pkg|
  describe package(pkg) do
    it { should be_installed }
  end
end

describe file('/etc/pgpool-II-95/pgpool.conf') do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

describe file('/etc/pgpool-II-95/pcp.conf') do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  it { should contain '^admin:foobar$' }
end

describe file('/etc/pgpool-II-95/pool_hba.conf') do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  it { should contain "host\tall\tall\t0.0.0.0/0\tmd5" }
end

describe service('pgpool-II-95') do
  it { should be_enabled }
  it { should be_running }
end

describe port('9898') do
  it { should be_listening.on('0.0.0.0').with('tcp') }
end

describe port('9999') do
  it { should be_listening.on('127.0.0.1').with('tcp') }
  it { should be_listening.on('::1').with('tcp6') }
end
