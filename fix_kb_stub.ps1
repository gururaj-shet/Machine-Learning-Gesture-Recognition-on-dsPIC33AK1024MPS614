# fix_kb_stub.ps1 — Register the stub knowledge-pack file (kb_stub.c) in the
# MPLAB X project so the build has an implementation of the kb_* API surface.
#
# Prereq: MPLAB X must be CLOSED.
#
# Usage:
#     & "C:\proj\ak-gesture\fix_kb_stub.ps1"

$ErrorActionPreference = 'Stop'
$xml = "C:\proj\ak-gesture\ak-gesture.X\nbproject\configurations.xml"

Get-Process mplab_ide,javaw,java -EA 0 | Stop-Process -Force -EA 0
Start-Sleep 3

# Verify file is unlocked
try {
    $fs = [System.IO.File]::Open($xml, 'Open', 'ReadWrite', 'None')
    $fs.Close()
} catch {
    throw "configurations.xml is locked. Close MPLAB X (or any editor viewing the file) and re-run."
}

$backup = "$xml.bak-kbstub-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
Copy-Item -LiteralPath $xml -Destination $backup
Write-Host "Backup -> $backup" -ForegroundColor Yellow

$c = Get-Content -LiteralPath $xml -Raw

# 1) Idempotency check
if ($c -match 'kb_stub\.c') {
    Write-Host "kb_stub.c already referenced. Nothing to do." -ForegroundColor DarkGray
    return
}

# 2) Insert logicalFolder entry
$anchor = '<itemPath>../knowledge-pack/application/sml_recognition_run.c</itemPath>' + "`r`n      </logicalFolder>"
$replace = $anchor + "`r`n      <logicalFolder name=`"mplabml`" displayName=`"mplabml`" projectFiles=`"true`">`r`n        <itemPath>../knowledge-pack/mplabml/src/kb_stub.c</itemPath>`r`n      </logicalFolder>"
if (-not $c.Contains($anchor)) {
    throw "logicalFolder anchor not found. Report to your assistant."
}
$c = $c.Replace($anchor, $replace)
Write-Host "Inserted mplabml logicalFolder" -ForegroundColor Green

# 3) Insert <item> block
$itemA = @"
      <item path="../knowledge-pack/application/sml_recognition_run.c"
            ex="false"
            overriding="false">
        <C30>
        </C30>
        <C30-AR>
        </C30-AR>
        <C30-AS>
        </C30-AS>
        <C30-CO>
        </C30-CO>
        <C30-LD>
        </C30-LD>
        <C30Global>
        </C30Global>
      </item>
"@ -replace "`r?`n","`r`n"

$itemB = $itemA + "`r`n" + @"
      <item path="../knowledge-pack/mplabml/src/kb_stub.c"
            ex="false"
            overriding="false">
        <C30>
        </C30>
        <C30-AR>
        </C30-AR>
        <C30-AS>
        </C30-AS>
        <C30-CO>
        </C30-CO>
        <C30-LD>
        </C30-LD>
        <C30Global>
        </C30Global>
      </item>
"@ -replace "`r?`n","`r`n"

if (-not $c.Contains($itemA)) {
    throw "item anchor not found. Report to your assistant."
}
$c = $c.Replace($itemA, $itemB)
Write-Host "Inserted mplabml item block" -ForegroundColor Green

# 4) Save
Set-Content -LiteralPath $xml -Value $c -Encoding UTF8 -NoNewline
Write-Host "Wrote XML" -ForegroundColor Green

# 5) Verify
$after = Get-Content -LiteralPath $xml -Raw
$refs = ([regex]::Matches($after, 'kb_stub\.c')).Count
Write-Host "kb_stub.c refs: $refs (expect 2)" -ForegroundColor Cyan

try {
    $x = New-Object System.Xml.XmlDocument
    $x.Load($xml)
    Write-Host "XML parses cleanly" -ForegroundColor Green
} catch {
    Write-Host "XML broken: $($_.Exception.Message)" -ForegroundColor Red
    throw
}

# 6) Clear caches
foreach ($p in @(
    "C:\proj\ak-gesture\ak-gesture.X\nbproject\Makefile-default.mk",
    "C:\proj\ak-gesture\ak-gesture.X\nbproject\Makefile-genesis.properties",
    "C:\proj\ak-gesture\ak-gesture.X\nbproject\Makefile-impl.mk",
    "C:\proj\ak-gesture\ak-gesture.X\nbproject\Makefile-local-default.mk",
    "C:\proj\ak-gesture\ak-gesture.X\nbproject\Makefile-variables.mk",
    "C:\proj\ak-gesture\ak-gesture.X\nbproject\private",
    "C:\proj\ak-gesture\ak-gesture.X\build",
    "C:\proj\ak-gesture\ak-gesture.X\dist"
)) {
    if (Test-Path -LiteralPath $p) { Remove-Item -LiteralPath $p -Recurse -Force }
}
Write-Host "Caches cleared" -ForegroundColor Green

Write-Host ""
Write-Host "Done. Open MPLAB X, open C:\proj\ak-gesture\ak-gesture.X, right-click the project -> Clean and Build (F11)." -ForegroundColor Cyan
