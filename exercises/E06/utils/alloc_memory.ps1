<#
.SYNOPSIS
    IW1 / E06 - memory pressure generator for testing the "Available MBytes" alert (graded task 1).

.DESCRIPTION
    Allocates memory in chunks until the performance counter \Memory\Available MBytes drops below
    -TargetFreeMB, holds the memory for -Seconds seconds and then releases it. Every page of every
    chunk is touched so the memory is really resident (a plain allocation would stay reserved only).

    Must run in a 64-bit PowerShell (the default one) - a 32-bit process cannot allocate more than
    about 2 GB, which is why the former Malloc.exe never reached the threshold on an 8 GB machine.

.EXAMPLE
    powershell.exe -ExecutionPolicy Bypass -File C:\utils\alloc_memory.ps1 -TargetFreeMB 500 -Seconds 60
#>
[CmdletBinding()]
param(
    [ValidateRange(100, 65536)] [int] $TargetFreeMB = 500,
    [ValidateRange(1, 3600)]    [int] $Seconds = 60,
    [ValidateRange(16, 1024)]   [int] $ChunkMB = 256,
    [ValidateRange(30, 1800)]   [int] $MaxAllocSeconds = 300
)

if (-not [Environment]::Is64BitProcess) {
    Write-Error 'Run this script in a 64-bit PowerShell (C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe).'
    exit 1
}

function Get-AvailableMB {
    [int](Get-CimInstance -ClassName Win32_PerfFormattedData_PerfOS_Memory).AvailableMBytes
}

$chunks   = New-Object 'System.Collections.Generic.List[byte[]]'
$pageSize = 4096
$started  = Get-Date

Write-Host ("Available memory at start: {0} MB, target: below {1} MB" -f (Get-AvailableMB), $TargetFreeMB)
try {
    while ((Get-AvailableMB) -gt $TargetFreeMB) {
        $buffer = New-Object byte[] ($ChunkMB * 1MB)
        for ($i = 0; $i -lt $buffer.Length; $i += $pageSize) { $buffer[$i] = 1 }   # touch every page
        $chunks.Add($buffer)
        Write-Host ("Allocated {0} MB, available {1} MB" -f ($chunks.Count * $ChunkMB), (Get-AvailableMB))
        if (((Get-Date) - $started).TotalSeconds -gt $MaxAllocSeconds) {
            Write-Warning 'Allocation is taking too long, stopping here.'
            break
        }
    }
    Write-Host ("Holding {0} MB for {1} s ..." -f ($chunks.Count * $ChunkMB), $Seconds)
    $until = (Get-Date).AddSeconds($Seconds)
    while ((Get-Date) -lt $until) {
        Start-Sleep -Seconds 5
        Write-Host ("Available memory: {0} MB" -f (Get-AvailableMB))
    }
}
catch [System.OutOfMemoryException] {
    Write-Warning ("Cannot allocate more memory, holding {0} MB for {1} s." -f ($chunks.Count * $ChunkMB), $Seconds)
    Start-Sleep -Seconds $Seconds
}
finally {
    $chunks.Clear()
    $chunks = $null
    [GC]::Collect()
    [GC]::WaitForPendingFinalizers()
    Write-Host ("Memory released, available memory: {0} MB" -f (Get-AvailableMB))
}
