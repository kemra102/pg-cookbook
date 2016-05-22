require 'serverspec'

set :backend, :exec

describe package('pgbouncer') do
  it { should be_installed }
end

describe file('/etc/pgbouncer/pgbouncer.ini') do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  it { should contain 'admin_users = postgres' }
  it { should contain 'stats_users = stats, postgres' }
end

describe service('pgbouncer') do
  it { should be_enabled }
  it { should be_running }
end

describe port('6432') do
  it { should be_listening.on('127.0.0.1').with('tcp') }
end
