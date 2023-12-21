if (!(Get-Module Indented.Net.IP -ListAvailable)) { Install-Module -Name Indented.Net.IP -Scope CurrentUser -Force }
function Invoke-PingSweep {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $Subnet,
        [Parameter(Mandatory = $false)]
        [switch]
        $ResolveAllAddresses
    )
    $Addresses = Get-NetworkRange $Subnet
    $Results = $Addresses | ForEach-Object {
        Write-Verbose $_
        $Alive = Test-Connection -TargetName $_.IPAddressToString -Quiet -Count 1 -TimeoutSeconds 1
        If ($Alive) { try {$DNSResult=(Resolve-DnsName $_ -ErrorAction Stop -QuickTimeout -DnsOnly).Namehost} catch {$DNSResult=$false} }
        else {
            if($ResolveAllAddresses) {try {$DNSResult=(Resolve-DnsName $_ -ErrorAction Stop -QuickTimeout -DnsOnly).Namehost} catch {$DNSResult=$false}}
            else {$DNSResult='skipped'}
        }
        @{
            Address  = $_.IPAddressToString
            Alive    = $Alive
            HostName = $DNSResult
        }
    }
    $Results | Select-Object Address,Alive,HostName
    $Results | Export-Csv .\Sweep-Log.csv -NoTypeInformation
}
