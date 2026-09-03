@echo on

:: dump licenses
cargo-bundle-licenses --format yaml --output THIRDPARTY.yml

:: copy l10n resources (only for utilities that exist in the source tree)
for /d %%D in (coreutils-l10n\src\uu\*) do (
    if exist "src\uu\%%~nxD" xcopy /s /e /y /q "%%D\*" "src\uu\%%~nxD\" >nul
)

:: build
cargo install --root "%PREFIX%" --path . --locked --no-track --profile release-small --features windows || goto :error

:: expose every utility as its own executable (see launcher.c); `link` is
:: skipped because a `link.exe` on PATH shadows the MSVC linker
cl /nologo /O1 /MT /W4 /WX "%RECIPE_DIR%\launcher.c" /Fe:"%SRC_DIR%\launcher.exe" /link /SUBSYSTEM:CONSOLE || goto :error
for /f "usebackq delims=" %%U in (`"%PREFIX%\bin\coreutils.exe" --list`) do (
    if not "%%U" == "link" copy /y "%SRC_DIR%\launcher.exe" "%PREFIX%\bin\%%U.exe" >nul || goto :error
)

goto :EOF

:error
echo Failed with error #%errorlevel%.
exit 1
