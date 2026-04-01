# AvailableNewMailboxSpace.ps1

Icinga/Nagios PowerShell plugin to monitor available free mailbox space in an Exchange database.

## Features

- Checks `AvailableNewMailboxSpace` in MiB
- Configurable minimum free space threshold
- Nagios-compatible output and exit codes
- Performance data output for graphing

## Requirements

- Windows PowerShell
- Exchange Management Shell / snap-in available

## Usage

```powershell
.\AvailableNewMailboxSpace.ps1 -DatabaseName "DB01" -MinFreeMB 2048
```

Optional custom snap-in:

```powershell
.\AvailableNewMailboxSpace.ps1 -DatabaseName "DB01" -MinFreeMB 2048 -ExchangeSnapIn "Microsoft.Exchange.Management.PowerShell.E2010"
```

## Exit Codes

- `0` OK
- `2` CRITICAL
- `3` UNKNOWN

## License

GNU General Public License v2.0 (see repository license selection).