# Repo root = parent of this script's .claude folder
$root      = Split-Path $PSScriptRoot -Parent
$indexPath = Join-Path $root "chats\_index.md"

if (-not (Test-Path $indexPath)) {
    $ctx = "SESSION START: _index.md not found. Your first output must be exactly: ``No chats yet. Start a new chat ('new', logged), or just talk ('quick', nothing logged)?`` then STOP and wait. On reply, follow the Session Management rules in CLAUDE.md."
    $out = @{ hookSpecificOutput = @{ hookEventName = "SessionStart"; additionalContext = $ctx } }
    Write-Output (ConvertTo-Json $out -Compress)
    exit 0
}

# Parse every chat row: | [title](path) | topic | created | status |
$lines = Get-Content $indexPath -Encoding UTF8
$chats = @()
foreach ($line in $lines) {
    if ($line -match '^\|\s*\[([^\]]+)\]\(([^)]+)\)\s*\|\s*([^|]+?)\s*\|\s*([^|]+?)\s*\|\s*([^|]+?)\s*\|') {
        $chats += [PSCustomObject]@{
            Title  = $matches[1].Trim()
            Path   = $matches[2].Trim()
            Topic  = $matches[3].Trim()
            Created= $matches[4].Trim()
            Status = $matches[5].Trim()
        }
    }
}

if ($chats.Count -eq 0) {
    $ctx = "SESSION START: No chats found. Your first output must be exactly: ``No chats yet. Start a new chat ('new', logged), or just talk ('quick', nothing logged)?`` then STOP and wait. On reply, follow the Session Management rules in CLAUDE.md."
    $out = @{ hookSpecificOutput = @{ hookEventName = "SessionStart"; additionalContext = $ctx } }
    Write-Output (ConvertTo-Json $out -Compress)
    exit 0
}

# Most recent first (index appends new chats at the bottom)
[array]::Reverse($chats)

# Page 1 only: first 10 (numbering continues across pages, driven by Claude on 'more')
$pageSize = 10
$shown    = [Math]::Min($pageSize, $chats.Count)
$list = ""
for ($i = 0; $i -lt $shown; $i++) {
    $c = $chats[$i]
    $list += "`n$($i + 1). $($c.Title)  ($($c.Topic), $($c.Created))"
}

$header   = "Recent chats:"
$moreLine = ""
$whichOpts = "number to resume, 'new', or 'quick'"
if ($chats.Count -gt $pageSize) {
    $header    = "Recent chats (1-$shown of $($chats.Count)):"
    $moreLine  = "`nmore.  Show the next $pageSize"
    $whichOpts = "number to resume, 'more' for older chats, 'new', or 'quick'"
}

$ctx = "SESSION START - REQUIRED ACTION: Your very first output must be exactly this picker, then STOP and wait for the user's reply before doing anything else. Do not run any tools first.`n`n$header$list`nnew.   Start a new chat (logged)`nquick. Just chat - nothing logged$moreLine`n`nWhich? ($whichOpts)`n`nWhen they reply, follow the Session Management rules in CLAUDE.md: a number resumes that chat (path is in chats/_index.md, most-recent-first, same order shown), 'new' starts the new-chat flow, 'quick' is a casual conversation with no logging - touch no files, 'more' shows the next 10 (continue numbering, e.g. 11-20)."

$out = @{
    hookSpecificOutput = @{
        hookEventName     = "SessionStart"
        additionalContext = $ctx
    }
}
Write-Output (ConvertTo-Json $out -Compress)
