.\util\show-utils.BAT >utils.txt
if errorlevel 1 exit 1

for /F "tokens=*" %%i in (utils.txt) do cargo install --bins --no-track --locked --root "%LIBRARY_PREFIX%" --path src/uu/%%i

cargo-bundle-licenses --format yaml --output THIRDPARTY.yml
if errorlevel 1 exit 1
