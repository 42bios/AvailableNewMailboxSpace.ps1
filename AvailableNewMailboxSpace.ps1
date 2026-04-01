[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$DatabaseName,

    [Parameter(Mandatory = $false)]
    [double]$MinFreeMB = 2048,

    [Parameter(Mandatory = $false)]
    [string]$ExchangeSnapIn = "Microsoft.Exchange.Management.PowerShell.E2010"
)

$ErrorActionPreference = "Stop"

function Exit-Plugin {
    param(
        [Parameter(Mandatory = $true)]
        [int]$Code,
        [Parameter(Mandatory = $true)]
        [string]$Message
    )

    Write-Output $Message
    exit $Code
}

try {
    if (-not (Get-PSSnapin -Name $ExchangeSnapIn -ErrorAction SilentlyContinue)) {
        Add-PSSnapin $ExchangeSnapIn
    }

    $db = Get-MailboxDatabase -Status $DatabaseName | Select-Object -First 1 Name, AvailableNewMailboxSpace

    if (-not $db) {
        Exit-Plugin -Code 3 -Message "UNKNOWN - Database '$DatabaseName' not found"
    }

    $freeMB = [double]$db.AvailableNewMailboxSpace.ToMB()
    $perf = "'db_free_mib'=$freeMB;$MinFreeMB;;;"

    if ($freeMB -lt $MinFreeMB) {
        Exit-Plugin -Code 2 -Message "CRITICAL - Database '$($db.Name)' free space is ${freeMB} MiB (min ${MinFreeMB} MiB) | $perf"
    }

    Exit-Plugin -Code 0 -Message "OK - Database '$($db.Name)' free space is ${freeMB} MiB | $perf"
}
catch {
    Exit-Plugin -Code 3 -Message "UNKNOWN - $($_.Exception.Message)"
}
