set -ex

MANPAGES=
COMPLETIONS=

# Generating manpages and completions requires calling the built tools
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" ]]; then
    MANPAGES=y
    COMPLETIONS=y
fi

make PROFILE=release PREFIX="${PREFIX}" PROG_SUFFIX= MULTICALL=y \
    MANPAGES=${MANPAGES} COMPLETIONS=${COMPLETIONS} install

cargo-bundle-licenses --format yaml --output THIRDPARTY.yml
