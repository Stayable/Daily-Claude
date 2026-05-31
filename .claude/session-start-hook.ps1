$indexPath = "C:\Claude Baby\Daily-Claude\chats\_index.md"

if (-not (Test-Path $indexPath)) {
    $out = @{
        hookSpecificOutput = @{
            hookEventName   = "SessionStart"
            additionalContext = "SESSION START: _index.md not found. Proceed as a normal conversation, no prompt needed."
        }
    }
    Write-Output (ConvertTo-Json $out -Compress)
    exit 0
}

$lines  = Get-Content $indexPath -Encoding UTF8
$active = @()

foreach ($line in $lines) {
    if ($line -match '^\|.*\|\s*active\s*\|\s*$') {
        if ($line -match '\[([^\]]+)\]\(') {
            $active += $matches[1]
        }
    }
}

if ($active.Count -eq 0) {
    $ctx = "SESSION START: No active chats. Proceed as a normal conversation, no prompt needed."

} elseif ($active.Count -eq 1) {
    $title = $active[0]
    $ctx = "SESSION START - REQUIRED ACTION: Your very first output must be exactly this line, then wait for the user's reply before doing anything else:`n`nContinue `"$title`" or start fresh? (c to continue, f for fresh)"

} else {
    $list = ""
    for ($i = 0; $i -lt $active.Count; $i++) {
        $list += "`n$($i + 1). $($active[$i])"
    }
    $ctx = "SESSION START - REQUIRED ACTION: Your very first output must be exactly this picker, then wait for the user's reply before doing anything else:`n`nActive sessions:$list`nf. Fresh chat`n`nWhich?"
}

$out = @{
    hookSpecificOutput = @{
        hookEventName     = "SessionStart"
        additionalContext = $ctx
    }
}

Write-Output (ConvertTo-Json $out -Compress)
