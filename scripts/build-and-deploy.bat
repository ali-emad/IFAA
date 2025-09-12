@echo off
REM IFAA App Build and Deploy Script for GitHub Pages (Windows)

echo 🚀 Building IFAA App for GitHub Pages...

REM Clean previous builds
echo 🧹 Cleaning previous builds...
flutter clean
flutter pub get

REM Build for web with proper base href
echo 🔨 Building web app...
flutter build web --release --web-renderer html --base-href "/ifaa_app_template/"

REM Check if build was successful
if %errorlevel% equ 0 (
    echo ✅ Build completed successfully!
    echo 📁 Build files are in: build/web/
    echo.
    echo 🌐 To deploy manually:
    echo    1. Install gh-pages: npm install -g gh-pages
    echo    2. Deploy: gh-pages -d build/web
    echo.
    echo 🔄 Or push to main branch for automatic deployment via GitHub Actions
) else (
    echo ❌ Build failed!
    exit /b 1
)