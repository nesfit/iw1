' Name: malloc.vbs
' Author: Jan Fiedor
' Description: VB Script for allocating remaining memory for a period of time

option explicit

' Variables
dim shell, process
dim size, period
dim wmiService, wmiQuery, result
dim fs

' Set period 1 minute
period = 30

' Connect to WMI service
set wmiService = GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")

' Get amount of free memory
set wmiQuery = wmiService.ExecQuery("SELECT * FROM Win32_PerfFormattedData_PerfOS_Memory")

' Process results
for each result in wmiQuery
  size = result.AvailableMBytes
next

' Test if Malloc.exe exist
set fs = CreateObject("Scripting.FileSystemObject")
if not fs.FileExists("Malloc.exe") then
  wscript.echo "Malloc.exe not found! Can't continue!"
  wscript.quit
end if 

' Execute memory allocation
set shell = CreateObject("WScript.Shell")
set process = shell.Exec("Malloc.exe " & size & " " & period)

' End of script malloc.vbs