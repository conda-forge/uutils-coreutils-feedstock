set -ex

util_bin="$CONDA_PREFIX"/bin/coreutils
util_list="$("$util_bin" --help)"
util_list="${str#*Currently defined functions:}"
util_list="${util_list//[[:space:]]/}"
util_list="${util_list//,/ }"

mkdir -p "$CONDA_PREFIX"/share/zsh/site-functions/
mkdir -p "$CONDA_PREFIX"/share/bash-completion/completions/
mkdir -p "$CONDA_PREFIX"/share/fish/vendor_completions.d/
mkdir -p "$CONDA_PREFIX"/share/man/man1

for i in $util_list
do
  "$util_bin" completion "$i" zsh > "$CONDA_PREFIX"/share/zsh/site-functions/_"$i"
  "$util_bin" completion "$i" bash > "$CONDA_PREFIX"/share/bash-completion/completions/"$i"
  "$util_bin" completion "$i" fish > "$CONDA_PREFIX"/share/fish/vendor_completions.d/"$i".fish
  "$util_bin" manpage "$i" > "$CONDA_PREFIX"/share/man/man1/"$i".1
done
