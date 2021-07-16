#!/bin/bash

export STATUS=1
i=0

while [[ $STATUS -ne 0 ]] && [[ $i -lt 60 ]]; do
  i=$i+1
  echo "*******************************************"
  echo "Aguarde o SQL Server iniciar"
  /opt/mssql-tools/bin/sqlcmd -t 1 -S 127.0.0.1 -U sa -P $MSSQL_SA_PASSWORD -Q "SELECT 1" >> /dev/null
  STATUS=$?
  sleep 1
done

if [ $STATUS -ne 0 ]; then
  echo "Erro: MSSQL Server precisa de mais 60 segundos para iniciar."
  exit 1
fi

# Se o arquivo mdf existir não tem necessidade de restaurar novamente
echo "***** MSSQL Server Iniciando *****" | tee -a ./config.log
file="/var/opt/mssql/data/Northwind.mdf"

if [ ! -f "$file" ]
then
  echo "************************ Restaurando banco de dados: ....." | tee -a ./config.log
  /opt/mssql-tools/bin/sqlcmd -S 127.0.0.1 -U sa -P $MSSQL_SA_PASSWORD -d master -i /usr/config/setup.restore.sql
else
  echo "************************ Banco de dados restaurando" | tee -a ./config.log
fi

echo "************************ MSSQL CONFIG COMPLETA ***************" | tee -a ./config.log