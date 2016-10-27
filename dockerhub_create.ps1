
Read-Host -Prompt "This will reset your development environment to the latests images from Dockerhub. Press enter to continue or close this window!"

$current_user=[Environment]::UserName
$linux_home_folder='/root'
$ipconfig = $(ipconfig | where {$_ -match 'IPv4.+\s(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})' } | select -First 1 | where {$_ -match 'IPv4.+\s(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})' } | foreach{$Matches[1]} )
Write-Host $ipconfig
Write-Host $current_user
Read-Host -Prompt "This will reset your development environment to the latests images from Dockerhub. Press enter to continue or close this window!"
docker rm btap_dev
docker create -ti  -e DISPLAY=${ipconfig}:0.0 -v c:/Users/${current_user}:$linux_home_folder/windows-host --name btap_dev phylroy/btap-development-environment
Read-Host -Prompt "Done. Press Enter to exit and execute dev_start.ps1 to start the environment."
