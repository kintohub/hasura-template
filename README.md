# database
Hasura / Postgres / Schema repository

## Get Started

### Before everything else

Update the host for your Hasura Engine in `config.yaml`

```yaml
  endpoint: http://localhost:8080
```

To start a local server use `docker-compose up -d`

### Generate Migration Files

1. Run `hasura console` at project root
2. Files are generated with timestamp under `./migrations`
3. Commit the files with git

### Generate Data Migration Files

1. `hasura migrate create [name_of_migration]`
2. Paste the sql to `.up.yaml`
3. Make sure you append the "ON_CONFLICT" to the query
   1. otherwise you may need to handle the rollback situation manually (by generate delete queries)
4. Commit the files with git

### Update the hasura schema

1. Run `hasura migrate apply`

### Creating and testing migrations

1. Run `hasura migrate status` to check your migration status
2. Use the hasura console to perform schema changes
3. Before commit the schema, ensure the schema is working by rolling back it and run again
   1. Run `hasura migrate apply --down 1` to take down the last migration (or `--down n` if you have more than 1)
   2. Check the schema, it should be back to the original state
   3. If there is any errors, please check the `*.down.yaml` to fix the issues
   4. Run `hasura migrate apply` again
4. Commit the files

### Remove migrations

!! This only applies for the migration files that are not merged to staging.

1. Run `hasura migrate status` to check your migration status
2. Run `hasura migrate apply --version 1550925483858 --type down`
   1. where the version is the timestamp of the migration you wish to revert to
3. Delete your migration files that you want to remove.
4. Run `hasura migrate apply` again