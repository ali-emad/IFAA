@echo off
echo Building Flutter web app with enhanced caching...
echo.

REM Build the Flutter web app
echo Step 1: Building Flutter web app...
flutter build web --release

if %errorlevel% neq 0 (
    echo Error: Flutter build failed
    exit /b %errorlevel%
)

echo.
echo Step 2: Compressing assets for faster loading...
node scripts\compress-assets.js

if %errorlevel% neq 0 (
    echo Error: Asset compression failed
    exit /b %errorlevel%
)

echo.
echo Build and compression completed successfully!
echo.
echo To serve the app with gzip compression, run:
echo   scripts\serve-compressed.bat
echo.