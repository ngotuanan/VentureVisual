$dev_folder = "E:\Bin"
$test_folder = "E:\bin_test"
$prod_folder = "\\127.0.0.1\bin_mirrored"

Write-Host "Please chose your action (type 1 or 2):"
Write-host "1) Move EXE and DLL files from DEV folder to TEST folder"
Write-Host "2) Move EXE and DLL files from TEST folder to MIRRORED folder"

$action = Read-Host "Your action"

If ($action -eq 1) {
    $confirm1 = Read-Host "You are copying files from DEV folder to TEST folder. All exist files will be replaced. Do you want to continue (y/n)?"
    If ($confirm1 -like "y") {
            Get-ChildItem -path $dev_folder -recurse -include "*.exe","*.dll" -Exclude "*vshost*" | Copy-Item -Destination $test_folder
            Write-Host "Successed"
    } Else {
    Write-Host "Canceled by user"
    exit 0
    }
}
Elseif ($action -eq 2) {
    $confirm2 = Read-Host "You are copying files from TEST folder to MIRRORED folder. All exist files will be replaced. Do you want to continue (y/n)?"
    If ($confirm2 -like "y") {
            Get-ChildItem -path $test_folder -recurse -include "*.exe","*.dll" -Exclude "*vshost*" | Copy-Item -Destination $prod_folder
            Write-Host "Successed"
    } Else {
    Write-Host "Canceled by user"
    exit 0
    }
}
