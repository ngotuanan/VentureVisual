$logfile="E:\backup\logs.txt"
$backupday=(Get-Date).AddDays(-1).ToString('yyyy-M-dd')  ## Get needed backup folder as day
##### BACKUP SCRIPT FOR CALL AUDIO FOLDERS #####

$rootdir="E:\CallAudio\"  #Root directory need to backup
$backupdir=$rootdir+=$backupday     #Get full backup folder link
$destdir="E:\backup\CallAudio\"   # Destination folder where backed up files will be saved
cp $backupdir $destdir -recurse

### Compare original folder and backed up folder
$destdir1=$destdir+=$backupday     #Get full destination folder link
$orisize="{0:N2}" -f ((Get-ChildItem -path $backupdir -recurse | Measure-Object -property length -sum ).sum /1MB)
$destsize="{0:N2}" -f ((Get-ChildItem -path $destdir1 -recurse | Measure-Object -property length -sum ).sum /1MB)
if ($orisize -eq $destsize)
	{
		$stt=">>>>> Backed up CallAudio successfully"
	}
else
	{
		$stt=">>>>> Backed up CallAudio might be failed. Please check again"
	}

Add-Content $logfile "`n"
Add-Content $logfile "################## BACKUP STATUS DATE $backupday ##################"
Add-Content $logfile "`n"
Add-Content $logfile "Backup folder:      $backupdir         ----- Size: $orisize MB"
Add-Content $logfile "Destination folder: $destdir1  ----- Size: $destsize MB"
Add-Content $logfile "`n"
Add-Content $logfile $stt

######## BACKUP SCRIPT FOR VIRTUALICE FOLDER ##########
$virtualice_ori="C:\VirtualICE"
$back_root="E:\backup\virtualice\"
$virtualice_bak=$back_root+=$backupday
New-Item -ItemType directory -Path $virtualice_bak
cp $virtualice_ori\* $virtualice_bak -recurse

### Compare original folder and backed up folder

$orisize1="{0:N2}" -f ((Get-ChildItem -path $virtualice_ori -recurse | Measure-Object -property length -sum ).sum /1MB)
$destsize1="{0:N2}" -f ((Get-ChildItem -path $virtualice_bak -recurse | Measure-Object -property length -sum ).sum /1MB)
if ($orisize -eq $destsize)
	{
		$stt=">>>>> Backed up VirtualICE successfully"
	}
else
	{
		$stt=">>>>> Backed up VirtualICE might be failed. Please check again"
	}

Add-Content $logfile "`n"
Add-Content $logfile "Backup folder:      $virtualice_ori                    ----- Size: $orisize1 MB"
Add-Content $logfile "Destination folder: $virtualice_bak  ----- Size: $destsize1 MB"
Add-Content $logfile "`n"
Add-Content $logfile $stt	