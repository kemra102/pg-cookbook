default['pg']['use_pgdg'] = false
default['pg']['manage_repo'] = true
default['pg']['pgdg']['version'] = '9.3'

default['pg']['initdb_locale'] = 'UTF-8'

# Default postgresql.conf values
default['pg']['config']['server']['port'] = 5432
default['pg']['config']['server']['max_connections'] = 100
default['pg']['config']['server']['shared_buffers'] = '32MB'
default['pg']['config']['server']['logging_collector'] = 'on'
default['pg']['config']['server']['log_filename'] = 'postgresql-%a.log'
default['pg']['config']['server']['log_truncate_on_rotation'] = 'on'
default['pg']['config']['server']['log_rotation_age'] = '1d'
default['pg']['config']['server']['log_rotation_size'] = 0
default['pg']['config']['server']['log_timezone'] = 'UTC'
default['pg']['config']['server']['datestyle'] = 'iso, mdy'
default['pg']['config']['server']['timezone'] = 'UTC'
default['pg']['config']['server']['lc_messages'] = 'en_US.UTF-8'
default['pg']['config']['server']['lc_monetary'] = 'en_US.UTF-8'
default['pg']['config']['server']['lc_numeric'] = 'en_US.UTF-8'
default['pg']['config']['server']['lc_time'] = 'en_US.UTF-8'
default['pg']['config']['server']['default_text_search_config'] = 'pg_catalog.english' # rubocop:disable Metrics/LineLength

# Default pg_hba.conf entries
default['pg']['config']['hba']['local'] = {
  enabled: true,
  type: 'local',
  database: 'all',
  user: 'postgres',
  address: '',
  method: 'trust'
}
default['pg']['config']['hba']['host'] = {
  enabled: true,
  type: 'host',
  database: 'all',
  user: 'all',
  address: '127.0.0.1/32',
  method: 'md5'
}
default['pg']['config']['hba']['host6'] = {
  enabled: true,
  type: 'host',
  database: 'all',
  user: 'all',
  address: '::1/128',
  method: 'md5'
}
