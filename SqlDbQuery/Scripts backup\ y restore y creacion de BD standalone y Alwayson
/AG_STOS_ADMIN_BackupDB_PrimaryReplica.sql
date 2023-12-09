/*
	Tipo: 			Upgrade plataforma.
	Acción: 		Realiza backup de todas las bases de datos STOS_ADMIN. Estos backups incluyen Full BK y Transaction Log BK.
	Ambiente:		PRO
	Bases de datos:	STOS_ADMIN
	Autor:			Ricardo Ledesma. Dpto. Administración Bases de Datos.
	
*/


USE master
GO

--Backup base de datos STOS_ADMIN:

	BACKUP DATABASE [STOS_ADMIN]
	TO DISK = N'U:\MSSQL\BACKUP\STOS_ADMIN.bak' 
	WITH INIT,  
	NAME = N'STOS_ADMIN-Full Database Backup', 
	SKIP, NOREWIND, NOUNLOAD,  STATS = 1
	GO

	BACKUP LOG [STOS_ADMIN]
	TO DISK = 'U:\MSSQL\BACKUP\STOS_ADMIN.trn' 
	WITH INIT;
	GO
	