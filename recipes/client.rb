# Include repo config
include_recipe 'pg::_repo'

# Set package name
if node['pg']['use_pgdg']
  node.default['pg']['packages']['client'] = "postgresql#{node['pg']['pgdg']['version'].delete('.')}" # rubocop:disable Metrics/LineLength
else
  node.default['pg']['packages']['client'] = 'postgresql'
end

# Install client package
package node['pg']['packages']['client']
