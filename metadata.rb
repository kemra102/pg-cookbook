name 'pg'
maintainer 'Danny Roberts'
maintainer_email 'danny@thefallenphoenix.net'
license 'BSD-2-Clause'
description 'Installs/Configures PostgreSQL.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '1.4.0'

%w(centos oracle redhat scientific).each do |os|
  supports os, '>= 6.0'
end

source_url 'https://github.com/kemra102/pg-cookbook' if
  respond_to?(:source_url)
issues_url 'https://github.com/kemra102/pg-cookbook/issues' if
  respond_to?(:issues_url)

depends 'yum', '>= 3.5.2'
