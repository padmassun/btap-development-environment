$os_version = "2.6.0"
$image = "canmet/btap-development-environment:$($os_version)"
$canmet_server_folder= "//s-bcc-nas2/Groups/Common\ Projects/HB/dockerhub_images/"
$xfolder = ""
if($xming -eq $null) {
if (Test-Path "c:\Program Files\Xming" ) {
   $xfolder = "c:\Program Files\Xming"
}
if (Test-Path "c:\Program Files(x86)\Xming" ) {
   $xfolder = 'c:\Program Files(x86)\Xming'
}

}
$host_ip = (Get-NetIPAddress).IPv4Address
$win_user = $env:UserName

$xming = Get-Process xming -ErrorAction SilentlyContinue
if($xming -eq $null) {
    $xmingexe = $xfolder +  '\Xming.exe'
	$arguments = '-ac -multiwindow -clipboard  -dpi 108'
	Write-Host $xmingexe $arguments
	start-process $xmingexe $arguments
	}
	
foreach ($element in $host_ip -ne $NULL) {
	Write-Host $element
	$xset = $xfolder +  '\Xset.exe'
	$arguments = ' -display ' + $element + ':0.0  q'
	$proc = Start-Process $xset $arguments  -PassThru
    $handle = $proc.Handle # cache proc.Handle
    $proc.WaitForExit();
	if  ($proc.ExitCode -eq 0) {
		$host_ip = $element
		break
	}
}

$x_display = $host_ip + ':0.0'
$linux_home_folder = '/home/osdev'

Write-Host "Windows User:"  $win_user
Write-Host "host_ip:" $host_ip
Write-Host "X server IP:" $x_display
Write-Host "image name:" $image
Write-Host "linux home folder:"  $linux_home_folder
	

	

