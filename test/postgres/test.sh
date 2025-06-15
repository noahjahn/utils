#!/bin/bash

source "$NOAHJAHN_UTILS_DIR/scripts/bash/validate-binary.sh"

__docker_compose() {
    dirname=$(_validate_binary dirname)
    readlink=$(_validate_binary readlink)
    docker=$(_validate_binary docker)

    SCRIPT_DIR="$($dirname "$($readlink -f "$0")")"
    $docker compose -f $SCRIPT_DIR/docker-compose.test.yml $@
}

__wait_for_database() {
    echo "Waiting for database $1 to be ready..."
    while ! __docker_compose exec $1 pg_isready -U postgres; do
        sleep 1
    done
}

__seed_database() {
    echo "Seeding database $1..."
    wget=$(_validate_binary wget)

    SAMPLE_DATABASE_URL=https://ftp.postgresql.org/pub/projects/pgFoundry/dbsamples/world/world-1.0/world-1.0.tar.gz
    SAMPLE_DATABASE_ROOT_DIR=dbsamples-0.1
    SAMPLE_DATABASE_PATH=$SAMPLE_DATABASE_ROOT_DIR/world/world.sql

    $wget -q -O- $SAMPLE_DATABASE_URL | tar -xzf -

    __docker_compose cp $SAMPLE_DATABASE_ROOT_DIR $1:/
    __docker_compose exec $1 psql -U test -f /$SAMPLE_DATABASE_PATH
}

_setup() {
    __docker_compose up --build -d
    __wait_for_database source
    __wait_for_database target
    __seed_database source
}

_execute() {
    echo "Running tests..."
    psql_export=$(_validate_binary psql-export)
    psql_import=$(_validate_binary psql-import)
    local_ip=$(_validate_binary local-ip)

    SOURCE_PORT=5432
    TARGET_PORT=5433

    $psql_export -h $($local_ip) -p $SOURCE_PORT -u test -d test
    $psql_import -h $($local_ip) -p $TARGET_PORT -u test -d test -f test.sql
}

_teardown() {
    __docker_compose down --remove-orphans
    rm -rf dbsamples-0.1
    rm test.sql
}

_handle_failure() {
    _teardown
    exit 1
}

_setup || { _handle_failure; }
_execute $1 || { _handle_failure; }
_teardown
