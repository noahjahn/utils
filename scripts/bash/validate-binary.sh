#!/bin/bash

source "$NOAHJAHN_UTILS_DIR/scripts/bash/check-for-binary.sh"

_validate_binary() {
    bin=$(_check_for_binary $1)
    status=$?
    if [ $status != 0 ]; then
        echo $bin >&2
        set -e
        exit $status
    fi

    echo $bin
}
