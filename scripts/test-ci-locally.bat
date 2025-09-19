@echo off
title IFAA CI Workflow Local Test
echo ========================================
echo IFAA CI Workflow Local Test
echo ========================================
echo This script simulates the GitHub Actions workflow locally
echo.

REM Check prerequisites
echo Checking prerequisites...
where flutter >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Flutter is not installed or not in PATH
    exit /b 1
)

where node >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Node.js is not installed or not in PATH
    exit /b 1
)

echo [OK] Prerequisites check passed
echo.

REM Step 1: Setup Flutter
echo Step 1: Setting up Flutter environment...
flutter pub get
if %errorlevel% neq 0 (
    echo [ERROR] Flutter setup failed
    exit /b 1
)
echo [OK] Flutter environment setup completed
echo.

REM Step 2: Build web
echo Step 2: Building web application...
flutter build web --release
if %errorlevel% neq 0 (
    echo [ERROR] Web build failed
    exit /b 1
)
echo [OK] Web build completed successfully
echo.

REM Step 3: Compress assets (simulating the CI step)
echo Step 3: Compressing assets for faster loading...
node scripts\compress-assets.js
if %errorlevel% neq 0 (
    echo [ERROR] Asset compression failed
    exit /b 1
)
echo [OK] Asset compression completed successfully
echo.

REM Step 4: Verify compressed files exist
echo Step 4: Verifying compressed assets...
if exist "build\web\main.dart.js.gz" (
    echo [OK] Main application bundle compressed
) else (
    echo [ERROR] Main application bundle not compressed
    exit /b 1
)

if exist "build\web\index.html.gz" (
    echo [OK] HTML file compressed
) else (
    echo [ERROR] HTML file not compressed
    exit /b 1
)

if exist "build\web\*.js.gz" (
    echo [OK] JavaScript files compressed
) else (
    echo [ERROR] JavaScript files not compressed
    exit /b 1
)

echo [OK] All compressed assets verified
echo.

REM Step 5: Summary
echo ========================================
echo CI Workflow Local Test Summary:
echo ========================================
echo ✓ Flutter environment setup
echo ✓ Web application build
echo ✓ Asset compression
echo ✓ Compressed asset verification
echo.
echo [SUCCESS] All CI workflow steps passed locally!
echo You can now push to GitHub with confidence.
echo ========================================
echo.