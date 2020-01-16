<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2019 v5.6.170
	 Created on:   	1/6/2020 12:22 PM
	 Created by:   	212670239
	 Organization: 	
	 Filename:     	Set-Proxy.ps1
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>

function Set-InternetProxy
{
	[CmdletBinding()]
	Param (
		
		[Parameter(Mandatory = $True, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
		[String[]]$Proxy,
		[Parameter(Mandatory = $False, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
		[AllowEmptyString()]
		[String[]]$acs,
		[Parameter(Mandatory = $False, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
		[AllowEmptyString()]
		[String[]]$pexclusion
		
	)
		
	$regKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
	
	try
	{
		Set-ItemProperty -path $regKey ProxyEnable -value 1
		
		Set-ItemProperty -path $regKey ProxyServer -value $proxy
		
		if ($acs)
		{
			Set-ItemProperty -path $regKey AutoConfigURL -Value $acs
		}
		
		if ($pexclusion)
		{
			Set-ItemProperty -path $regKey ProxyOverride -Value $pexclusion
		}
		
		return "Proxy Set Successfully"
	}
	catch
	{
		return $_
	}
	
	
}


