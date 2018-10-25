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

Import-Module -Name ".\WpaSupplicantConf.psm1" -Force

Add-Network "$driveLetter" "$wifiSSID" "$wifiPSK"

Write-Verbose "All done."
