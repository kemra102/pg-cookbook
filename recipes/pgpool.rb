# Include PG client
include_recipe 'pg::client'

# Set package name
if node['pg']['use_pgdg']
  node.default['pg']['packages']['pgpool'] = "pgpool-II-#{node['pg']['pgdg']['version'].delete('.')}" # rubocop:disable Metrics/LineLength
else
  Chef::Application.fatal!('pgpool can only be used if you are using PGDG.', 1)
end

# Install pgpool package
package node['pg']['packages']['pgpool']

# Update main config
node.default['pg']['config']['pgpool']['pid_file_name'] = "/var/run/pgpool-II-#{node['pg']['pgdg']['version'].delete('.')}/pgpool.pid" # rubocop:disable Metrics/LineLength
node.default['pg']['config']['pgpool']['logdir'] = "/var/log/pgpool-II-#{node['pg']['pgdg']['version'].delete('.')}" # rubocop:disable Metrics/LineLength

template "/etc/pgpool-II-#{node['pg']['pgdg']['version'].delete('.')}/pgpool.conf" do # rubocop:disable Metrics/LineLength
  cookbook 'pg'
  source 'pgpool.conf.erb'
  mode '0644'
  owner 'root'
  group 'root'
  notifies :restart, 'service[pgpool]', :delayed
end

# Update pcp config
template "/etc/pgpool-II-#{node['pg']['pgdg']['version'].delete('.')}/pcp.conf" do # rubocop:disable Metrics/LineLength
  cookbook 'pg'
  source 'pcp.conf.erb'
  mode '0644'
  owner 'root'
  group 'root'
  notifies :restart, 'service[pgpool]', :delayed
end

# Update pool_hba.conf
template "/etc/pgpool-II-#{node['pg']['pgdg']['version'].delete('.')}/pool_hba.conf" do # rubocop:disable Metrics/LineLength
  cookbook 'pg'
  source 'pool_hba.conf.erb'
  mode '0644'
  owner 'root'
  group 'root'
  notifies :restart, 'service[pgpool]', :delayed
end

# Manage service
service 'pgpool' do
  service_name "pgpool-II-#{node['pg']['pgdg']['version'].delete('.')}"
  supports restart: true, status: true, reload: false
  action [:enable, :start]
end
