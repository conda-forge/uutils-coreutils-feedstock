cargo build  --features "base32 base64 basename basenc cat cksum comm cp csplit cut date dd df dir dircolors dirname echo env expand expr factor false fmt fold hashsum head join link ln ls mkdir mktemp more mv nl nproc numfmt od paste pr printenv printf ptx pwd readlink realpath rm rmdir seq shred shuf sleep sort split sum sync tac tail tee test tr true truncate tsort unexpand uniq vdir wc whoami yes" --release --no-default-features
if errorlevel 1 exit 1

make PROFILE=release PREFIX="%CYGWIN_PREFIX%/Library" MULTICALL=n PROG_SUFFIX=.exe install
if errorlevel 1 exit 1

cargo-bundle-licenses --format yaml --output THIRDPARTY.yml
if errorlevel 1 exit 1
