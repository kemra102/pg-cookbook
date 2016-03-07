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
  '/usr/bin/postgresql95-check-db-dir' => '/usr/pgsql-9.5/bin/postgresql95-check-db-dir', # rubocop:disable Metrics/LineLength
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

describe file('/var/lib/pgsql/9.5/data/pg_hba.conf') do
  it { should be_file }
  it { should be_mode 600 }
  it { should be_owned_by 'postgres' }
  it { should be_grouped_into 'root' }
  it { should contain "local\tall\tpostgres\t\ttrust" }
  it { should contain "host\tall\tall\t127.0.0.1/32\tmd5" }
  it { should contain "host\tall\tall\t::1/128\tmd5" }
end

describe file('/var/lib/pgsql/9.5/data/postgresql.conf') do
  it { should be_file }
  it { should be_mode 600 }
  it { should be_owned_by 'postgres' }
  it { should be_grouped_into 'root' }
  it { should contain 'port = 5432' }
  it { should contain 'max_connections = 100' }
  it { should contain 'shared_buffers = \'32MB\'' }
  it { should contain 'logging_collector = \'on\'' }
  it { should contain 'log_filename = \'postgresql-%a.log\'' }
  it { should contain 'log_truncate_on_rotation = \'on\'' }
  it { should contain 'log_rotation_age = \'1d\'' }
  it { should contain 'log_rotation_size = 0' }
  it { should contain 'log_timezone = \'UTC\'' }
  it { should contain 'datestyle = \'iso, mdy\'' }
  it { should contain 'timezone = \'UTC\'' }
  it { should contain 'lc_messages = \'en_US.UTF-8\'' }
  it { should contain 'lc_monetary = \'en_US.UTF-8\'' }
  it { should contain 'lc_numeric = \'en_US.UTF-8\'' }
  it { should contain 'lc_time = \'en_US.UTF-8\'' }
  it { should contain 'default_text_search_config = \'pg_catalog.english\'' }
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
  it { should be_listening.on('127.0.0.1').with('tcp') }
  it { should be_listening.on('::1').with('tcp6') }
end
