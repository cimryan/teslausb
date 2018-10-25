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

$wpaSupplicantConfPath="$drivePath\wpa_supplicant.conf"

$wpaSupplicantConfContent=@"


network={
  ssid="$wifiSSID"
  psk="$wifiPSK"
}
"@

$utf8 = New-Object System.Text.UTF8Encoding $false

Add-Content -Value $utf8.GetBytes($wpaSupplicantConfContent) -Encoding Byte -Path "$wpaSupplicantConfPath"

Write-Verbose "All done."
