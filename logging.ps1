function get-logfile {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true)][string]$File
    )
    If(!(Test-Path $File)) {
        New-Item -Path $File -ItemType File
    }
    else { Get-Item -Path $File}
}

function add-logentry {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true,Position=0)][string]$Message,
        [Parameter(Mandatory=$true,Position=1)][string]$File
    )
    $DateTime=Get-Date -Format "s"
    "[$($DateTime)] $Message" | Write-Host
    "[$($DateTime)] $Message" | Out-File -Append -Encoding utf8 -FilePath $File
}

