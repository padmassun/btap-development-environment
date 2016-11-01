
@@:: This prolog allows a PowerShell script to be embedded in a .CMD file.
@@:: Any non-PowerShell content must be preceeded by "@@"
@@setlocal
@@set POWERSHELL_BAT_ARGS=%*
@@if defined POWERSHELL_BAT_ARGS set POWERSHELL_BAT_ARGS=%POWERSHELL_BAT_ARGS:"=\"%
@@PowerShell -ExecutionPolicy Bypass -Command Invoke-Expression $('$args=@(^&{$args} %POWERSHELL_BAT_ARGS%);'+[String]::Join(';',$((Get-Content '%~f0') -notmatch '^^@@'))) & goto :EOF

Read-Host -Prompt "This will reset your container to the original image. It will erase all information in your container. \n Press Enter to continue."
$current_user=[Environment]::UserName
$linux_home_folder='/home/nrcan'
$ipconfig = $(ipconfig | where {$_ -match 'IPv4.+\s(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})' } | select -First 1 | where {$_ -match 'IPv4.+\s(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})' } | foreach{$Matches[1]} )
Write-Host  Display for X has been determined to be $ipconfig:0
Write-Host The  windows user is identified as $current_user
docker rm dockerfile_btap_dev_container 
docker create -ti  -e DISPLAY=${ipconfig}:0.0 -v c:/Users/${current_user}:$linux_home_folder/windows-host --name dockerfile_btap_dev_container dockerfile_btap_dev_image
Read-Host -Prompt "Old container has been deleted and a replaced with a fresh container."
