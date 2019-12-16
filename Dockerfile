FROM hasura/graphql-engine:v1.0.0-rc.1.cli-migrations

ENV HASURA_GRAPHQL_MIGRATIONS_DIR /migrations \
    HASURA_GRAPHQL_ENABLE_CONSOLE true \
    HASURA_GRAPHQL_UNAUTHORIZED_ROLE anonymous \
    HASURA_GRAPHQL_DATABASE_URL postgres://postgres:tea@cs-patroni:5432/postgres \
    HASURA_GRAPHQL_ADMIN_SECRET

COPY migrations /migrations
