# -------------------------------------
# Configurações
# -------------------------------------

# Serviços a serem monitorados
$services = @("W3SVC", "MSSQLSERVER")

# Diretório de backup
$backupDir = "C:\Backup"

# Arquivo de relatório
$reportFile = "C:\Logs\server_report_$(Get-Date -Format 'yyyy-MM-dd').log"

# -------------------------------------
# Funções
# -------------------------------------

# Verificar status dos serviços
function Check-Services {
    Write-Host "🔍 Verificando status dos serviços..."
    foreach ($service in $services) {
        if (Get-Service -Name $service -ErrorAction SilentlyContinue) {
            $status = Get-Service -Name $service
            if ($status.Status -eq 'Running') {
                Write-Host "✔️ Serviço $service está ativo."
                Add-Content $reportFile "✔️ Serviço $service está ativo."
            } else {
                Write-Host "❌ Serviço $service não está ativo!"
                Add-Content $reportFile "❌ Serviço $service não está ativo!"
            }
        } else {
            Write-Host "⚠️ Serviço $service não encontrado."
            Add-Content $reportFile "⚠️ Serviço $service não encontrado."
        }
    }
}

# Realizar backup de arquivos importantes
function Backup-Files {
    Write-Host "🔄 Realizando backup dos arquivos importantes..."
    
    if (-not (Test-Path -Path $backupDir)) {
        New-Item -Path $backupDir -ItemType Directory
    }
    
    $iisPath = "C:\inetpub\wwwroot"
    $sqlPath = "C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA"
    
    if (Test-Path -Path $iisPath) {
        Compress-Archive -Path $iisPath -DestinationPath "$backupDir\IIS_backup_$(Get-Date -Format 'yyyy-MM-dd').zip"
        Write-Host "✔️ Backup do IIS realizado com sucesso."
    } else {
        Write-Host "⚠️ Caminho $iisPath não encontrado. Backup do IIS não realizado."
    }
    
    if (Test-Path -Path $sqlPath) {
        Compress-Archive -Path $sqlPath -DestinationPath "$backupDir\SQL_backup_$(Get-Date -Format 'yyyy-MM-dd').zip"
        Write-Host "✔️ Backup do SQL Server realizado com sucesso."
    } else {
        Write-Host "⚠️ Caminho $sqlPath não encontrado. Backup do SQL Server não realizado."
    }
}

# Monitorar uso de recursos do sistema
function Monitor-Resources {
    Write-Host "🔍 Monitorando recursos do sistema..."
    
    $cpu = Get-WmiObject win32_processor | Measure-Object -property LoadPercentage -Average | Select-Object Average
    $memory = Get-WmiObject win32_operatingsystem | Select-Object TotalVisibleMemorySize,FreePhysicalMemory
    $disk = Get-PSDrive -PSProvider FileSystem | Select-Object Name, Used, Free, @{Name="Total";Expression={($_.Used + $_.Free)}}

    Add-Content $reportFile "`nCPU Load: $($cpu.Average)%"
    Add-Content $reportFile "`nMemória Total: $([math]::round($memory.TotalVisibleMemorySize / 1MB, 2)) MB"
    Add-Content $reportFile "`nMemória Livre: $([math]::round($memory.FreePhysicalMemory / 1MB, 2)) MB"
    Add-Content $reportFile "`nEspaço em Disco: "
    
    foreach ($d in $disk) {
        Add-Content $reportFile "$($d.Name): Usado: $([math]::round($d.Used / 1GB, 2)) GB, Livre: $([math]::round($d.Free / 1GB, 2)) GB, Total: $([math]::round($d.Total / 1GB, 2)) GB"
    }
    
    Write-Host "✔️ Monitoramento de recursos concluído."
}

# Verificar e instalar atualizações de segurança
function Update-System {
    Write-Host "🔄 Verificando e instalando atualizações de segurança..."
    
    # Instala todas as atualizações de segurança disponíveis
    Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -AutoReboot | Out-File -FilePath $reportFile -Append
    
    Write-Host "✔️ Atualizações instaladas com sucesso."
}

# Gerar relatório de monitoramento
function Generate-Report {
    Write-Host "📄 Gerando relatório..."
    Add-Content $reportFile "Relatório de monitoramento - $(Get-Date)"
    Add-Content $reportFile "---------------------------------"
    Check-Services
    Monitor-Resources
    Write-Host "📄 Relatório gerado em $reportFile."
}

# -------------------------------------
# Execução das Funções
# -------------------------------------

function Main {
    Generate-Report   # Gera o relatório e inclui verificação de serviços e monitoramento de recursos
    Backup-Files      # Realiza o backup dos arquivos importantes
    Update-System     # Atualiza o sistema com as últimas atualizações de segurança
}

# Executa o script principal
Main
