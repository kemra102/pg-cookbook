# pg Cookbook
[![Build Status](https://travis-ci.org/kemra102/pg-cookbook.svg?branch=master)](https://travis-ci.org/kemra102/pg-cookbook)

#### Table of Contents

1. [Overview](#overview)
2. [Requirements](#requirements)
3. [Attributes](#attributes)
4. [Usage](#usage)
    * [pg_hba.conf](#pg_hba.conf)
    * [pool_hba.conf](#pool_hba.conf)
5. [Contributing](#contributing)
6. [License & Authors](#license-and-authors)

## Overview

This module manages the installation and configuration of PostgreSQL.

## Requirements

* Chef (no particular version at this time).
* `yum` Cookbook.

## Attributes

### pg::server
| Key                               | Type      | Description                                   | Default |
|:---------------------------------:|:---------:|:---------------------------------------------:|:-------:|
| `['pg']['use_pgdg']` | `Boolean` | Determines if Postgres should be installed from the [PGDG](http://www.postgresql.org/about/). | `false`  |
| `['pg']['manage_repo']` | `Boolean` | Determines if this cookbook should manage the PGDG repo. Only applies if `['pg']['use_pgdg']` is set to `true`. | `true`  |
| `['pg']['pgdg']['version']` | `String` | Determines which version of Postgres should be installed/managed. Only applies if `['pg']['use_pgdg']` is set to `true`. | `9.3`  |
| `['pg']['initdb']` | `Boolean` | Determines if the `intidb` command should be run to do initial population of the database. | `true`  |
| `['pg']['initdb_locale']` | `String` | Determines the locale to be used by the `initdb` command on systems running versions less than Postgres 9.4. | `UTF-8`  |
| `['pg']['initdb_cmd']` | `String` | The command to be run in order to initialise database. | Varies based on PG Version, see `recipes/server.rb:11-26` |

The following attributes are used to populate `postgresql.conf`:

| Key                               | Type      | Description                                   | Default |
|:---------------------------------:|:---------:|:---------------------------------------------:|:-------:|
| `['pg']['config']['server']['port']` | `Integer` | Port that Postgres should listen on. | `5432` |
| `['pg']['config']['server']['max_connections']` | `Integer` | Determines the number of connection "slots" that are reserved for connections by PostgreSQL superusers. At most max_connections connections can ever be active simultaneously. Whenever the number of active concurrent connections is at least max_connections minus superuser_reserved_connections, new connections will be accepted only for superusers, and no new replication connections will be accepted. | `100` |
| `['pg']['config']['server']['shared_buffers']` | `String` | Sets the amount of memory the database server uses for shared memory buffers. | `32MB` |
| `['pg']['config']['server']['logging_collector']` | `Boolean` | This parameter enables the logging collector, which is a background process that captures log messages sent to stderr and redirects them into log files. | `true` |
| `['pg']['config']['server']['log_filename']` | `String` | When logging_collector is enabled, this parameter sets the file names of the created log files. The value is treated as a strftime pattern, so %-escapes can be used to specify time-varying file names. (Note that if there are any time-zone-dependent %-escapes, the computation is done in the zone specified by log_timezone.) The supported %-escapes are similar to those listed in the Open Group's strftime specification. Note that the system's strftime is not used directly, so platform-specific (nonstandard) extensions do not work. | `postgresql-%a.log` |
| `['pg']['config']['server']['log_truncate_on_rotation']` | `Boolean` | When logging_collector is enabled, this parameter will cause PostgreSQL to truncate (overwrite), rather than append to, any existing log file of the same name. | `true` |
| `['pg']['config']['server']['log_rotation_age']` | `String` | When logging_collector is enabled, this parameter determines the maximum lifetime of an individual log file. After this many minutes have elapsed, a new log file will be created. Set to zero to disable time-based creation of new log files. | `1d` |
| `['pg']['config']['server']['log_rotation_size']` | `Integer` | When logging_collector is enabled, this parameter determines the maximum size of an individual log file. After this many kilobytes have been emitted into a log file, a new log file will be created. Set to zero to disable size-based creation of new log files. | `0` |
| `['pg']['config']['server']['log_timezone']` | `String` | Sets the time zone used for timestamps written in the server log. Unlike TimeZone, this value is cluster-wide, so that all sessions will report timestamps consistently. | `UTC` |
| `['pg']['config']['server']['datestyle']` | `String` | Sets the display format for date and time values, as well as the rules for interpreting ambiguous date input values. | `iso, mdy` |
| `['pg']['config']['server']['timezone']` | `String` | Sets the time zone for displaying and interpreting time stamps. | `UTC` |
| `['pg']['config']['server']['lc_messages']` | `String` | Sets the language in which messages are displayed. | `en_US.UTF-8` |
| `['pg']['config']['server']['lc_monetary']` | `String` | Sets the locale to use for formatting monetary amounts, for example with the to_char family of functions. | `en_US.UTF-8` |
| `['pg']['config']['server']['lc_numeric']` | `String` | Sets the locale to use for formatting numbers, for example with the to_char family of functions. | `en_US.UTF-8` |
| `['pg']['config']['server']['lc_time']` | `String` | Sets the locale to use for formatting dates and times, for example with the to_char family of functions. | `en_US.UTF-8` |
| `['pg']['config']['server']['default_text_search_config']` | `String` | Selects the text search configuration that is used by those variants of the text search functions that do not have an explicit argument specifying the configuration. | `pg_catalog.english` |

> NOTE: Values that read as `on` or `off` in `postgresql.conf` should be set as `true` or `false` respectively.

Finally the following default `pg_hba.conf` entries are:

```ruby
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
```

The default `pg_hba.conf` entries can be disabled by setting their `enabled` values to `false`, e.g.:

```ruby
default['pg']['config']['hba']['local']['enabled'] = false
```

### pg::pgbouncer

| Key                               | Type      | Description                                   | Default |
|:---------------------------------:|:---------:|:---------------------------------------------:|:-------:|
| `['pg']['packages']['pgbouncer']` | `String` | Specifies the name of the `pgbouncer` package. | `pgbouncer` |


The following attributes are usef to populate `/etc/pgbouncer/pgbouncer.ini`:

| Key                               | Type      | Description                                   | Default |
|:---------------------------------:|:---------:|:---------------------------------------------:|:-------:|
| `['pg']['config']['pgbouncer']['pgbouncer']['logfile']` | `String` | Specifies log file. Log file is kept open so after rotation `kill -HUP` or on console `RELOAD;` should be done. | `/var/log/pgbouncer/pgbouncer.log` |
| `['pg']['config']['pgbouncer']['pgbouncer']['pidfile']` | `String` | Specifies the pid file. Without a pidfile, daemonization is not allowed. | `/var/run/pgbouncer/pgbouncer.pid` |
| `['pg']['config']['pgbouncer']['pgbouncer']['listen_addr']` | `String` | Specifies list of addresses, where to listen for TCP connections. You may also use `*` meaning "listen on all addresses". When not set, only Unix socket connections are allowed. | `127.0.0.1` |
| `['pg']['config']['pgbouncer']['pgbouncer']['listen_port']` | `Integer` | Which port to listen on. Applies to both TCP and Unix sockets. | `6432` |
| `['pg']['config']['pgbouncer']['pgbouncer']['auth_type']` | `String` | How to authenticate users. See the [official documentation](https://pgbouncer.github.io/config.html) for support auth types. | `trust` |
| `['pg']['config']['pgbouncer']['pgbouncer']['auth_file']` | `String` | The name of the file to load user names and passwords from. The file format is the same as the PostgreSQL 8.x pg_auth/pg_pwd file, so this setting can be pointed directly to one of those backend files. | `/etc/pgbouncer/userlist.txt` |
| `['pg']['config']['pgbouncer']['pgbouncer']['admin_users']` | `Array` | Comma-separated list of database users that are allowed to connect and run all commands on console. Ignored when `auth_type` is `any`, in which case any username is allowed in as admin. | `%w(postgres)` |
| `['pg']['config']['pgbouncer']['pgbouncer']['stats_users']` | `Array` | Comma-separated list of database users that are allowed to connect and run read-only queries on console. Thats means all `SHOW` commands except `SHOW FDS`. | `%w(stats postgres)` |
| `['pg']['config']['pgbouncer']['pgbouncer']['pool_mode']` | `String` | Specifies when a server connection can be reused by other clients. | `session` |
| `['pg']['config']['pgbouncer']['pgbouncer']['server_reset_query']` | `String` | Query sent to server on connection release, before making it available to other clients. | `DISCARD ALL` |
| `['pg']['config']['pgbouncer']['pgbouncer']['max_client_conn']` | `Integer` | Maximum number of client connections allowed. | `100` |
| `['pg']['config']['pgbouncer']['pgbouncer']['default_pool_size']` | `integer` | How many server connections to allow per user/database pair. Can be overridden in the per-database configuration. | `20` |

By default the `[databases]` section of `/etc/pgbouncer/pgbouncer.ini` is not populated. You can populate like so:

```ruby
default['pg']['config']['pgbouncer']['databases']['wordpress'] = 'dbname=wordpress host=postgres.example.net user=wordpress'
```

You should do this for each database you wish `pgbouncer` to create a connection for.

If `['pg']['config']['pgbouncer']['pgbouncer']['auth_type']` is set to `hba` & `['pg']['config']['pgbouncer']['pgbouncer']['auth_hba_file']` is set then the HBA file can be populated as per the following example:

```ruby
default['pg']['config']['pool_hba']['md5'] = {
  enabled: true,
  type: 'host',
  database: 'all',
  user: 'all',
  address: '0.0.0.0/0',
  method: 'md5'
}
```

### pg::pgpool

| Key                               | Type      | Description                                   | Default |
|:---------------------------------:|:---------:|:---------------------------------------------:|:-------:|
| `['pg']['config']['pgpool']['listen_addresses']` | `String` | Specifies the hostname or IP address, on which pgpool-II will accept TCP/IP connections. | `localhost` |
| `['pg']['config']['pgpool']['port']` | `Integer` | The port number used by pgpool-II to listen for connections. | `9999` |
| `['pg']['config']['pgpool']['socket_dir']` | `String` | The directory where the UNIX domain socket accepting connections for pgpool-II will be created. | `/tmp` |
| `['pg']['config']['pgpool']['listen_backlog_multiplier']` | `Integer` | Controls the length of connection queue from frontend to pgpool-II. | `2` |
| `['pg']['config']['pgpool']['serialize_accept']` | `Boolean` | Whether to serialize accept() call for incoming client connections. | `false` |
| `['pg']['config']['pgpool']['pcp_listen_addresses']` | `String` | Specifies the hostname or IP address, on which pcp process will accept TCP/IP connections. | `*` |
| `['pg']['config']['pgpool']['pcp_port']` | `Integer` | The port number where PCP process accepts connections. | `9898` |
| `['pg']['config']['pgpool']['pcp_socket_dir']` | `String` | The directory path of the UNIX domain socket accepting connections for the PCP process. | `/tmp` |
| `['pg']['config']['pgpool']['backend_hostname0']` | `String` | Specifies where to connect with the PostgreSQL backend. It is used by pgpool-II to communicate with the server. | `localhost` |
| `['pg']['config']['pgpool']['backend_port0']` | `Integer` | Specifies the port number of the backends. | `5432` |
| `['pg']['config']['pgpool']['backend_weight0']` | `Integer` | Specifies the load balance ratio for the backends. | `1` |
| `['pg']['config']['pgpool']['backend_data_directory0']` | `Integer` | Specifies the database cluster directory of the backends. | `''` |
| `['pg']['config']['pgpool']['backend_flag0']` | `String` | Controls various backend behavior. | `ALLOW_TO_FAILOVER` |
| `['pg']['config']['pgpool']['enable_pool_hba']` | `Boolean` | Just like the `pg_hba.conf` file for PostgreSQL. | `false` |
| `['pg']['config']['pgpool']['authentication_timeout']` | `Integer` | Specify the timeout for pgpool authentication. | `60` |
| `['pg']['config']['pgpool']['ssl']` | `Boolean` | If `true`, enable SSL support for both the frontend and backend connections. | `false` |
| `['pg']['config']['pgpool']['num_init_children']` | `Integer` | The number of preforked pgpool-II server processes. | `32` |
| `['pg']['config']['pgpool']['max_pool']` | `Integer` | The maximum number of cached connections in pgpool-II children processes. | `4` |
| `['pg']['config']['pgpool']['child_life_time']` | `Integer` | A pgpool-II child process' life time in seconds. | `300` |
| `['pg']['config']['pgpool']['child_max_connections']` | `Integer` | A pgpool-II child process will be terminated after this many connections from clients. | `0` |
| `['pg']['config']['pgpool']['connection_life_time']` | `Integer` | Cached connections expiration time in seconds. An expired cached connection will be disconnected. | `0` |
| `['pg']['config']['pgpool']['client_idle_limit']` | `Integer` | Disconnect a client if it has been idle for client_idle_limit seconds after the last query has completed. | `0` |
| `['pg']['config']['pgpool']['log_destination']` | `String` | PgPool II supports several methods for logging server messages, including `stderr` and `syslog`. | `stderr` |
| `['pg']['config']['pgpool']['log_line_prefix']` | `String` | This is a printf-style string that is output at the beginning of each log line. | `%t: pid %p: ` |
| `['pg']['config']['pgpool']['log_connections']` | `Boolean` | If true, all incoming connections will be printed to the log. | `false` |
| `['pg']['config']['pgpool']['log_hostname']` | `Boolean` | If true, ps command status will show the client's hostname instead of an IP address. | `false` |
| `['pg']['config']['pgpool']['log_statement']` | `Boolean` | Produces SQL log messages when true. | `false` |
| `['pg']['config']['pgpool']['log_per_node_statement']` | `Boolean` | Similar to log_statement, except that it prints logs for each DB node separately. | `false` |
| `['pg']['config']['pgpool']['log_standby_delay']` | `String` | Specifies how to log the replication delay. | `none` |
| `['pg']['config']['pgpool']['syslog_facility']` | `String` | When logging to syslog is enabled, this parameter determines the syslog "facility" to be used. | `LOCAL0` |
| `['pg']['config']['pgpool']['syslog_ident']` | `String` | When logging to syslog is enabled, this parameter determines the program name used to identify PgPool messages in syslog logs. | `pgpool` |
| `['pg']['config']['pgpool']['debug_level']` | `Integer` | Debug message verbosity level. | `0` |
| `['pg']['config']['pgpool']['connection_cache']` | `Boolean` | Caches connections to backends when set to true. | `true` |
| `['pg']['config']['pgpool']['reset_query_list']` | `String` | Specifies the SQL commands sent to reset the connection to the backend when exiting a session. | `ABORT; DISCARD ALL` |
| `['pg']['config']['pgpool']['replication_mode']` | `Boolean` | Setting to true enables replication mode. | `false` |
| `['pg']['config']['pgpool']['insert_lock']` | `Boolean` | If replicating a table with SERIAL data type, the SERIAL column value may differ between the backends. | `true` |
| `['pg']['config']['pgpool']['lobj_lock_table']` | `String` | This parameter specifies a table name used for large object replication control. | `''` |
| `['pg']['config']['pgpool']['replication_stop_on_mismatch']` | `Boolean` | When set to true, if all backends don't return the same packet kind, the backends that differ from most frequent result set are degenerated. | `false` |
| `['pg']['config']['pgpool']['failover_if_affected_tuples_mismatch']` | `Boolean` | When set to true, if backends don't return the same number of affected tuples during an `INSERT`/`UPDATE`/`DELETE`, the backends that differ from most frequent result set are degenerated.  | `false` |
| `['pg']['config']['pgpool']['load_balance_mode']` | `Boolean` | When set to true, SELECT queries will be distributed to each backend for load balancing. Default is false. | `false` |
| `['pg']['config']['pgpool']['ignore_leading_white_space']` | `Boolean` | pgpool-II ignores white spaces at the beginning of SQL queries while in the load balance mode. | `true` |
| `['pg']['config']['pgpool']['white_function_list']` | `String` | Specify a comma separated list of function names that **do not** update the database. | `''` |
| `['pg']['config']['pgpool']['black_function_list']` | `String` | Specify a comma separated list of function names that **do** update the database. | `nextval,setval,nextval,setval` |
| `['pg']['config']['pgpool']['database_redirect_preference_list']` | `String` | You can set "database name:node id" pair to specify the node id when connecting to the database. | `''` |
| `['pg']['config']['pgpool']['app_name_redirect_preference_list']` | `String` | You can set "application name:node id" pair to specify the node id when the application is used.  | `''` |
| `['pg']['config']['pgpool']['allow_sql_comments']` | `Boolean` | If on, ignore SQL comments when judging if load balance or query cache is possible. If off, SQL comments effectively prevent the judgment (pre 3.4 behavior). | `false` |
| `['pg']['config']['pgpool']['master_slave_mode']` | `Boolean` | This mode is used to couple pgpool-II with another master/slave replication software (like Slony-I and Streaming replication), which is responsible for doing the actual data replication. | `false` |
| `['pg']['config']['pgpool']['master_slave_sub_mode']` | `String` | The master/slave mode has a `master_slave_sub` mode. The default is `slony` which is suitable for Slony-I. You can also set it to `stream`, which should be set if you want to work with PostgreSQL's built-in replication system (Streaming Replication). | `slony` |
| `['pg']['config']['pgpool']['sr_check_period']` | `Integer` | This parameter specifies the interval between the streaming replication delay checks in seconds.  | `0` |
| `['pg']['config']['pgpool']['sr_check_user']` | `String` | The user name to perform streaming replication check. | `nobody` |
| `['pg']['config']['pgpool']['sr_check_password']` | `String` | The password of the user to perform streaming replication check. | `''` |
| `['pg']['config']['pgpool']['sr_check_database']` | `String` | The database to perform streaming replication delay check. | `postgres` |
| `['pg']['config']['pgpool']['delay_threshold']` | `Integer` | Specifies the maximum tolerated replication delay of the standby against the primary server in WAL bytes. | `0` |
| `['pg']['config']['pgpool']['follow_master_command']` | `String` | This parameter specifies a command to run in master/slave streaming replication mode only after a master failover | `''` |
| `['pg']['config']['pgpool']['health_check_period']` | `Integer` | This parameter specifies the interval between the health checks in seconds. | `0` |
| `['pg']['config']['pgpool']['health_check_timeout']` | `Integer` | pgpool-II periodically tries to connect to the backends to detect any error on the servers or networks. | `20` |
| `['pg']['config']['pgpool']['health_check_user']` | `String` | The user name to perform health check. | `nobody` |
| `['pg']['config']['pgpool']['health_check_password']` | `String` | The password of the user to perform health check. | `''` |
| `['pg']['config']['pgpool']['health_check_database']` | `String` | The database name to perform health check. | `''` |
| `['pg']['config']['pgpool']['health_check_max_retries']` | `Integer` | The maximum number of times to retry a failed health check before giving up and initiating failover. | `0` |
| `['pg']['config']['pgpool']['health_check_retry_delay']` | `Integer` | The amount of time (in seconds) to sleep between failed health check retries (not used unless `health_check_max_retries` is > 0). | `1` |
| `['pg']['config']['pgpool']['failover_command']` | `String` | This parameter specifies a command to run when a node is detached. | `''` |
| `['pg']['config']['pgpool']['failback_command']` | `String` | This parameter specifies a command to run when a node is attached. | `''` |
| `['pg']['config']['pgpool']['fail_over_on_backend_error']` | `Boolean` | If true, and an error occurs when reading/writing to the backend communication, pgpool-II will trigger the fail over procedure. | `true` |
| `['pg']['config']['pgpool']['search_primary_node_timeout']` | `Integer` | The parameter specifies the maximum amount of time in seconds to search for a primary node when a failover scenario occurs. | `10` |
| `['pg']['config']['pgpool']['recovery_user']` | `String` | This parameter specifies a PostgreSQL user name for online recovery. | `nobody` |
| `['pg']['config']['pgpool']['recovery_password']` | `String` | This parameter specifies a PostgreSQL password for online recovery. | `''` |
| `['pg']['config']['pgpool']['recovery_1st_stage_command']` | `String` | This parameter specifies a command to be run by master(primary) PostgreSQL server at the first stage of online recovery. | `''` |
| `['pg']['config']['pgpool']['recovery_2nd_stage_command']` | `String` | This parameter specifies a command to be run by master(primary) PostgreSQL server at the second stage of online recovery. | `''` |
| `['pg']['config']['pgpool']['recovery_timeout']` | `Integer` | pgpool does not accept new connections during the second stage. If a client connects to pgpool during recovery processing, it will have to wait for the end of the recovery. This parameter specifies recovery timeout in sec. If this timeout is reached, pgpool cancels online recovery and accepts connections. | `90` |
| `['pg']['config']['pgpool']['client_idle_limit_in_recovery']` | `Integer` | Similar to client_idle_limit but only takes effect in the second stage of recovery. | `0` |
| `['pg']['config']['pgpool']['use_watchdog']` | `Boolean` | If on, activates watchdog. | `false` |
| `['pg']['config']['pgpool']['trusted_servers']` | `String` | The list of trusted servers to check the up stream connections. | `''` |
| `['pg']['config']['pgpool']['ping_path']` | `String` | This parameter specifies a path of ping command for monitoring connection to the upper servers. | `/bin` |
| `['pg']['config']['pgpool']['wd_hostname']` | `String` | Specifies the hostname or IP address of pgpool-II server. | `''` |
| `['pg']['config']['pgpool']['wd_port']` | `Integer` | Specifies the port number for watchdog communication. | `9000` |
| `['pg']['config']['pgpool']['wd_priority']` | `Integer` | This parameter can be used to elevate the local watchdog node priority in the elections to select master watchdog node. | `1` |
| `['pg']['config']['pgpool']['wd_authkey']` | `String` | This option specifies the authentication key used in watchdog communication. All the pgpool-II must have the same key. | `''` |
| `['pg']['config']['pgpool']['wd_ipc_socket_dir']` | `String` | The directory where the UNIX domain socket accepting pgpool-II watchdog IPC connections will be created.  | `/tmp` |
| `['pg']['config']['pgpool']['delegate_IP']` | `String` | Specifies the virtual IP address (VIP) of pgpool-II that is connected from client servers (application servers etc.). | `''` |
| `['pg']['config']['pgpool']['if_cmd_path']` | `String` | This parameter specifies a path of a command to switch the IP address. | `/sbin` |
| `['pg']['config']['pgpool']['if_up_cmd']` | `String` | This parameter specifies a command to bring up the virtual IP. | `ip addr add $_IP_$/24 dev #{node['network']['default_interface']} label #{node['network']['default_interface']}:0` |
| `['pg']['config']['pgpool']['if_down_cmd']` | `String` | This parameter specifies a command to bring down the virtual IP. | `ip addr del $_IP_$/24 dev #{node['network']['default_interface']}` |
| `['pg']['config']['pgpool']['arping_path']` | `String` | This parameter specifies a path of a command to send an ARP request after the virtual IP is switched. | `/usr/sbin` |
| `['pg']['config']['pgpool']['arping_cmd']` | `String` | This parameter specifies a command to send an ARP request after the virtual IP is switched. | `arping -U $_IP_$ -w 1` |
| `['pg']['config']['pgpool']['clear_memqcache_on_escalation']` | `Boolean` | If this is on, watchdog clears all the query cache in the shared memory when pgpool-II escaltes to active.  | `true` |
| `['pg']['config']['pgpool']['wd_escalation_command']` | `String` | Watchdog executes this command on the node that is escalated to the master watchdog. | `''` |
| `['pg']['config']['pgpool']['wd_de_escalation_command']` | `String` | Watchdog executes this command on the master pgpool-II watchdog node when that node resigns from the master node responsibilities. | `''` |
| `['pg']['config']['pgpool']['wd_monitoring_interfaces_list']` | `String` | Specify a comma separated list of network device names, to be monitored by the watchdog process for the network link state. | `''` |
| `['pg']['config']['pgpool']['wd_lifecheck_method']` | `String` | This parameter specifies the method of life check. This can be either of `heartbeat` (default), `query` or `external`. | `heartbeat` |
| `['pg']['config']['pgpool']['wd_interval']` | `Integer` | This parameter specifies the interval between life checks of pgpool-II in second. | `10` |
| `['pg']['config']['pgpool']['wd_heartbeat_port']` | `Integer` | This option specifies the port number to receive heartbeat signals. | `9694` |
| `['pg']['config']['pgpool']['wd_heartbeat_keepalive']` | `Integer` | This option specifies the interval time (sec.) of sending heartbeat signals. | `2` |
| `['pg']['config']['pgpool']['wd_heartbeat_deadtime']` | `Integer` | If there are no heartbeat signal for the period specified by this option, watchdog regards it as failure of the remote pgpool-II. | `30` |
| `['pg']['config']['pgpool']['heartbeat_destination0']` | `String` | This option specifies the destination of heartbeat signals by IP address or hostname. | `host0_ip1` |
| `['pg']['config']['pgpool']['heartbeat_destination_port0']` | `Integer` | This option specifies the port number of destination of heartbeat signals which is specified by heartbeat_destinationX. | `9694` |
| `['pg']['config']['pgpool']['heartbeat_device0']` | `String` | This option specifies the network device name for sending heartbeat signals to destination specified by heartbeat_destinationX. | `''` |
| `['pg']['config']['pgpool']['wd_life_point']` | `Integer` | The times to retry a failed life check of pgpool-II. | `3` |
| `['pg']['config']['pgpool']['wd_lifecheck_query']` | `String` | Actual query to check pgpool-II. | `SELECT 1` |
| `['pg']['config']['pgpool']['wd_lifecheck_dbname']` | `String` | The database name connected for checking pgpool-II. | `template1` |
| `['pg']['config']['pgpool']['wd_lifecheck_user']` | `String` | The user name to check pgpool-II. | `nobody` |
| `['pg']['config']['pgpool']['wd_lifecheck_password']` | `String` | The password of the user to check pgpool-II. | `''` |
| `['pg']['config']['pgpool']['relcache_expire']` | `Integer` | Life time of relation cache in seconds. | `0` |
| `['pg']['config']['pgpool']['relcache_size']` | `Integer` | Number of relcache entries. | `256` |
| `['pg']['config']['pgpool']['check_temp_table']` | `Boolean` | If on, enable temporary table check in SELECT statements. | `true` |
| `['pg']['config']['pgpool']['check_unlogged_table']` | `Boolean` | If on, enable unlogged table check in SELECT statements. | `true` |
| `['pg']['config']['pgpool']['memory_cache_enabled']` | `Boolean` | To enable the memory cache functionality, set this to on. | `false` |
| `['pg']['config']['pgpool']['memqcache_method']` | `String` | Memory cache behavior can be specified by `memqcache_method` directive. Either `shmem` (shared memory) or `memcached`. | `shmem` |
| `['pg']['config']['pgpool']['memqcache_memcached_host']` | `String` | Specify the host name or the IP address in which memcached works. | `localhost` |
| `['pg']['config']['pgpool']['memqcache_memcached_port']` | `Integer` | Specify the port number of memcached. | `11211` |
| `['pg']['config']['pgpool']['memqcache_total_size']` | `Integer` | Specify the size of shared memory as cache storage in bytes. | `67108864` |
| `['pg']['config']['pgpool']['memqcache_max_num_cache']` | `Integer` | Specify the number of cache entries. | `1000000` |
| `['pg']['config']['pgpool']['memqcache_expire']` | `Integer` | Life time of query cache in seconds. | `0` |
| `['pg']['config']['pgpool']['memqcache_auto_cache_invalidation']` | `Boolean` | If on, automatically deletes cache related to the updated tables. | `true` |
| `['pg']['config']['pgpool']['memqcache_maxcache']` | `Integer` | If the size of a `SELECT` result is larger than `memqcache_maxcache` bytes, it is not cached and the messages is shown: `2012-05-02 15:08:17 LOG:   pid 13756: pool_add_temp_query_cache: data size exceeds memqcache_maxcache. current:4095 requested:111 memq_maxcache:4096`. To avoid this problem, you have to set `memqcache_maxcache` larger. | `409600` |
| `['pg']['config']['pgpool']['memqcache_cache_block_size']` | `Integer` | If cache storage is shared memory, pgpool uses the memory divided by memqcache_cache_block_size. | `1048576` |
| `['pg']['config']['pgpool']['memqcache_oiddir']` | `String` | Full path to the directory where oids of tables used by SELECTs are stored. | `/var/log/pgpool/oiddir` |
| `['pg']['config']['pgpool']white_memqcache_table_list` | `String` | Specify a comma separated list of table names whose SELECT results are to be cached even if they are VIEWs or unlogged tables. | `''` |
| `['pg']['config']['pgpool']['black_memqcache_table_list']` | `String` | Specify a comma separated list of table names whose SELECT results are **NOT** to be cached. | `''` |
| `['pg']['config']['pgpool']['pid_file_name']` | `String` | Full path to a file which contains pgpool's process id. | `/var/run/pgpool-II-#{node['pg']['pgdg']['version'].delete('.')}/pgpool.pid` |
| `['pg']['config']['pgpool']['logdir']` | `String` | pgpool_status is written into this directory. | `/var/log/pgpool-II-#{node['pg']['pgdg']['version'].delete('.')}` |

The following default entry is added to `pool_hba.conf`:

```ruby
default['pg']['config']['pool_hba']['md5'] = {
  enabled: true,
  type: 'host',
  database: 'all',
  user: 'all',
  address: '0.0.0.0/0',
  method: 'md5'
}
```

## Usage

This cookbook can:

* Optionally sets up the PGDG repo.
* Install Postgres Client.
* Install Postgres Server.
* Configure Postgres Server.
* Configure Host-Based Authentication.
* Manage Postgres service.
* Install pgbouncer.
* Configure pgbouncer (including HBA if applicable).
* Manage pgbouncer service.
* Install pgpool-II.
* Configure pgpool-II (including PCP & HBA).
* Manage pgpool-II service.

To install the Postgres client:

```ruby
include_recipe 'pg::client'
```

To install the Postgres server:

```ruby
include_recipe 'pg::server'
```

To install pgbouncer:

```ruby
include_recipe 'pg::pgbouncer'
```

To install pgpool-II:

```ruby
include_recipe 'pg::pgpool'
```

### pg_hba.conf

To create new entries in `pg_hba.conf` create a new uniquely named hash under `['pg']['config']['hba']`, e.g.:

```ruby
default['pg']['config']['hba']['www'] = {
  enabled: true,
  type: 'host',
  database: 'www',
  user: 'www',
  address: '192.168.0.1/32',
  method: 'md5'
}
```

### pool_hba.conf

To create new entries in `pool_hba.conf` for pgpool-II servers create a new uniquely named hash under `['pg']['config']['pool_hba']`, e.g.:

```ruby
default['pg']['config']['pool_hba']['www'] = {
  enabled: true,
  type: 'host',
  database: 'www',
  user: 'www',
  address: '192.168.0.1/32',
  method: 'trust'
}
```

## Contributing

If you would like to contribute to this cookbook please follow these steps;

1. Fork the repository on Github.
2. Create a named feature branch (like `add_component_x`).
3. Write your change.
4. Write tests for your change (if applicable).
5. Write documentation for your change (if applicable).
6. Run the tests, ensuring they all pass.
7. Submit a Pull Request using GitHub.

## License and Authors

License: [BSD 2-Clause](https://tldrlegal.com/license/bsd-2-clause-license-\(freebsd\))

Authors:

  * [Danny Roberts](https://github.com/kemra102)
  * [All Contributors](https://github.com/kemra102/yumserver-cookbook/graphs/contributors)
