#!/bin/bash

source "$NOAHJAHN_UTILS_DIR/scripts/bash/base-image-tag.sh"
source "$NOAHJAHN_UTILS_DIR/scripts/bash/validate-binary.sh"

id=$(_validate_binary uuidgen)
docker=$(_validate_binary docker)

# cmd=go
# preceding=""
# while [[ $# -gt 0 ]]; do
#     case "$1" in
#     --utils-cmd)
#         if [[ -z $2 || $2 == -* ]]; then
#             echo "Error: --utils-cmd requires a value" >&2
#             exit 1
#         fi
#         cmd=$2
#         shift 2
#         break
#         ;;
#     *)
#         preceding="$preceding$1 "
#         if [[ -z $2 ]]; then
#             shift
#         else
#             preceding="$preceding$2 "
#             shift 2
#         fi
#         ;;
#     esac
# done

# pass="${cmd%" "} $preceding"
# pass="${pass%" "} $@"
# pass="${pass%" "}"

IMAGE_TAG="$BASE_IMAGE_TAG-golang"
CONTAINER_NAME="$IMAGE_TAG-$($id +%s)"

$docker build --build-arg USERNAME=$(whoami) --pull --quiet -f "$NOAHJAHN_UTILS_DIR/Dockerfile.golang" -t $IMAGE_TAG . >/dev/null || exit 1

mkdir -p "$NOAHJAHN_UTILS_DIR/.go/bin"

$docker run --name $CONTAINER_NAME --rm --entrypoint=go \
    -v $NOAHJAHN_UTILS_DIR/.go:/home/$(whoami)/go \
    -v $HOME/.cache:/home/$(whoami)/.cache \
    -v $(pwd):$(pwd) \
    -w $(pwd) \
    $IMAGE_TAG "$@" || exit 1
