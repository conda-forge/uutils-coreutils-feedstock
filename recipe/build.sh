#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

cargo-bundle-licenses --format yaml --output THIRDPARTY.yml

if [[ "$(uname)" == "Linux" ]]; then
    export LIBCLANG_PATH=$BUILD_PREFIX/lib
fi

export LN="$(command -v ln) -sf"
make PROFILE=release-small MULTICALL=y PREFIX="${PREFIX}" LN="${LN}" install
