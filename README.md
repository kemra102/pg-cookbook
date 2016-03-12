# pg Cookbook
[![Build Status](https://travis-ci.org/kemra102/pg-cookbook.svg?branch=master)](https://travis-ci.org/kemra102/pg-cookbook)

#### Table of Contents

1. [Overview](#overview)
2. [Requirements](#requirements)
3. [Attributes](#attributes)
4. [Usage](#usage)
    * [pg_hba.conf](#pg_hba.conf)
5. [Contributing](#contributing)
6. [License & Authors](#license-and-authors)

## Overview

This module manages the installation and configuration of PostgreSQL.

## Requirements

None.

## Attributes

### pg::default
| Key                               | Type      | Description                                   | Default |
|:---------------------------------:|:---------:|:---------------------------------------------:|:-------:|
| `['pg']['use_pgdg']` | `Boolean` | Determines if Postgres should be installed from the [PGDG](http://www.postgresql.org/about/). | `false`  |
| `['pg']['manage_repo']` | `Boolean` | Determines if this cookbook should manage the PGDG repo. Only applies if `['pg']['use_pgdg']` is set to `true`. | `true`  |
| `['pg']['pgdg']['version']` | `String` | Determines which version of Postgres should be installed/managed. Only applies if `['pg']['use_pgdg']` is set to `true`. | `9.3`  |
| `['pg']['initdb']` | `Boolean` | Determines if the `intidb` command should be run to do initial population of the database. | `true`  |
| `['pg']['initdb_locale']` | `String` | Determines the locale to be used by the `initdb` command on systems running versions less than Postgres 9.4. | `UTF-8`  |

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

## Usage

This recipe:

* Optionally sets up the PGDG repo.
* Installs Postgres Client.
* Installs Postgres Server.
* Configures Postgres Server.
* Configures Host-Based Authentication.
* Manages Postgres service.

To install the Postgres client:

```ruby
include_recipe 'pg::client'
```

To install the Postgres server:

```ruby
include_recipe 'pg::server'
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
