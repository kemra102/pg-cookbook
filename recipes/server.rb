# Include repo config
include_recipe 'pg::_repo'

# Set various attributes
if node['pg']['use_pgdg']
  node.default['pg']['packages']['server'] = "postgresql#{node['pg']['pgdg']['version'].delete('.')}-server" # rubocop:disable Metrics/LineLength
  node.default['pg']['version'] = node['pg']['pgdg']['version']
  svc_name = "postgresql-#{node['pg']['pgdg']['version']}"
else
  node.default['pg']['packages']['server'] = 'postgresql-server'
  svc_name = 'postgresql'
  case node['platform_version'].to_i
  when 7
    node.default['pg']['version'] = '9.2'
  when 6
    node.default['pg']['version'] = '8.4'
  else
    Chef::Application.fatal!('You must be on at least EL6.')
  end
end

# Install server package
package node['pg']['packages']['server']

# Manage data directory
node.default['pg']['datadir'] = "/var/lib/pgsql/#{node['pg']['version']}/data"
directory node['pg']['datadir'] do
  mode 0_700
  owner 'postgres'
  group 'postgres'
  recursive true
end

# If using PGDG, add symlinks so that downstream commands all work
compact_version = node['pg']['version'].delete('.')

if node['pg']['use_pgdg']
  [
    "postgresql#{compact_version}-setup",
    "postgresql#{compact_version}-check-db-dir"
  ].each do |cmd|
    link "/usr/bin/#{cmd}" do
      to "/usr/pgsql-#{node['pg']['version']}/bin/#{cmd}"
    end
  end
  link '/usr/bin/initdb' do
    to "/usr/pgsql-#{node['pg']['version']}/bin/initdb"
  end
end

# Initialise database
if node['pg']['version'].to_f <= 9.3
  execute "initdb --locale=#{node['pg']['initdb_locale']} --pgdata=#{node['pg']['datadir']}" do # rubocop:disable Metrics/LineLength
    user 'postgres'
    not_if { ::File.exist?("#{node['pg']['datadir']}/PG_VERSION") }
  end
else
  execute "initdb --pgdata=#{node['pg']['datadir']}" do
    user 'postgres'
    not_if { ::File.exist?("#{node['pg']['datadir']}/PG_VERSION") }
  end
end

# Manage service
if node['init_package'] == 'systemd'
  template '/etc/systemd/system/postgresql.service' do
    source 'postgresql.service.erb'
    owner 'root'
    group 'root'
    mode '0644'
    notifies :run, 'execute[systemctl-reload]', :immediately
    notifies :reload, 'service[postgresql]', :delayed
  end
  execute 'systemctl-reload' do
    command 'systemctl daemon-reload'
    action :nothing
  end
else
  directory '/etc/sysconfig/pgsql' do
    mode 0_755
  end
  template "/etc/sysconfig/pgsql/#{svc_name}" do
    source 'pgsql.sysconfig.erb'
    mode 0_644
    notifies :restart, 'service[postgresql]', :delayed
  end
end

service 'postgresql' do
  service_name svc_name
  supports restart: true, status: true, reload: true
  action [:enable, :start]
end
