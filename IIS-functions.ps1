function New-WebApp{
param(
[string]$rootwebsite,
[string]$WebAppName,
[string]$AppPoolName
)
$targetpath="d:\inetpub\"+$rootwebsite+"_"+$WebAppName
New-WebApplication -name $WebAppName -Site $rootwebsite -PhysicalPath $targetpath -ApplicationPool $WebAppName -Force

}


Function add-AppPool{
Param(
[string]$PoolName,
[string]$netVersion = "4.0",
[boolean]$enable32Bit = $false,
[boolean]$classicPipelineMode = $false,
[string]$svcAccount,
[string]$svcAccountpswrd
)
  New-WebAppPool -Name $PoolName
  Set-ItemProperty IIS:\AppPools\$PoolName managedRuntimeVersion v$netVersion -Force
  if ($enable32Bit -eq $True){Set-ItemProperty IIS:\AppPools\$PoolName enable32BitAppOnWin64 true -Force}
  if ($classicPipelineMode -eq $True){Set-ItemProperty IIS:\AppPools\$siteName managedPipelineMode 1 -Force}
  $pool=Get-Item IIS:\AppPools\$PoolName
  $pool.processModel.username=$svcAccount
  $pool.processModel.password =$svcAccountpswrd
  $pool.processModel.identityType = 3
  $pool|Set-Item
  $pool.stop()
  $pool.start()
}
