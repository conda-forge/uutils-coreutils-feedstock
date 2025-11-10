@echo on

:: dump licenses
cargo-bundle-licenses --format yaml --output THIRDPARTY.yml

:: build
set CARGO_BUILD_TARGET=
make PROFILE=release MULTICALL=y PREFIX="%PREFIX%" install || goto :error

goto :EOF

:error
echo Failed with error #%errorlevel%.
exit 1
