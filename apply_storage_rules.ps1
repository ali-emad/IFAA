# PowerShell script to display instructions for applying Firebase Storage rules
# This script cannot directly apply the rules, but provides guidance

Write-Host "Firebase Storage Rules Application Script" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

Write-Host "To apply the Firebase Storage rules manually:" -ForegroundColor Yellow
Write-Host ""

Write-Host "1. Open your web browser and go to:" -ForegroundColor Cyan
Write-Host "   https://console.firebase.google.com/" -ForegroundColor White
Write-Host ""

Write-Host "2. Select your project (ifaa-54ebf)" -ForegroundColor Cyan
Write-Host ""

Write-Host "3. In the left sidebar, click on 'Storage'" -ForegroundColor Cyan
Write-Host ""

Write-Host "4. Click on the 'Rules' tab" -ForegroundColor Cyan
Write-Host ""

Write-Host "5. Replace the existing rules with the following content:" -ForegroundColor Cyan
Write-Host ""

# Read and display the content of storage.rules file
$rulesContent = Get-Content -Path "storage.rules" -Raw
Write-Host $rulesContent -ForegroundColor White
Write-Host ""

Write-Host "6. Click 'Publish' to save the rules" -ForegroundColor Cyan
Write-Host ""

Write-Host "After applying the rules, restart your Flutter web app:" -ForegroundColor Yellow
Write-Host "   flutter run -d chrome" -ForegroundColor White
Write-Host ""

Write-Host "Press any key to exit..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")