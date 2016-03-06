default['pg']['use_pgdg'] = false
default['pg']['manage_repo'] = true
default['pg']['pgdg']['version'] = '9.3'

default['pg']['initdb_locale'] = 'UTF-8'

default['pg']['config']['server']['port'] = 5432

# Default pg_hba.conf entries
default['pg']['config']['hba']['local'] = {
  enabled: true,
  type: 'local',
  database: 'all',
  user: 'all',
  address: '',
  method: 'trust'
}
default['pg']['config']['hba']['host'] = {
  enabled: true,
  type: 'host',
  database: 'all',
  user: 'all',
  address: '127.0.0.1/32',
  method: 'trust'
}
default['pg']['config']['hba']['host6'] = {
  enabled: true,
  type: 'host',
  database: 'all',
  user: 'all',
  address: '::1/128',
  method: 'trust'
}
