#!/bin/bash

_validate_input() {
    if [ -z "$1" ]; then
        $2
        set -e
        exit 0
    fi
}
