<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2019 v5.6.170
	 Created on:   	12/11/2019 11:24 AM
	 Created by:   	212670239
	 Organization: 	
	 Filename:     	Add-NetAddress.ps1
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>

function Convert-Subnetmask
{
	param
	(
		[parameter(Mandatory = $true)]
		[string]
		$subnetmask
	)
	try
	{
		$netMaskIP = [IPAddress]$subnetmask
		
		$binaryString = [String]::Empty
		$netMaskIP.GetAddressBytes() | Foreach {
			# combine each
			$binaryString += [Convert]::ToString($_, 2)
		}
		
		return $binaryString.TrimEnd('0').Length
	}
	catch
	{
		return $_
	}
}

function Convert-Prefix
{
	param
	(
		[parameter(Mandatory = $true)]
		[string]$prefixLength
	)
	try
	{
		$bitString = ('1' * $prefixLength).PadRight(32, '0')
		
		$ipString = [String]::Empty
		
		# make 1 string combining a string for each byte and convert to int
		for ($i = 0; $i -lt 32; $i += 8)
		{
			$byteString = $bitString.Substring($i, 8)
			$ipString += "$([Convert]::ToInt32($byteString, 2))."
		}
		
		return $ipString.TrimEnd('.')
	}
	catch
	{
		return $_
	}
}

function Set-IPAddress
{
	param (
		[Parameter(ValueFromPipeline = $true, Mandatory = $true)]
		[string]$Nic,
		[Parameter(ValueFromPipeline = $true, Mandatory = $true)]
		[string]$Ipadd,
		[Parameter(ValueFromPipeline = $true, Mandatory = $true)]
		[string]$Gw,
		[Parameter(ValueFromPipeline = $true, Mandatory = $true)]
		[string]$Sn
	)
	
	$rslt = New-NetIPAddress -InterfaceAlias $Nic -IPAddress $Ipadd -DefaultGateway $Gw -PrefixLength $(Convert-Subnetmask $Sn) -ErrorVariable $rslterr
	if (!$rslterr)
	{
		return $rslt
	}
	else
	{
		return $rslterr
	}
	
}

function Set-DNS
{
	param (
		[Parameter(ValueFromPipeline = $true, Mandatory = $true)]
		[string]$Nic,
		[Parameter(ValueFromPipeline = $true, Mandatory = $true)]
		[string]$DnsAdd
	)
	[string[]] $DnsAdds = $DnsAdd.Split('|', ',',';')
	$rslt = Set-DnsClientServerAddress -InterfaceAlias $Nic -ServerAddresses $DnsAdds -ErrorVariable $rslterr
	if (!$rslterr)
	{
		return $rslt
	}
	else
	{
		return $rslterr
	}
	
}



