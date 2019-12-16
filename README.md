# KintoHub Hasura Example

## Overview
Hasura is a graphql engine which makes it easy to create CRUD graphql on top of postgres aside from stitching together APIs providing and eventing queue!

[](live/example/on/kintohub)

__About KintoHub:__

KintoHub aligns teams to ship & operate cloud native apps with ease. [Learn More](https://www.kintohub.com)


## Deployment

1. Apply this template to your [Github](https://github.com/kintohub/hasura-template/generate)
2. Create a [Website Block](https://beta.kintohub.com) on KintoHub:
3. Set the name of your block
4. Select `Dynamic Web App`
5. For `language` select `Custom Dockerfile`
6. Set the port to 8080
7. Hit the `Create` button
8. You're now good to build! Click `Build Latest Commit`. Once complete, Click  Now click `Add To Project` and Create a new Project.
9. Scroll to "KintoBlocks" section and in the Search Box type "Postgres" and select it to add a Postgres Database.
10. Click `Create New Project` at bottom right

The deployment can take up to 3 minutes. Once successful, click `Open URL` on the Hasura Block under "KintoBlocks" section.

## Installation & Local Run

Run `docker-compose up -d`

## Usage

Click "Open URL" and start playing with hasura. We recommend using the advance migration functionality for multiple environments such as `dev` and `staging`.

## What's Next?

* [Password protect your hasura instance](https://docs.kintohub.com/docs/kintoblocks/websites#basic-auth-for-websites)
* [Setup `dev` and `staging` environments](https://docs.kintohub.com/docs/projects/environments)
* [Read KintoHub's block series on Hasura](https://blog.kintohub.com/from-idea-to-scale-with-hasura-kintohub-part-1-7-bbc97532424a)

## Hasura Pro Tips && Operations!

Hasura console records every schema changes and generate the migration queries as file. In this project,we have set it up to automatically update your database when being deployed on KintoHub and be able to easily run it locally on your machine to test. Migrations are branch friendly :)

You have the following files:

* **config.yaml** to configure your hasura cli tools
* **docker-compose** used to configure local postgres database and hasura instance for local testing and creating migrations.
* **Dockerfile** is used to build and deploy your migrations onto Kintohub.
* **migrations** folder has all changesets / migrations in it currently empty by default.

### Before everything else

Install hasura cli tools [here](https://docs.hasura.io/1.0/graphql/manual/hasura-cli/install-hasura-cli.html)

To start a local server use `docker-compose up -d`

**NOTE: If you changed your port in the `docker-compose` file, make sure to update/syc the `config.yaml` entrypoint.**

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

## Setup the database from scratch

In case you need to setup the database from scratch:

1. Ensure you have a super admin account or check to ensure you have [these permissions setup](https://docs.hasura.io/1.0/graphql/manual/deployment/postgres-permissions.html)
2. Install the hasura cli tools
3. Configure the `config.yaml`
4. Ensure hasura working properly by running `hasura console`
5. Run `hasura migrate apply` to run the migration
