# PowerShell script to guide Firebase Storage setup
# This script provides instructions since Firebase Storage initialization requires manual steps

Write-Host "Firebase Storage Setup Script" -ForegroundColor Green
Write-Host "=============================" -ForegroundColor Green
Write-Host ""

Write-Host "IMPORTANT: Firebase Storage initialization requires manual steps in the Firebase Console." -ForegroundColor Yellow
Write-Host ""

Write-Host "Step 1: Initialize Firebase Storage" -ForegroundColor Cyan
Write-Host "----------------------------------" -ForegroundColor Cyan
Write-Host "1. Open your web browser and go to:" -ForegroundColor White
Write-Host "   https://console.firebase.google.com/" -ForegroundColor White
Write-Host ""
Write-Host "2. Select your project: ifaa-54ebf" -ForegroundColor White
Write-Host ""
Write-Host "3. In the left sidebar, click on 'Storage'" -ForegroundColor White
Write-Host ""
Write-Host "4. Click 'Get Started'" -ForegroundColor White
Write-Host ""
Write-Host "5. Click 'Next'" -ForegroundColor White
Write-Host ""
Write-Host "6. Select your location (closest region to your users)" -ForegroundColor White
Write-Host ""
Write-Host "7. Click 'Done'" -ForegroundColor White
Write-Host ""

Write-Host "Step 2: Apply Storage Rules" -ForegroundColor Cyan
Write-Host "---------------------------" -ForegroundColor Cyan
Write-Host "After initializing Storage, apply the security rules:" -ForegroundColor White
Write-Host ""
Write-Host "1. In the Firebase Console, go to 'Storage'" -ForegroundColor White
Write-Host ""
Write-Host "2. Click on the 'Rules' tab" -ForegroundColor White
Write-Host ""
Write-Host "3. Replace the existing rules with the content from storage.rules file:" -ForegroundColor White
Write-Host ""

# Read and display the content of storage.rules file
try {
    $rulesContent = Get-Content -Path "storage.rules" -Raw
    Write-Host $rulesContent -ForegroundColor White
} catch {
    Write-Host "Error reading storage.rules file: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "4. Click 'Publish'" -ForegroundColor White
Write-Host ""

Write-Host "Step 3: Apply CORS Configuration" -ForegroundColor Cyan
Write-Host "--------------------------------" -ForegroundColor Cyan
Write-Host "Run the CORS setup script:" -ForegroundColor White
Write-Host "   setup_cors.bat" -ForegroundColor White
Write-Host ""
Write-Host "If the script fails, manually apply CORS using gsutil:" -ForegroundColor White
Write-Host "   gsutil cors set cors.json gs://ifaa-54ebf.appspot.com" -ForegroundColor White
Write-Host ""

Write-Host "Step 4: Test the Setup" -ForegroundColor Cyan
Write-Host "----------------------" -ForegroundColor Cyan
Write-Host "1. Restart your Flutter web app:" -ForegroundColor White
Write-Host "   flutter run -d chrome" -ForegroundColor White
Write-Host ""
Write-Host "2. Try uploading an image in the news management section" -ForegroundColor White
Write-Host ""

Write-Host "Press any key to continue..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")