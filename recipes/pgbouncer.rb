# Include repo config
include_recipe 'pg::_repo'

# Check we're using PGDG
Chef::Application.fatal!('pgbouncer can only be used if you are using PGDG.', 1) unless node['pg']['use_pgdg'] # rubocop:disable Metrics/LineLength

# Install pgbouncer
package node['pg']['packages']['pgbouncer']

# Main config file
template '/etc/pgbouncer/pgbouncer.ini' do
  cookbook 'pg'
  source 'pgbouncer.ini.erb'
  owner 'root'
  group 'root'
  mode 0644
  notifies :restart, 'service[pgbouncer]', :delayed
end

# Populate HBA config if required
if node['pg']['config']['pgbouncer']['auth_hba_file'] # ~FC023
  template node['pg']['config']['pgbouncer']['auth_hba_file'] do
    cookbook 'pg'
    source 'pool_hba.conf.erb'
    mode '0644'
    owner 'root'
    group 'root'
    notifies :restart, 'service[pgbouncer]', :delayed
  end
end

# pgbouncer service
service 'pgbouncer' do
  supports restart: true, status: true, reload: false
  action [:enable, :start]
end
