FROM hasura/graphql-engine:v1.3.1.cli-migrations-v2

ENV HASURA_GRAPHQL_ENABLE_CONSOLE true

COPY migrations /hasura-migrations
COPY metadata /hasura-metadata
COPY metadata /hasura-seeds
