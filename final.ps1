#Whenever you start PowerCLI, you see :
#File C:\Program Files (x86)\VMware\Infrastructure\vSphere PowerCLI\Scripts\Initialize-PowerCLIEnvironment.ps1 cannot be loaded 
#because the execution of scripts is disabled on this system. Please see "get-help about_signing" for more details.
#At line:1 char:2
#+ . <<<<  "C:\Program Files (x86)\VMware\Infrastructure\vSphere PowerCLI\Script
#s\Initialize-PowerCLIEnvironment.ps1"
#    + CategoryInfo          : NotSpecified: (:) [], PSSecurityException
#    + FullyQualifiedErrorId : RuntimeException
#PS C:\Program Files (x86)\VMware\Infrastructure\vSphere PowerCLI>

#To permanently allow the execution of scripts, Right-click on PowerCLI > Run as Administrator:
#PS C:\> Set-ExecutionPolicy RemoteSigned
#Do you want to change the execution policy?
#[Y] Yes  [N] No  [S] Suspend  [?] Help (default is "Y"): y
#PS C:\> Get-ExecutionPolicy
#RemoteSigned

### MAIN CODE #####

write-host Started at: (Get-Date).ToString("hh:mm:ss")
$Date = [DateTime]::Now.AddDays(-1)
$Date.tostring("MM-dd-yyyy") 
$DT = (Get-Date -f MM-dd-yyyy)
$LogName = 'E:\logs\Security_Log_'+$env:ComputerName+'_'+$DT+'.html'  #LOG FILE. ENSURE THAT THE DIRECTORY IS CORRECT
$eventList = @()

#######DO NOT INSERT COMMENT BETWEEN THE FOLLOWING LINES ####################
#####Add more line " and $_.ReplacementStrings[5] -notlike "*TrustedUsers*" `" if you want to delist trusted users in your system
## ie -and $_.ReplacementStrings[5] -notlike "ANONY*" `
##    -and $_.ReplacementStrings[5] -notlike "*pos*" `

Get-EventLog "Security" -InstanceId 4624,4625 -After $Date `
| Where -FilterScript {$_.ReplacementStrings[5] -notlike "*CLT*" `
-and $_.ReplacementStrings[5] -notlike "*CLT-SP*" `
-and $_.ReplacementStrings[-2]} | foreach{

########################################################
		# FOR LOG ON SUCCESSFULLY (4624)
		if($_.InstanceID -eq 4624){
		$stt = 'Successed'
		$row = "" | Select 'Login Time', Users, Workstation, 'Source IP', 'Port', 'Logon Process', Status
        $row.'Login Time' = $_.TimeGenerated
		$row.Users = $_.ReplacementStrings[5]
		$row.Workstation = $_.ReplacementStrings[11]
        $row.'Source IP' = $_.ReplacementStrings[-2]
		$row.'Port' = $_.ReplacementStrings[-1]
		$row.'Logon Process' = $_.ReplacementStrings[9]
		$row.Status = $stt
        $eventList += $row
		}
		
		# FOR LOG ON FAILED (4625)
		if($_.InstanceID  -eq 4625) {
		$stt = 'Failed'
        $row = "" | Select 'Login Time', Users, Workstation, 'Source IP', 'Port', 'Logon Process', Status
        $row.'Login Time' = $_.TimeGenerated
		$row.Users = $_.ReplacementStrings[5]
		$row.Workstation = $_.ReplacementStrings[13]
        $row.'Source IP' = $_.ReplacementStrings[-2]
		$row.'Port' = $_.ReplacementStrings[-1]
		$row.'Logon Process' = $_.ReplacementStrings[11]
		$row.Status = $stt
        $eventList += $row
		}
}
#### FORMATTING OUT PUT ####
$a = "<style>"
$a = $a + "TABLE{border-width: 2px;border-style: solid;border-color: black;border-collapse: collapse;}"
$a = $a + "TH{border-width: 2px;padding: 0px;border-style: solid;border-color: black;background-color:Blue}"
$a = $a + "TD{border-width: 2px;padding: 0px;border-style: solid;border-color: black;background-color:White}"
$a = $a + "</style>"
      
$eventList | Sort-Object 'Status' -descending | ConvertTo-HTML -head $a| out-file $LogName

############################################################################### 
### SENDING MAIL WITH SMTP SERVER PORT 25 
###########Define Variables######## 

#$fromaddress = New-Object system.net.Mail.MailAddress "auto-report@zimbra.vtdc.vn"   # Sender
#$toaddress = "tlm@matrixhost.net" 												# Recipient
#$CCaddress																		# CC
#$bccaddress																	# BCC
#$Subject = "[AUTO REPORT] Security Audit Log For Server '"+$env:ComputerName+"' ("+(get-date -f MM/dd/yyyy)+")"   # Subject
#$body = get-content $LogName													# Add Log file to body
#$attachment = "C:\sendemail\test.txt" 											# Attachment
#$smtpserver = "127.0.0.1" 														# SMTP Server. Ensure allow relay from this server
	
#################################### 
 
#$message = new-object System.Net.Mail.MailMessage 								# Initial 
#$message.From = $fromaddress 													# Add from address
#$message.To.Add($toaddress) 													# Add Recipient
#$message.CC.Add($CCaddress) 													# Add CC
#$message.Bcc.Add($bccaddress)													# Add BCC
#$message.IsBodyHtml = $True 													# Use HTML format to send
#$message.Subject = $Subject 													# Add Subject
#$attach = new-object Net.Mail.Attachment($attachment) 
#$message.Attachments.Add($attach) 
#$message.body = $body 
#$smtp = new-object Net.Mail.SmtpClient($smtpserver) 
#$smtp.Send($message) 

#################################################################################
write-host Finished at: (Get-Date).ToString("hh:mm:ss")