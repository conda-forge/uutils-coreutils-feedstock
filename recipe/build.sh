set -ex

FEATURE_SET="unix"
if [[ "${target_platform}" == "osx"* ]]; then
    FEATURE_SET="macos"
fi

cargo build --release --target="${CARGO_BUILD_TARGET}" --features "${FEATURE_SET}"

make PROFILE=Release PREFIX="${PREFIX}" PROG_SUFFIX= MULTICALL=y install

cargo-bundle-licenses --format yaml --output THIRDPARTY.yml
