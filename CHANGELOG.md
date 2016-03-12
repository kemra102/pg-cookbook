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
