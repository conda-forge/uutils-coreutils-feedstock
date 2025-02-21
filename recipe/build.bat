make PROFILE=release PREFIX="%LIBRARY_PREFIX%" MULTICALL=n PROG_SUFFIX=.exe install
if errorlevel 1 exit 1

cargo-bundle-licenses --format yaml --output THIRDPARTY.yml
if errorlevel 1 exit 1
