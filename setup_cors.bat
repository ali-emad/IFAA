@echo off
echo Firebase Storage CORS Setup Script
echo =================================

echo.
echo Checking if Google Cloud SDK is installed...
echo -------------------------------------------

where gcloud >nul 2>&1
if %errorlevel% == 0 (
    echo Google Cloud SDK is installed.
    echo.
    
    echo Initializing gcloud (if not already initialized)...
    echo ------------------------------------------------
    gcloud init
    echo.
    
    echo Setting project configuration...
    echo ----------------------------
    gcloud config set project ifaa-54ebf
    echo.
    
    echo Installing gsutil component (if not already installed)...
    echo -----------------------------------------------------
    gcloud components install gsutil
    echo.
    
    echo Applying CORS configuration...
    echo ----------------------------
    echo Using bucket name: gs://ifaa-54ebf.appspot.com
    gsutil cors set cors.json gs://ifaa-54ebf.appspot.com
    
    if %errorlevel% == 0 (
        echo.
        echo CORS configuration applied successfully!
        echo.
        echo Please restart your Flutter web app:
        echo   flutter run -d chrome
        echo.
    ) else (
        echo.
        echo Failed to apply CORS configuration.
        echo Please check the error message above.
        echo.
        echo Alternative solution:
        echo 1. Go to https://console.firebase.google.com/
        echo 2. Select your project
        echo 3. Click on "Storage" in the left sidebar
        echo 4. Click on the "Rules" tab
        echo 5. Replace the existing rules with the rules from storage.rules file
        echo 6. Click "Publish" to save the rules
        echo.
    )
) else (
    echo Google Cloud SDK is not installed or not in PATH.
    echo.
    echo Step 1: Downloading Google Cloud SDK
    echo ------------------------------------
    echo Please download and install the Google Cloud SDK from:
    echo https://cloud.google.com/sdk/docs/install
    echo.
    echo During installation, make sure to:
    echo 1. Select "Add to PATH" option
    echo 2. Restart your command prompt after installation
    echo.
    echo Step 2: After installation
    echo ------------------------
    echo 1. Run this script again
    echo.
    echo Press any key to open the download page in your browser...
    pause >nul
    start "" "https://cloud.google.com/sdk/docs/install"
    echo.
    echo After installing Google Cloud SDK, please:
    echo 1. Restart your command prompt
    echo 2. Run this script again
    echo.
)

pause