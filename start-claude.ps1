$ErrorActionPreference = 'SilentlyContinue'
$Root     = $PSScriptRoot
$ChatDir  = "$Root\chats"
$Session  = "$Root\session.md"
$Topics   = @('operations','investor-comms','legal','financial','procurement')

Set-Location $Root

# Sync remote
Write-Host ""
Write-Host "  Syncing..." -ForegroundColor DarkGray
git pull origin main --quiet 2>$null

# Collect all chat files sorted by last modified
$chats = @()
if (Test-Path $ChatDir) {
    Get-ChildItem -Path $ChatDir -Recurse -Filter "*.md" |
        Where-Object { $_.Name -ne "_index.md" } |
        Sort-Object LastWriteTime -Descending |
        ForEach-Object {
            $chats += [PSCustomObject]@{
                Num      = $chats.Count + 1
                Topic    = $_.Directory.Name
                File     = $_.BaseName
                FullPath = $_.FullName
                Modified = $_.LastWriteTime.ToString("yyyy-MM-dd")
            }
        }
}

# --- MENU ---
Clear-Host
Write-Host ""
Write-Host "  ==============================================" -ForegroundColor Cyan
Write-Host "       DAILY CLAUDE  --  RISE8 COMPANIES       " -ForegroundColor Cyan
Write-Host "  ==============================================" -ForegroundColor Cyan
Write-Host ""

if ($chats.Count -gt 0) {
    Write-Host "  RECENT CHATS" -ForegroundColor Yellow
    Write-Host ""
    foreach ($c in ($chats | Select-Object -First 12)) {
        $label = $c.File -replace '_\d{8}$',''
        Write-Host ("  [{0,2}]  {1,-20}  {2}  {3}" -f $c.Num, $c.Topic.ToUpper(), $c.Modified, $label)
    }
    Write-Host ""
}

Write-Host "  [ N]  New chat" -ForegroundColor Green
Write-Host "  [ Q]  Quit"
Write-Host ""
$choice = (Read-Host "  Select").Trim()
if ($choice -ieq 'Q') { exit 0 }

# --- NEW CHAT ---
if ($choice -ieq 'N') {
    Write-Host ""
    Write-Host "  TOPICS:" -ForegroundColor Yellow
    for ($i = 0; $i -lt $Topics.Count; $i++) {
        Write-Host ("  [{0}]  {1}" -f ($i + 1), $Topics[$i])
    }
    Write-Host ""
    $topicInput = (Read-Host "  Topic number or name").Trim()

    if ($topicInput -match '^\d+$' -and [int]$topicInput -ge 1 -and [int]$topicInput -le $Topics.Count) {
        $topic = $Topics[[int]$topicInput - 1]
    } else {
        $topic = $topicInput.ToLower() -replace '\s+', '-'
    }

    Write-Host ""
    $purpose = (Read-Host "  One-line purpose (becomes the title)").Trim()
    $slug    = $purpose.ToLower() -replace '[^a-z0-9\s]+','' -replace '\s+','-' -replace '^-|-$',''
    $date    = Get-Date -Format 'yyyyMMdd'
    $today   = Get-Date -Format 'yyyy-MM-dd'
    $fname   = "{0}_{1}.md" -f $slug, $date
    $topicDir = Join-Path $ChatDir $topic

    if (-not (Test-Path $topicDir)) {
        New-Item -ItemType Directory -Path $topicDir | Out-Null
    }

    $chatFile = Join-Path $topicDir $fname
    $template = @"
---
topic: $topic
created: $today
last_saved: never
status: active
---

# $purpose
**Purpose:** $purpose

---

## SUMMARY
*No save yet — use /save to snapshot this conversation.*

## Open Items
- [ ] (none yet)

## Next Steps
Start the conversation.
"@
    Set-Content -Path $chatFile -Value $template -Encoding UTF8

    # Append to _index.md
    $indexLine = "| [$purpose](chats/$topic/$fname) | $topic | $today | active |"
    Add-Content -Path (Join-Path $ChatDir "_index.md") -Value $indexLine -Encoding UTF8

    $relPath = "chats/$topic/$fname"
    Write-Host ""
    Write-Host "  Created: $relPath" -ForegroundColor Green

# --- RESUME EXISTING ---
} elseif ($choice -match '^\d+$') {
    $selected = $chats | Where-Object { $_.Num -eq [int]$choice } | Select-Object -First 1
    if (-not $selected) {
        Write-Host "  Invalid selection." -ForegroundColor Red
        exit 1
    }
    $relPath = $selected.FullPath.Replace("$Root\", '').Replace('\', '/')
    Write-Host ""
    Write-Host ("  Resuming: {0}" -f $selected.File) -ForegroundColor Green
} else {
    Write-Host "  Invalid input." -ForegroundColor Red
    exit 1
}

# Write session pointer
$sessionContent = @"
# Active Session
Chat: $relPath
Resumed: $(Get-Date -Format 'yyyy-MM-dd HH:mm')

Read the SUMMARY section of the chat file above before your first response.
"@
Set-Content -Path $Session -Value $sessionContent -Encoding UTF8

Write-Host "  Launching Claude Code..."
Write-Host ""
Start-Sleep -Milliseconds 600

Set-Location $Root
claude
