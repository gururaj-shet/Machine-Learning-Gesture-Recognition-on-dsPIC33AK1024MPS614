# fix_project.ps1
# Patch ak-gesture.X/nbproject/configurations.xml to include the two new
# hand-written drivers (spi2.c, ext_int.c), and clear MPLAB X's private
# cache so the IDE re-scans the source tree on next open.
#
# Run this from PowerShell after CLOSING MPLAB X:
#     cd C:\proj\ak-gesture
#     .\fix_project.ps1

$ErrorActionPreference = 'Stop'

$xmlPath   = "C:\proj\ak-gesture\ak-gesture.X\nbproject\configurations.xml"
$privDir   = "C:\proj\ak-gesture\ak-gesture.X\nbproject\private"
$buildDir  = "C:\proj\ak-gesture\ak-gesture.X\build"
$distDir   = "C:\proj\ak-gesture\ak-gesture.X\dist"

# --- 1. Sanity checks ---
if (-not (Test-Path -LiteralPath $xmlPath)) {
    throw "configurations.xml not found at $xmlPath"
}
foreach ($src in @(
    "C:\proj\ak-gesture\My_MCC_Config\mcc\mcc_generated_files\spi_host\src\spi2.c",
    "C:\proj\ak-gesture\My_MCC_Config\mcc\mcc_generated_files\interrupt\src\ext_int.c"
)) {
    if (-not (Test-Path -LiteralPath $src)) {
        throw "Missing source file: $src  --  did you run install_drivers.ps1?"
    }
}

# --- 2. Backup ---
$backup = "$xmlPath.bak-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
Copy-Item -LiteralPath $xmlPath -Destination $backup
Write-Host "Backed up $xmlPath -> $backup" -ForegroundColor Yellow

# --- 3. Load and patch the XML as text (safer than XML-DOM parsing for MPLAB X format) ---
$content = Get-Content -LiteralPath $xmlPath -Raw

# 3a. Add the new logicalFolders under Source Files -> mcc_generated_files
# Insert them after the "adc" logicalFolder for readability.
if ($content -notmatch '<logicalFolder name="spi_host"') {
    $before = '<logicalFolder name="uart" displayName="uart" projectFiles="true">'
    $insertAfterCan = @'
<logicalFolder name="interrupt" displayName="interrupt" projectFiles="true">
          <logicalFolder name="src" displayName="src" projectFiles="true">
            <itemPath>../My_MCC_Config/mcc/mcc_generated_files/interrupt/src/ext_int.c</itemPath>
          </logicalFolder>
        </logicalFolder>
        <logicalFolder name="spi_host" displayName="spi_host" projectFiles="true">
          <logicalFolder name="src" displayName="src" projectFiles="true">
            <itemPath>../My_MCC_Config/mcc/mcc_generated_files/spi_host/src/spi2.c</itemPath>
          </logicalFolder>
        </logicalFolder>
        
'@
    $content = $content -replace [regex]::Escape($before), ($insertAfterCan + $before)
    Write-Host "Inserted spi_host + interrupt logical folders" -ForegroundColor Green
} else {
    Write-Host "spi_host logical folder already present (skipped)" -ForegroundColor DarkGray
}

# 3b. Add the same two folders under Header Files -> mcc_generated_files
if ($content -notmatch '(?s)HeaderFiles.*?<logicalFolder name="spi_host"') {
    $marker = '<logicalFolder name="uart" displayName="uart" projectFiles="true">
            <logicalFolder name="src" displayName="src" projectFiles="true">'
    # We'll insert BEFORE the first 'uart' occurrence in HeaderFiles section.
    # Simpler approach: insert headers as items directly under mcc_generated_files.
    $hdrInsert = @'
<logicalFolder name="interrupt" displayName="interrupt" projectFiles="true">
            <itemPath>../My_MCC_Config/mcc/mcc_generated_files/interrupt/ext_int.h</itemPath>
          </logicalFolder>
          <logicalFolder name="spi_host" displayName="spi_host" projectFiles="true">
            <itemPath>../My_MCC_Config/mcc/mcc_generated_files/spi_host/spi2.h</itemPath>
          </logicalFolder>
          
'@
    # Find the FIRST 'uart' logicalFolder inside HeaderFiles (that one has no <src> subfolder,
    # unlike the SourceFiles one).
    $regex = '(?ms)(HeaderFiles.*?)(          <logicalFolder name="uart" displayName="uart" projectFiles="true">\r?\n            <logicalFolder)'
    if ($content -match $regex) {
        $content = [regex]::Replace($content, $regex, "`$1          $hdrInsert`$2", 1)
        Write-Host "Inserted header logical folders" -ForegroundColor Green
    }
}

# 3c. Add the two <item> entries near the other MCC generated <item> entries.
if ($content -notmatch 'path="\.\./My_MCC_Config/mcc/mcc_generated_files/spi_host/src/spi2\.c"') {
    $insertItems = @'
<item path="../My_MCC_Config/mcc/mcc_generated_files/interrupt/src/ext_int.c"
            ex="true"
            overriding="false">
      </item>
      <item path="../My_MCC_Config/mcc/mcc_generated_files/spi_host/src/spi2.c"
            ex="true"
            overriding="false">
      </item>
      
'@
    # Insert right after the adc3.c item entry.
    $anchor = '<item path="../My_MCC_Config/mcc/mcc_generated_files/adc/src/adc3.c"' + "`r`n            ex=`"true`"" + "`r`n            overriding=`"false`">" + "`r`n      </item>" + "`r`n"
    if ($content -match [regex]::Escape($anchor)) {
        $content = $content -replace [regex]::Escape($anchor), ($anchor + '      ' + $insertItems)
        Write-Host "Inserted <item> entries" -ForegroundColor Green
    } else {
        # Fallback: append before final </confs>
        Write-Host "Anchor not found. Falling back to append-before-Tool." -ForegroundColor Yellow
        $content = $content -replace '<C30>', ("      $insertItems" + '<C30>')
    }
} else {
    Write-Host "spi2/ext_int item entries already present (skipped)" -ForegroundColor DarkGray
}

# --- 4. Write back ---
Set-Content -LiteralPath $xmlPath -Value $content -Encoding UTF8
Write-Host "Wrote patched $xmlPath" -ForegroundColor Green

# --- 5. Clear MPLAB X private cache + build artefacts (force re-scan) ---
foreach ($p in @($privDir, $buildDir, $distDir)) {
    if (Test-Path -LiteralPath $p) {
        Remove-Item -LiteralPath $p -Recurse -Force
        Write-Host "Deleted $p" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "Project fixed. Now:" -ForegroundColor Cyan
Write-Host "  1. Open MPLAB X (if it's still running, close it first)."
Write-Host "  2. File -> Open Project -> C:\proj\ak-gesture\ak-gesture.X"
Write-Host "  3. In the Projects pane, expand Source Files -> mcc_generated_files"
Write-Host "     You should now see:"
Write-Host "         interrupt/src/ext_int.c"
Write-Host "         spi_host/src/spi2.c"
Write-Host "     alongside the existing adc/can/pwm/system/timer/uart folders."
Write-Host "  4. Right-click the project -> Clean and Build (F11)."
