# fix_project2.ps1 — Corrective patch for the previous run of fix_project.ps1.
# Moves the spi2.c / ext_int.c itemPaths from the Header Files section
# (where they were wrongly placed) into the empty spi_host/src and
# interrupt/src folders under Source Files.
#
# Usage (from PowerShell, with MPLAB X CLOSED):
#     cd C:\proj\ak-gesture
#     .\fix_project2.ps1

$ErrorActionPreference = 'Stop'

$xmlPath = "C:\proj\ak-gesture\ak-gesture.X\nbproject\configurations.xml"
$privDir = "C:\proj\ak-gesture\ak-gesture.X\nbproject\private"

if (-not (Test-Path -LiteralPath $xmlPath)) { throw "not found: $xmlPath" }

# Verify file is not locked (MPLAB X must be closed)
try {
    $fs = [System.IO.File]::Open($xmlPath, 'Open', 'ReadWrite', 'None')
    $fs.Close()
} catch {
    throw "configurations.xml is locked. Close MPLAB X first and re-run this script."
}

$backup = "$xmlPath.bak2-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
Copy-Item -LiteralPath $xmlPath -Destination $backup
Write-Host "Backup: $backup" -ForegroundColor Yellow

$content = Get-Content -LiteralPath $xmlPath -Raw

# Split file into individual lines for surgical editing
$lines = $content -split "`r?`n"

# --- Fix 1: SourceFiles section - populate empty spi_host/src and interrupt/src ---
# Distinguish SourceFiles' mcc_generated_files subtree from HeaderFiles'
# by pwm/src content: SourceFiles has pwm sccp3/4/7.c, HeaderFiles has empty pwm/src.
#
# We'll scan for `<logicalFolder name="spi_host"` blocks whose immediately following
# `<logicalFolder name="src"` is EMPTY, and inject the appropriate itemPath.

$newLines = New-Object System.Collections.Generic.List[string]
for ($i = 0; $i -lt $lines.Count; $i++) {
    $newLines.Add($lines[$i]) | Out-Null

    # spi_host: look for empty src folder pattern
    if ($lines[$i] -match '<logicalFolder name="spi_host"' -and
        ($i+1) -lt $lines.Count -and $lines[$i+1] -match '<logicalFolder name="src"' -and
        ($i+2) -lt $lines.Count -and $lines[$i+2] -match '^\s*</logicalFolder>\s*$') {

        # Add itemPath after the <src> line (which will be added next by the loop)
        $newLines.Add($lines[$i+1]) | Out-Null
        $indent = ($lines[$i+1] -replace '<.*$','')
        $newLines.Add("$indent  <itemPath>../My_MCC_Config/mcc/mcc_generated_files/spi_host/src/spi2.c</itemPath>") | Out-Null
        $i++  # skip re-adding the <src> line
        Write-Host "Populated empty SourceFiles spi_host/src with spi2.c" -ForegroundColor Green
    }
    elseif ($lines[$i] -match '<logicalFolder name="interrupt"' -and
        ($i+1) -lt $lines.Count -and $lines[$i+1] -match '<logicalFolder name="src"' -and
        ($i+2) -lt $lines.Count -and $lines[$i+2] -match '^\s*</logicalFolder>\s*$') {

        $newLines.Add($lines[$i+1]) | Out-Null
        $indent = ($lines[$i+1] -replace '<.*$','')
        $newLines.Add("$indent  <itemPath>../My_MCC_Config/mcc/mcc_generated_files/interrupt/src/ext_int.c</itemPath>") | Out-Null
        $i++
        Write-Host "Populated empty SourceFiles interrupt/src with ext_int.c" -ForegroundColor Green
    }
}

# --- Fix 2: Remove the wrongly-placed populated blocks in the HeaderFiles section ---
# In HeaderFiles all mcc_generated_files subfolders have empty src (no itemPaths).
# The ONLY places spi_host and interrupt should contain itemPaths are in SourceFiles.
# After Fix 1, there may now be TWO instances of `spi_host/src/spi2.c` itemPath.
# Remove the FIRST one (which is in HeaderFiles).

$fixed = $newLines -join "`r`n"

# Count occurrences to decide if a de-dup is needed
$spi2Count    = ([regex]::Matches($fixed, '<itemPath>\.\./My_MCC_Config/mcc/mcc_generated_files/spi_host/src/spi2\.c</itemPath>')).Count
$extIntCount  = ([regex]::Matches($fixed, '<itemPath>\.\./My_MCC_Config/mcc/mcc_generated_files/interrupt/src/ext_int\.c</itemPath>')).Count

Write-Host "spi2.c itemPath occurrences: $spi2Count" -ForegroundColor Cyan
Write-Host "ext_int.c itemPath occurrences: $extIntCount" -ForegroundColor Cyan

if ($spi2Count -gt 1) {
    # Remove the FIRST occurrence (it's inside HeaderFiles section)
    $rx = New-Object System.Text.RegularExpressions.Regex(
        '<itemPath>\.\./My_MCC_Config/mcc/mcc_generated_files/spi_host/src/spi2\.c</itemPath>\r?\n?')
    $fixed = $rx.Replace($fixed, '', 1)
    Write-Host "Removed duplicate spi2.c itemPath from HeaderFiles" -ForegroundColor Green
}
if ($extIntCount -gt 1) {
    $rx = New-Object System.Text.RegularExpressions.Regex(
        '<itemPath>\.\./My_MCC_Config/mcc/mcc_generated_files/interrupt/src/ext_int\.c</itemPath>\r?\n?')
    $fixed = $rx.Replace($fixed, '', 1)
    Write-Host "Removed duplicate ext_int.c itemPath from HeaderFiles" -ForegroundColor Green
}

# --- Write back ---
Set-Content -LiteralPath $xmlPath -Value $fixed -Encoding UTF8
Write-Host "Wrote patched $xmlPath" -ForegroundColor Green

# Clear cache
if (Test-Path -LiteralPath $privDir) {
    Remove-Item -LiteralPath $privDir -Recurse -Force
    Write-Host "Cleared $privDir" -ForegroundColor Green
}

# Verify final counts
$after = Get-Content -LiteralPath $xmlPath -Raw
$s2 = ([regex]::Matches($after, '<itemPath>\.\./My_MCC_Config/mcc/mcc_generated_files/spi_host/src/spi2\.c</itemPath>')).Count
$e2 = ([regex]::Matches($after, '<itemPath>\.\./My_MCC_Config/mcc/mcc_generated_files/interrupt/src/ext_int\.c</itemPath>')).Count
Write-Host ""
Write-Host "Final: spi2.c=$s2, ext_int.c=$e2 (each should be exactly 1)" -ForegroundColor Cyan

Write-Host ""
Write-Host "Now reopen MPLAB X - the .c files should appear in the Projects pane" -ForegroundColor Green
