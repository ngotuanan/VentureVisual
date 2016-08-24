### Search "ERROR" pattern and output CSV file to shared folder
$date=Get-date -f "yyyy_MM_dd"
Get-ChildItem -recurse | Select-String -pattern "ERROR" | group path | select name,count | Export-CSV "Z:\WeekEnding_$date"

### Move Logs to Archive Folder weekly
$Logs_folder = "C:\virtualICE\local\logs"
$Archive_root = "C:\Logs Archive"
$Archive_folder = "$Archive_root\WeekEnding_$date"
New-Item "$Archive_folder" -type directory
Move-Item "$Logs_folder\*" "$Archive_folder" -force