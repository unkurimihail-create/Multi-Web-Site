$ErrorActionPreference = 'Continue'

$historyDir = Join-Path $env:USERPROFILE ".ps-terminal"
$historyFile = Join-Path $historyDir "history.txt"

if (-not (Test-Path $historyDir)) {
    New-Item -ItemType Directory -Path $historyDir | Out-Null
}

if (-not (Test-Path $historyFile)) {
    New-Item -ItemType File -Path $historyFile | Out-Null
}

$commandHistory = New-Object System.Collections.Generic.List[string]
Get-Content $historyFile -ErrorAction SilentlyContinue | ForEach-Object {
    if (-not [string]::IsNullOrWhiteSpace($_)) {
        $commandHistory.Add($_)
    }
}

function Write-Banner {
    Write-Host "===========================================" -ForegroundColor DarkCyan
    Write-Host "   Windows Full Terminal (PowerShell)" -ForegroundColor Cyan
    Write-Host "   Type 'help' for commands" -ForegroundColor Gray
    Write-Host "===========================================" -ForegroundColor DarkCyan
}

function Get-Prompt {
    $path = (Get-Location).Path
    return "PS-Terminal $path> "
}

function Show-Help {
    Write-Host "Built-in commands:" -ForegroundColor Yellow
    Write-Host "  help               Show this help" -ForegroundColor Gray
    Write-Host "  cd <path>          Change directory" -ForegroundColor Gray
    Write-Host "  pwd                Print current directory" -ForegroundColor Gray
    Write-Host "  clear              Clear screen" -ForegroundColor Gray
    Write-Host "  history [N]        Show last N commands (default 20)" -ForegroundColor Gray
    Write-Host "  exit               Exit terminal" -ForegroundColor Gray
    Write-Host "" 
    Write-Host "Any other input runs as regular Windows/PowerShell command." -ForegroundColor DarkGray
}

function Save-History {
    param(
        [System.Collections.Generic.List[string]]$History
    )

    try {
        $History | Set-Content -Path $historyFile -Encoding UTF8
    }
    catch {
        Write-Host "Could not save history: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Banner

while ($true) {
    try {
        $inputLine = Read-Host (Get-Prompt)
    }
    catch {
        Write-Host "Input error: $($_.Exception.Message)" -ForegroundColor Red
        continue
    }

    if ([string]::IsNullOrWhiteSpace($inputLine)) {
        continue
    }

    $commandHistory.Add($inputLine)

    $trimmed = $inputLine.Trim()
    $lower = $trimmed.ToLowerInvariant()

    if ($lower -eq 'exit') {
        Save-History -History $commandHistory
        Write-Host "Bye!" -ForegroundColor Green
        break
    }

    if ($lower -eq 'help') {
        Show-Help
        continue
    }

    if ($lower -eq 'clear') {
        Clear-Host
        continue
    }

    if ($lower -eq 'pwd') {
        (Get-Location).Path
        continue
    }

    if ($lower.StartsWith('cd ')) {
        $targetPath = $trimmed.Substring(3).Trim('"')
        try {
            Set-Location -Path $targetPath
        }
        catch {
            Write-Host "cd error: $($_.Exception.Message)" -ForegroundColor Red
        }
        continue
    }

    if ($lower -eq 'cd') {
        (Get-Location).Path
        continue
    }

    if ($lower.StartsWith('history')) {
        $parts = $trimmed -split '\s+'
        $count = 20

        if ($parts.Count -gt 1) {
            [int]$parsed = 0
            if ([int]::TryParse($parts[1], [ref]$parsed) -and $parsed -gt 0) {
                $count = $parsed
            }
        }

        $start = [Math]::Max(0, $commandHistory.Count - $count)
        for ($i = $start; $i -lt $commandHistory.Count; $i++) {
            $lineNumber = $i + 1
            Write-Host ("{0,4}: {1}" -f $lineNumber, $commandHistory[$i]) -ForegroundColor DarkGray
        }
        continue
    }

    try {
        Invoke-Expression $inputLine
    }
    catch {
        Write-Host "Command error: $($_.Exception.Message)" -ForegroundColor Red
    }
}
