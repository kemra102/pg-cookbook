## 2016-05-22 (v1.4.0)
### Summary
Adds support for pgbouncer.

#### Features
- Added pgbouncer support:
  - Install pgbouncer from PGDG.
  - Manage all config files.
  - Manage pgbouncer service.

## 2016-03-23 (v1.3.1)
### Summary
Reload the service when changing HBA config instead of restarting.

#### Bugfixes
- Updating config for `pg_hba.conf` will now cause the Postgres service to reload instead of restart. This change was made as doing a full restart caused undesirable behaviour in some situations.

## 2016-03-15 (v1.3.0)
### Summary
Configurable `initdb` command.

#### Features
- The `initdb` is now configurable via an attribute. The default remains the same as previous versions. This change was made to be able to perform alternate commands, for example on a Slave with Streaming Replication you need to copy the data from the master rather than run the traditional initdb command.

## 2016-03-14 (v1.2.0)
### Summary
Added pgpool-II support.

#### Features
- Added pgpool-II support.
  - Install pgpool-II from PGDG.
  - Manage all config files.
  - Manage pgpool-II service.

## 2016-03-12 (v1.1.0)
### Summary
Made `initdb` optional.

#### Features
- Made `initdb` optional in order to support SR (Streaming Replication) set-ups where the slave should not be initialised with it's own data. This value is set to `true` by default.

## 2016-03-07 (v1.0.0)
### Summary
Initial release.

#### Features
- Install Client and/or Server.
- Use distro or PGDG packages.
- Optionally manage the PGDG repo.
- Manage `postgresql.conf values`.
- Manage entries in `pg_hba.conf`.
- Manage the Postgres service.
