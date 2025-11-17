@echo on

:: dump licenses
cargo-bundle-licenses --format yaml --output THIRDPARTY.yml

for /f "usebackq delims=" %%A in (`where ln`) do set "LN=%%A" :: https://github.com/uutils/coreutils/issues/9244
for /f "usebackq delims=" %%A in (`where link`) do set "RUSTC_LINKER=%%A" :: https://github.com/conda-forge/uutils-coreutils-feedstock/pull/22

:: convert Windows format path to Unix format
if "%LN%" == "" ( echo LN not set & goto :error)
if "%PREFIX%" == "" ( echo PREFIX not set & goto :error)
if "%RUSTC_LINKER%" == "" ( echo RUSTC_LINKER not set & goto :error)
for /f "usebackq delims=" %%A in (`cygpath -u "%%LN%%"`) do set "LN=%%A"
for /f "usebackq delims=" %%A in (`cygpath -u "%%PREFIX%%"`) do set "PREFIX=%%A"
for /f "usebackq delims=" %%A in (`cygpath -u "%%RUSTC_LINKER%%"`) do set "RUSTC_LINKER=%%A"

:: build
set CARGO_BUILD_TARGET=
make PROFILE=release MULTICALL=y PREFIX="%PREFIX%" LN="%LN%" install || goto :error

goto :EOF

:error
echo Failed with error #%errorlevel%.
exit 1
