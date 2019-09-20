#!/bin/sh

# FROM https://github.com/hasura/graphql-engine/blob/master/scripts/cli-migrations/docker-entrypoint.sh

set -e

log() {
    MESSAGE=$1
    echo $REVISION $MESSAGE
}

DEFAULT_MIGRATIONS_DIR="/hasura-migrations"
TEMP_MIGRATIONS_DIR="/tmp/hasura-migrations"

# check server port and ser default as 8080
if [ -z ${HASURA_GRAPHQL_SERVER_PORT+x} ]; then
    HASURA_GRAPHQL_SERVER_PORT=8080
fi

if [ -z ${HASURA_GRAPHQL_MIGRATIONS_SERVER_TIMEOUT+x} ]; then
    HASURA_GRAPHQL_MIGRATIONS_SERVER_TIMEOUT=30
fi

# wait for a port to be ready
wait_for_port() {
    local PORT=$1
    log "waiting $HASURA_GRAPHQL_MIGRATIONS_SERVER_TIMEOUT for $PORT to be ready"
    for i in `seq 1 $HASURA_GRAPHQL_MIGRATIONS_SERVER_TIMEOUT`;
    do
        nc -z localhost $PORT > /dev/null 2>&1 && log "port $PORT is ready" && return
        sleep 1
    done
    log "failed waiting for $PORT" && exit 1
}

# wait for port to be ready
wait_for_port $HASURA_GRAPHQL_SERVER_PORT

# check if migration directory is set, default otherwise
if [ -z ${HASURA_GRAPHQL_MIGRATIONS_DIR+x} ]; then
    HASURA_GRAPHQL_MIGRATIONS_DIR="$DEFAULT_MIGRATIONS_DIR"
fi

# apply migrations if the directory exist
if [ -d "$HASURA_GRAPHQL_MIGRATIONS_DIR" ]; then
    log "applying migrations from $HASURA_GRAPHQL_MIGRATIONS_DIR"
    mkdir -p "$TEMP_MIGRATIONS_DIR"
    cp -a "$HASURA_GRAPHQL_MIGRATIONS_DIR/." "$TEMP_MIGRATIONS_DIR/migrations/"
    cd "$TEMP_MIGRATIONS_DIR"
    echo "endpoint: http://localhost:$HASURA_GRAPHQL_SERVER_PORT" > config.yaml
    echo "show_update_notification: false" >> config.yaml
    hasura-cli migrate apply
    # check if metadata.[yaml|json] exist and apply
    if [ -f migrations/metadata.yaml ]; then
        log "applying metadata from $HASURA_GRAPHQL_MIGRATIONS_DIR/metadata.yaml"
        hasura-cli metadata apply
    elif [ -f migrations/metadata.json ]; then
        log "applying metadata from $HASURA_GRAPHQL_MIGRATIONS_DIR/metadata.json"
        hasura-cli metadata apply
    fi
else
    log "directory $HASURA_GRAPHQL_MIGRATIONS_DIR does not exist, skipping migrations"
fi