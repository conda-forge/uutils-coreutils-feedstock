@echo on

:: dump licenses
cargo-bundle-licenses --format yaml --output THIRDPARTY.yml

for /f "usebackq delims=" %%A in (`where ln`) do set "LN=%%A" :: https://github.com/uutils/coreutils/issues/9244

:: convert Windows format path to Unix format
if "%LN%" == "" ( echo LN not set & goto :error)
if "%PREFIX%" == "" ( echo PREFIX not set & goto :error)
for /f "usebackq delims=" %%A in (`cygpath -u "%%LN%%"`) do set "LN=%%A"
for /f "usebackq delims=" %%A in (`cygpath -u "%%PREFIX%%"`) do set "PREFIX=%%A"

:: build
set CARGO_BUILD_TARGET=
make PROFILE=release MULTICALL=y PREFIX="%PREFIX%" LN="%LN%" install || goto :error

goto :EOF

:error
echo Failed with error #%errorlevel%.
exit 1
