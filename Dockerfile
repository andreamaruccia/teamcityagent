FROM microsoft/windowsservercore

RUN powershell -NoProfile -Command "iwr https://chocolatey.org/install.ps1 -UseBasicParsing | invoke-expression"

RUN choco install server-jre -y
RUN choco install nuget.commandline -y
RUN choco install ruby -y
RUN choco install nodejs.install -version 6.3.1 -y
RUN choco install git.install -params '/GitAndUnixToolsOnPath' -y

ADD https://www.python.org/ftp/python/2.7.11/python-2.7.11.amd64.msi c:/python-2.7.11.amd64.msi
RUN msiexec.exe /i c:\python-2.7.11.amd64.msi /qn
RUN powershell -NoProfile -Command "Remove-Item "c:/python-2.7.11.amd64.msi" -Force"

ADD runagent.ps1 c:/runagent.ps1

CMD [ "powershell", "-NoProfile", "-Command", "c:/runagent.ps1" ]