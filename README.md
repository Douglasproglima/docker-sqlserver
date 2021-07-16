### DOCKER 2021
---

<p align="center">
  <img src="https://blog.geekhunter.com.br/wp-content/uploads/2019/06/docker-na-pratica-como-construir-uma-aplicacao-2.png" width="320" alt="Docker Logo" />
</p>

<h1 align="center">
🚧 Estudo dos detalhes Docker/Container 🚧
</h1>

<p align="center">
  <img alt="GitHub language count" src="https://img.shields.io/github/languages/count/Douglasproglima/docker-sqlserver">

  <img alt="Repository size" src="https://img.shields.io/github/repo-size/Douglasproglima/docker-sqlserver">

  <a href="https://github.com/Douglasproglima/docker-sqlserver/commits/main">
    <img alt="GitHub last commit" src="https://img.shields.io/github/last-commit/Douglasproglima/docker-sqlserver">
  </a>

  <a href="https://github.com/Douglasproglima/docker-sqlserver/issues">
    <img alt="Repository issues" src="https://img.shields.io/github/issues/Douglasproglima/docker-sqlserver">
  </a>

  <img alt="License" src="https://img.shields.io/badge/license-MIT-brightgreen">
</p>

```sh
### Levantar o docker
	sudo service docker start

# Parar o docker
	sudo service docker stop
 
# Listar as imagens
	docker ps

# Histórico de Containers Criados
	docker ps -a

# Roda um container com a Imagem do Nginx
# Nginx: servidor web de código aberto, também serve como proxy reverso, balanceador de carga HTTP e proxy de 
# e-mail para IMAP, POP3 e SMTP.
	docker run nginx

# Usando o container nginx na porta 85 do container e redirecionando para porta 8080 da maquina local externa
# Se acessar o localhost:1234 irá redirecionar para a porta 80 dentro do container
	docker run -p 1234:80 nginx
 
# Rodando o nginx como detached (-d) ou seja em background(segundo plano) para o terminal não ficar preso e ouvindo o log
	docker run -d -p 1234:80 nginx
 
# Criar o container e remover ele da lista do "docker ps -a" quando terminar de usar o container
	docker run --rm -d -p 1234:80 nginx
 
# Renomear Containers
	docker run -dti --name nome-container nome-imagem
	$ docker run -dti Ubuntu-DLima Ubuntu
 
# Parar/Iniciar um container existente
	docker stop ou start id-container ou nome-container 

# Remover um container  o -f para forçar caso o container estiver rodando
	docker rm id-container ou docker rm id-container -f

# Listar as imagens Dockers
	docker image list

# Deletar uma imagem docker
	docker image rmi id-imagem-docker

# Deletar um Container -> -f Forçar a exclusão
	docker rm id-container -f

# Copiar arquivos do S.O para dentro de um container
	docker exec nome-container mkdir /diretorio
	docker cp nome-arquivo.extensao nome-container:diretorio-dentro-container
	
## Exemplo: O comando abaixo é divido em 3 partes: 
	### 1 - Cria o diretório dlima 
	### 2 - cria o diretório controle-versao
	### 3 - copia o file local Teste.txt para o diretório dentro do container home/dlima/controle-versao/
	docker exec Ubuntu-DLima mkdir /home/dlima &&
	docker exec Ubuntu-DLima mkdir /home/dlima/controle-versao &&
	docker cp Teste.txt Ubuntu-DLima:home/dlima/controle-versao
	
	OU
	
	docker exec Ubuntu-DLima mkdir /home/dlima && docker exec Ubuntu-DLima mkdir /home/dlima/controle-versao && docker cp Teste.txt Ubuntu-DLima:home/dlima/controle-versao

## Caso queira copiar varios arquivos, uma alternativa seria zip uma pasta, enviar para o container e descompactar a pasta
	### 1 - Instalar o zip na maquina local
	apt install -y zip
	
	zip meu.zip *.txt && docker exec 3bfae086a373 mkdir /home/dlima && docker exec 3bfae086a373 mkdir /home/dlima/controle-versao && docker cp meu.zip 3bfae086a373:home/dlima/controle-versao
	
	docker exec -itd 3bfae086a373 bash apt update -y && docker exec -itd 3bfae086a373 bash apt upgrade -y
	
	docker exec -itd 3bfae086a373 bash apt install zip -y
	
	docker exec -itd 3bfae086a373 bash unzip /home/dlima/controle-versao/meu.zip

# Copiar arquivo do container para máquina local
	docker cp 3bfae086a373:home/dlima/controle-versao/meu.zip Copiado.zip

# Executando um comando dentro de um container existente[-it: permite entrar no container em modo interativo]
	docker exec -it nome-container comando
	docker exec -it xenodochial_lichterman bash
	
# diretório onde se encontra o index.html do nginx dentro do container
	cd usr/share/nginx/html/

# Backup do arquivo original
	index.html index.html_bck
	
# Para alterar o index.html é necessario instalar um editor de text
	apt-get update
	apt-get install nano -y
	nano
	 # vai abrir o arquivo informe <h1>Minha Página Nginx<h1>
# descobrir IP
	hostname -I
```

### Receita de Bolo para criar uma nova IMAGEM
```sh
# Criar uma pasta nginx-react
	mkdir nginx-react
	cd nginx-react
	code .
	
# 1 - Criar uma pasta nginx e dentro o arquinvo index.html 
# 2 - Abrir o arquivo e usar o HTML5 para gerar o template
	
# Na pasta nginx, criar o arquivo Dockerfile com o seguinte conteúdo
	FROM nginx:latest
	COPY index.html /usr/share/nginx/html/index.html
	
# No terminal executar (-t é para dar um nome p/ IMAGEM) 
# O ponto(.) após o nome da image é a onde está o Dockerfile
# Esse comando cria uma imagem  com o nome que quisermos
	docker build -t douglasproglima/nginx:latest .
	
# Agora é só rodar o container com o nome
	docker run -d -p 8081:80 douglasproglima/nginx:latest
	
# Existe o site dockerhub que é similar ao github, só que para imagens Docker
# Se quiser enviar a imagem criada anteriormente para o dockerhub

# VOLUMES: Quando se cria uma pasta compartilhada entre o container e a máquina, alteração BI-Lateral

# docker-compose: Permite subir vários containers ao mesmo tempo
#No Vs Code, na raiz criar um arquivo "docker-compose" e dentro dele add:
version: "3"
services:
  web:
    build: nginx/
    ports:
      - 8081:80
    volumes:
      - ./nginx/:/usr/share/nginx/html/
	
# Algumas propriedades do docker-compose	
# Subir os containers-> 
	# -d: detached -> Para não ficar preso ao terminal, rodar em segundo plano
	# --build: Irá compilar novamente a(s) imagem(s)
	docker-compose up -d --build

# Parar os containers que estão rodando
	docker-compose down
	
# Crie outra pasta com o nome nodeapp e dentro criar o arquivo Dockerfile com o conteúdo:
# FROM nome-da-imagem => Neste caso usei uma imagem hospedado no DockerHub
FROM node:15.14.0-alpine3.10
# RUN: Após baixar e instalar a imagem, instala o bash => Dist Linus-Alpine que não possui o apt-get, por isso apk add <pacote>
RUN apk add bash
# WORKDIR: Diretório dentro da imagem onde vai estar o app ou rotina
WORKDIR /usr/src/app
# CMD: Comando para deixar o container sempre execução(Segurar o processo como UP)
CMD ["tail","-f","/dev/null"]

# Ver os detalhes das imagens do docker-compose
	docker-compose ps
	
# Para entrar dentro dos containers
	docker exec -it nginx-react_nodeapp_1 ou nginx-react_web_1 bash
	
# Modificações para acessar o app web apenas pelo nginx, a máquina física local não irá conseguir a partir de agora
	
	
# Portainer: Gerenciador de Containers do Docker
	docker run -d -p 8000:8000 -p 9001:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer-ce

# Acessar o browser localhost:9001 informar o usuário admin e pass: 12345678

# SQL SERVER 2019
# Baixar a image sql2019
	docker pull mcr.microsoft.com/mssql/server:2019-latest

# Configurar o SQL
	docker run -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=sa,@!2021' -p 1401:1433 -d --name=SQLServer mcr.microsoft.com/mssql/server:2019-latest

# PAMETROS INFORMADOS:
## docker run									Cria e executa o contêiner Docker
## -e 'ACCEPT_EULA=Y'							Aceita os termos de licença da Microsoft
## -e 'SA_PASSWORD=sa.1'						Define uma senha para o usuário SA
## -p 1401:1433									Mapeia a porta 1433 do contêiner para porta 1401 do host
## -d											Executa o contêiner em segundo plano
## --name=SQLServer								Define o nome do contêiner
## mcr.microsoft.com/mssql/server:2019-latest	Nome da imagem usada para criar o contêiner

# Testar se o SQL Server: Entrar no container criado
	docker exec -it SQLServer bash

# Testar - http://www.macoratti.net/19/01/dock_mssql1.htm
	/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P 'dga,@!2612'
	
# Se ocorrer o erro ao executar o passo acima instale o mssql-tools
	# https://sqlserveronlinuxbackup.com/sqlcmd-command-not-found-ubuntu/

# SQL no docker-compose - Ao reiniciar perder os dados
	## Playlist sobre docker + sql: https://www.youtube.com/playlist?list=PLXXExoAK--GKyqZnybOMZGy65WFSGzTzl
	## Permissão: https://www.eiximenis.dev/posts/2020-06-26-sql-server-docker-no-se-ejecuta-en-root/
	## Criar a past sqlserver/shared_folder/ com as permissões
		mkdir -p /home/douglasproglima/sqlserver/shared_folder/
		chown 10001:0 /home/douglasproglima/sqlserver/shared_folder/
		chmod +rwx /home/douglasproglima/sqlserver/shared_folder/
		
	## Arquivo .env
		SHARED_FOLDER=/home/douglasproglima/sqlserver/shared_folder/
	## docker-compose.yml
version: '3'

services:

  db_sql:
    container_name: container-sql
    image: mcr.microsoft.com/mssql/server:2019-latest
    restart: always
    tty: true
    hostname:
      mssql-demo1
    domainname:
      douglasproglima
    environment:
      MSSQL_SA_PASSWORD: "PaSSw0rd"
      ACCEPT_EULA: "Y"
      MSSQL_PID: "Developer"
      MSSQL_AGENT_ENABLED: "true"
    volumes:
      - ${SHARED_FOLDER}:/var/opt/mssql/shared_folder
    expose:
      - 14333
    ports:
      - "14333:1433"
    cpu_count: 4

			
	## Levantar o Container
		docker-compose up

# SQL Server: Montando a propria imagem Docker
	## Criar o arquivo Dockerfile
FROM mcr.microsoft.com/mssql/server:2019-CU3-ubuntu-20.04
EXPOSE 1433

LABEL "MAINTAINER" "Douglas Lima <douglasproglima@gmail.com>"
LABEL "Project" "Microsoft SQL Server container with a sample database"

RUN mkdir -p /var/opt/mssql/backup
WORKDIR /var/opt/mssql/backup

########################################################
# DATABASE SECTION
#	1) Add here the databases you want to have in your image
#	2) Edit setup.sh and include the RESTORE commands
COPY ./backups/Northwind.sql
########################################################

RUN mkdir -p /usr/config
WORKDIR /usr/config


	## docker-compose.yml
version: '3'

services:

  db_sql:
    container_name: container-sql-full
    image: mcr.microsoft.com/mssql/server:2019-latest
    restart: always
    tty: true
	build:
		context: .
		dockerfile: Dockerfile
    hostname:
      mssql-full
    domainname:
      douglasproglima
    environment:
      MSSQL_SA_PASSWORD: "PaSSw0rd"
      ACCEPT_EULA: "Y"
      MSSQL_PID: "Developer"
      MSSQL_AGENT_ENABLED: "true"
    expose:
      - 14333
    ports:
      - "14333:1433"
    cpu_count: 4

## Exemplo 2 com nginx
version: "3"
services:
  web:
    build: nginx/
    ports:
      - 8081:80
    volumes:
      - ./nginx/:/usr/share/nginx/html/
  nodeapp:
    build: nodeapp/
    volumes:
      - ./nodeapp/:/usr/src/app
db:
    image: "mcr.microsoft.com/mssql/server"
    restart: always
    tty: true
    environment:
        PATH: /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
        MSSQL_SA_PASSWORD: "sa.1"
        ACCEPT_EULA: "Y"
    ports:
      - "1433:1433"

```