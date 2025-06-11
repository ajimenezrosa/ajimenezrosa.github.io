#### **1. Administración**
- 1.1 [Conectar una unidad de red a un servidor SQL Server](#1)  
- 1.2 [Crecimiento automático de los ficheros de la base de datos](#2)  
    - 1.2.1 [Cómo mover TempDB a otra unidad y carpeta](#21)  
    - 1.2.2 [Consultas y soluciones para bases de datos en SQL Server DB recovery Pending](#2_recovery1)  
<!-- - 1.3 [Eliminar correos del servidor de correos SQL Server](#3)  
    - 1.3.1 [Comprobar `sysmail_event_log` vista](#3.1)  
    - 1.3.2 [Comprobación del elemento de correo con error específico](#3.2)  
    - 1.3.3 [Sysmail_faileditems](#3.3)  
    - 1.3.4 [Sysmail_sentitems](#3.4)  
    - 1.3.5 [Comprobación de la configuración de correo electrónico de base de datos para el servidor SMTP](#3.5)  
    - 1.3.6 [Ver log de envío de correos `sql mail`](#3.6)  
    - 1.3.7 [Ver log de envío de correos fallidos, FAILED MESSAGES LOG](#3.7)  
    - 1.3.8 [ALL MESSAGES – REGARDLESS OF STATUS](#3.8)   -->
- 1.4 [Conexiones activas del servidor de SQL Server](#4)  
- 1.5 [DBCC CHECKDB](#5)  
- 1.6.1 [Reducción de Archivos TempDB en SQL Server Actualizado](#6a)
- 1.7 [Conexión de administración dedicada: cuándo y cómo usarla](#7)  
- 1.8 [Guía para Manejar una Base de Datos en Modo RECOVERING](#RECOVERING)
##### users
- 1.9 [Cerrar Conexiones de un Usuario en SQL Server](#1.9)

# 





# Conectar  una unidad de red a un servidor sql Server.<a name="1"></a>


<img src="https://www.softzone.es/app/uploads-softzone.es/2019/01/almacenamiento-en-la-nube.jpg?format=jpg&name=large" alt="JuveR" width="800px">

~~~sql
EXEC xp_cmdshell 'net use M: \\10.0.0.167\Transaccional passworddominio/user:INABIMASD\administrador'

EXEC xp_cmdshell 'net use T:  \\10.0.0.167\backups\MSSQL passworddominio/user:INABIMASD\administrador'

--exec xp_cmdshell 'net use Y: \\127.0.0.1\Shared aVeRyStR0nGP@s$w0rd@123 /USER:Administrator /PERSISTENT:yes'
--go

exec xp_cmdshell 'net use'
 
~~~
#
# Crecimiento automático de los ficheros de la base de datos<a name="2"></a>

![](https://www.campusmvp.es/recursos/image.axd?picture=/2022/2T/sql-server-tamano/tamano-sql-server-management-archivos.jpg)

# DBCC CHECKDB (Transact-SQL)  <a name="5"></a>
#### Checks the logical and physical integrity of all the objects in the specified database by performing the following operations:

#### Runs 


~~~sql
  DBCC CHECKALLOC 
~~~
## on the database.

#### Runs 
# 
~~~sql
    DBCC CHECKTABLE 
~~~
on every table and view in the database.
#### Runs

~~~sql
    DBCC CHECKCATALOG 
~~~



on the database.

#### Validates the contents of every indexed view in the database.
#### Validates link-level consistency between table metadata and file system directories and files when #### storing varbinary(max) data in the file system using FILESTREAM.
#### Validates the Service Broker data in the database.
#### This means that the ***DBCC CHECKALLOC, DBCC CHECKTABLE, or DBCC CHECKCATALOG*** commands do not have to be run separately from ***DBCC CHECKDB***. For more detailed information about the checks that these commands perform, see the descriptions of these commands.

Information about this topyc
https://docs.microsoft.com/en-us/sql/t-sql/database-console-commands/dbcc-checkdb-transact-sql?view=sql-server-ver15

Ejecucion de los dbcc check db de todas las bases de datos de Inabima de forma separada.
Esto debe ser ejecutado con cuidado.

~~~sql
DBCC CHECKDB(N'AuditoriaDB')  WITH NO_INFOMSGS
GO
DBCC CHECKDB(N'Certificaciones')  WITH NO_INFOMSGS
GO
DBCC CHECKDB(N'DatosCertificaciones')  WITH NO_INFOMSGS
GO
DBCC CHECKDB(N'DatosPersonalesRRHH')  WITH NO_INFOMSGS
GO
DBCC CHECKDB(N'dbPadron2010')  WITH NO_INFOMSGS
GO
DBCC CHECKDB(N'DBTurismoMagisterial')  WITH NO_INFOMSGS
GO
DBCC CHECKDB(N'Genesis')  WITH NO_INFOMSGS
GO
DBCC CHECKDB(N'INABIMA')  WITH NO_INFOMSGS
GO
DBCC CHECKDB(N'INVENTARIO')  WITH NO_INFOMSGS
GO
DBCC CHECKDB(N'ManageEngineDB')  WITH NO_INFOMSGS
GO
DBCC CHECKDB(N'master')  WITH NO_INFOMSGO
DBCC CHECKDB(N'MINERD')  WITH NO_INFOMSGS
GO
DBCC CHECKDB(N'model')  WITH NO_INFOMSGS
GO
DBCC CHECKDB(N'msdb')  WITH NO_INFOMSGS
GO
DBCC CHECKDB(N'Odontologico')  WITH NO_INFOMSGS
GO
DBCC CHECKDB(N'POA_INABIMA')  WITH NO_INFOMSGS
GO
DBCC CHECKDB(N'RegistroAfiliados')  WITH NO_INFOMSGS
GO
DBCC CHECKDB(N'SIGOB_INABIMA_RD')  WITH NO_INFOMSGS
GO
DBCC CHECKDB(N'TA100SQL')  WITH NO_INFOMSGS
~~~

# 

#### Nuestras bases de datos crecen con el uso y SQL Server reserva espacio en disco duro para los ficheros que la componen, pidiéndole al sistema operativo más espacio cuando el que tenía asignado deja de estar disponible. Cada vez que esto ocurre, el rendimiento de nuestra base de datos se ve afectado, ya que el servidor debe bloquear la actividad en ella mientras obtiene el nuevo espacio. Así pues, es deseable configurar las opciones de crecimiento de los ficheros de la base de datos de tal manera que:

  - Los eventos de crecimiento ocurran con poca frecuencia
  - No nos excedamos en la cantidad de disco reservada a los ficheros de una base de datos, ya que podría no ser necesario y estaríamos consumiendo recursos útiles para otras bases de datos en el mismo disco o sistema de discos.
# 

~~~sql
/*
Crecimiento de los mdb 
bases de datos..
AJ   2018- noviembre 15

*/
SELECT
[database_name] AS "database",
format(backup_start_date, 'yyyy-MM-dd') as date,
--DATEPART(month,[backup_start_date]) AS "Month",
AVG([backup_size]/1024/1024) AS "size MB"
--AVG([compressed_backup_size]/1024/1024) AS "Compressed Backup Size MB",
--AVG([backup_size]/[compressed_backup_size]) AS "Compression Ratio"
FROM msdb.dbo.backupset 
where [type] = 'D'
        and [database_name] = 'SIGOB_INABIMA_RD'
GROUP BY [database_name], format(backup_start_date, 'yyyy-MM-dd') --DATEPART(mm,[backup_start_date]);
order by date desc

USE [AuditoriaDB]
GO
SELECT 
    --[id]
      [DatabaseName]
      ,[Date]
     -- ,[logical_name]
     -- ,[Physical_name]
      ,[SizeMB]
      --,[SizeGB]
      
    --  ,[DateTime]
  FROM [dbo].[Db_SpaceMDB_log_inTime_Audit]
        where Physical_name = 'K:\MSSQL\MSSQLSERVER\DATA\SIGOB_INABIMA_RD.mdf' 
  order by Date desc
GO


declare @databasename varchar(50) = 'SIGOB_INABIMA_RD'

SELECT
[database_name] AS "database",
format(backup_start_date, 'yyyy-MM-dd') as date,
--DATEPART(month,[backup_start_date]) AS "Month",
AVG([backup_size]/1024/1024) AS "size MB"
--AVG([compressed_backup_size]/1024/1024) AS "Compressed Backup Size MB",
--AVG([backup_size]/[compressed_backup_size]) AS "Compression Ratio"
FROM msdb.dbo.backupset 
where [type] = 'D'  and database_name = @databasename
GROUP BY [database_name], format(backup_start_date, 'yyyy-MM-dd') --DATEPART(mm,[backup_start_date]);
order by date desc
~~~

#

# Cómo mover TempDB a otra unidad y carpeta<a name="21"><a/>
![](https://blog.sqlauthority.com/wp-content/uploads/2016/06/tempdbmove-800x552.jpg)
#
# 

~~~sql
SELECT 'ALTER DATABASE tempdb MODIFY FILE (NAME = [' + f.name + '],'
    + ' FILENAME = ''Z:\MSSQL\DATA\' + f.name
    + CASE WHEN f.type = 1 THEN '.ldf' ELSE '.mdf' END
    + ''');'
FROM sys.master_files f
WHERE f.database_id = DB_ID(N'tempdb');
~~~
# 
#

### El Resultado de esta consulta seria lo siguiente.
![](https://www.brentozar.com/wp-content/uploads/2017/11/moving-tempdb.png)

###  al ejecutar este resultado en la consola de Mssql server  se modificaran los temporales de  las bases de datos.
# 

----


# Reducción de Archivos TempDB en SQL Server<a name="6a"></a>

## Introducción
Esta documentación proporciona una guía paso a paso para reducir el tamaño de `tempdb` en SQL Server. Incluye comandos SQL y mejores prácticas para garantizar un rendimiento óptimo y evitar problemas de crecimiento inesperado.

![Optimización de TempDB](https://upload.wikimedia.org/wikipedia/commons/thumb/2/2d/SQL_Server_Management_Studio_Logo.png/800px-SQL_Server_Management_Studio_Logo.png)

## Mejores prácticas para administrar `tempdb`

### 1. Configurar el número de archivos de datos
- Ajustar el número de archivos de `tempdb` al número de procesadores lógicos (hasta 8 archivos).
- Si tienes más de ocho procesadores lógicos, comienza con ocho archivos y aumenta en múltiplos de cuatro si hay contención.

### 2. Asignar tamaños iguales a los archivos
Asegúrate de que todos los archivos de `tempdb` dentro del mismo grupo de archivos tengan el mismo tamaño para maximizar la eficiencia de las operaciones en paralelo.

### 3. Configurar tamaño inicial y crecimiento automático
- Define tamaños iniciales y de crecimiento adecuados según la carga esperada.
- Evita incrementos pequeños y frecuentes para no afectar el rendimiento.

### 4. Optimizar la ubicación de los archivos
- Coloca `tempdb` en un subsistema de E/S rápido para evitar cuellos de botella.
- Ubica `tempdb` en un disco separado de las bases de datos de usuario y otras bases del sistema.

## Métodos para reducir `tempdb`

### Usando `ALTER DATABASE`
```sql
USE master;
GO
ALTER DATABASE tempdb
MODIFY FILE (NAME = tempdev, SIZE = 500MB);
ALTER DATABASE tempdb
MODIFY FILE (NAME = templog, SIZE = 250MB);
GO
```

### Usando `DBCC SHRINKDATABASE`
```sql
USE tempdb;
GO
DBCC SHRINKDATABASE (tempdb, 10); -- Reduce `tempdb` al 10% de su tamaño actual
GO
```

### Usando `DBCC SHRINKFILE`
```sql
USE tempdb;
GO
DBCC SHRINKFILE (tempdev, 500); -- Reduce archivo de datos a 500MB
DBCC SHRINKFILE (templog, 250); -- Reduce archivo de registro a 250MB
GO
```

### Usando SQL Server Management Studio (SSMS)
1. Abre **SSMS** y conéctate a tu instancia de SQL Server.
2. Expande **Bases de datos del sistema** y selecciona `tempdb`.
3. Haz clic derecho en `tempdb` y selecciona **Tareas > Reducir > Archivos**.
4. En la ventana emergente, selecciona el archivo a reducir (tempdev o templog).
5. Configura el tamaño deseado y haz clic en **Aceptar**.

## Pasos adicionales para reducir `tempdb`

### Limpiar cachés y realizar checkpoints
```sql
CHECKPOINT;
GO
DBCC DROPCLEANBUFFERS;
GO
DBCC FREEPROCCACHE;
GO
DBCC FREESYSTEMCACHE ('ALL');
GO
DBCC FREESESSIONCACHE;
GO
CHECKPOINT;
GO
```

### Reiniciar SQL Server
Si `tempdb` no se reduce efectivamente, reiniciar el servicio de SQL Server restablecerá su tamaño.

### Modo de usuario único para reducción forzada
```sql
ALTER DATABASE tempdb SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO
DBCC SHRINKFILE (tempdev, 500); -- Ajustar tamaño según necesidad
DBCC SHRINKFILE (templog, 250);
GO
ALTER DATABASE tempdb SET MULTI_USER;
GO
```

## Supervisión y mantenimiento

### Monitorear el crecimiento de `tempdb`
Consulta para verificar los archivos y tamaños de `tempdb`:
```sql
SELECT file_id, name, size * 8 / 1024 AS SizeMB, physical_name 
FROM tempdb.sys.database_files;
```

### Identificar consultas que usan `tempdb`
```sql
SELECT s.session_id, r.start_time, r.status, r.command, r.cpu_time, r.total_elapsed_time
FROM sys.dm_exec_sessions s
JOIN sys.dm_exec_requests r ON s.session_id = r.session_id
WHERE s.is_user_process = 1;
```

### Configurar crecimiento automático
Asegúrate de que los incrementos de crecimiento sean lo suficientemente grandes para evitar expansiones frecuentes y pequeñas.

## Enfoque alternativo: Reducción dinámica de todos los archivos de `tempdb`
Este script reduce todos los archivos de `tempdb` de manera dinámica:
```sql
DECLARE @file_id INT;
DECLARE @file_name NVARCHAR(128);
DECLARE @desired_size INT = 1024; -- Tamaño deseado en MB

CREATE TABLE #TempdbFiles (
    file_id INT,
    name NVARCHAR(128)
);

INSERT INTO #TempdbFiles (file_id, name)
SELECT file_id, name
FROM tempdb.sys.database_files;

WHILE EXISTS (SELECT * FROM #TempdbFiles)
BEGIN
    SELECT TOP 1 @file_id = file_id, @file_name = name
    FROM #TempdbFiles;
    DBCC SHRINKFILE (@file_name, @desired_size);
    DELETE FROM #TempdbFiles WHERE file_id = @file_id;
END

DROP TABLE #TempdbFiles;
```

## Consejo adicional: Configurar tamaño antes de reducir
Antes de hacer un `shrink`, es recomendable configurar el tamaño adecuado:
```sql
USE master;
ALTER DATABASE tempdb
MODIFY FILE (NAME = tempdev, SIZE = 100MB);
GO
```
Después, reducir el archivo:
```sql
USE tempdb;
DBCC SHRINKFILE ('tempdev', 100, TRUNCATEONLY);
GO
```

## Conclusión
Reducir el tamaño de `tempdb` es fundamental para mantener el rendimiento de SQL Server. Aplicar las mejores prácticas, monitorear el crecimiento y ajustar la configuración de forma adecuada ayudará a evitar problemas de almacenamiento y rendimiento.

---
📌 **Autor**: Tu Nombre  
📅 **Última actualización**: Marzo 2025  
🔗 **Repositorio GitHub**: [Tu Enlace de Repositorio]



# 


# La conexión de administración dedicada: por qué la quiere, cuándo la necesita y cómo saber quién la está usando <a name="7"></a>
![](https://www.acens.com/comunicacion/wp-content/images/2015/12/conexion-escritorio-remoto-white-paper-acens-12.jpg)

# CAD? ¿Qué es eso?
- Primero, un poco de desambiguación. El acrónimo 'DAC' es demasiado popular.

- Para el contexto de este artículo, nuestra DAC es la 'Conexión de administración dedicada'.

- SQL Server también implementa una DAC totalmente no relacionada: una aplicación de nivel de datos o un paquete DAC. No estamos hablando de eso aquí.

## ¿Qué puede hacer DAC por usted?
#### ¿Tiene un servidor SQL que está en crisis? El DAC puede ayudarlo a organizar una intervención.

#### La conexión de administración dedicada se creó para ayudarlo a conectarse y ejecutar consultas básicas de resolución de problemas en casos de problemas graves de rendimiento. Esta es su oportunidad para obtener una tarjeta de "Salir de la cárcel", pero como no la usa regularmente, es fácil olvidar cómo usarla. También es fácil olvidar habilitar el acceso al DAC de forma remota.

## Cómo funciona la conexión de administración dedicada
#### El DAC utiliza un programador reservado especial que tiene un hilo para procesar solicitudes. Básicamente, esto significa que SQL Server mantiene una puerta trasera abierta a los recursos del procesador disponibles solo para usted.

#### No caigas en la tentación de abusar de este privilegio. Ese hilo es solo un hilo: no hay paralelismo para las consultas que se ejecutan en el DAC. El dos por ciento de ustedes tendrá la tentación de usar esto para sus trabajos de mantenimiento en sistemas ocupados. En serio, simplemente no vayas allí. El DAC no fue diseñado para un alto rendimiento.

## Cómo habilitar el DAC para conexiones remotas y clústeres
#### De manera predeterminada, la DAC solo está habilitada para las cuentas registradas en la máquina local. Para servidores de producción, eso significa que solo funciona para sesiones de escritorio remoto en instancias de SQL Server no agrupadas. Si su instancia está agrupada o si se conecta a través de TCP/IP, no tendrá suerte a menos que cambie una configuración. Esa configuración es 'Conexiones de administración remota'.

# 

#### ***"Si SQL Server no responde y la escucha de DAC no está habilitada, es posible que deba reiniciar SQL Server para conectarse con DAC."***

#### ¡Para agrupaciones, inscríbeme! Estoy a favor de habilitarlo para otras instancias también. En tiempos de problemas, desea minimizar la cantidad de tiempo que pasa usando el escritorio remoto en un servidor que tiene problemas. Desea usar eso solo para recopilar información que no puede obtener de otra manera.

#### Habilitar el DAC para conexiones remotas es muy fácil. Está controlado por la configuración de 'Conexiones de administración remota'. Para habilitarlo, simplemente ejecute este fragmento de código:
#
#### Habilitar el DAC
~~~sql
 EXEC sp_configure 'remote admin connections', 1;
 GO
 RECONFIGURE
 GO
~~~

#### Siempre hay una trampa. Es posible que también deba abrir los puertos del firewall, según su entorno y desde dónde desee conectarse. Probablemente será el puerto 1434, pero variará según su configuración. (Books Online lo respalda: lea más en la sección "Puerto DAC" aquí).

## Solo un administrador del sistema puede montar este caballo a la vez
#### Esta no es una línea compartida, solo un administrador de sistemas a la vez puede usar el DAC. Además, solo debe ejecutar consultas simples y rápidas utilizando el DAC.


#### En otras palabras, solo conéctese al DAC cuando realmente lo necesite. Cuando haya terminado, **limpie el asiento**, asegúrese de desconectarlo.

## Cómo conectarse al DAC
#### Puede conectarse al DAC usando la línea de comando. Utilice la opción "-A" con SQLCMD.exe.

#### Me resulta más conveniente conectarme en Management Studio. Para ello, coloque el prefijo "Admin:" en el nombre de la instancia a la que se está conectando.

#### Un FYI: Object Explorer no puede conectarse al DAC. Si abre SSMS y tiene el Explorador de objetos conectado de forma predeterminada, el primer aviso de conexión que verá será para eso. Si intenta decirle que se conecte al DAC, fallará. Eso es algo bueno, no queremos que el poder se le suba a la cabeza al Explorador de objetos.

## ¿Quién ha estado durmiendo en mi DAC? Cómo saber quién está usando la conexión de administración dedicada.
#### Si intenta conectarse al DAC cuando alguien ya está conectado, verá un error de conexión. Probablemente no le dirá directamente que alguien ya está conectado al DAC, pero si revisa el registro de errores de SQL Server, debería ver el mensaje:

#### ***No se pudo conectar porque ya existe el número máximo de conexiones de administrador dedicadas '1'. Antes de que se pueda realizar una nueva conexión, se debe eliminar la conexión de administrador dedicada existente, ya sea cerrando la sesión o finalizando el proceso.***

# 


~~~sql
SELECT
CASE
WHEN ses.session_id= @@SPID THEN 'It''s me! '
ELSE '' END 
+ coalesce(ses.login_name,'???') as WhosGotTheDAC,
ses.session_id,
ses.login_time,
ses.status,
ses.original_login_name
from sys.endpoints as en
join sys.dm_exec_sessions ses on
en.endpoint_id=ses.endpoint_id
where en.name='Dedicated Admin Connection'
~~~



#




<!-- ========================== -->



<!-- insertar publicacion de mover Tempdb  -->

# Cómo mover TempDB a otra unidad y carpeta<a name="2_1"><a/>
![](https://blog.sqlauthority.com/wp-content/uploads/2016/06/tempdbmove-800x552.jpg)
#
# 

~~~sql
SELECT 'ALTER DATABASE tempdb MODIFY FILE (NAME = [' + f.name + '],'
    + ' FILENAME = ''Z:\MSSQL\DATA\' + f.name
    + CASE WHEN f.type = 1 THEN '.ldf' ELSE '.mdf' END
    + ''');'
FROM sys.master_files f
WHERE f.database_id = DB_ID(N'tempdb');
~~~
# 
#

### El Resultado de esta consulta seria lo siguiente.
![](https://www.brentozar.com/wp-content/uploads/2017/11/moving-tempdb.png)

###  al ejecutar este resultado en la consola de Mssql server  se modificaran los temporales de  las bases de datos.
# 


## Consultas y Soluciones para Bases de Datos en SQL Server DB recovery Pending<a name="2_recovery1"><a/>

<img src="https://stevestedman.com/wp-content/uploads/SQL14RecoveryPending.png?format=png&name=large" alt="JuveR" width="800px">

#



#### Este documento proporciona dos consultas comunes y soluciones para problemas relacionados con bases de datos en Microsoft SQL Server. Las consultas abordan el estado de "recovery pending" de una base de datos y cómo solucionarlo.

## Consulta 1: Verificar Bases de Datos en Estado "Recovery Pending"
#### Esta consulta se utiliza para verificar las bases de datos en estado "recovery pending". Esto puede ser útil para identificar bases de datos que necesitan atención debido a problemas de recuperación.

~~~sql
Copy code
SELECT name, state_desc 
FROM sys.databases 
WHERE state_desc = 'RECOVERY_PENDING';
~~~

#### sys.databases: Es una vista del sistema que contiene una fila por cada base de datos en el servidor.
#### name: Nombre de la base de datos.
#### state_desc: Descripción del estado actual de la base de datos.
#### RECOVERY_PENDING: Estado que indica que la base de datos está en proceso de recuperación, pero aún no se ha completado.


## Consulta 2: Solucionar Problema de "Recovery Pending"
#### Esta consulta proporciona una solución para el problema de "recovery pending" en una base de datos de SQL Server. Ayuda a reparar la base de datos y resolver el estado de recuperación pendiente.

~~~sql

USE master;
GO

ALTER DATABASE [NombreDeTuBaseDeDatos] SET RESTRICTED_USER; -- Solo sysadmin puede conectarse
GO

ALTER DATABASE [NombreDeTuBaseDeDatos] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO

DBCC CHECKDB ([NombreDeTuBaseDeDatos], REPAIR_ALLOW_DATA_LOSS) WITH NO_INFOMSGS;
GO

ALTER DATABASE [NombreDeTuBaseDeDatos] SET MULTI_USER;
GO
~~~

#### USE master;: Cambia al contexto de la base de datos master, donde se ejecutan las declaraciones de administración del servidor.
#### SET SINGLE_USER WITH ROLLBACK IMMEDIATE;: Establece la base de datos en modo de usuario único y realiza un rollback inmediato para desbloquear la base de datos.
#### DBCC CHECKDB ([NombreDeTuBaseDeDatos], REPAIR_ALLOW_DATA_LOSS) WITH NO_INFOMSGS;: Ejecuta la verificación de integridad de la base de datos con opción de reparación permitiendo pérdida de datos.
#### SET MULTI_USER;: Restaura la base de datos al modo de usuario múltiple para permitir el acceso a múltiples usuarios.

Búsqueda Rápida
1: Verificar Bases de Datos en Estado "Recovery Pending"
 2: Solucionar Problema de "Recovery Pending"









<!-- ================================================ -->

# MEJORES PRÁCTICAS EN TEMPDB DE SQL SERVER
![](https://reader016.staticloud.net/reader016/html5/20190612/55957c4d1a28ab6f5f8b4751/bg1.png)

## Primero, ¿por qué es tan importante?
#### La tempdb es un recurso global dentro de nuestra instancia. Todas las conexiones pueden utilizarla.

#### Imagínate una conexión que necesite de ella y la base no esté disponible. Sería un desastre, considerando su naturaleza.

## ¿Pero qué contiene?
#### Puede almacenar diferentes objetos o ser un soporte a diferentes procesos. Almacena tablas o procedimientos temporales, resultados temporales de funciones o cursores como también soporta a procesos internos como spools, sorts, group by, order by, union o también ayuda en procesos de ordenamientos de índices cuando se especifica el valor SORT_IN_TEMPDB en su creación o reconstrucción.

#### Básicamente podríamos decir que la tempdb está presente en todo lo que podemos hacer en nuestra instancia. Vamos entendiendo su criticidad, ¿verdad?

## Ahora bien, los factores que pueden costarnos caro. ¡Evítalos!
## 1 Tempdb compartiendo disco lógico
#### Si tienes la base de datos tempdb en una unidad de disco junto con otras bases de datos de sistema o de usuario, nunca podrás tener un seguimiento aislado del performance o de su demanda en espacio físico.

#### Por otro lado, harás más difícil el monitoreo y mantenimiento pues ya no podrás controlar el crecimiento individual mirando solo la unidad del disco.

## 2 Autocrecimiento por defecto
#### Dependiendo de la versión que tengas de SQL Server o si cambiaste las configuraciones por defecto en la instalación, el valor del crecimiento automático puede variar.

#### El problema surje cuando el valor es muy pequeño y empezamos a sentir contención por la necesidad de expansión de la base de datos. Imagina que el crecimiento se da de 1 MB en 1 MB y necesitamos crecer 1 GB…necesitamos “hacer ese crecimiento” 1000 veces. No es lo mismo que crecer dos veces en un ritmo de 500 MB en 500 MB. Mientras más pequeña la tasa, más esfuerzo en escritura en disco.

## 3 1 solo archivo de datos
#### Las bases de datos tienen archivos físicos de datos (mdf, ndf) y de log (ldf). Por defecto cada base tiene un archivo de data y uno de log.

#### Se ha visto que existen escenarios de lentitud de servidores en los que se genera una contención particular en la base de datos tempdb. Usualmente esta se ve como tiempos de espera PAGELATCH_UP y pueden ser referencias a páginas del formato 2:1:1, 2:1:3 (PFS, SGAM). Esta contención se puede liberar fácilmente cuando se piensa en Dividir Archivos de data en tempdb.

## 4 Algunos otros
#### Tener collation diferentes entre la base de datos tempdb, la instancia de SQL Server y/o otras bases de usuario. Nos puede llevar a generar errores de collate en JOINS.

#### Crecimiento disparejo en archivos de datos. Puede restar optimización en la distribución de páginas hacia los archivos.

#### No monitorear la base de datos tempdb. Fácilmente puede llevarnos a perder el acceso a la instancia a través de errores por falta de espacio en esta base. Ya te pasó, ¿verdad? Ya recordaste las letras rojas diciendo “The transaction log for database tempdb is full”.

#### (Muy típico y usual) Pensar que su espacio es infinito. Muchas prácticas en desarrollo o administración de SQL Server malinterpretan el uso de la base tempdb como “espacio temporal”, esto no es un espacio ilimitado o que “solo está en memoria” como a veces se piensa. Mientras utilices tablas temporales en una conexión abierta, con esta ejecución puedes ver un reporte de tamaños de objetos temporales.

#### Ya lo sabes, no es un espacio infinito. Cuidado con las operaciones de DBCC CHECKDB, INDEX REBUILD con SORT_IN_TEMPDB, cursores o consultas gigantescas con ORDER BY en campos sin índices. Siempre monitorea tus mejores prácticas en tempdb.
 # 

 # Cerrar Conexiones de un Usuario en SQL Server<a name="1.9"></a>

**Propiedad de:** JOSE ALEJANDRO JIMENEZ ROSA  
**Fecha:** 19 de noviembre de 2024  
**Autor:** Alejandro Jimenez Rosa  

---

## 📘 Descripción

Este script T-SQL permite cerrar todas las conexiones activas de un usuario específico en SQL Server. Utiliza la vista de administración dinámica `sys.dm_exec_sessions` para identificar las sesiones activas y genera comandos `KILL` para cada una de ellas.

---

## 💻 Código SQL

```sql
DECLARE @username NVARCHAR(50) = 'nombre_del_usuario';
DECLARE @sql NVARCHAR(MAX) = N'';

SELECT @sql += N'KILL ' + CAST(session_id AS NVARCHAR(5)) + N';'
FROM sys.dm_exec_sessions
WHERE login_name = @username;

EXEC sp_executesql @sql;
```

## 🛠️ Instrucciones
### Definir el Usuario:
#### Reemplaza 'nombre_del_usuario' con el nombre del usuario cuyas conexiones deseas cerrar.

#### Generar Comandos KILL:
#### La consulta selecciona todas las sesiones activas del usuario especificado y genera comandos KILL para cada sesión.

####  Ejecutar el Script:
#### Ejecuta el script en tu entorno de SQL Server Management Studio (SSMS) para cerrar todas las conexiones activas del usuario.

## ⚠️ Notas
#### Asegúrate de tener los permisos necesarios para ejecutar comandos KILL en el servidor SQL.

#### Utiliza este script con precaución, ya que cerrará todas las conexiones activas del usuario especificado, lo que puede interrumpir procesos en curso.

#### Este procedimiento es útil en tareas de mantenimiento, despliegues o solución de bloqueos causados por sesiones activas.

## ✅ Uso Típico
#### Este script es útil en escenarios donde necesitas liberar recursos rápidamente o realizar tareas administrativas que requieren que el usuario esté desconectado del servidor.




# 

# 
# Conexiones Activas del Servidor de SQL SERVER<a name="4"></a>
![](https://www.deskshare.com/lang/sp/help/fml/Active1.gif)
# A veces es necesario conocer las conexiones activas en una instancia de Microsoft SQL Server.


#### Para obtener esta información yo suelo usar la siguiente consulta SQL que devuelve el servidor,
 #### la base de datos, el usuario, el número de conexiones y la marca temporal de cuando se ejecuto la consulta.
#

~~~sql
/*
 Alejandro Jimenez 
 2019-08-01
*/
SELECT @@ServerName AS server,
  NAME AS dbname,
  LOGINAME AS LoginName,
  COUNT(STATUS) AS number_of_connections,
  GETDATE() AS timestamp
FROM sys.databases sd
LEFT JOIN sys.sysprocesses sp ON sd.database_id = sp.dbid
WHERE database_id NOT BETWEEN 1 AND 4
AND LOGINAME IS NOT NULL
GROUP BY NAME,LOGINAME;
~~~
# 
#

