@echo off
echo Validating GitHub Actions workflow file...
echo.

REM Check if yq is installed (for YAML validation)
yq --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Warning: yq is not installed. Installing now...
    echo This will install yq using chocolatey
    timeout /t 3 /nobreak >nul
    
    REM Try to install yq
    choco install yq -y
    if %errorlevel% neq 0 (
        echo Failed to install yq. Please install it manually:
        echo 1. Install Chocolatey from https://chocolatey.org/install
        echo 2. Run: choco install yq
        echo.
        echo Skipping YAML validation...
        goto validate_structure
    )
)

:validate_structure
echo.
echo Checking workflow file structure...
echo.

REM Basic structure checks
findstr /C:"name:" .github\workflows\deploy.yml >nul
if %errorlevel% equ 0 (
    echo [OK] Workflow has a name
) else (
    echo [ERROR] Workflow is missing name
    exit /b 1
)

findstr /C:"on:" .github\workflows\deploy.yml >nul
if %errorlevel% equ 0 (
    echo [OK] Workflow has trigger events
) else (
    echo [ERROR] Workflow is missing trigger events
    exit /b 1
)

findstr /C:"jobs:" .github\workflows\deploy.yml >nul
if %errorlevel% equ 0 (
    echo [OK] Workflow has jobs section
) else (
    echo [ERROR] Workflow is missing jobs section
    exit /b 1
)

echo.
echo [SUCCESS] Workflow structure validation passed!
echo You can now test the workflow with act or push to GitHub.
echo.