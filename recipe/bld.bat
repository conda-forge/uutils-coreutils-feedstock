@echo on

:: dump licenses
cargo-bundle-licenses --format yaml --output THIRDPARTY.yml

:: build
set CARGO_BUILD_TARGET=
for /f "usebackq delims=" %%A in (`which ln`) do set "LN=%%A" :: https://github.com/uutils/coreutils/issues/9244
for /f "usebackq delims=" %%A in (`cygpath -u "%%PREFIX%%"`) do set "PREFIX=%%A" :: convert Windows format path to Unix format
make PROFILE=release MULTICALL=y PREFIX="%PREFIX%" LN="%LN%" install || goto :error

goto :EOF

:error
echo Failed with error #%errorlevel%.
exit 1
