# 🛠️ Projeto de Automação de Servidores Linux e Windows

## 📋 Tarefa e Objetivo

Este projeto foi desenvolvido para automatizar o processo de monitoramento e gerenciamento de servidores Linux e Windows em uma infraestrutura mista. O objetivo principal é criar scripts de automação que verifiquem o status de serviços críticos, realizem backups de arquivos importantes, monitorem o uso de recursos, verifiquem e instalem atualizações de segurança, e gerem relatórios periódicos sobre o estado dos servidores.

Neste repositório, você encontrará scripts para ambos os ambientes: Linux (usando Bash) e Windows (usando PowerShell). Além disso, foi utilizado Docker para criar um ambiente de teste para o script Linux.

## 📜 Explicação dos Arquivos de Automação

### `monitoramento.sh` (Linux)

O arquivo `monitoramento.sh` é um script em Bash que realiza as seguintes tarefas em servidores Linux:

1. **Verificação do Status dos Serviços** (`check_services`):
   - Verifica se os serviços principais, como `apache2` e `mysqld`, estão em execução usando o comando `pgrep`.
   - Registra o status desses serviços em um arquivo de relatório.

2. **Backup de Arquivos Importantes** (`backup_files`):
   - Realiza backups das configurações do Apache e dos dados do MySQL, salvando-os em um diretório `/backup`.
   - Utiliza o comando `tar` para criar arquivos comprimidos dos diretórios especificados.

3. **Monitoramento de Recursos do Sistema** (`monitor_resources`):
   - Monitora a utilização de CPU, memória e espaço em disco usando os comandos `mpstat`, `free`, e `df`.
   - Registra essas informações no arquivo de relatório.

4. **Verificação e Instalação de Atualizações de Segurança** (`update_system`):
   - Verifica e instala atualizações de segurança no sistema usando os comandos `apt update` e `apt upgrade`.

5. **Geração de Relatório** (`generate_report`):
   - Gera um relatório detalhado que inclui o status dos serviços e o uso de recursos do sistema.
   - Salva o relatório no diretório `/var/log` com o nome `server_report_YYYY-MM-DD.log`.
  
Esse script pode ser facilmente expandido para incluir mais funcionalidades, como alertas via email ou integração com sistemas de monitoramento, e agendado para execução periódica usando o cron.

## 🐳 Criação e Teste com Docker (Linux)

Para testar o script `monitoramento.sh` em um ambiente Linux, foi criado um container Ubuntu usando Docker. Este container simula um ambiente de servidor onde o script pode ser executado para validar suas funcionalidades.

### Dockerfile

O arquivo `Dockerfile` foi criado para configurar o ambiente de teste. Ele realiza as seguintes ações:

1. **Base da Imagem**: Usa a imagem oficial do Ubuntu como base (`ubuntu:latest`).
2. **Instalação de Pacotes Necessários**: Instala os serviços `apache2`, `sysstat`, e `mysql-server` dentro do container.
3. **Cópia do Script**: Copia o script `monitoramento.sh` do diretório local para dentro do container, em `/usr/local/bin/`.
4. **Permissão de Execução**: Torna o script executável.
5. **Definição do Comando Padrão**: Configura o script `monitoramento.sh` para ser executado automaticamente quando o container for iniciado.

## 🚀 Comandos Docker (Linux)

Abaixo estão os comandos Docker utilizados para construir a imagem, interagir com o container e testar o script em ambiente Linux:

1. **Construir a Imagem Docker**:
   ```bash
   docker build -t monitoramento_linux .
   ```

2. **Rodar o Script Manualmente e Interagir com o Container**:
   ```bash
   docker run -it --name monitoramento_ubuntu monitoramento_linux /bin/bash
   ```

3. **Execução Manual do Script dentro do Container**:
   ```bash
   /usr/local/bin/monitoramento.sh
   ```

4. **Verificação do Relatório Gerado**:
   ```bash
   cat /var/log/server_report_$(date +%F).log
   ```

5. **Verificar os Arquivos de Backup na Pasta de Backup**:
   ```bash
   ls /backup/
   ```

### `monitoramento.ps1` (Windows)

O arquivo `monitoramento.ps1` é um script em PowerShell que realiza tarefas semelhantes em servidores Windows:

1. **Verificação do Status dos Serviços** (`Check-Services`):
   - Verifica se os serviços principais, como IIS (`W3SVC`) e MSSQLSERVER, estão em execução usando o cmdlet `Get-Service`.
   - Registra o status desses serviços em um arquivo de relatório.

2. **Backup de Arquivos Importantes** (`Backup-Files`):
   - Realiza backups dos arquivos da pasta do IIS e dos dados do MSSQLSERVER, salvando-os em `C:\Backup`.

3. **Monitoramento de Recursos do Sistema** (`Monitor-Resources`):
   - Monitora a utilização de CPU, memória e espaço em disco. 
   - Registra essas informações no arquivo de relatório.

4. **Verificação e Instalação de Atualizações de Segurança** (`Update-System`):
   - Verifica e instala atualizações de segurança.

5. **Geração de Relatório** (`Generate-Report`):
   - Gera um relatório detalhado sobre o status dos serviços e uso de recursos do sistema.
   - Salva o relatório no diretório `C:\Logs` com o nome `server_report_YYYY-MM-DD.log`.

## 🖥️ Comandos PowerShell (Windows)

Para executar o script em servidores Windows, utilize os seguintes comandos PowerShell:

1. **Executar o Script**:
   ```powershell
   .\monitoramento.ps1
   ```

2. **Verificação do Relatório Gerado**:
   - Navegue até `C:\Logs` e abra o arquivo `server_report_YYYY-MM-DD.log` para visualizar o relatório gerado.

3. **Verificar os Arquivos de Backup**:
   - Navegue até `C:\Backup` para visualizar os arquivos de backup gerados pelo script.


## 📜 Conclusão

Este projeto demonstra como automatizar tarefas críticas de monitoramento e gerenciamento de servidores Linux e Windows usando Bash, PowerShell e Docker. A modularidade e simplicidade dos scripts `monitoramento.sh` e `monitoramento.ps1`, combinadas com a portabilidade proporcionada pelo Docker, fazem desta solução uma ferramenta eficiente para a gestão de servidores em uma infraestrutura mista.
