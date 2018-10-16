[CmdletBinding()]
Param
(
    [Parameter(Mandatory=$True,Position=1)]
    [string]$driveLetter
)

$drivePath="${driveLetter}:"
$configPath = "$drivePath\config.txt"
$cmdlinePath = "$drivePath\cmdline.txt"
$sshPath = "$drivePath\ssh"

if ((![System.IO.File]::Exists($configPath) -or
    (![System.IO.File]::Exists($cmdlinePath)))) {
    Write-Error "Didn't find cmdline.txt and config.txt on drive $drivePath."
    exit 1
}

Write-Verbose "Updating $configPath ..."

"" | Out-File -FilePath $configPath -Append -Encoding utf8
"dtoverlay=dwc2" | Out-File -FilePath $configPath -Append -Encoding utf8

Write-Verbose "Updating $cmdlinePath ..."
$cmdlinetxtContent = gc -Raw $cmdlinePath
$cmdlinetxtContent.Replace("rootwait", "rootwait modules-load=dwc2,g_ether").Replace(" init=/usr/lib/raspi-config/init_resize.sh", "") | Out-File -FilePath $cmdlinePath -Encoding utf8

Write-Verbose "Enabling SSH ..."
[System.IO.File]::CreateText($sshPath).Dispose()

Write-Verbose "All done."