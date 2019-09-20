# database
Hasura / Postgres / Schema repository

Thanks to https://gitlab.com/tactable.io/graphql-next-app/tree/master/hasura

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


## Steps to follow

Thanks to https://gitlab.com/tactable.io/graphql-next-app/tree/master/hasura

gcloud components install beta
gcloud components update

gcloud auth login

gcloud projects create —name hasura-test-app —set-as-default

Open web page and setup billing

gcloud services enable sqladmin.googleapis.com


gcloud sql instances create test-app-db \
 --availability-type zonal \
 --no-backup \
 --database-version POSTGRES_9_6 \
 --root-password {secure_password} \
 --storage-type HDD \
 --tier db-f1-micro \
 —zone asia-northeast1

gcloud sql databases create hasura --instance test-app-db

gcloud sql users set-password postgres \
    --instance test-app-db \
    --password abcd1234

TEST_APP_DB=$(gcloud sql instances describe test-app-db | \
 grep connectionName | \
 awk '{print $2}')

export TEST_APP_PROJECT_ID=$(gcloud config list --format 'value(core.project)')

echo $TEST_APP_PROJECT_ID

gcloud services enable cloudbuild.googleapis.com

https://console.cloud.google.com/marketplace/details/google-cloud-platform/cloud-run

Go to cloud IAM and add cloud sql client

gcloud builds submit ./hasura \
   --tag gcr.io/$TEST_APP_PROJECT_ID/graphql-server:latest

gcloud beta run deploy \
 --image gcr.io/$TEST_APP_PROJECT_ID/graphql-server:latest \
 --region asia-northeast1 \
 --platform managed \
 --set-env-vars HASURA_GRAPHQL_DATABASE_URL="postgres://postgres:abcd1234@127.0.0.1:5432/hasura",CLOUDSQL_INSTANCE=${TEST_APP_DB} \
 --timeout 900 \
 --allow-unauthenticated