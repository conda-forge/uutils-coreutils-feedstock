@echo on

set CARGO_PROFILE_RELEASE_STRIP=symbols
set CARGO_PROFILE_RELEASE_LTO=fat

:: check licenses
cargo-bundle-licenses --format yaml --output THIRDPARTY.yml

:: build
set CARGO_BUILD_TARGET=
make PROFILE=release MULTICALL=y PREFIX="%LIBRARY_PREFIX%" install || goto :error

goto :EOF

:error
echo Failed with error #%errorlevel%.
exit 1
