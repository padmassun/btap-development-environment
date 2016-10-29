Set-ExecutionPolicy remotesigned
$current_user=phylr
$ipconfig = $(ipconfig | where {$_ -match 'IPv4.+\s(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})' } | select -First 1 | where {$_ -match 'IPv4.+\s(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})' } | foreach{$Matches[1]} )
Write-Host $ipconfig
Write-Host $current_user
docker start dockerfile_btap_dev_container
Read-Host -Prompt "Done. Press Enter to exit and execute dev_start.ps1 to start the environment."
