# Usando a imagem base do Windows Server Core
FROM mcr.microsoft.com/windows/servercore:ltsc2022

# Configura o shell para PowerShell
SHELL ["powershell.exe", "-Command"]

# Diretório de trabalho
WORKDIR /scripts

# Instalação do IIS (W3SVC)
RUN powershell.exe -Command \
    Install-WindowsFeature -name Web-Server -IncludeManagementTools

# Instalação do SQL Server Express
RUN Invoke-WebRequest -Uri https://go.microsoft.com/fwlink/?linkid=866658 -OutFile sqlexpress.exe; \
    Start-Process -FilePath .\sqlexpress.exe -ArgumentList '/q', '/ACTION=Install', '/FEATURES=SQL', '/INSTANCENAME=MSSQLSERVER', '/SQLSVCACCOUNT="NT AUTHORITY\SYSTEM"', '/SQLSYSADMINACCOUNTS="BUILTIN\ADMINISTRATORS"', '/AGTSVCSTARTUPTYPE=Automatic', '/SECURITYMODE=SQL', '/SAPWD="YourStrong@Passw0rd"' -NoNewWindow -Wait; \
    Remove-Item -Force sqlexpress.exe

# Copia o script PowerShell para o container
COPY monitoramento.ps1 /scripts/monitoramento.ps1

# Configura os serviços para iniciar automaticamente
RUN powershell.exe -Command \
    Set-Service W3SVC -StartupType Automatic; \
    Set-Service MSSQLSERVER -StartupType Automatic

# Inicia os serviços
RUN powershell.exe -Command \
    Start-Service W3SVC; \
    Start-Service MSSQLSERVER

# Exponha as portas necessárias (80 para IIS e 1433 para SQL Server)
EXPOSE 80 1433

# Entry point para interações futuras
CMD ["powershell.exe", "-NoLogo", "-NoProfile"]
