require 'serverspec'

set :backend, :exec

describe package('postgresql-server') do
  it { should be_installed }
end

describe file('/var/lib/pgsql/9.2/data') do
  it { should be_directory }
  it { should be_mode 700 }
  it { should be_owned_by 'postgres' }
  it { should be_grouped_into 'postgres' }
end

describe file('/var/lib/pgsql/9.2/data/PG_VERSION') do
  it { should be_file }
end

describe file('/var/lib/pgsql/9.2/data/pg_hba.conf') do
  it { should be_file }
  it { should be_mode 600 }
  it { should be_owned_by 'postgres' }
  it { should be_grouped_into 'root' }
  it { should contain "local\tall\tall\t\ttrust" }
  it { should contain "host\tall\tall\t127.0.0.1/32\ttrust" }
  it { should contain "host\tall\tall\t::1/128\ttrust" }
end

describe file('/var/lib/pgsql/9.2/data/postgresql.conf') do
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

describe service('postgresql') do
  it { should be_enabled }
  it { should be_running }
end

describe port('5432') do
  it { should be_listening.on('127.0.0.1').with('tcp') }
  it { should be_listening.on('::1').with('tcp6') }
end
