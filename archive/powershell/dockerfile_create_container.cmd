
@@:: This prolog allows a PowerShell script to be embedded in a .CMD file.
@@:: Any non-PowerShell content must be preceeded by "@@"
@@setlocal
@@set POWERSHELL_BAT_ARGS=%*
@@if defined POWERSHELL_BAT_ARGS set POWERSHELL_BAT_ARGS=%POWERSHELL_BAT_ARGS:"=\"%
@@PowerShell -ExecutionPolicy Bypass -Command Invoke-Expression $('$args=@(^&{$args} %POWERSHELL_BAT_ARGS%);'+[String]::Join(';',$((Get-Content '%~f0') -notmatch '^^@@'))) & goto :EOF

Read-Host -Prompt "This will reset your container to the original image. It will erase all information in your container. \n Press Enter to continue."

$win_user=[Environment]::UserName
$linux_home_folder='/home/nrcan'
$x_display = $(ipconfig | where {$_ -match 'IPv4.+\s(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})' } | select -First 1 | where {$_ -match 'IPv4.+\s(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})' } | foreach{$Matches[1]} )
$container='dockerfile_btap_dev_container' 
$image='dockerfile_btap_dev_image'

Write-Host  Display for X has been determined to be ${x_display}:0
Write-Host The  windows user is identified as $win_user
docker rm  ${container}
Write-Host "docker create -ti  -e DISPLAY=${x_display}:0.0 -v c:/Users/${win_user}:${linux_home_folder}/windows-host --name ${container} ${image}"
docker create -ti  -e DISPLAY=${x_display}:0.0 -v c:/Users/${win_user}:${linux_home_folder}/windows-host --name ${container} ${image}
Read-Host -Prompt "Old container ${container} has been deleted and a replaced with a fresh container."
