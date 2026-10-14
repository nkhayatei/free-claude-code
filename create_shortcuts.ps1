$ws = New-Object -ComObject WScript.Shell
$desktop = [System.Environment]::GetFolderPath('Desktop')
$startMenu = [System.Environment]::GetFolderPath('Programs')

$desktopLnk = Join-Path $desktop "Free Claude Code Server.lnk"
$startLnk = Join-Path $startMenu "Free Claude Code Server.lnk"
$targetCmd = "d:\free-claude-code-main\start-silent.vbs"
$iconPath = "$env:USERPROFILE\.fcc\app-icon.ico"

$s1 = $ws.CreateShortcut($desktopLnk)
$s1.TargetPath = "wscript.exe"
$s1.Arguments = "`"$targetCmd`""
$s1.WorkingDirectory = "d:\free-claude-code-main"
$s1.IconLocation = "$iconPath,0"
$s1.Description = "Start Free Claude Code Server (Silent)"
$s1.Save()

$s2 = $ws.CreateShortcut($startLnk)
$s2.TargetPath = "wscript.exe"
$s2.Arguments = "`"$targetCmd`""
$s2.WorkingDirectory = "d:\free-claude-code-main"
$s2.IconLocation = "$iconPath,0"
$s2.Description = "Start Free Claude Code Server (Silent)"
$s2.Save()

Write-Output "SHORTCUTS_UPDATED: True"
