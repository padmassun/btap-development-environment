
$current_user=[Environment]::UserName
$ipconfig = $(ipconfig | where {$_ -match 'IPv4.+\s(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})' } | select -First 1 | where {$_ -match 'IPv4.+\s(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})' } | foreach{$Matches[1]} )
Write-Host $ipconfig
Write-Host $current_user
docker run -ti -e DISPLAY=${ipconfig}:0.0 -v c:/Users/phylr:/home/nrcan/windows-host openstudio-dev
Read-Host -Prompt "Press Enter to exit"
