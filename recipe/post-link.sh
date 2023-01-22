set -ex

# Install Shell completion
echo Linking coreutils # debug
util_bin="$CONDA_PREFIX"/bin/coreutils
util_list="$("$util_bin" --help | tail -n +7)"

mkdir -p "$CONDA_PREFIX"/share/zsh/site-functions/
mkdir -p "$CONDA_PREFIX"/share/bash-completion/completions/
mkdir -p "$CONDA_PREFIX"/share/fish/vendor_completions.d/

for i in ${util_list//,/ }
do
  echo $i # debug
  "$util_bin" completion "$i" zsh > "$CONDA_PREFIX"/share/zsh/site-functions/_"$i"
  "$util_bin" completion "$i" zsh > "$CONDA_PREFIX"/share/bash-completion/completions/"$i"
  "$util_bin" completion "$i" zsh > "$CONDA_PREFIX"/share/fish/vendor_completions.d/"$i".fish
done
