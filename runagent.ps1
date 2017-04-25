$ErrorActionPreference = "Stop"
Set-StrictMode -version 2

$agentDir = "c:\buildAgent"
$agentName = "Build-$env:computername"
$buildAgentZip = "c:\buildAgent.zip"
$ownPort = "9090"
$serverUrl = $env:teamcityserverurl
if ([string]::IsNullOrEmpty($serverUrl))
{
    throw "Environment variable teamcityserverurl must not be empty or null"
}

#download agent first
Invoke-WebRequest -Uri $serverUrl/update/buildAgent.zip -OutFile $buildAgentZip

New-Item -ItemType Directory -Force -Path $agentDir
Expand-Archive -Path $buildAgentZip -DestinationPath $agentDir
Remove-Item $buildAgentZip -Force
 
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