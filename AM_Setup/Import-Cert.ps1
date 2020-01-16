<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2019 v5.6.170
	 Created on:   	1/15/2020 10:26 AM
	 Created by:   	212670239
	 Organization: 	
	 Filename:     	Import-Cert.ps1
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>

function Import-Cert
{
	param
	(
		[parameter(Mandatory = $true)]
		[string]$certpath,
		[parameter(Mandatory = $true)]
		[string]$certdst,
		[parameter(Mandatory = $true)]
		[object[]]$certstores	
	)
	$rslt
	try
	{
		switch ($certdst)
		{
			'localmachine' {
				foreach ($ct in $certstores)
				{
					switch ($ct)
					{
						'Personal' {
							Import-Certificate -FilePath $certpath -CertStoreLocation cert:\LocalMachine\My
							$rslt += "$certpath imported in to cert:\LocalMachine\My `r`n"
							break;
						}
						'Root' {
							Import-Certificate -FilePath $certpath -CertStoreLocation cert:\LocalMachine\Root
							$rslt += "$certpath imported in to cert:\LocalMachine\Root `r`n"
							break;
						}
						'Intermediate' {
							Import-Certificate -FilePath $certpath -CertStoreLocation cert:\LocalMachine\CA
							$rslt += "$certpath imported in to cert:\LocalMachine\CA `r`n"
							break;
						}
					}
				}
				
				break;
			}
			'currentuser' {
				foreach ($ct in $certstores)
				{
					switch ($ct)
					{
						'Personal' {
							Import-Certificate -FilePath $certpath -CertStoreLocation cert:\CurrentUser\My
							$rslt += "$certpath imported in to cert:\CurrentUser\My `r`n"
							break;
						}
						'Root' {
							Import-Certificate -FilePath $certpath -CertStoreLocation cert:\CurrentUser\Root
							$rslt += "$certpath imported in to cert:\CurrentUser\Root `r`n"
							break;
						}
						'Intermediate' {
							Import-Certificate -FilePath $certpath -CertStoreLocation cert:\CurrentUser\CA
							$rslt += "$certpath imported in to cert:\CurrentUser\CA `r`n"
							break;
						}
					}
				}
				break;
			}
			default {
				$rslt = 'No path Choosen'
				break;
			}
		}
		return $rslt
	}
	catch
	{
		return $_
	}
	
}

