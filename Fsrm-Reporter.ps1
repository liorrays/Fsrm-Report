#----------------------------------------
# Author Lior Rays 2022©.
#Linkedin Profile - www.linkedin.com/in/lior-rays-58266b194

<#

Purpose of the script:

*** There is three seperate CSV. ***

1) Export to csv file all the file groups and the Extensions.

2) Export to csv file all the file screens Exculude , path ,include ,path.

3 )Export to csv file all the file screens template.

#>

#----------------------------------------


# Section One Create A folder At UserProfile Desktop Were The Csv Export Log
function FolderCreateor{
Write-Host "Creating Log Folder On $env:USERPROFILE\Desktop\365-MultiTool" -BackgroundColor Black -ForegroundColor White

New-Item -Name 365-MultiTool -path "$($env:USERPROFILE)\Desktop" -ItemType "directory" -ErrorAction Ignore
if($?){
    Write-Host "New Folder 365-MultiTool Has Created on  $($env:USERPROFILE)\Desktop  " `r`n`r`n -ForegroundColor Green -BackgroundColor Black 
    }
else{
Write-Host "The Folder 365-MultiTool  Is Already Exist"`r`n`r`n -ForegroundColor Yellow -BackgroundColor Black
}



foreach($f in $folders){

Write-Host "Creating Log Folder On $env:USERPROFILE\Desktop\365-MultiTool" -BackgroundColor Black -ForegroundColor White

New-Item -Name $f -path "$($env:USERPROFILE)\Desktop\365-MultiTool" -ItemType "directory" -ErrorAction Ignore
if($?){
    Write-Host "New Folder $f Has Created on  $($env:USERPROFILE)\Desktop\365-MultiTool" `r`n`r`n -ForegroundColor Green -BackgroundColor Black 
    }
else{
Write-Host "The Folder $f  Is Already Exist"`r`n`r`n -ForegroundColor Yellow -BackgroundColor Black
}
}
}

$folders ='FSRM' #Folder Name               #You can Edit Here

$CsvLocation5= "$env:USERPROFILE\Desktop\Fsrm-Report\Fsrm" # Folder Location       #You can Edit Here
#-----------------------------------------------------------------------------------

function Fsrm-Reporter{

write-host "Checking if FS-Resource-Manager Role Is Installed" -BackgroundColor Black -ForegroundColor White

$FsrmRoleCheck = Get-WindowsFeature | Where-Object {$_.name -eq 'FS-Resource-Manager'} #Check If Fsrm Role Is Installed

if($FsrmRoleCheck.InstallState  -eq 'Installed'){

Write-Host "FSRM Role - Is Installed . Script Start Runing" -ForegroundColor Black -BackgroundColor Green
[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')
[System.Windows.Forms.MessageBox]::Show('You Have To Run This Script As Administrator On The File Server !')

function Get-FSRMExceptionCSV  {
Write-Host "Checking FSRM Exception " -BackgroundColor Black   -ForegroundColor White

$g = Get-FsrmFileScreenException
foreach($p in $g ){

Write-Host "Checking FSRM Exception Path $($p.Path) " -BackgroundColor Black   -ForegroundColor Cyan
$g1 = $p.IncludeGroup
$g2 = $p.Path


 [PSCustomObject]@{
 ServerName = $env:COMPUTERNAME
 Exceptions_Groups = $(($g1 ) -join ", ")
 Exceptions_Path = (($g2) -join ", ")

  
 }| Select-Object ServerName,Exceptions_Path,Exceptions_Groups | Export-Csv "$CsvLocation5\Exeptions-$env:COMPUTERNAME.csv" -Append -NoTypeInformation -Encoding UTF8 

 }

 $g1 = $null
 $g2 = $null

 }
function Get-FSRMFileScreenCSV {
Write-Host "Checking FSRM File Screen " -BackgroundColor Black   -ForegroundColor White

$s =Get-FsrmFileScreen

foreach($f in $s ){
Write-Host "Checking FSRM File Screen Path $($f.Path) " -BackgroundColor Black   -ForegroundColor Magenta


$s1 = $f.IncludeGroup
$s2 = $f.Path
$s3 = $f.active



 [PSCustomObject]@{
 ServerName = $env:COMPUTERNAME
 FileScreen_Active = $(($s3 ) -join ", ")
 FileScreen_Path = (($s2) -join ", ")
 FileScreen_Groups = (($s1) -join ", ")

  
 }| Select-Object ServerName,FileScreen_Active,FileScreen_Path,FileScreen_Groups| Export-Csv "$CsvLocation5\FileScreens-$env:COMPUTERNAME.csv" -Append -NoTypeInformation -Encoding UTF8 

 }

 $s1 = $null
 $s2 = $null
 $s3 = $null

 }
function Get-FSRMFileGroupsCSV {
Write-Host "Checking FSRM File Groups " -BackgroundColor Black   -ForegroundColor White


$fg =  Get-FSRMFileGroup | Select-Object -ExpandProperty name

foreach($i in $fg){
Write-Host "Checking FSRM File Group $($i) " -BackgroundColor Black   -ForegroundColor Yellow

$fg3 = Get-FSRMFileGroup -Name $i | Select-Object -ExpandProperty IncludePattern 



 [PSCustomObject]@{
 ServerName = $env:COMPUTERNAME
 FileGroups_extentions = $(($fg3 ) -join ", ")
 FileGroups_Name = (($i) -join ", ")

  
 }| Select-Object ServerName, FileGroups_Name, FileGroups_extentions | Export-Csv "$CsvLocation5\FileGroups-$env:COMPUTERNAME.csv" -Append -NoTypeInformation -Encoding UTF8 

 

 $i = $null
 $fg3 = $null

 }
 }
 

Get-FSRMExceptionCSV
Get-FSRMFileScreenCSV
Get-FSRMFileGroupsCSV
}


elseif($FsrmRoleCheck.InstallState  -eq 'Available'){
Write-Host "FSRM Role - Not Installed . Script Has Stopped" -ForegroundColor Black -BackgroundColor red
}

else{Write-Host "Error - May Not Windows Server Environment" -BackgroundColor white -ForegroundColor Red}
}

Fsrm-Reporter
