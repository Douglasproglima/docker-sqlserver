FROM mcr.microsoft.com/mssql/server:2019-CU3-ubuntu-16.04
EXPOSE 1433

LABEL "MAINTAINER" "Douglas Lima <douglasproglima@gmail.com>"
LABEL "Project" "Microsoft SQL Server container with a sample database"

RUN mkdir -p /var/opt/mssql/backup
WORKDIR /var/opt/mssql/backup

########################################################
# DATABASE SECTION
#	1) Add here the databases you want to have in your image
#	2) Edit setup.sh and include the RESTORE commands
COPY ./backups/Northwind.bak ./
########################################################

RUN mkdir -p /usr/config
WORKDIR /usr/config

COPY setup.* ./
COPY entrypoint.sh ./

# Usa o usuário root para atribuir permissões especiais aos arquivos
USER root
RUN chown -R 10001:0 setup.sh
RUN chown -R 10001:0 entrypoint.sh

# Dockerize para aguardar o container levar para depois executar o script entrypoint.sh e por assim restaurar o BD
#RUN wget https://github.com/jwilder/dockerize/releases/download/v0.6.1/dockerize-linux-amd64-v0.6.1.tar.gz
#RUN chown -R 10001:0 dockerize-linux-amd64-v0.6.1.tar.gz
#RUN tar -C /usr/local/bin -xzvf dockerize-linux-amd64-v0.6.1.tar.gz
#RUN rm dockerize-linux-amd64-v0.6.1.tar.gz
# add no arquivo entrypoint.sh #dockerize -wait tcp://db_sql:14334 -timeout 40s /opt/mssql/bin/sqlservr & /usr/configs/setup.sh

# Usuário default
USER 10001

# Permissão do usuário normal
RUN chmod +x setup.sh
RUN chmod +x entrypoint.sh

# Este script levanta o SQL Server e restaura o BD
ENTRYPOINT ["./entrypoint.sh"]

# Aqui aguardar indeterminadamente o passo anterior
CMD ["sleep infinity"]