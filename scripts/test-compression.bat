@echo off
echo Testing asset compression locally...
echo.

REM Build the web app first
echo Step 1: Building Flutter web app...
flutter build web --release

if %errorlevel% neq 0 (
    echo Error: Flutter build failed
    exit /b %errorlevel%
)

echo.
echo Step 2: Testing asset compression...
node scripts\compress-assets.js

if %errorlevel% neq 0 (
    echo Error: Asset compression failed
    exit /b %errorlevel%
)

echo.
echo [SUCCESS] Local compression test passed!
echo All assets were compressed successfully.
echo.