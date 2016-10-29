
Read-Host -Prompt "This will reset your development environment to the latests images from Dockerhub. Press enter to continue or close this window!"

$current_user='phylr'
$linux_home_folder='/home/nrcan'
$ipconfig = $(ipconfig | where {$_ -match 'IPv4.+\s(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})' } | select -First 1 | where {$_ -match 'IPv4.+\s(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})' } | foreach{$Matches[1]} )
Write-Host $ipconfig
Write-Host $current_user
Read-Host -Prompt "This will reset your development environment to the latests images from Dockerhub. Press enter to continue or close this window!"
docker rm dockerfile_btap_dev_container 
docker create -ti  -e DISPLAY=${ipconfig}:0.0 -v c:/Users/${current_user}:$linux_home_folder/windows-host --name dockerfile_btap_dev_container dockerfile_btap_dev_image
Read-Host -Prompt "Done. Press Enter to exit and execute dev_start.ps1 to start the environment."
