@echo off
setlocal enabledelayedexpansion

echo [1/3] Gathering your project files...

set "SWIFT_FILES="
for /r %%f in (*.swift) do (
    set "SWIFT_FILES=!SWIFT_FILES! "%%f""
)

echo [2/3] Cooking your School System...

swiftc ^
    -sdk "C:\Users\Moham\AppData\Local\Programs\Swift\Platforms\6.3.1\Windows.platform\Developer\SDKs\Windows.sdk" ^
    -I .\Resources\swift ^
    -I .\Resources\include ^
    -L .\Resources\bin ^
    -lSwiftWin32 ^
    -lsqlite3 ^
    !SWIFT_FILES! ^
    -o SchoolSystem.exe

if %errorlevel% neq 0 (
    echo.
    echo [!] Build Failed. Look at the errors above.
    pause
    exit /b %errorlevel%
)

echo [3/3] Build Successful! SchoolSystem.exe created.

copy .\Resources\bin\*.dll . >nul
echo [+] Launching your app...

.\SchoolSystem.exe

echo [+] Cleaning up log files...
del /q *.log 2>nul
del /q logs.txt 2>nul

endlocal