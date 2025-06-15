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
    while ! __docker_compose exec $1 mysqladmin ping -h localhost -psecret --user test; do
        sleep 1
    done

    echo "Database $1 is ready."
}

__seed_database() {
    echo "Seeding database $1..."
    __docker_compose exec $1 mysql --user test -psecret </$SAMPLE_DATABASE_PATH
}

SAMPLE_DATABASE_URL=https://github.com/datacharmer/test_db/releases/download/v1.0.7/test_db-1.0.7.tar.gz
SAMPLE_DATABASE_ROOT_DIR=test_db
SAMPLE_DATABASE_PATH=$SAMPLE_DATABASE_ROOT_DIR/employees.sql

__setup_sample_database() {
    echo "Setting up sample database $1..."

    wget=$(_validate_binary wget)
    $wget -q -O- $SAMPLE_DATABASE_URL | tar -xzf -

    __docker_compose cp $SAMPLE_DATABASE_ROOT_DIR $1:/
}

_setup() {
    __docker_compose up --build -d
    __wait_for_database source
    __wait_for_database target
    __setup_sample_database source
    __docker_compose exec source mysql --user test -psecret </$SAMPLE_DATABASE_PATH
    __setup_sample_database target
    __seed_database source
}

_execute() {
    echo "Running tests..."
    msql_export=$(_validate_binary msql-export)
    msql_import=$(_validate_binary msql-import)
    local_ip=$(_validate_binary local-ip)

    SOURCE_PORT=5432
    TARGET_PORT=5433

    $msql_export -h $($local_ip) -p $SOURCE_PORT -u test -d test
    $msql_import -h $($local_ip) -p $TARGET_PORT -u test -d test -f test.sql

    __docker_compose exec source mysql -U test -psecret -t </$SAMPLE_DATABASE_ROOT_DIR/test_employees_sha.sql
}

_teardown() {
    __docker_compose down --remove-orphans
    rm -rf test_db
    rm test.sql
}

_handle_failure() {
    _teardown
    exit 1
}

_setup || { _handle_failure; }
_execute $1 || { _handle_failure; }
_teardown
