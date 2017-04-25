$agentDir = "c:\buildAgent"
$agentName = "Build-$env:computername"
$ownPort = "9090"
$serverUrl = $env:teamcityserverurl
if ([string]::IsNullOrEmpty($serverUrl))
{
    throw "Environment variable teamcityserverurl must not be empty or null"
}

#download agent
New-Item -ItemType Directory -Force -Path $agentDir
Expand-Archive -Path c:\buildAgent.zip -DestinationPath c:\buildAgent
Remove-Item c:\buildAgent.zip -Force
 
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