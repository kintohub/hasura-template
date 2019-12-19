FROM hasura/graphql-engine:v1.0.0.cli-migrations

ENV HASURA_GRAPHQL_MIGRATIONS_DIR /migrations
ENV HASURA_GRAPHQL_ENABLE_CONSOLE true
ENV HASURA_GRAPHQL_UNAUTHORIZED_ROLE anonymous
ENV HASURA_GRAPHQL_DATABASE_URL postgres://postgres:tea@cs-patroni:5432/postgres

COPY migrations /migrations
