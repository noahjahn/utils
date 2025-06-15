#!/bin/bash

source "$NOAHJAHN_UTILS_DIR/scripts/bash/base-image-tag.sh"
source "$NOAHJAHN_UTILS_DIR/scripts/bash/validate-binary.sh"

id=$(_validate_binary uuidgen)
docker=$(_validate_binary docker)

IMAGE_TAG="$BASE_IMAGE_TAG-golang"
CONTAINER_NAME="$IMAGE_TAG-$($id +%s)"

$docker build --pull --quiet -f "$NOAHJAHN_UTILS_DIR/Dockerfile.golang" -t $IMAGE_TAG . || exit 1

mkdir -p "$NOAHJAHN_UTILS_DIR/.go/bin"

$docker run --name $CONTAINER_NAME --rm --entrypoint=go -v $NOAHJAHN_UTILS_DIR/.go/bin:/go/bin -v go-cache:/home/go/.cache -v $(pwd):/home/go/src -w /home/go/src $IMAGE_TAG "$@" || exit 1
