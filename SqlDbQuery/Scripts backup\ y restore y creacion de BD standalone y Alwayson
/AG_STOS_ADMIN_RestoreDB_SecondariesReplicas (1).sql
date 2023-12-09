/*
	Tipo: 			Upgrade plataforma.
	Acción: 		Realiza restore de todas las bases de datos STOS_ADMIN. Las bases quedan en estatus RESTORING
	Ambiente:		PRO
	Bases de datos:	STOS_ADMIN.
	Autor:			Ricardo Ledesma. Dpto. Administración Bases de Datos.
	
*/

	
--Restore base de datos STOS_ADMIN:

USE master
GO	
	--RESTORE FULL BACKUP:

		RESTORE DATABASE [STOS_ADMIN]
		FROM  DISK = N'U:\MSSQL\BACKUP\STOS_ADMIN.BAK' 
		WITH  FILE = 1,  
		MOVE N'STOS_ADMIN' TO N'E:\MSSQL\DATA\STOS_ADMIN.mdf',  
		MOVE N'STOS_ADMIN' TO N'L:\MSSQL\LOG\STOS_ADMIN.ldf',
		MOVE N'STOS_ADMIN' TO N'I:\MSSQL\INDEX\STOS_ADMIN.ndf',
		NOUNLOAD,  STATS = 1,
		NORECOVERY;	
		GO

	--RESTORE T-LOG BACKUP:

		RESTORE LOG [STOS_ADMIN]
		FROM Disk = 'U:\MSSQL\BACKUP\STOS_ADMIN.trn'
		WITH NOREC-OVERY;
		GO