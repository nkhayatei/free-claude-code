# PowerShell script to automatically reinstall and configure Free Claude Code after fresh Windows install
$ErrorActionPreference = "Continue"

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "       Free Claude Code - Auto Reinstaller & Setup        " -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host ""

$workDir = "d:\free-claude-code-main"
$fccDir = Join-Path $env:USERPROFILE ".fcc"

# 1. Restore Configuration Backup (Keys & Settings)
Write-Host "[1/5] Restoring API keys and configuration..." -ForegroundColor Green
if (Test-Path "$workDir\backup_config") {
    if (-not (Test-Path $fccDir)) {
        New-Item -ItemType Directory -Force -Path $fccDir | Out-Null
    }
    Copy-Item -Path "$workDir\backup_config\*" -Destination $fccDir -Recurse -Force
    Write-Host "      -> Configuration restored to $fccDir" -ForegroundColor Gray
} else {
    Write-Host "      -> Warning: backup_config folder not found. Skipping restore." -ForegroundColor Yellow
}

# 2. Check and Install uv package manager
Write-Host ""
Write-Host "[2/5] Checking package manager (uv)..." -ForegroundColor Green
$uvInstalled = (Get-Command "uv" -ErrorAction SilentlyContinue)
if (-not $uvInstalled) {
    Write-Host "      -> Installing uv via winget..." -ForegroundColor Yellow
    winget install --id astral-sh.uv -e --accept-source-agreements --accept-package-agreements
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
} else {
    Write-Host "      -> uv is already installed." -ForegroundColor Gray
}

# 3. Setup Python 3.14.7 runtime
Write-Host ""
Write-Host "[3/5] Setting up Python 3.14.7 environment..." -ForegroundColor Green
Set-Location $workDir
& uv python install 3.14.7
& uv venv --python 3.14.7 --allow-existing

# 4. Synchronize all project dependencies
Write-Host ""
Write-Host "[4/5] Installing dependencies and packages..." -ForegroundColor Green
$env:SETUPTOOLS_SCM_PRETEND_VERSION = "0.1.0"
& uv sync

# 5. Create Desktop and Start Menu Shortcuts
Write-Host ""
Write-Host "[5/5] Creating Desktop and Start Menu shortcuts..." -ForegroundColor Green
$ws = New-Object -ComObject WScript.Shell
$desktop = [System.Environment]::GetFolderPath('Desktop')
$startMenu = [System.Environment]::GetFolderPath('Programs')
$desktopLnk = Join-Path $desktop "Free Claude Code Server.lnk"
$startLnk = Join-Path $startMenu "Free Claude Code Server.lnk"
$targetCmd = "$workDir\start-silent.vbs"
$iconPath = "$fccDir\app-icon.ico"

$s1 = $ws.CreateShortcut($desktopLnk)
$s1.TargetPath = "wscript.exe"
$s1.Arguments = "`"$targetCmd`""
$s1.WorkingDirectory = $workDir
if (Test-Path $iconPath) { $s1.IconLocation = "$iconPath,0" }
$s1.Description = "Start Free Claude Code Server"
$s1.Save()

$s2 = $ws.CreateShortcut($startLnk)
$s2.TargetPath = "wscript.exe"
$s2.Arguments = "`"$targetCmd`""
$s2.WorkingDirectory = $workDir
if (Test-Path $iconPath) { $s2.IconLocation = "$iconPath,0" }
$s2.Description = "Start Free Claude Code Server"
$s2.Save()

Write-Host ""
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  Installation Complete! Shortcuts created on Desktop.   " -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Starting server now..." -ForegroundColor Yellow
Start-Process "wscript.exe" -ArgumentList "`"$targetCmd`""
Start-Sleep -Seconds 3
Start-Process "http://127.0.0.1:8082/admin"

Write-Host "Done! Admin dashboard is opening in your browser." -ForegroundColor Green
