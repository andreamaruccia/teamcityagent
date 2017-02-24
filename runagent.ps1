$serverUrl = "http://teamcity-server-a14fac6f.7adb6e9b.svc.dockerapp.io:8111"
$agentDir = "c:\buildAgent"
$agentName = "Build-$env:computername"
$ownPort = "9090"
 
# Configure agent
Copy-Item $agentDir\conf\buildAgent.dist.properties $agentDir\conf\buildAgent.properties
(Get-Content $agentDir\conf\buildAgent.properties) | Foreach-Object {
    $_ -replace 'serverUrl=http://localhost:8111/', "serverUrl=$serverUrl" `
     -replace 'name=', "name=$agentName" `
     -replace 'ownPort=9090', "ownPort=$ownPort"
    } | Set-Content $agentDir\conf\buildAgent.properties

#run agent
Set-Location -Path $agentDir\bin
& .\agent.bat start

while ($true) { Start-Sleep -Seconds ([Int16]::MaxValue) }