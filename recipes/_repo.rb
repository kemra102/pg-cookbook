compact_version = node['pg']['pgdg']['version'].delete('.')

if node['pg']['use_pgdg'] && node['pg']['manage_repo']
  cookbook_file "/etc/pki/rpm-gpg/RPM-GPG-KEY-PGDG-#{compact_version}" do
    source 'gpg.key'
    notifies :run, 'execute[import-key]', :immediately
  end
  execute 'import-key' do
    command "rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-PGDG-#{compact_version}"
  end
  yum_repository 'pgdg' do
    description "PostgreSQL #{node['pg']['pgdg']['version']} #{node['platform_version'].to_i} - #{node['kernel']['machine']}"
    baseurl "https://download.postgresql.org/pub/repos/yum/#{node['pg']['pgdg']['version']}/redhat/rhel-#{node['platform_version'].to_i}-#{node['kernel']['machine']}"
    enabled true
    gpgcheck true
    gpgkey "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-PGDG-#{compact_version}"
  end
end
