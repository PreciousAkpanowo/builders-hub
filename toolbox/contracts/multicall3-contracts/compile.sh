#!/bin/bash
set -exu -o pipefail

SCRIPT_DIR=$(dirname "$0")
# Convert to absolute path
SCRIPT_DIR=$(cd "$SCRIPT_DIR" && pwd)

ICM_COMMIT="ebd8b64"
SUBNET_EVM_VERSION="v0.7.3"

# Get current user and group IDs
CURRENT_UID=$(id -u)
CURRENT_GID=$(id -g)

rm -rf "$SCRIPT_DIR/compiled"

docker build -t multicall3-compiler --build-arg SUBNET_EVM_VERSION=$SUBNET_EVM_VERSION --build-arg ICM_COMMIT=$ICM_COMMIT "$SCRIPT_DIR"
docker run -it --rm \
    -v "${SCRIPT_DIR}/compiled":/compiled \
    -v "${SCRIPT_DIR}/multicall3_source":/multicall3_source \
    -e ICM_COMMIT=$ICM_COMMIT \
    -e HOST_UID=$CURRENT_UID \
    -e HOST_GID=$CURRENT_GID \
    multicall3-compiler
