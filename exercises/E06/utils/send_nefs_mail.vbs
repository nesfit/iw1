' Name: send_nefs_mail.vbs
' Author: Jan Fiedor
' Description: VB Script for sending e-mail with information about partition
'              which do not have enought free space

option explicit

' Variables
dim sendTo, email, pFreeSpace
dim wmiQuery, result, hostname
dim wmiService, diskC

' Parse arguments
if wscript.arguments.count <> 1 then
  wscript.echo "Špatný poèet parametrù!" & vbCrLf & "Použití:" & vbCrLf & "  send_nefs_mail.vbs email"
  wscript.quit
else
  sendto = wscript.arguments(0)
end if

' Execute hostname resolution query
set wmiQuery = GetObject("WinMgmts:root/cimv2").ExecQuery("Select * FROM Win32_ComputerSystem")

' Process the result
for each result in wmiQuery
  hostname = result.Name
next

' Connect to WMI service
set wmiService = GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")

' Get amount of free space on disk C
set diskC = wmiService.Get("Win32_PerfFormattedData_PerfDisk_LogicalDisk.Name='C:'")
diskC.Refresh_
pFreeSpace = diskC.PercentFreeSpace

' Create email message
set email = CreateObject("CDO.Message")
email.Subject = "Not Enought Free Space"
email.From = "iwxmwxeventalertsender@seznam.cz" '"iwx.mwx@gmail.com"
email.To = sendTo
email.TextBody = "Na poèítaèí " & hostname & " dochází místo na disku C, disk obsahuje pouze " & pFreeSpace & "% volného místa."

' Remote SMTP Server configuration

' Use remote network server
email.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2

' Remote SMTP Server Hostname or IP Address
email.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "smtp.seznam.cz" '"smtp.gmail.com"

' Server port
email.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 465

' Type of authentication { NONE, Basic (Base64 encoded), NTLM }, use Basic
email.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = 1

' Login name
email.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusername") = "iwxmwxeventalertsender@seznam.cz" '"iwx.mwx@gmail.com"

' Password
email.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendpassword") = "Dn2hmMuUZH" '"aaaAAA111"

' Use SSL for the connection (False or True)
email.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpusessl") = True

' Connection Timeout in seconds (the maximum time CDO will try to establish a connection to the SMTP server)
email.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout") = 60

email.Configuration.Fields.Update

' End of remote SMTP Server configuration

email.Send

' End of script send_nefs_mail.vbs