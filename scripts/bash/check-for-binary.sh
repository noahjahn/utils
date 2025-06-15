#!/bin/bash

_check_for_binary() {
    if ! command -v "$1" 2>&1 >/dev/null; then
        echo "$1 could not be found"
        exit 1
    fi

    bin=$(which $1)
    echo $bin
}
