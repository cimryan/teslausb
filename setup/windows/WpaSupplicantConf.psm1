function Write-Header {
param(
	[string]$driveLetter
	)
$header=@"
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
"@

	Set-WpaSupplicantConfContent "$driveLetter" "$header"
}

function Add-Network {
param(
	[string]$driveLetter,
	[string]$wifiSSID,
	[string]$wifiPSK
	)

	$network=@"


network={
  ssid="$wifiSSID"
  psk="$wifiPSK"
}
"@

	Add-WpaSupplicantConfContent "$driveLetter" "$network"
}

function Set-WpaSupplicantConfContent {
param(
	[string]$driveLetter,
	[string]$content
	)

	$wpaSupplicantConfPath = Get-WpaSupplicantConfPath $driveLetter
	$encodedContent = Encode-Content $content
	Set-Content -Value $encodedContent -Encoding Byte -Path "$wpaSupplicantConfPath"
}

function Add-WpaSupplicantConfContent {
param(
	[string]$driveLetter,
	[string]$content
	)

	$wpaSupplicantConfPath = Get-WpaSupplicantConfPath $driveLetter
	$encodedContent = Encode-Content $content
	Add-Content -Value $encodedContent -Encoding Byte -Path "$wpaSupplicantConfPath"
}

function Verify-WpaSupplicantConfPath {
param(
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
}

function Encode-Content {
param(
	[string]$content
	)
	$utf8 = New-Object System.Text.UTF8Encoding $false

	return $utf8.GetBytes($content)
}

function Get-WpaSupplicantConfPath {
param(
	[string]$driveLetter
	)

	Verify-WpaSupplicantConfPath $driveLetter
	
	return "${driveLetter}:\wpa_supplicant.conf"
}

Export-ModuleMember -Function Write-Header
Export-ModuleMember -Function Add-Network