#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

cargo-bundle-licenses --format yaml --output THIRDPARTY.yml

if [[ "$(uname)" == "Linux" ]]; then
    export LIBCLANG_PATH=$BUILD_PREFIX/lib
fi

# copy l10n resources (only for utilities that exist in the source tree)
for util_dir in coreutils-l10n/src/uu/*/; do
    util_name=$(basename "$util_dir")
    if [ -d "src/uu/${util_name}" ]; then
        cp -a "${util_dir}"* "src/uu/${util_name}/"
    fi
done

export LN="$(command -v ln) -sf"
make PROFILE=release-small MULTICALL=y PREFIX="${PREFIX}" LN="${LN}" install
