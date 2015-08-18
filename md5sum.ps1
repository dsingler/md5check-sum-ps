<#

.SYNOPSIS
This is a powershell script to compare hash values of downloaded files. The defaul algorithm is set to the SHA256.

.DESCRIPTION
This script when run will compare the provided known good hash value of a file to the downloaded file to attempt to validate the file was not modified or changed upon downloading.

.EXAMPLE

./md5sum.ps1 c:\path\to\file\somefile.txt KnownGoodHashValue AlgorithmOption(default is SHA256)

./md5sum.ps1 c:\work\scripts\md5sum.ps1 966E5D40092376385256385569422E57AD4C5ED8 SHA1

Output On Screen

The current hash value for c:\work\scripts\md5sum.ps1 is
966E5D40092376385256385569422E57AD4C5ED8

The file c:\work\scripts\md5sum.ps1 hash evaluated equal

.NOTES
The allowed algorithm options are SHA1 | SHA256 | SHA384 | SHA512 | MACTripleDES | MD5 | RIPEMD160

.LINK
to be used at a later date
#>

[CmdletBinding()]
Param (
[Parameter(
    Mandatory=$True,
    Position=0,
    HelpMessage="Please enter the file location"
    )]
[ValidateScript({Test-Path $_})]
[string]$filePath,

[Parameter(
    Mandatory=$True,
    Position=1,
    HelpMessage="Please enter the known good hash value"
    )]
[string]$hash,

[Parameter(
    Position=2,
    HelpMessage="The default algorithm value is set to SHA256, options to change are SHA1 | SHA384 | SHA512 | MACTripleDES | MD5 | RIPEMD160"
    )]
[ValidateSet("SHA1","SHA256","SHA384","SHA512","MACTripleDES","MD5","RIPEMD160")]
[string]$algorithm = "SHA256"
)


$newhash = Get-FileHash $filePath -Algorithm $algorithm

Write-Host "`nThe current hash value for $filePath is`n" -ForegroundColor Yellow -NoNewline
Write-Host $newhash.Hash -ForegroundColor Magenta 

if($newhash.Hash -eq $hash)
{
    Write-Host "`nThe file $filePath hash evaluated equal`n" -ForegroundColor Green
}

else
{
    Write-Host "`nThe file $filePath hash value is not the same, proceed with caution`n" -ForegroundColor Yellow
    Write-Host "`nWould you like to delete the file? " -ForegroundColor DarkGreen -NoNewline
    Write-Host "[y/n]" -ForegroundColor DarkGray -NoNewline
        if(($inp = Read-Host) -eq "y" -or "n")
        {
            switch -Regex ($inp)
            {
                y {
                  Remove-Item $filePath -Force 
                  Write-Host "`n$filePath has been removed`n" -ForegroundColor Green 
                  }
                n {
                  Write-Host "`n$filePath has not been removed`n" -ForegroundColor Red
                  }
            }

        }

}
