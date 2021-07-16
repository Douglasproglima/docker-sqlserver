RESTORE DATABASE [Northwind] FROM DISK = N'/var/opt/mssql/backup/Northwind.bak' WITH
FILE = 1, MOVE N'Northwind' TO N'/var/opt/mssql/data/Northwind.mdf',
MOVE N'Northwind_log' TO N'/var/opt/mssql/data/Northwind_log.ldf',
REPLACE, NOUNLOAD, STATS = 5;