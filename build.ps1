


$ipconfig = $(ipconfig | where {$_ -match 'IPv4.+\s(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})' } | select -First 1 | where {$_ -match 'IPv4.+\s(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})' } | foreach{$Matches[1]} )
docker build --build-arg DISPLAY=$ipconfig:0.0 -t openstudio-dev .
Read-Host -Prompt "Press Enter to exit"
