set -ex

# Install Shell completion
echo Unlinking coreutils # debug
util_bin="$CONDA_PREFIX"/bin/coreutils
util_list="$("$util_bin" --help | tail -n +7)"
util_list="${util_list//[[:blank:]]/}"
util_list="${util_list//,/ }"

for i in $util_list
do
  rm "$CONDA_PREFIX"/share/zsh/site-functions/_"$i"
  rm "$CONDA_PREFIX"/share/bash-completion/completions/"$i"
  rm "$CONDA_PREFIX"/share/fish/vendor_completions.d/"$i".fish
done
