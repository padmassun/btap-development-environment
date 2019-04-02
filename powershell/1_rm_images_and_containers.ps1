docker stop @(docker ps -a -q)
$command = 'docker system prune'
iex $command