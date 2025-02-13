cargo install --bins --no-track --locked --root "%LIBRARY_PREFIX%" --path . --features windows
if errorlevel 1 exit 1

%LIBRARY_PREFIX%\bin\coreutils.exe --list >utils.txt
if errorlevel 1 exit 1

for /F "tokens=*" %%i in (utils.txt) do cp %LIBRARY_PREFIX%\bin\coreutils.exe %LIBRARY_PREFIX%\bin\%%i.exe
if errorlevel 1 exit 1

cargo-bundle-licenses --format yaml --output THIRDPARTY.yml
if errorlevel 1 exit 1
