# KintoHub Hasura Example

## Overview
Hasura's graphql-engine makes it easy to create secure CRUD graphql operations on top of postgres.
It also comes with the ability to stitch APIs together and even event driven operations for queuing!

__About KintoHub:__

KintoHub is a cloud platform made for fullstack developers. [Learn More](https://www.kintohub.com)

## Develop Locally

**Ensure you have Docker v2.x or higher running locally on your machine**

Hasura console records every schema changes and generate the migration queries as file.
In this project, we have set it up to automatically update your database when being deployed on KintoHub and be able to easily run it locally on your machine to test.
Migrations are branch friendly :)

You have the following files:

* **config.yaml** to configure your hasura cli tools
* **docker-compose** used to configure local postgres database and hasura instance for local testing and creating migrations.
* **Dockerfile** is used to build and deploy Hasura on KintoHub.
* **migrations** folder has all changesets / migrations and is empty by default.
* **metadata** folder has all migration metadata in it and is empty by default.
* **seeds** folder that has initial SQL data which is not covered in this example. Learn more [here](https://hasura.io/docs/1.0/graphql/core/migrations/advanced/seed-data-migration.html)

### Start Hasura + Postgres Locally

1) run `docker-compose up -d`

If you make any changes to your migrations, metadata or Dockerfile:

1) run `docker-compose build` to rebuild the image
2) run `docker-compose up -d` to update the running services

### Reset your local environment

1) run `docker-compose down -v` to delete your local postgres volume
2) run `docker-compose up -d` to bring it back up

### Install Hasura CLI

Install hasura cli tools [here](https://docs.hasura.io/1.0/graphql/manual/hasura-cli/install-hasura-cli.html)

To start a local server use `docker-compose up -d`

**NOTE: If you changed your port in the `docker-compose` file, make sure to update/syc the `config.yaml` entrypoint**

### Generate Migration Files

1. Run `hasura console` at project root
2. Files are generated with timestamp under `./migrations`
3. Commit the files with git

### Generate Data Migration Files

1. `hasura migrate create [name_of_migration]`
2. Paste the sql to `.up.yaml`
3. Make sure you append the "ON_CONFLICT" to the query. Otherwise you may need to handle the rollback situation manually (by generate delete queries)
4. Commit your files

### Force run the hasura schema updates

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

1. Run `hasura migrate status` to check your migration status
2. Run `hasura migrate apply --version 1550925483858 --type down`
   1. where the version is the timestamp of the migration you wish to revert to
3. Delete your migration files that you want to remove.
4. Run `hasura migrate apply` again

### Setup the database from scratch

In case you need to setup the database from scratch:

1. Ensure you have a super admin account or check to ensure you have [these permissions setup](https://docs.hasura.io/1.0/graphql/manual/deployment/postgres-permissions.html)
2. Install the hasura cli tools
3. Configure the `config.yaml`
4. Ensure hasura working properly by running `hasura console`
5. Run `hasura migrate apply` to run the migration

## Deploy On KintoHub

We are going to deploy Hasura + Postgres on KintoHub.

### Deploy a Postgres Server

To store your data, you will need a Postgres database.
KintoHub provides a free dedicated Postgres server with 1 GB of storage.

1. Click on the **Create Service** button displayed at the top right of your environment
2. Click on the **From Catalog** tab
3. Click on **PostgreSQL** service
4. Enter or generate your `Username`, `Password`, and `Root Password`.
5. Click on the **Deploy** button at the top right.

This process will take around **1 Minute** to complete.
Once the **Status** has changed from `Deploying` to `Live Version`, click on the **Access** tab at the top center of the page.

Copy the **Connection String (Admin)** and paste it in a notepad to use for the next step.

### Deploy a Hasura Service

1. Apply this template to your [Github Account](https://github.com/kintohub/hasura-template/generate)
2. Click on the **Create Service** button at the top right
3. Click on the **Backend API** service
4. Connect your Github Account or use **Import URL** tab to add the repository from step (1)
5. Type `8080` in the **Port** field
8. Click the **Environment Variables** tab
9. Add the **key** `HASURA_GRAPHQL_DATABASE_URL` and paste in the **Connection String (Admin)** from the previous step as the **value**
10. Add the **key** `HASURA_GRAPHQL_ENABLE_CONSOLE` and enter the value `true`
11. Click on the **Deploy** button at the top right

After a couple minutes, the Release complete successfully and an https link will be available at the bottom of the logs.

# Support

Reach out to us on [discord](https://discord.com/invite/E2CMjKP) or our [contact us page](https://www.kintohub.com/contact-us)
