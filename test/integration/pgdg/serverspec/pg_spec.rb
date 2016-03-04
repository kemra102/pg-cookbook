require 'serverspec'

set :backend, :exec

describe package('postgresql95-server') do
  it { should be_installed }
end

describe file('/var/lib/pgsql/9.5/data') do
  it { should be_directory }
  it { should be_mode 700 }
  it { should be_owned_by 'postgres' }
  it { should be_grouped_into 'postgres' }
end

{
  '/usr/bin/postgresql95-setup' => '/usr/pgsql-9.5/bin/postgresql95-setup',
  '/usr/bin/postgresql95-check-db-dir' => '/usr/pgsql-9.5/bin/postgresql95-check-db-dir',
  '/usr/bin/initdb' => '/usr/pgsql-9.5/bin/initdb'
}.each_pair do |link, target|
  describe file(link) do
    it { should be_symlink }
    it { should be_linked_to target }
  end
end

describe file('/var/lib/pgsql/9.5/data/PG_VERSION') do
  it { should be_file }
end

describe file('/etc/systemd/system/postgresql.service') do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

describe service('postgresql-9.5') do
  it { should be_enabled }
  it { should be_running }
end

describe port('5432') do
  it { should be_listening }
end
