# ============================================================================
# PATIENT RECORD MANAGEMENT SYSTEM - SERVER STOP SCRIPT
# ============================================================================

$currentDir = $PSScriptRoot
if (-not $currentDir) { $currentDir = (Get-Location).Path }
$tomcatDir = Join-Path $currentDir "tomcat-9"

$env:CATALINA_HOME = $tomcatDir
$env:CATALINA_BASE = $tomcatDir

$catalinaScript = Join-Path $tomcatDir "bin\catalina.bat"

if (Test-Path $catalinaScript) {
    Write-Host "[INFO] Stopping Apache Tomcat 9 server..." -ForegroundColor Yellow
    Start-Process -FilePath "cmd.exe" -ArgumentList "/c `"$catalinaScript`" stop" -Wait -WindowStyle Hidden
    Write-Host "[SUCCESS] Apache Tomcat 9 server stopped." -ForegroundColor Green
} else {
    Write-Host "[ERROR] Tomcat directory not found." -ForegroundColor Red
}
