# Usando a imagem do Ubuntu
FROM ubuntu:latest

# Instalação de pacotes necessários
RUN apt-get update && apt-get install -y \
    apache2 \
    sysstat \
    mysql-server 

# Copiando o script para dentro do container
COPY monitoramento.sh /usr/local/bin/monitoramento.sh

# Tornando o script executável
RUN chmod +x /usr/local/bin/monitoramento.sh

# Definindo o comando padrão para execução
CMD ["/usr/local/bin/monitoramento.sh"]