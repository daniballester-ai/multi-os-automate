#!/bin/bash

# -------------------------------
# Configurações
# -------------------------------

# Definindo os serviços a serem monitorados
SERVICES=("apache2" "mysqld")

# Diretório de backup
BACKUP_DIR="/backup"

# Arquivo de relatório
REPORT_FILE="/var/log/server_report_$(date +%F).log"

# -------------------------------
# Funções
# -------------------------------

# Verificar se os processos dos serviços estão em execução
check_services() {
    echo "🔍 Verificando status dos serviços..."
    for service in "${SERVICES[@]}"; do
        if pgrep -x "$service" > /dev/null; then
            echo "✔️ Serviço $service está ativo."
            echo "✔️ Serviço $service está ativo." >> "$REPORT_FILE"
        else
            echo "❌ Serviço $service não está ativo!"
            echo "❌ Serviço $service não está ativo!" >> "$REPORT_FILE"
        fi
    done
}

# Realizar backup de arquivos importantes
backup_files() {
    echo "🔄 Realizando backup dos arquivos importantes..."
    mkdir -p "$BACKUP_DIR"
    tar -czf "$BACKUP_DIR/apache2_backup_$(date +%F).tar.gz" -C / etc/apache2
    tar -czf "$BACKUP_DIR/mysql_backup_$(date +%F).tar.gz" -C / var/lib/mysql
    echo "✔️ Backup realizado com sucesso em $BACKUP_DIR."
}

# Monitorar uso de recursos do sistema
monitor_resources() {
    echo "🔍 Monitorando recursos do sistema..."
    echo "CPU:" >> "$REPORT_FILE"
    mpstat >> "$REPORT_FILE" 2>&1
    echo -e "\nMemória:" >> "$REPORT_FILE"
    free -h >> "$REPORT_FILE"
    echo -e "\nEspaço em Disco:" >> "$REPORT_FILE"
    df -h >> "$REPORT_FILE"
    echo "✔️ Monitoramento de recursos concluído."
}

# Verificar e instalar atualizações de segurança
update_system() {
    echo "🔄 Verificando e instalando atualizações de segurança..."
    apt update -y && apt upgrade -y
    echo "✔️ Atualizações instaladas com sucesso."
}

# Gerar relatório de monitoramento
generate_report() {
    echo "📄 Gerando relatório..."
    echo "Relatório de monitoramento - $(date)" > "$REPORT_FILE"
    echo "---------------------------------" >> "$REPORT_FILE"
    check_services
    monitor_resources
    echo "📄 Relatório gerado em $REPORT_FILE."
}

# -------------------------------
# Execução das Funções
# -------------------------------

main() {
    generate_report   # Gera o relatório e inclui verificação de serviços e monitoramento de recursos
    backup_files      # Realiza o backup dos arquivos importantes
    update_system     # Atualiza o sistema com as últimas atualizações de segurança
}

# Executa o script principal
main