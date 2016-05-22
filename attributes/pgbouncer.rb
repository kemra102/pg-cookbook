default['pg']['packages']['pgbouncer'] = 'pgbouncer'

default['pg']['config']['pgbouncer']['pgbouncer']['logfile'] = '/var/log/pgbouncer/pgbouncer.log'
default['pg']['config']['pgbouncer']['pgbouncer']['pidfile'] = '/var/run/pgbouncer/pgbouncer.pid'
default['pg']['config']['pgbouncer']['pgbouncer']['listen_addr'] = '127.0.0.1'
default['pg']['config']['pgbouncer']['pgbouncer']['listen_port'] = 6432
default['pg']['config']['pgbouncer']['pgbouncer']['auth_type'] = 'trust'
default['pg']['config']['pgbouncer']['pgbouncer']['auth_file'] = '/etc/pgbouncer/userlist.txt'
default['pg']['config']['pgbouncer']['pgbouncer']['admin_users'] = %w(postgres)
default['pg']['config']['pgbouncer']['pgbouncer']['stats_users'] = %w(stats postgres)
default['pg']['config']['pgbouncer']['pgbouncer']['pool_mode'] = 'session'
default['pg']['config']['pgbouncer']['pgbouncer']['server_reset_query'] = 'DISCARD ALL'
default['pg']['config']['pgbouncer']['pgbouncer']['max_client_conn'] = 100
default['pg']['config']['pgbouncer']['pgbouncer']['default_pool_size'] = 20
