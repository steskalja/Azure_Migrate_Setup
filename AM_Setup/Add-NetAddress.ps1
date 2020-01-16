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
		throw $_
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
		throw $_
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
	try
	{
		New-NetIPAddress -InterfaceAlias $Nic -IPAddress $Ipadd -DefaultGateway $Gw -PrefixLength $(Convert-Subnetmask $Sn)
		return "IP Address Configured $Ipadd for Nic $Nic"

	}
	catch
	{
		return $_
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
	try
	{
		$DnsAdds = $DnsAdd.Split("|").Split(",").Split(";")
		Set-DnsClientServerAddress -InterfaceAlias $Nic -ServerAddresses $DnsAdds 
		return "DNS Addresses added: $DNSAdds"
		
	}
	catch
	{
		return $_
	}
}



