[CmdletBinding()]
Param
(
    [Parameter(Mandatory=$True,Position=1)]
    [string]$driveLetter,
	
    [Parameter(Mandatory=$True,Position=2)]
    [string]$wifiSSID,

    [Parameter(Mandatory=$True,Position=3)]
    [string]$wifiPSK
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

# Sets up wifi credentials so wifi will be 
# auto configured on first boot

$wpaSupplicantConfPath="$drivePath\wpa_supplicant.conf"

Write-Verbose "(Re)creating WiFi configuration file $wpaSupplicantConfPath."
if ([System.IO.File]::Exists("$wpaSupplicantConfPath")) {
  del "$wpaSupplicantConfPath"
}

$wpaSupplicantConfContent=@"
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1

network={
  ssid="$wifiSSID"
  psk="$wifiPSK"
}
"@

$utf8 = New-Object System.Text.UTF8Encoding $false

Set-Content -Value $utf8.GetBytes($wpaSupplicantConfContent) -Encoding Byte -Path "$wpaSupplicantConfPath"

Write-Verbose "All done."