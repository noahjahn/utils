#!/bin/bash

source "$NOAHJAHN_UTILS_DIR/scripts/bash/base-image-tag.sh"
source "$NOAHJAHN_UTILS_DIR/scripts/bash/validate-binary.sh"

id=$(_validate_binary uuidgen)
docker=$(_validate_binary docker)

entrypoint=go
command=""
interactive=true
while [[ $# -gt 0 ]]; do
    case "$1" in
    --utils-entrypoint)
        if [[ -z $2 || $2 == -* ]]; then
            echo "Error: --utils-entrypoint requires a value" >&2
            exit 1
        fi
        entrypoint=$2
        shift 2
        ;;

    --utils-port)
        if [[ -z $2 || $2 == -* ]]; then
            echo "Error: --utils-port requires a value" >&2
            exit 1
        fi
        port=$2
        shift 2
        ;;

    --utils-non-interactive)
        interactive=false
        shift 1
        ;;
    *)
        command+="$1 "
        shift
        ;;
    esac
done

command="${command%" "}"

IMAGE_TAG="$BASE_IMAGE_TAG-golang"
CONTAINER_NAME="$IMAGE_TAG-$($id +%s)"

$docker build --build-arg USERNAME=$(whoami) --pull --quiet -f "$NOAHJAHN_UTILS_DIR/Dockerfile.golang" -t $IMAGE_TAG . >/dev/null || exit 1

mkdir -p "$NOAHJAHN_UTILS_DIR/.go/bin"

run="$docker run --name $CONTAINER_NAME --rm --init -t --entrypoint=$entrypoint \
    -v $NOAHJAHN_UTILS_DIR/.go:/home/$(whoami)/go \
    -v $HOME/.cache:/home/$(whoami)/.cache \
    -v $(pwd):$(pwd) \
    -w $(pwd)"

if [[ -n $port ]]; then
    run="$run -p $port"
fi

if [ -t 1 ]; then
    run="$run -i"
fi

$run $IMAGE_TAG $command || exit 1
