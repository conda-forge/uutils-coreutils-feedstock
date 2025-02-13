cargo install --bins --no-track --locked --root "%LIBRARY_PREFIX%" --path . --features windows
if errorlevel 1 exit 1

cargo-bundle-licenses --format yaml --output THIRDPARTY.yml
if errorlevel 1 exit 1
