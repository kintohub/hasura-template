FROM hasura/graphql-engine:v1.0.0-beta.6.cli-migrations

ENV HASURA_GRAPHQL_MIGRATIONS_DIR /migrations \
    HASURA_GRAPHQL_ENABLE_CONSOLE true \
    HASURA_GRAPHQL_UNAUTHORIZED_ROLE anonymous \
    HASURA_GRAPHQL_DATABASE_URL \
    HASURA_GRAPHQL_ADMIN_SECRET

COPY migrations /migrations