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

# stdbuf looks for libstdbuf next to its own executable before falling back to
# the compile-time LIBSTDBUF_DIR. That fallback contains the build prefix, which
# is deliberately not rewritten at install time (see prefix_detection).
if [ -d "${PREFIX}/libexec/coreutils" ]; then
    mv "${PREFIX}"/libexec/coreutils/libstdbuf.* "${PREFIX}/bin/"
    rmdir "${PREFIX}/libexec/coreutils" "${PREFIX}/libexec"
fi
