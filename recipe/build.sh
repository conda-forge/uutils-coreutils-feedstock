set -ex

FEATURE_SET="unix"
if [[ "${target_platform}" == "osx"* ]]; then
    FEATURE_SET="macos"
fi

cargo install --bins --no-track --locked --root "${PREFIX}" --path . --features "${FEATURE_SET}"

cargo-bundle-licenses --format yaml --output THIRDPARTY.yml

coreutils_bin="$PREFIX/bin/coreutils"

mkdir -p "$PREFIX/share/zsh/site-functions/"
mkdir -p "$PREFIX/share/bash-completion/completions/"
mkdir -p "$PREFIX/share/fish/vendor_completions.d/"
mkdir -p "$PREFIX/share/man/man1"

"$coreutils_bin" --list >utils
while IFS= read -r util; do
    ln -sf coreutils "$PREFIX/bin/$util"
    "$coreutils_bin" completion "$util" zsh > "$PREFIX/share/zsh/site-functions/_$util"
    "$coreutils_bin" completion "$util" bash > "$PREFIX/share/bash-completion/completions/$util"
    "$coreutils_bin" completion "$util" fish > "$PREFIX/share/fish/vendor_completions.d/$util.fish"
    "$coreutils_bin" manpage "$util" > "$PREFIX/share/man/man1/$util.1"
done <utils
