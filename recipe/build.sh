set -ex

FEATURE_SET="unix"
if [[ "${target_platform}" == "osx"* ]]; then
    FEATURE_SET="macos"
fi

cargo build --release --features "${FEATURE_SET}"

make PROFILE=Release PREFIX="${PREFIX}" PROG_SUFFIX= MULTICALL=y CARGO_TARGET_DIR="$(pwd)/target/release" install

cargo-bundle-licenses --format yaml --output THIRDPARTY.yml
