#$filterxml = '<QueryList>
#<Query Id="0" Path="Security">
#<Select Path="Security">*[System[(EventID=4624)]]</Select>
#</Query>
#</QueryList>'

[System.DateTime]$EventStartDate = (((Get-Date).addDays(-2)).date)
[System.DateTime]$EventEndTime = (Get-Date)
$EventLog = Get-WinEvent -ComputerName $env:computername -FilterHashTable @{logname = 'Security';ID = '4624'; StartTime=$EventStartDate; EndTime=$EventEndTime}
ForEach ($LogEntry in $EventLog) {
#Get print job details
#$time = $LogEntry.TimeCreated
$entry = [xml]$LogEntry.ToXml() | out-file "D
#$Username = $entry.Event.EventData.Param6
#$Destination = $entry.Event.EventData.Param7
#$Source = $entry.Event.EventData.Param12
#$IP = $entry.Event.EventData.Param19
#$Write Log to CSV file
#$strOutput = $Username+ "," +$time.ToString()+ "," +$Destination+ "," +$Source+ "," +$IP
#write-output $strOutput | Out-File E:\a.csv -append
}

Start-Sleep -s 100

 