function New-WebApp{
param(
[string]$rootwebsite,
[string]$WebAppName,
[string]$AppPoolName
)
$targetpath="d:\inetpub\"+$rootwebsite+"_"+$WebAppName
New-WebApplication -name $WebAppName -Site $rootwebsite -PhysicalPath $targetpath -ApplicationPool $WebAppName -Force

}

