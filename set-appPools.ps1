
function set-appPools{
param
(
$Settings
)
    Import-Module webadministration
    cd iis:
    $pool=Get-Item IIS:\AppPools\$($Settings.appPoolName)
    $pool.name
    if($Settings.username -ne $null){$pool.processModel.username=$Settings.username}
    if($Settings.password -ne $null){$pool.processModel.password =$Settings.password;$pool.processModel.identityType = 3}
    if($Settings.privatememory -ne $null){$pool.recycling.periodicRestart.PrivateMemory=$Settings.privatememory}
    if($Settings.idleTimeout -ne $null){$pool.processModel.idleTimeout= $Settings.idletimeout} #[TimeSpan] $Settings.idletimeout
    if($Settings.time -ne $null){$pool.Recycling.periodicRestart.time=[TimeSpan] "00:00:00"} #clears periodic restart
    $pool|set-item
    if($Settings.time -ne $null){clear-ItemProperty -Path "IIS:\AppPools\$($Settings.appPoolName)" -Name Recycling.periodicRestart.schedule.collection}
    if($Settings.time -ne $null){new-ItemProperty IIS:\AppPools\$($Settings.appPoolName) -Name Recycling.periodicRestart.schedule.collection -Value $($Settings.time)} # sets a time for app pool recycle
}

$cred = Get-Credential
$servers=Get-Content C:\temp\ServerLists\serverlist.txt |Out-GridView #-PassThru
$Setting=@()
$Setting=""|select Username,Password,PrivateMemory,IdleTimeout,Time,appPoolName
$Setting.appPoolName="testAppPoolName"
$Setting.Username=$null
$Setting.Password=$null
$Setting.PrivateMemory=$null # 700000 is 700 meg
$Setting.IdleTimeout="$([TimeSpan]::FromMinutes(0))"  #"$([TimeSpan]::FromMinutes(240))"
$Setting.Time=$null # "04:00" is 4:00am

foreach($server in $servers){
    $server
    Invoke-Command -ComputerName $server -Credential $cred -ScriptBlock ${function:set-appPools} -ArgumentList (,$Setting)

}
