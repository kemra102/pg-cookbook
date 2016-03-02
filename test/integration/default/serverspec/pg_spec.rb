require 'serverspec'

set :backend, :exec

describe package('postgresql-server') do
  it { should be_installed }
end

describe file('/var/lib/pgsql/9.2/data') do
  it { should be_directory }
  it { should be_mode 700 }
  it { should be_owned_by 'postgres' }
  it { should be_grouped_into 'postgres'}
end

describe file('/var/lib/pgsql/9.2/data/PG_VERSION') do
  it { should be_file }
end

describe file('/etc/systemd/system/postgresql.service') do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root'}
end

describe service('postgresql') do
  it { should be_enabled }
  it { should be_running }
end

describe port('5432') do
  it { should be_listening }
end
