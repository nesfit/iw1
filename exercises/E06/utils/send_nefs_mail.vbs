' Name: send_nefs_mail.vbs
' Author: Jan Fiedor
' Description: VB Script for sending an e-mail with information about a partition
'              which does not have enough free space (IW1 / E06, Lab 03 - variant
'              outside the lab; the lab VMs have no internet access).
'
' Fill in your own SMTP server and account below before use. The repository
' contains placeholders only - never commit real credentials.
' Note: VBScript is deprecated since October 2023 (optional feature in Windows 11 24H2);
'       Gmail / Outlook.com require an app password instead of the account password.
'
' Usage: wscript.exe send_nefs_mail.vbs <recipient e-mail address>

option explicit

' --- SMTP configuration (placeholders, replace) ---
Const smtpServer   = "smtp.example.com"
Const smtpPort     = 465
Const smtpUseSsl   = True
Const smtpUser     = "user@example.com"
Const smtpPassword = "CHANGE-ME"
Const smtpFrom     = "user@example.com"
' --- end of SMTP configuration ---

' Variables
dim sendTo, email, pFreeSpace
dim wmiQuery, result, hostname
dim wmiService, diskC

' Parse arguments
if wscript.arguments.count <> 1 then
  wscript.echo "Wrong number of arguments!" & vbCrLf & "Usage:" & vbCrLf & "  wscript.exe send_nefs_mail.vbs <e-mail>"
  wscript.quit 1
else
  sendTo = wscript.arguments(0)
end if

if smtpPassword = "CHANGE-ME" then
  wscript.echo "SMTP configuration not filled in - edit the constants at the top of the script."
  wscript.quit 1
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
email.Subject = "Not Enough Free Space"
email.From = smtpFrom
email.To = sendTo
email.TextBody = "Computer " & hostname & " is running out of space on drive C: only " & pFreeSpace & "% free space left."

' Remote SMTP Server configuration

' Use remote network server
email.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2

' Remote SMTP Server Hostname or IP Address
email.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = smtpServer

' Server port
email.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = smtpPort

' Type of authentication { 0 = NONE, 1 = Basic (Base64 encoded), 2 = NTLM }, use Basic
email.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = 1

' Login name
email.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusername") = smtpUser

' Password
email.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendpassword") = smtpPassword

' Use SSL for the connection (False or True)
email.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpusessl") = smtpUseSsl

' Connection Timeout in seconds (the maximum time CDO will try to establish a connection to the SMTP server)
email.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout") = 60

email.Configuration.Fields.Update

' End of remote SMTP Server configuration

email.Send

' End of script send_nefs_mail.vbs
