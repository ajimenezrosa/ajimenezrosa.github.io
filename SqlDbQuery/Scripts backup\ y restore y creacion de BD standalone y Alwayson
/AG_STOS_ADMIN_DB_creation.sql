/*
	Tipo: 			Setting plataforma.
	Acción: 		Creacion de la base de datos STOS_ADMIN.
	Ambiente:		PRO
	Bases de datos:	STOS_ADMIN
	Autor:			Ricardo A. Ledesma. Dpto. Administración Bases de Datos.
	Creado:			2 Julio 2018
*/

CREATE DATABASE [STOS_ADMIN]
 ON  PRIMARY 
( NAME = N'STOS_ADMIN', FILENAME = N'E:\MSSQL\DATA\STOS_ADMIN.mdf' , SIZE = 153600KB , FILEGROWTH = 51200KB ), 
 FILEGROUP [INDEXES] 
( NAME = N'STOS_ADMIN_Index', FILENAME = N'I:\MSSQL\INDEX\STOS_ADMIN_Index.ndf' , SIZE = 153600KB , FILEGROWTH = 51200KB )
 LOG ON 
( NAME = N'STOS_ADMIN_log', FILENAME = N'L:\MSSQL\LOG\STOS_ADMIN_log.ldf' , SIZE = 51200KB , FILEGROWTH = 51200KB )
GO
ALTER DATABASE [STOS_ADMIN] SET RECOVERY FULL WITH NO_WAIT
GO


--CAMBIO DB OWNER:
		USE [STOS_ADMIN]
		GO
		EXEC dbo.sp_changedbowner @loginame = N'_SQLDBOwner', @map = false	
		GO