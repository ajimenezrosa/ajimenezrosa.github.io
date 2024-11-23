# Guía de Administración de Bases de Datos MICROSOFT SQL SERVER

## Alejandro Jimenez Rosa


<table>
<thead>
<tr>
  <th>
Manuales de</th>
  <th> 	Bases de Datos MICROSOFT SQL SERVER -- AJ</th>
</tr>
</thead>
<tbody><tr>

<tr>
  <td><img src="https://avatars2.githubusercontent.com/u/7384546?s=460&v=4?format=jpg&name=large" alt="JuveR" width="400px" ></td>
  <td><img src="https://billeteranews.com/wp-content/uploads/2021/12/banco-popular-dominicano-office.jpg?format=jpg&name=large" alt="JuveR" width="400px" height="400px"></td>
</tr>
<!-- <tr>
  <td>Siempre</td>
  <td><img src="https://avatars2.githubusercontent.com/u/7384546?s=460&v=4?format=jpg&name=large" alt="JuveR" width="400px"></td>
</tr> -->


</tbody>
</table>

# 
### SQL Server: Compendio de Consultas Administrativas y Mantenimiento

---

#### **1. Administración**
- 1.1 [Conectar una unidad de red a un servidor SQL Server](#1)  
- 1.2 [Crecimiento automático de los ficheros de la base de datos](#2)  
    - 1.2.1 [Cómo mover TempDB a otra unidad y carpeta](#21)  
    - 1.2.2 [Consultas y soluciones para bases de datos en SQL Server DB recovery Pending](#2_recovery1)  
- 1.3 [Eliminar correos del servidor de correos SQL Server](#3)  
    - 1.3.1 [Comprobar `sysmail_event_log` vista](#3.1)  
    - 1.3.2 [Comprobación del elemento de correo con error específico](#3.2)  
    - 1.3.3 [Sysmail_faileditems](#3.3)  
    - 1.3.4 [Sysmail_sentitems](#3.4)  
    - 1.3.5 [Comprobación de la configuración de correo electrónico de base de datos para el servidor SMTP](#3.5)  
    - 1.3.6 [Ver log de envío de correos `sql mail`](#3.6)  
    - 1.3.7 [Ver log de envío de correos fallidos, FAILED MESSAGES LOG](#3.7)  
    - 1.3.8 [ALL MESSAGES – REGARDLESS OF STATUS](#3.8)  
- 1.4 [Conexiones activas del servidor de SQL Server](#4)  
- 1.5 [DBCC CHECKDB](#5)  
- 1.6 [Reducir tamaño de `Tempdb`](#6)  
- 1.7 [Conexión de administración dedicada: cuándo y cómo usarla](#7)  

---

#### **2. Memoria y Caché de SQL Server**
- 2.1 [Una vista dentro de la caché del búfer de SQL Server](#8)  
    - 2.1.1 [Vista general del uso de la memoria en SQL Server](#8-1)  
    - 2.1.2 [Métrica del uso de la caché del búfer por la base de datos](#metricausocachequery)  
    - 2.1.3 [Totales de páginas y conteo de bytes](#totalespaginasconteo)  
    - 2.1.4 [Porcentaje de cada tabla en memoria](#percentajecadapagina)  
    - 2.1.5 [Número de páginas y tamaño de datos en MB](#numerodepaginas)  
    - 2.1.6 [DBCC DROPCLEANBUFFERS](#dbccdropcleanbuffers)  
    - 2.1.7 [Expectativa de vida de las páginas](#expectativadevidadelaspaginas)  
    - 2.1.8 [¿Qué hay en la caché del búfer?](#quehayenlacachedelbufer)  

---

#### **3. Mantenimiento de Índices**
- 3.1 [Información general de mantenimiento de índices en SQL Server](#inf_mant_indices)  
    - 3.1.1 [Localizar tablas sin `Clustered Index`](#tablasinclusterindex)  
    - 3.1.2 [Detección de índices no utilizados – Parte 1](#indicesnoutilizados)  
    - 3.1.3 [Tablas de montón](#tablasmonton)  
    - 3.1.4 [Detección de índices no utilizados – Parte 2](#indicesnoutilizados2)  
    - 3.1.5 [Posibles índices NC incorrectos](#escrituraslecturas)  
    - 3.1.6 [Identificación de índices duplicados](#indicesduplicados)  
    - 3.1.7 [Conceptos básicos del diseño de índices](#disenoindices)  
    - 3.1.8 [Tareas y consideraciones del diseño de índices](#tareadisind)  
    - 3.1.9 [Eliminar y recrear índices de forma ONLINE=ON](#6.8)  
    - 3.1.10 [Listado de los índices en una base de datos](#6.9)  
    - 3.1.11 [Missing Index Script](#missinindex)  
    - 3.1.12 [Procedimiento `MeasureIndexImprovement`](#MeasureIndexImprovement)  
    - 3.1.13 [Evaluación de Índices en SQL Server](3113)
---

#### **4. Recuperación y Backup**
- 4.1 [Cuánta data puedo perder](#dataperder)  
- 4.2 [Query de los tamaños de los backups de base de datos](#querybackup)  
    - 4.2.1 [Envío por correo electrónico del tamaño de los backups](#querybackup2)  
- 4.3 [Últimos backups realizados en un servidor de bases de datos](#ultimobackup)  
- 4.4 [Query que muestra los últimos restores realizados en un servidor](#queryrestoresql)  
- 4.5 [Limpiar y reducir el log de transacciones SQL Server](#limpiarlog)  
- 4.6 [Seguimiento en tiempo real de operaciones de backup y restore](#tiemporestore)  
- 4.7 [Monitoreo de operaciones de backup y restore](#tiempobkrestore)  
- 4.8 [Fecha de última restauración de un backup](#ultimarestauracion)  
- 4.9 [Scripts para restaurar DB/s en diferentes tipos de ambientes](#46)  

---

#### **5. Performance**
* 5.1 [Performance de la base de datos](#performance)  
* 5.2 [Consultar última fecha de acceso de login en MS SQL Server](#consultaulfechaacceso)  
* 5.3 [Identificar latencia de disco en SQL Server](#disklatency)  
* 5.4 [Uso de memoria de SQL Server por base de datos y objeto](#disklatency2)  
* 5.5 [Listar todos los procedimientos almacenados de una base de datos](#procalmacenados)  
    - 5.5.1 [Buscar las consultas TOP N](#buscarconsultatop)  
    - 5.5.2 [Espacios en disco ocupados por base de datos](#espacioendiscodb)  
    - 5.5.3 [Vía 2: Rendimiento de las consultas](#rendimientoconsultas2)  
    - 5.5.4 [Top 10 procedimientos almacenados con mayor tiempo transcurrido](#10procmayortiemeje)  
    - 5.5.5 [Consultas SQL más ejecutadas](#lasconsultassqlmasejecutadas)  
    - 5.5.6 [Consultas SQL con mayor consumo de CPU](#consultassqlmayorconsumodecpu)  

---

#### **6. Auditoría y Seguridad**
- 6.1 [Detener un proceso de auditoría en SQL Server](#13)  
- 6.2 [Cambiar el Collation en una instancia de SQL Server](#cambiarcollattionsql)  
- 6.3 [Cambio del esquema de una tabla por query](#cambiarsquemad)  
- 6.4 [Lista de permisos por usuario](#listausuariosdb)  
- 6.5 [Número de sesiones por usuario en SQL Server](#numeroseccionessqlserver)  
* 6.6 [Objetos modificados en los últimos 10 días](#objectosmodificadosultimosdias)  
 - 6.7 [Listado de transacciones bloqueadas en un servidor DB](#bloqueos2)  
 - 6.8 [Verificar logs de errores del SQL Server](#errorlogsql)  
 - 6.9 [Cerrar todas las conexiones a una base de datos](#cerrarconexionessql)  
 - 6.10 [Documentación de SQL Scripts para backup y restore con TDE](#tde1)  
 -  6.11 [Cómo saber si una base de datos tiene TDE](#49)  
 - 6.12 [Script de Microsoft para detectar problemas SDP](#45sdp)  

# 
 - 602 [Consulta de Estadísticas de Ejecución de Queries en SQL Server con Detalles de Rendimiento y Uso de Recursos](#602)
 - 603 [Cómo Localizar y Revisar Archivos de Auditoría (.sqlaudit) en SQL Server](#603)
 - 604 [Auto-fix para Usuarios Huérfanos en SQL Server](#604)
 - 605 [Clonación de Permisos y Roles de un Usuario en SQL Server ](#605)

# 

#### **7. Consultas Especiales**
* 7.1 [Tablas que contienen un nombre de campo específico](#buscarnombrecampo)  
* 7.2 [Listar todos los objetos de una base de datos](#14.3)  
* 7.3 [Query de la última vez que se ejecutó un procedimiento](#ultejecproc1)  
* 7.4 [Última vez que se usó una tabla](#ultejecproc3)  
* 7.5 [Última vez que se utilizó un índice](#ultejecproc2)  
* 7.6 [Cuánto ocupan mis tablas](#cuantoocupantablas)  
* 7.7 [Defragmentación](#desfragmentacionalrescate)  
* 7.8 [Detectar actividad del servidor](#dectectandoactenservidor)  
    - 7.8.1 [Información sobre sesiones en tiempo real](#20.1)  
* 7.9 [Cuántos cores tiene mi base de datos](#cuantoscoretengo)  
* 7.10 [Query de listado de tablas con su tamaño y cantidad de registros](#listadotablas)  

---

#### **8. Sistemas Integrados: Genesis y Soluflex**

- 8.1 [Sistema Genesis](#sistemaponchesgenesis)  
    - 8.1.1 [Ejecutar procedimiento que actualiza las tablas con los datos de ponches para reportes de RRHH](#genesiscargadatosreloj1)  
    - 8.1.2 [Cargar datos reloj](#genesiscargadatosreloj)  
    - 8.1.3 [Horas de almuerzo](#genesishorasdealmuerzo)  
    - 8.1.4 [Personas que deben ponchar y no ponchan con envío a supervisores](#genesispersonasdebenponcharynoponc)  
    - 8.1.5 [Insertar datos reloj a Soluflex](#queryinsertardatossoluflex25)  
    - 8.1.6 [Verificación de salida INABIMA](#geneissalidasinabiama)  
    - 8.1.7 [Ejecutar procedimiento de carga de datos a Soluflex](#procedurecargadatossoluflex)  
    - 8.1.8 [Jobs deshabilitados utilizados por Soluflex](#soluflexjobdisable)  
    - 8.1.9 [Sincronización de empleados de Soluflex con el reloj](#procedurecargadatossoluflex)  
- 8.2 [Sincronizar datos de la tabla TA_ponchesreloj con SQL Server](#ta_ponchesrelojjob)  

---

#### **9. Notificaciones de SQL Mail**
- 9.1 [Reporte de variación de espacio en disco K:\](#reporteespacioendiscok)  
- 9.2 [Notificar cambios en el padrón electoral](#notificarcambios2)  
- 9.3 [Consulta para enviar por correo de e-Flow citas](#consultaseflowcitas)  
- 9.4 [Remisión de encuesta de satisfacción de servicios de mensajería](#encuestamensajeria)  
- 9.5 [Reporte de registros modificados en las tablas de afiliados del INABIMA](#repafiliadosinabima)  

 ---

#### **10. Central Telefónica**
- 10.1 [Cargar registros de llamadas de la central telefónica](#registrosdellamadas)  

---

#### **11. Interacción con el Dominio de Windows**
- 11.1 [Conectar a un dominio de Windows y leer información](#leerdominio)  

---

#### **12. BPD: Administración de Jobs**
- 12.1 [Listar jobs de SQL Server](#listajob28)  
- 12.2 [Jobs con sus días de ejecución por steps](#listajob282)  
    - 12.2.1 [Jobs del sistema SQL Server, con nombre y base de datos](#28.2.1)  
    - 12.2.2 [Jobs del sistema SQL Server para control M](#28.2.2)  
- 12.3 [Jobs ejecutándose en un servidor SQL Server](#jobactivos2)  
- 12.4 [Configurar max worker threads](#autogrowmaxime)  
- 12.5 [Query para saber el Max/memory de un servidor SQL](#querymamemory)  
- 12.6 [Shrink DB](#shrinkfilebpd)  
- 12.7 [Ver espacio libre en archivos MDF y LDF](#espaciodbLibres)  
- 12.8 [Espacio en discos que ocupan mis tablas](#espacidiscobpd)  
- 12.9 [Migrar jobs de un servidor SQL Server a otro](#migrarjobs)  
- 13 -- [Cambiar Owner de Múltiples Jobs en SQL Server](#13.00)
- 14  [Solución de Problemas con Jobs en SQL Server que No Se Dejan Eliminar](#14.1)
- 14.1 [___Consulta de subplanes asociados a un Job](#14.1)
- 14.2. [___Eliminación de subplanes asociados a un Job](#14.2)
- 14.3. [___Comando para eliminar un job específico](#14.3)
- 14.4. [___Eliminación de registros en el log de mantenimiento](#14.4)
- 14.5. [___Verificación de logs de mantenimiento](#14.5)
---

#### **13. AlwaysOn y Replicación**
- 13.1 [Determinar si un nodo es primario o secundario en un AlwaysOn](#queestestenodoAO)  
- 13.2 [Verificar si un servidor SQL Server AlwaysOn hizo failover](#failover)  
    - 13.2.1 [Información detallada sobre failover de servidores](#failover2)  
- 13.3 [Cambiar el "collation" de todas las bases de datos en un servidor SQL Server](#collectionchange)  
- 13.4 [Verificar si SQL Server Replication está instalado en SQL Server 2019](#saberreplicationserver)  

- 13.5 [ALTER DATABASE ... SET HADR RESUME](#135)
---

#### **14. Scripts de Monitoreo y Optimización**
* 14.1 [Script de monitoreo y optimización del rendimiento de SQL Server](#500)  
* 14.2 [Captura de logs en grupos de disponibilidad Always On](#501)  

---

#### **15. Auditoría y Verificación de Ambientes**
- 15.1 [Query de extracción de bases de datos y tablas en SQL Server](#600)  
- 15.2 [Documentación para la Solucionar problemas   de bases de datos ABT `fuera de linea problemas de permisos` ](#601)  





---

#### **16. Soluciones para GCS-SYSTEMS**
- 16.1 [Eliminar número enganchado en Dakota/Café GCS-SYSTEMS](#700)  

---
 - 16.2. [Documentación de Inserción de Usuarios en SQL Server para GCS SII_OMGGA_GCS](#1601)
    - [Requerimientos](#1602)
    - [Scripts](#1603)
    - [Insertar usando Variables](#1631)
    - [Insertar usando `INSERT ... SELECT` con Usuario Modelo](#1632)
    - [Instrucciones de Uso](#1604)

---

## Configuraciones Post-Instalación de SQL Server

- 17.1 [Actualizar Políticas de Crecimiento y Tamaños de las Bases de Datos del Sistema](#17.1)
- 17.2  [Adicionar Nuevos Archivos de TempDB](#17.1)
    - [Paso 1: Validar Archivos](#17.21)
    - [Paso 2: Crear Nuevos Archivos para TempDB (4 Cores)](#17.22)
    - [Paso 3: Crear Nuevos Archivos para TempDB (8, 12, y 16 Cores)](#17.23)
    - [Paso 4: Modificar Nombres y Tamaños de Archivos](#17.24)
- 17.3 [Cálculo del MAXDOP](#17.3)
- 17.4 [Ajustar Valores de Parámetros de Configuración de la Instancia](#17.4)
- 17.5 [Actualizar Valor del Parámetro Server Name](#17.5)
- 17.6 [Crear Bases de Datos Administrativas STOS_ADMIN y STOS_PTO](#17.6)
- 17.7 [Licencia](#17.7)



---


#
<!-- ConsultasEflowCitas -->

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


# Tempdb: Reducir Tamaño <a name="6"></a>

#### La base de datos “Tempdb” es una base de datos de sistema la cual se utiliza para almacenar diversos objetos temporales, entre los mas conocidos estan las tablas temporales creadas explicitamente (#temptable), tambien tablas de trabajo generadas por los planes de ejecución para almacenar resultados intermedios, cursores materializados estaticos, y registros versionados cuando usamos alguno de los niveles de aislamiento de tipo

## En este caso hay diversos metodos por los cuales reducirla:

#### ***Método 1:*** El más confiable de todos, pero requiere reiniciar el servicio de SQL Server. Cuando se reinicia el servicio de SQL Server la tempdb se recrea desde cero y sus archivos vuelven al tamaño original en el que fueron configurados por última vez.

#### ***Método 2:*** En el caso que no se tenga alguna ventana para el reinicio, entonces se puede utilizar este método el cual no requiere reiniciar el servicio de SQL Server, pero si algunos recursos del servidor para poder completarlo. Los pasos para este método son los siguientes:


 - Verificar cuanto espacio disponible hay en la base de datos tempdb.
~~~sql
use tempdb;
exec sp_spaceused
~~~
![](https://dbamemories.files.wordpress.com/2017/01/sp_spaceused_tempdb.png)

 - Hacer “shrink” a la base de datos basado en ese espacio disponible. En este   caso estoy reduciendo el archivo a un 10% de su tamaño actual

#### ***Método 3:*** Este método tampoco require reinicio del servicio de SQL Server y se utiliza cuando el anterior no produce el efecto deseado y es que hay ocaciones en las que no se puede reducir el tamaño de la tempdb debido a que aun contiene objetos activos tales como tablas de trabajo u otras estructuras temporales, entonces cuando tenemos este caso debemos hacer una serie de limpiezas en el motor antes de intentarlo. Es importante mencionar que esto deberia ser el ultimo recurso y pensarlo dos veces antes de ejecutarlo en producción ya que limpiara muchas cosas que el motor debera volver a calcular.

 - Realizar la limpieza de varios cache y un checkpoint




~~~sql
USE tempdb
GO
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
~~~
# 




#### La siguiente acción no es necesariamente obligatoria, pero hay ocaciones en las que me ha servido, y es configurar el archivo de datos de la tempdb al tamaño deseado antes de darle el shrink. Para esto se debe ejecutar el siguiente comando ejemplo en el cual la estoy configurando a 100 MB:
# 

~~~sql
use master
ALTER DATABASE tempdb
MODIFY FILE
(name=tempdev
,size=100M)
~~~
# 
# 
#### Finalmente reducir el tamaño del archivo de datos de la tempdb, en este caso lo reduzco a 100 MB
# 
# 

~~~sql
use tempdb
dbcc shrinkfile ('tempdev',100,TRUNCATEONLY)
~~~
# 
# 

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


<!-- Final de Insertar Publicacion de Mover Tempdb -->
















#  Eliminar corroes del servidor de correos Sql Server<a name="3"><a/>
![](https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTOkenEQH0-zNGFyFke0vcGbu3LqRt9jfDtAA&usqp=CAU)
## Observaciones
#### Correo electrónico de base de datos mensajes y sus datos adjuntos se almacenan en la base de datos msdb . Los mensajes deben eliminarse periódicamente para evitar que msdb crezca más de lo esperado y cumplir con el programa de retención de documentos de las organizaciones. Utilice el sysmail_delete_mailitems_sp procedimiento almacenado para eliminar de forma permanente los mensajes de correo electrónico de las tablas de correo electrónico de base de datos. Un argumento opcional permite eliminar solo los mensajes de correo electrónico antiguos indicando la fecha y la hora. Se eliminarán los mensajes de correo electrónico anteriores al valor de ese argumento. Otro argumento opcional permite eliminar solo los mensajes de correo electrónico de un tipo determinado, especificado como el argumento sent_status . Debe proporcionar un argumento para ** @ sent_before** o ** @ sent_status**. Para eliminar todos los mensajes, utilice ** @ sent_before = getDate ()**.
#### Si se eliminan mensajes de correo electrónico, se eliminarán también los archivos adjuntos relacionados con los mismos. Al eliminar el correo electrónico, no se eliminan las entradas correspondientes en sysmail_event_log. Use sysmail_delete_log_sp para eliminar elementos del registro.
## Permisos
#### De forma predeterminada, este procedimiento almacenado se concede para la ejecución a los miembros del rol fijo de servidor sysadmin y de DatabaseMailUserRole. Los miembros del rol fijo de servidor sysadmin pueden ejecutar este procedimiento para eliminar los mensajes de correo electrónico enviados por todos los usuarios. Los miembros de DatabaseMailUserRole solo pueden eliminar los mensajes de correo electrónico enviados por ese usuario.
# Ejemplos
# 
#

~~~sql
DECLARE @GETDATE datetime  
SET @GETDATE = GETDATE();  
EXECUTE msdb.dbo.sysmail_delete_mailitems_sp @sent_before = @GETDATE;  
GO  


USE msdb ;  
GO  
  
EXECUTE dbo.sysmail_start_sp ;  
GO
~~~
# 
## Comprobar sysmail_event_log vista<a name="3.1"></a>
#### Esta vista del sistema es el punto de partida para solucionar todos los problemas de Correo electrónico de base de datos.

#### Al solucionar problemas Correo electrónico de base de datos, busque en la sysmail_event_log vista eventos relacionados con errores de correo electrónico. Algunos mensajes (como el error del Correo electrónico de base de datos programa externo) no están asociados a correos electrónicos específicos.

#### Sysmail_event_logcontiene una fila para cada mensaje de Windows o SQL Server devuelto por el sistema Correo electrónico de base de datos. En SQL Server Management Studio (SSMS), seleccione Administración, haga clic con el botón derecho en Correo electrónico de base de datos y seleccione Ver Correo electrónico de base de datos registro para comprobar la Correo electrónico de base de datos registro de la siguiente manera:

    Ejecute la consulta siguiente en sysmail_event_log:
 ~~~sql
SELECT er.log_id AS [LogID],
  er.event_type AS [EventType],
  er.log_date AS [LogDate],
  er.description AS [Description],
  er.process_id AS [ProcessID],
  er.mailitem_id AS [MailItemID],
  er.account_id AS [AccountID],
  er.last_mod_date AS [LastModifiedDate],
  er.last_mod_user AS [LastModifiedUser]
FROM msdb.dbo.sysmail_event_log er
ORDER BY [LogDate] DESC
 ~~~   

## Comprobación del elemento de correo con error específico<a name="3.2"></a>

#### Para buscar errores relacionados con correos electrónicos específicos, busque el mailitem_id del correo electrónico con errores en la sysmail_faileditems vista y, a continuación, busque los mensajes relacionados con mailitem_id en sysmail_event_log.

~~~sql
SELECT er.log_id AS [LogID], 
    er.event_type AS [EventType], 
    er.log_date AS [LogDate], 
    er.description AS [Description], 
    er.process_id AS [ProcessID], 
    er.mailitem_id AS [MailItemID], 
    er.account_id AS [AccountID], 
    er.last_mod_date AS [LastModifiedDate], 
    er.last_mod_user AS [LastModifiedUser],
    fi.send_request_user,
    fi.send_request_date,
    fi.recipients, fi.subject, fi.body
FROM msdb.dbo.sysmail_event_log er 
    LEFT JOIN msdb.dbo.sysmail_faileditems fi
ON er.mailitem_id = fi.mailitem_id
ORDER BY [LogDate] DESC
~~~


## 3.3 Sysmail_faileditems<a name="3,3"></a>

#### Si sabe que no se pudo enviar el correo electrónico, puede consultarlo sysmail_faileditems directamente. Para obtener más información sobre cómo consultar sysmail_faileditems y filtrar mensajes específicos por destinatario, vea [Comprobar el estado de los mensajes de correo electrónico enviados con Correo electrónico de base de datos.](https://learn.microsoft.com/es-es/sql/relational-databases/database-mail/check-the-status-of-e-mail-messages-sent-with-database-mail?view=sql-server-ver16)

#### Para comprobar el estado de los mensajes de correo electrónico que se envían mediante Correo electrónico de base de datos, ejecute los siguientes scripts:

~~~sql
-- Show the subject, the time that the mail item row was last  
-- modified, and the log information.  
-- Join sysmail_faileditems to sysmail_event_log   
-- on the mailitem_id column.  
-- In the WHERE clause list items where danw was in the recipients,  
-- copy_recipients, or blind_copy_recipients.  
-- These are the items that would have been sent to Jane@contoso.com
 
SELECT items.subject, items.last_mod_date, l.description 
FROM dbo.sysmail_faileditems AS items  
INNER JOIN dbo.sysmail_event_log AS l ON items.mailitem_id = l.mailitem_id  
WHERE items.recipients LIKE '%Jane%'    
    OR items.copy_recipients LIKE '%Jane%'   
    OR items.blind_copy_recipients LIKE '%Jane%'  
GO
~~~



## Sysmail_sentitems<a name="3.4"></a>
#### Si desea encontrar la hora en que se envió correctamente el último correo electrónico, puede consultar sysmail_sentitems y ordenar de sent_date la siguiente manera:

~~~sql
SELECT ssi.sent_date, * 
FROM msdb.dbo.sysmail_sentitems ssi
ORDER BY ssi.sent_date DESC
~~~

#### Esta vista contiene una fila por cada dato adjunto que se envía a Correo electrónico de base de datos. Use esta vista cuando necesite información sobre Correo electrónico de base de datos datos adjuntos.

#### Si tiene problemas para enviar correos electrónicos con datos adjuntos, pero algunos correos con datos adjuntos se envían correctamente, esta vista puede ayudarle a averiguar las diferencias.
# 

#### Comprobación de la configuración de Correo electrónico de base de datos para el servidor SMTP<a name="3.5"></a>

#### Otro paso para ayudar a resolver problemas de Correo electrónico de base de datos es comprobar la configuración de Correo electrónico de base de datos para el servidor SMTP y la cuenta que se usa para enviar Correo electrónico de base de datos.

#### Para obtener más información sobre cómo configurar Correo electrónico de base de datos, vea
[Configurar Correo electrónico de base de datos.](https://learn.microsoft.com/es-es/sql/relational-databases/database-mail/configure-database-mail?view=sql-server-ver16)

#


## Ver log de envio de correos sql mail<a name="3.6"></a>
#### SENT MESSAGES LOG
query de los mail enviados por el servidor de correos sql server.
~~~sql
SELECT TOP 20 *
FROM [msdb].[dbo].[sysmail_sentitems]
ORDER BY [send_request_date] DESC
~~~

## Ver log de envio de correos fallidos, FAILED MESSAGES LOG<a name="3.7"></a>
#### query de los Mail fallidos del servidor sql server.
~~~sql
SELECT TOP 20 *
FROM [msdb].[dbo].[sysmail_faileditems]
ORDER BY [send_request_date] DESC
~~~

## ALL MESSAGES – REGARDLESS OF STATUS<a name="3.8"></a>
Listado de todos los mail enviados por el servidor de correos sql serve.

~~~sql
SELECT TOP 20 *
FROM [msdb].[dbo].[sysmail_allitems]
ORDER BY [send_request_date] DESC
~~~




trabajando

#


#### De ser necesario para corregir el problema procederemos a ejecutar el siguiente archivo.
#### Dependiendo de tu instalacion y/o Sistema Operativo puede estar en una Direccion u otra.  Pero la direccion seria similar a la mostrada a continuacion.

~~~npm
C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\Binn\DatabaseMail.exe
~~~


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

<!-- Iniciamos aqui con las Memorias y paginaciones en Sql server -->


# Una vista dentro de la caché del búfer de SQL Server<a name="8"></a>
![](https://learn.microsoft.com/es-es/sql/database-engine/configure-windows/media/ssdbufferpoolextensionarchitecture.gif?view=sql-server-ver16)
## Datos de Manejo de Memoria y paginacion en el Servidor sql server 
### Alejandro Jimenez Febrero 5 del 2021
#### original December 29, 2016 by Ed Pollack

#### Cuando hablamos acerca del uso de la memoria en SQL Server, a menudo nos referimos a la caché del búfer. Esta es una parte importante de la arquitectura de SQL Server, y es responsable por la habilidad de consultar datos frecuentemente accedidos extremadamente rápido. Saber cómo funciona la caché del búfer nos permitirá asignar apropiadamente memoria en SQL Server, estimar de manera precisa cómo las bases de datos están accediendo los datos, y asegura que no haya ineficiencias en nuestro código que causen que datos excesivos sean enviados a la caché.

#### **¿Qué hay en la caché del búfer?**<a name="quehayenlacachedelbufer"></a>
![](https://concepto.de/wp-content/uploads/2018/08/memoria-cache-e1534944680214.jpg)
#### Los discos duros son lentos, la memoria es rápida. Este es un hecho de la naturaliza para cualquiera que trabaja con computadoras. Incluso los SSDs son lentos en comparación a la memoria de alto rendimiento. La manera en que el software lidia con este problema es escribir los datos desde el almacenamiento lento a la memoria rápida. Una vez cargadas, sus aplicaciones favoritas pueden desempeñarse muy rápidamente y sólo necesitan volver al disco cuando nuevos datos son necesarios. Este hecho en la computación es una parte importante de la arquitectura de SQL Server.

#### Cuando sea que los datos son escritos a o leídos desde una base de datos SQL Server, serán copiados a la memoria por el administrador del búfer. La caché del búfer (también conocida como grupo de búferes) usará tanta memoria como esté asignada a ella para mantener tantas páginas de datos como sea posible. Cuando la caché del búfer se llena, datos más antiguos y menos usados serán purgados para hacer campo para datos más nuevos.

#### Los datos son almacenados en páginas de 8k dentro de la caché del búfer y pueden ser referidos como páginas “limpias” o “sucias”. Una página sucia es una que ha sido cambiada desde la última vez que fue escriba al disco y es el resultado de una operación de escritura contra el índice o los datos de tabla. Las páginas limpias son aquellas que no han cambiado, y los datos dentro de ellas aún coinciden con lo que está en el disco. Los puntos de control son publicados automáticamente en el fondo por SQL Server y escribirán páginas sucias al disco para crear un buen punto conocido de restauración en el evento de un colapso u otra situación desafortunada del servidor.

#### Usted puede ver una vista general del estado actual del uso de la memoria en SQL Server revisando la DMV sys.dm_os_sys_info DMV:<a name="8-1"></a>
# 
# 
~~~sql

SELECT
    physical_memory_kb,
    virtual_memory_kb,
    committed_kb,
    committed_target_kb
FROM sys.dm_os_sys_info;
~~~
# 
#

#### Los resultados de esta consulta me dicen algo acerca del uso de la memoria en mi servidor:

#### **Aquí está lo que significan las columnas:**
#### ***physical_memory_kb:*** Memoria física total instalada en el servidor.
#### ***virtual_memory_kb:*** Cantidad total de memoria virtual disponible para SQL Server. Idealmente, no queremos utilizar esto tan a menudo como la memoria virtual (usar un archivo de página en el disco o en algún otro lugar que no sea la memoria, va a ser significativamente más lento que la memoria).
#### ***Committed_kb:*** La cantidad de memoria actualmente asignada por la caché del búfer para el uso por páginas de base de datos.
#### ***Committed_target_kb:*** Esta es la cantidad de memoria que la caché del búfer “quiere” usar. Si la cantidad actualmente en uso (indicada por commited_kb) es más alta que esta cantidad, entonces el administrador del búfer comenzará a remover páginas antiguas desde la memoria. Si la cantidad actualmente en uso es menor, entonces el administrador del búfer asignará más memoria para nuestros datos.
#### 
#### EL uso de la memoria es crítico para el desempeño de SQL Server – si no hay suficiente memoria disponible para servir nuestras consultas comunes, entonces usaremos muchos más recursos leyendo datos desde el disco, sólo para descartarlos y leerlos de nuevo después.

#### **¿Cómo podemos usar las métricas de la caché del búfer?**
#### Nosotros podemos acceder a la información acerca de la caché del búfer usando la vista dinámica de administración sys.dm_os_buffer_descriptors, la cual provee todo lo que usted siempre quiso saber acerca de los datos almacenados en la memoria por SQL Server, pero temía preguntar. Dentro de esta vista, usted encontrará una sola fila por descriptor de búfer, lo que da identificación única y provee algo de información acerca de cada página en la memoria. Note que, en un servidor con bases de datos grandes, puede tomar un poco de tiempo consultar esta vista.

#### Una métrica útil que es fácil de obtener es la medida del uso de la caché del búfer por la base de datos en el servidor:<a name="metricausocachequery"></a>
# 
# 
~~~sql
SELECT
    databases.name AS database_name,
    COUNT(*) * 8 / 1024 AS mb_used
FROM sys.dm_os_buffer_descriptors
INNER JOIN sys.databases
ON databases.database_id = dm_os_buffer_descriptors.database_id
GROUP BY databases.name
ORDER BY COUNT(*) DESC;
~~~

# 
#### Esta consulta retorna, ordenada desde más páginas a menos, la cantidad de memoria consumida por cada base de datos en la caché del búfer:
####
####
#### Mi servidor local no es increíblemente emocionante ahora…pero si decidiéramos correr una variedad de consultas contra AdventureWorks2014, podríamos correr nuestra consulta desde arriba de nuevo para verificar el impacto que tuvo en la caché del búfer:
#### 

#### Mientras que no enloquecí aquí, mi consulta al azar sí incrementó la cantidad de datos en la caché del búfer para AdventureWorks2014 en 27MB. Esta consulta puede ser una manera útil de determinar rápidamente qué base de datos cuenta con el mayor uso de memoria en la caché del búfer. En una arquitectura multiusuario, o en un servidor en el cual hay muchas bases de datos clave compartiendo recursos, este puede ser un método rápido para hallar la base de datos que está desempeñándose pobremente o acaparando la memoria en cualquier momento.

#### **De forma similar, podemos ver los totales como una página o un conteo de bytes:**<a name="totalespaginasconteo"></a>
# 

~~~sql

SELECT
    COUNT(*) AS buffer_cache_pages,
    COUNT(*) * 8 / 1024 AS buffer_cache_used_MB
FROM sys.dm_os_buffer_descriptors;
~~~
# 


#### Esto retorna una sola fila conteniendo el número de páginas en la caché del búfer, así como la memoria consumida por ellas:
#### 

#### Dado que una página es de 8KB, podemos convertir el número de páginas en megabytes multiplicando por 8 para obtener KB, y luego dividir por 1024 para llegar a MB.
#### 
#### Podemos subdividir esto más allá y ver cómo la caché del búfer es usada por objetos específicos. Esto puede proveer mucha más información acerca del uso de la memoria, ya que podemos determinar qué tablas son acaparadoras de memoria. Adicionalmente, podemos verificar algunas métricas interesantes, como qué porcentaje de una tabla está en la memoria actualmente, o qué tablas son infrecuentemente usadas (o no). La siguiente consulta retornará las páginas en búfer y el tamaño por tabla:
# 
~~~sql
SELECT
    objects.name AS object_name,
    objects.type_desc AS object_type_description,
    COUNT(*) AS buffer_cache_pages,
    COUNT(*) * 8 / 1024  AS buffer_cache_used_MB
FROM sys.dm_os_buffer_descriptors
INNER JOIN sys.allocation_units
ON allocation_units.allocation_unit_id = dm_os_buffer_descriptors.allocation_unit_id
INNER JOIN sys.partitions
ON ((allocation_units.container_id = partitions.hobt_id AND type IN (1,3))
OR (allocation_units.container_id = partitions.partition_id AND type IN (2)))
INNER JOIN sys.objects
ON partitions.object_id = objects.object_id
WHERE allocation_units.type IN (1,2,3)
AND objects.is_ms_shipped = 0
AND dm_os_buffer_descriptors.database_id = DB_ID()
GROUP BY objects.name,
         objects.type_desc
ORDER BY COUNT(*) DESC;
~~~

# 

#### 
#### Las tablas de sistema son excluidas, y esto sólo jalará datos para la base de datos actual. Las vistas indexadas no serán incluidas, ya que sus índices son entidades distintas de las tablas de las que derivan- La combinación en sys.partitions contiene dos partes para manejar los índices, así como las pilas. Los datos mostrados aquí incluyen todos los índices en la tabla, así como la pila, si no hay ninguna definida.
#### 
#### Un segmento de los resultados de esto es el siguiente (para AdventureWorks2014):
<!-- ![](
C:\Users\epollack\Dropbox\SQL\Articles\Searching the SQL Server Buffer Cache\5. Buffer Cache by Table.jpg
) -->
#### 
#### De forma similar, podemos dividir los datos por índice en lugar de por tabla, proveyendo incluso más granularidad en el uso de la caché del búfer:
#### 
# 
~~~sql
SELECT
    indexes.name AS index_name,
    objects.name AS object_name,
    objects.type_desc AS object_type_description,
    COUNT(*) AS buffer_cache_pages,
    COUNT(*) * 8 / 1024  AS buffer_cache_used_MB
FROM sys.dm_os_buffer_descriptors
INNER JOIN sys.allocation_units
ON allocation_units.allocation_unit_id = dm_os_buffer_descriptors.allocation_unit_id
INNER JOIN sys.partitions
ON ((allocation_units.container_id = partitions.hobt_id AND type IN (1,3))
OR (allocation_units.container_id = partitions.partition_id AND type IN (2)))
INNER JOIN sys.objects
ON partitions.object_id = objects.object_id
INNER JOIN sys.indexes
ON objects.object_id = indexes.object_id
AND partitions.index_id = indexes.index_id
WHERE allocation_units.type IN (1,2,3)
AND objects.is_ms_shipped = 0
AND dm_os_buffer_descriptors.database_id = DB_ID()
GROUP BY indexes.name,
         objects.name,
         objects.type_desc
ORDER BY COUNT(*) DESC;
~~~

# 
#### Esta consulta es casi la misma que nuestra última, excepto que hacemos una combinación adicional a sys.indexes, y agrupamos en el nombre del índice en adición al nombre de la tabla/vista. Los resultados proveen incluso más detalles acerca de cómo la caché del búfer está siendo usada, y pueden ser valiosos en tablas con muchos índices de uso variado:

#### 


#### Los resultados pueden ser útiles cuando se trata de determinar el nivel general de uso para un índice específico en cualquier momento. Adicionalmente, nos permite estimar cuánto de un índice está siendo leído, comparado con su tamaño general.
#### 
#### Para recolectar el porcentaje de cada tabla que está en la memoria, podemos poner esa consulta en un CTE y comparar las páginas en memoria versus el total para cada tabla:
#### 
# 
~~~sql
WITH CTE_BUFFER_CACHE AS (
    SELECT
        objects.name AS object_name,
        objects.type_desc AS object_type_description,
        objects.object_id,
        COUNT(*) AS buffer_cache_pages,
        COUNT(*) * 8 / 1024  AS buffer_cache_used_MB
    FROM sys.dm_os_buffer_descriptors
    INNER JOIN sys.allocation_units
    ON allocation_units.allocation_unit_id = dm_os_buffer_descriptors.allocation_unit_id
    INNER JOIN sys.partitions
    ON ((allocation_units.container_id = partitions.hobt_id AND type IN (1,3))
    OR (allocation_units.container_id = partitions.partition_id AND type IN (2)))
    INNER JOIN sys.objects
    ON partitions.object_id = objects.object_id
    WHERE allocation_units.type IN (1,2,3)
    AND objects.is_ms_shipped = 0
    AND dm_os_buffer_descriptors.database_id = DB_ID()
    GROUP BY objects.name,
             objects.type_desc,
             objects.object_id)
SELECT
    PARTITION_STATS.name,
    CTE_BUFFER_CACHE.object_type_description,
    CTE_BUFFER_CACHE.buffer_cache_pages,
    CTE_BUFFER_CACHE.buffer_cache_used_MB,
    PARTITION_STATS.total_number_of_used_pages,
    PARTITION_STATS.total_number_of_used_pages * 8 / 1024 AS total_mb_used_by_object,
    CAST((CAST(CTE_BUFFER_CACHE.buffer_cache_pages AS DECIMAL) /
     CAST(PARTITION_STATS.total_number_of_used_pages AS DECIMAL)
      * 100) AS DECIMAL(5,2)) AS percent_of_pages_in_memory
FROM CTE_BUFFER_CACHE
INNER JOIN (
    SELECT 
        objects.name,
        objects.object_id,
        SUM(used_page_count) AS total_number_of_used_pages
    FROM sys.dm_db_partition_stats
    INNER JOIN sys.objects
    ON objects.object_id = dm_db_partition_stats.object_id
    WHERE objects.is_ms_shipped = 0
    GROUP BY objects.name, objects.object_id) PARTITION_STATS
ON PARTITION_STATS.object_id = CTE_BUFFER_CACHE.object_id
ORDER BY CAST(CTE_BUFFER_CACHE.buffer_cache_pages AS DECIMAL) / CAST(PARTITION_STATS.
total_number_of_used_pages AS DECIMAL) DESC;
~~~
# 
# 


#### 
#### Esta consulta combina nuestro conjunto previo de datos con una consulta en sys.dm_db_partition_stats para comparar lo que está actualmente en la caché del búfer versus el espacio total usado por cualquier tabla dada. Las muchas operaciones CAST al final ayudan a evitar el truncado y hacen al resultado final fácil de leer. Los resultados en mi servidor local son los siguientes:

#### 

#### Estos datos nos dicen qué tablas están las zonas calientes en nuestra base de datos, y con un poco de conocimiento de su uso de aplicación, podemos determinar cuáles simplemente tienen demasiados datos residiendo en la memoria. Las tablas pequeñas son probablemente no muy importantes para nosotros aquí. Por ejemplo, las primeras cuatro en la salida anterior están debajo de un megabyte y si quisiéramos omitirlas, podríamos filtrar los resultados para retornar solamente tablas más grandes que un tamaño específico de interés.

#### Por otra parte, estos datos nos dicen que ¾ de SalesOrderDetail está en la caché del búfer. Si esto pareciera inusual, consultaría la caché del plan de consultas y determinaría si hay alguna consulta ineficiente en la tabla que está seleccionando *, o una cantidad excesivamente grande de datos. Combinando nuestras métricas desde la caché del búfer y la caché del plan, podemos idear nuevas maneras de determinar con precisión mañas consultas o aplicaciones que están jalando muchos más datos de lo que requieren.

#### Esta consulta puede ser modificada para proveer el porcentaje de un índice que está siendo usado también, de forma similar a cómo recolectamos el porcentaje de una tabla usada:
#### 
# 
~~~sql
SELECT
    indexes.name AS index_name,
    objects.name AS object_name,
    objects.type_desc AS object_type_description,
    COUNT(*) AS buffer_cache_pages,
    COUNT(*) * 8 / 1024  AS buffer_cache_used_MB,
    SUM(allocation_units.used_pages) AS pages_in_index,
    SUM(allocation_units.used_pages) * 8 /1024 AS total_index_size_MB,
    CAST((CAST(COUNT(*) AS DECIMAL) / CAST(SUM(allocation_units.
    used_pages) AS DECIMAL) * 100) AS DECIMAL(5,2)) AS percent_of_pages_in_memory
FROM sys.dm_os_buffer_descriptors
INNER JOIN sys.allocation_units
ON allocation_units.allocation_unit_id = dm_os_buffer_descriptors.allocation_unit_id
INNER JOIN sys.partitions
ON ((allocation_units.container_id = partitions.hobt_id AND type IN (1,3))
OR (allocation_units.container_id = partitions.partition_id AND type IN (2)))
INNER JOIN sys.objects
ON partitions.object_id = objects.object_id
INNER JOIN sys.indexes
ON objects.object_id = indexes.object_id
AND partitions.index_id = indexes.index_id
WHERE allocation_units.type IN (1,2,3)
AND objects.is_ms_shipped = 0
AND dm_os_buffer_descriptors.database_id = DB_ID()
GROUP BY indexes.name,
         objects.name,
         objects.type_desc
ORDER BY CAST((CAST(COUNT(*) AS DECIMAL) / CAST(SUM
(allocation_units.used_pages) AS DECIMAL) * 100) AS DECIMAL(5,2)) DESC;
~~~
# 
#### 

#### Dado que sys.allocation_units provee algo de información acerca del tamaño de nuestros índices, evitamos la necesidad de CTEs y conjuntos de datos adicionales de dm_db_partition_stats. Aquí está un pedazo de los resultados, mostrando el tamaño del índice (MB y páginas) y el espacio usado de la caché del búfer (MB y páginas):

#### 

#### Si estuviéramos poco interesados en tablas/índices pequeños, podríamos añadir una cláusula HAVING a la consulta para filtrar por un índice que es más pequeño que un tamaño especificado, en MB o páginas. Estos datos proveen una vista de la eficiencia de las consultas en índices específicos y podría asistir en la limpieza de índices, el ajuste de índices o algún ajuste más granular del uso de la memoria en su SQL Server.

#### Una columna interesante en dm_os_buffer_descriptors es free_space_in_bytes. Esta columna nos dice cuán llena está cada página en la caché del búfer, y por lo tanto provee un indicador del espacio potencial desperdiciado o la ineficiencia. Podemos determinar el porcentaje de páginas que han sido tomadas por el espacio libre, en lugar de datos, para cada base de datos en nuestro servidor:
####  
# 
~~~sql
WITH CTE_BUFFER_CACHE AS
( SELECT
  databases.name AS database_name,
  COUNT(*) AS total_number_of_used_pages,
  CAST(COUNT(*) * 8 AS DECIMAL) / 1024 AS buffer_cache_total_MB,
  CAST(CAST(SUM(CAST(dm_os_buffer_descriptors.free_space_in_bytes AS BIGINT)) AS DECIMAL) / (1024 * 1024) AS
   DECIMAL(20,2))  AS buffer_cache_free_space_in_MB
 FROM sys.dm_os_buffer_descriptors
 INNER JOIN sys.databases
 ON databases.database_id = dm_os_buffer_descriptors.database_id
 GROUP BY databases.name)
SELECT
 *,
 CAST((buffer_cache_free_space_in_MB / NULLIF(buffer_cache_total_MB, 0)) * 100 AS DECIMAL(5,2)) AS
  buffer_cache_percent_free_space
FROM CTE_BUFFER_CACHE
ORDER BY buffer_cache_free_space_in_MB / NULLIF(buffer_cache_total_MB, 0) DESC
~~~
# 
# 
#### 
#### Esto retorna una fila por base de datos que muestra la agregación de espacio libre por base de datos, sumada a través de todas las páginas en la caché del búfer para esa base de datos particular:

#### 

#### Esto es interesante, pero no muy útil todavía debido a que estos resultados no son muy específicos. Nos dicen que una base de datos puede tener un poco de espacio desperdiciado, pero no mucho sobre qué tablas son las causantes. Tomemos el mismo enfoque que hicimos anteriormente y devolvemos espacio libre por tabla en una base de datos dada:
#### 
<!-- final de memoria -->
#### De forma similar, podemos dividir los datos por índice en lugar de por tabla, proveyendo incluso más granularidad en el uso de la caché del búfer:
#### 
# 

~~~sql
SELECT
    indexes.name AS index_name,
    objects.name AS object_name,
    objects.type_desc AS object_type_description,
    COUNT(*) AS buffer_cache_pages,
    COUNT(*) * 8 / 1024  AS buffer_cache_used_MB
FROM sys.dm_os_buffer_descriptors
INNER JOIN sys.allocation_units
ON allocation_units.allocation_unit_id = dm_os_buffer_descriptors.allocation_unit_id
INNER JOIN sys.partitions
ON ((allocation_units.container_id = partitions.hobt_id AND type IN (1,3))
OR (allocation_units.container_id = partitions.partition_id AND type IN (2)))
INNER JOIN sys.objects
ON partitions.object_id = objects.object_id
INNER JOIN sys.indexes
ON objects.object_id = indexes.object_id
AND partitions.index_id = indexes.index_id
WHERE allocation_units.type IN (1,2,3)
AND objects.is_ms_shipped = 0
AND dm_os_buffer_descriptors.database_id = DB_ID()
GROUP BY indexes.name,
         objects.name,
         objects.type_desc
ORDER BY COUNT(*) DESC;
~~~
## 
# 

#### 
####  Esta consulta es casi la misma que nuestra última, excepto que hacemos una combinación adicional a sys.indexes, y agrupamos en el nombre del índice en adición al nombre de la tabla/vista. Los resultados proveen incluso más detalles acerca de cómo la caché del búfer está siendo usada, y pueden ser valiosos en tablas con muchos índices de uso variado:

#### 

#### Los resultados pueden ser útiles cuando se trata de determinar el nivel general de uso para un índice específico en cualquier momento. Adicionalmente, nos permite estimar cuánto de un índice está siendo leído, comparado con su tamaño general.
#### 
#### Para recolectar el porcentaje de cada tabla que está en la memoria, podemos poner esa consulta en un CTE y comparar las páginas en memoria versus el total para cada tabla:<a name="percentajecadapagina"></a>
# 
# 
~~~sql
WITH CTE_BUFFER_CACHE AS (
    SELECT
        objects.name AS object_name,
        objects.type_desc AS object_type_description,
        objects.object_id,
        COUNT(*) AS buffer_cache_pages,
        COUNT(*) * 8 / 1024  AS buffer_cache_used_MB
    FROM sys.dm_os_buffer_descriptors
    INNER JOIN sys.allocation_units
    ON allocation_units.allocation_unit_id = dm_os_buffer_descriptors.allocation_unit_id
    INNER JOIN sys.partitions
    ON ((allocation_units.container_id = partitions.hobt_id AND type IN (1,3))
    OR (allocation_units.container_id = partitions.partition_id AND type IN (2)))
    INNER JOIN sys.objects
    ON partitions.object_id = objects.object_id
    WHERE allocation_units.type IN (1,2,3)
    AND objects.is_ms_shipped = 0
    AND dm_os_buffer_descriptors.database_id = DB_ID()
    GROUP BY objects.name,
             objects.type_desc,
             objects.object_id)
SELECT
    PARTITION_STATS.name,
    CTE_BUFFER_CACHE.object_type_description,
    CTE_BUFFER_CACHE.buffer_cache_pages,
    CTE_BUFFER_CACHE.buffer_cache_used_MB,
    PARTITION_STATS.total_number_of_used_pages,
    PARTITION_STATS.total_number_of_used_pages * 8 / 1024 AS 
    total_mb_used_by_object,
    CAST((CAST(CTE_BUFFER_CACHE.buffer_cache_pages AS DECIMAL) / 
    CAST(PARTITION_STATS.total_number_of_used_pages AS DECIMAL)
     * 100) AS DECIMAL(5,2)) AS percent_of_pages_in_memory
FROM CTE_BUFFER_CACHE
INNER JOIN (
    SELECT 
        objects.name,
        objects.object_id,
        SUM(used_page_count) AS total_number_of_used_pages
    FROM sys.dm_db_partition_stats
    INNER JOIN sys.objects
    ON objects.object_id = dm_db_partition_stats.object_id
    WHERE objects.is_ms_shipped = 0
    GROUP BY objects.name, objects.object_id) PARTITION_STATS
ON PARTITION_STATS.object_id = CTE_BUFFER_CACHE.object_id
ORDER BY CAST(CTE_BUFFER_CACHE.buffer_cache_pages AS DECIMAL) / 
CAST(PARTITION_STATS.total_number_of_used_pages AS DECIMAL) DESC;
~~~


# 
#### Esta consulta combina nuestro conjunto previo de datos con una consulta en sys.dm_db_partition_stats para comparar lo que está actualmente en la caché del búfer versus el espacio total usado por cualquier tabla dada. Las muchas operaciones CAST al final ayudan a evitar el truncado y hacen al resultado final fácil de leer. Los resultados en mi servidor local son los siguientes:
# 


#### Estos datos nos dicen qué tablas están las zonas calientes en nuestra base de datos, y con un poco de conocimiento de su uso de aplicación, podemos determinar cuáles simplemente tienen demasiados datos residiendo en la memoria. Las tablas pequeñas son probablemente no muy importantes para nosotros aquí. Por ejemplo, las primeras cuatro en la salida anterior están debajo de un megabyte y si quisiéramos omitirlas, podríamos filtrar los resultados para retornar solamente tablas más grandes que un tamaño específico de interés.

#### Por otra parte, estos datos nos dicen que ¾ de SalesOrderDetail está en la caché del búfer. Si esto pareciera inusual, consultaría la caché del plan de consultas y determinaría si hay alguna consulta ineficiente en la tabla que está seleccionando *, o una cantidad excesivamente grande de datos. Combinando nuestras métricas desde la caché del búfer y la caché del plan, podemos idear nuevas maneras de determinar con precisión mañas consultas o aplicaciones que están jalando muchos más datos de lo que requieren.

#### Esta consulta puede ser modificada para proveer el porcentaje de un índice que está siendo usado también, de forma similar a cómo recolectamos el porcentaje de una tabla usada:
# 

~~~sql
SELECT
    indexes.name AS index_name,
    objects.name AS object_name,
    objects.type_desc AS object_type_description,
    COUNT(*) AS buffer_cache_pages,
    COUNT(*) * 8 / 1024  AS buffer_cache_used_MB,
    SUM(allocation_units.used_pages) AS pages_in_index,
    SUM(allocation_units.used_pages) * 8 /1024 AS total_index_size_MB,
    CAST((CAST(COUNT(*) AS DECIMAL) / CAST(SUM(allocation_units.
    used_pages) AS DECIMAL) * 100) AS DECIMAL(5,2)) AS percent_of_pages_in_memory
FROM sys.dm_os_buffer_descriptors
INNER JOIN sys.allocation_units
ON allocation_units.allocation_unit_id = dm_os_buffer_descriptors.allocation_unit_id
INNER JOIN sys.partitions
ON ((allocation_units.container_id = partitions.hobt_id AND type IN (1,3))
OR (allocation_units.container_id = partitions.partition_id AND type IN (2)))
INNER JOIN sys.objects
ON partitions.object_id = objects.object_id
INNER JOIN sys.indexes
ON objects.object_id = indexes.object_id
AND partitions.index_id = indexes.index_id
WHERE allocation_units.type IN (1,2,3)
AND objects.is_ms_shipped = 0
AND dm_os_buffer_descriptors.database_id = DB_ID()
GROUP BY indexes.name,
         objects.name,
         objects.type_desc
ORDER BY CAST((CAST(COUNT(*) AS DECIMAL) / CAST(SUM
(allocation_units.used_pages) AS DECIMAL) * 100) AS DECIMAL(5,2)) DESC;
~~~

# 
#### Dado que sys.allocation_units provee algo de información acerca del tamaño de nuestros índices, evitamos la necesidad de CTEs y conjuntos de datos adicionales de dm_db_partition_stats. Aquí está un pedazo de los resultados, mostrando el tamaño del índice (MB y páginas) y el espacio usado de la caché del búfer (MB y páginas):



#### Si estuviéramos poco interesados en tablas/índices pequeños, podríamos añadir una cláusula HAVING a la consulta para filtrar por un índice que es más pequeño que un tamaño especificado, en MB o páginas. Estos datos proveen una vista de la eficiencia de las consultas en índices específicos y podría asistir en la limpieza de índices, el ajuste de índices o algún ajuste más granular del uso de la memoria en su SQL Server.

#### Una columna interesante en dm_os_buffer_descriptors es free_space_in_bytes. Esta columna nos dice cuán llena está cada página en la caché del búfer, y por lo tanto provee un indicador del espacio potencial desperdiciado o la ineficiencia. Podemos determinar el porcentaje de páginas que han sido tomadas por el espacio libre, en lugar de datos, para cada base de datos en nuestro servidor:
# 

~~~sql
WITH CTE_BUFFER_CACHE AS
( SELECT
  databases.name AS database_name,
  COUNT(*) AS total_number_of_used_pages,
  CAST(COUNT(*) * 8 AS DECIMAL) / 1024 AS buffer_cache_total_MB,
  CAST(CAST(SUM(CAST(dm_os_buffer_descriptors.free_space_in_bytes AS BIGINT)) AS DECIMAL) / (1024 * 1024) AS 
  DECIMAL(20,2))  AS buffer_cache_free_space_in_MB
 FROM sys.dm_os_buffer_descriptors
 INNER JOIN sys.databases
 ON databases.database_id = dm_os_buffer_descriptors.database_id
 GROUP BY databases.name)
SELECT
 *,
 CAST((buffer_cache_free_space_in_MB / NULLIF
 (buffer_cache_total_MB, 0)) * 100 AS DECIMAL(5,2)) AS 
 buffer_cache_percent_free_space
FROM CTE_BUFFER_CACHE
ORDER BY buffer_cache_free_space_in_MB / NULLIF(buffer_cache_total_MB, 0) DESC
~~~


#### Esto retorna una fila por base de datos que muestra la agregación de espacio libre por base de datos, sumada a través de todas las páginas en la caché del búfer para esa base de datos particular:



#### Esto es interesante, pero no muy útil todavía debido a que estos resultados no son muy específicos. Nos dicen que una base de datos puede tener un poco de espacio desperdiciado, pero no mucho sobre qué tablas son las causantes. Tomemos el mismo enfoque que hicimos anteriormente y devolvemos espacio libre por tabla en una base de datos dada:
# 

~~~sql
SELECT
    objects.name AS object_name,
    objects.type_desc AS object_type_description,
    COUNT(*) AS buffer_cache_pages,
    CAST(COUNT(*) * 8 AS DECIMAL) / 1024  AS buffer_cache_total_MB,
    CAST(SUM(CAST(dm_os_buffer_descriptors.free_space_in_bytes 
    AS BIGINT)) AS DECIMAL) / 1024 / 1024 AS 
    buffer_cache_free_space_in_MB,
    CAST((CAST(SUM(CAST(dm_os_buffer_descriptors.free_space_in_bytes AS BIGINT)) AS DECIMAL) / 1024 / 1024) / 
    (CAST(COUNT(*) * 8 AS DECIMAL) / 1024) * 100 AS DECIMAL(5,
    2)) AS buffer_cache_percent_free_space
FROM sys.dm_os_buffer_descriptors
INNER JOIN sys.allocation_units
ON allocation_units.allocation_unit_id = dm_os_buffer_descriptors.allocation_unit_id
INNER JOIN sys.partitions
ON ((allocation_units.container_id = partitions.hobt_id AND type IN (1,3))
OR (allocation_units.container_id = partitions.partition_id AND type IN (2)))
INNER JOIN sys.objects
ON partitions.object_id = objects.object_id
WHERE allocation_units.type IN (1,2,3)
AND objects.is_ms_shipped = 0
AND dm_os_buffer_descriptors.database_id = DB_ID()
GROUP BY objects.name,
            objects.type_desc,
            objects.object_id
HAVING COUNT(*) > 0
ORDER BY COUNT(*) DESC;
~~~

# 
#### Esto devuelve una fila por tabla o vista indexada que tiene al menos una página en la memoria caché del búfer ordenada primeramente por aquellos que tienen la mayor cantidad de páginas en memoria.



#### **¿Qué significa exactamente?** Cuanto más espacio libre por página existe en promedio, más páginas hay que leer para retornar los datos que estamos buscando. Además, se requieren más páginas para almacenar datos, lo que significa que se necesita más espacio en la memoria y en disco para mantener nuestros datos. El espacio perdido también significa más E/S para obtener los datos que necesitamos y las consultas se ejecutan más tiempo de lo necesario a medida que se recuperan estos datos.

#### La causa más común de un exceso de espacio libre son las tablas con filas muy amplias. Puesto que una página es de 8k, si una fila pasó a ser de 5k, nunca seríamos capaces de encajar una sola fila en una página, y siempre habrá ese extra de ~3k de espacio libre que no se puede utilizar. Las tablas con muchas operaciones de inserción aleatoria pueden ser problemáticas también. Por ejemplo, una clave que no aumenta puede resultar en divisiones de página cuando los datos se escriben en diferente orden. Un GUID sería el peor de los casos, pero cualquier clave que no está aumentando de manera natural puede dar lugar a este problema hasta cierto punto.

#### A medida que los índices se fragmentan con el tiempo, la fragmentación se verá en parte como un exceso de espacio libre cuando observamos el contenido de la caché del búfer. La mayoría de estos problemas se resuelven con un diseño inteligente de bases de datos y un mantenimiento razonable de la base de datos. Este no es el lugar para entrar en detalles sobre esos temas, pero hay muchos artículos y presentaciones sobre estos temas en la red para su entretenimiento.

#### Al principio de este artículo, discutimos brevemente qué páginas sucias y limpias son y su correlación con las operaciones de escritura dentro de una base de datos. Dentro de dm_os_buffer_descriptors podemos verificar si una página está limpia o no está usando la columna is_modified. Esta nos dice si una página ha sido modificada por una operación de escritura, pero aún no se ha escrito en disco. Podemos usar esta información para contar las páginas limpias y sucias en la caché del búfer para una base de datos determinada:
# 

~~~sql
SELECT
    databases.name AS database_name,
    COUNT(*) AS buffer_cache_total_pages,
    SUM(CASE WHEN dm_os_buffer_descriptors.is_modified = 1
                THEN 1
                ELSE 0
        END) AS buffer_cache_dirty_pages,
    SUM(CASE WHEN dm_os_buffer_descriptors.is_modified = 1
                THEN 0
                ELSE 1
        END) AS buffer_cache_clean_pages,
    SUM(CASE WHEN dm_os_buffer_descriptors.is_modified = 1
                THEN 1
                ELSE 0
        END) * 8 / 1024 AS buffer_cache_dirty_page_MB,
    SUM(CASE WHEN dm_os_buffer_descriptors.is_modified = 1
                THEN 0
                ELSE 1
        END) * 8 / 1024 AS buffer_cache_clean_page_MB
FROM sys.dm_os_buffer_descriptors
INNER JOIN sys.databases
ON dm_os_buffer_descriptors.database_id = databases.database_id
GROUP BY databases.name;
~~~



# 
#### Esta consulta devuelve el número de páginas y el tamaño de los datos en MB:<a name="numerodepaginas"></a>



#### Mi servidor no tiene mucho por el momento. Si corriera una gran sentencia de actualización, podríamos ilustrar qué veríamos cuando más operaciones de escritura están ocurriendo. Corramos la siguiente consulta:
# 
~~~sql
UPDATE Sales.SalesOrderDetail
    SET OrderQty = OrderQty
~~~  
# 
#### Esto es esencialmente una no-operación y no resultará en ningún cambio real a la tabla SalesOrderDetail – pero SQL Server aún pasará por el problema de actualizar cada fila en la tabla para esta columna particular. Si corremos el conteo de páginas sucias/limpias desde arriba, obtendremos algunos resultados interesantes:



#### Cerca de 2/3 de las páginas para AdventureWorks2014 en la caché del búfer están sucios. Adicionalmente, TempDB también tiene bastante actividad, lo cual es indicativo del desencadenador update/insert/delete en la tabla, lo que causó que se ejecutara una gran cantidad de T-SQL adicional. El desencadenador causó que haya bastantes lecturas contra AdventureWorks2014, así como la necesidad de trabajo de tablas en TempDB para procesar esas operaciones adicionales.

#### Como antes, podemos dividir esta tabla o índice para recolectar datos más granulares acerca del uso de la caché del búfer:
# 
~~~sql
SELECT
    indexes.name AS index_name,
    objects.name AS object_name,
    objects.type_desc AS object_type_description,
    COUNT(*) AS buffer_cache_total_pages,
    SUM(CASE WHEN dm_os_buffer_descriptors.is_modified = 1
                THEN 1
                ELSE 0
        END) AS buffer_cache_dirty_pages,
    SUM(CASE WHEN dm_os_buffer_descriptors.is_modified = 1
                THEN 0
                ELSE 1
        END) AS buffer_cache_clean_pages,
    SUM(CASE WHEN dm_os_buffer_descriptors.is_modified = 1
                THEN 1
                ELSE 0
        END) * 8 / 1024 AS buffer_cache_dirty_page_MB,
    SUM(CASE WHEN dm_os_buffer_descriptors.is_modified = 1
                THEN 0
                ELSE 1
        END) * 8 / 1024 AS buffer_cache_clean_page_MB
FROM sys.dm_os_buffer_descriptors
INNER JOIN sys.allocation_units
ON allocation_units.allocation_unit_id = dm_os_buffer_descriptors.allocation_unit_id
INNER JOIN sys.partitions
ON ((allocation_units.container_id = partitions.hobt_id AND type IN (1,3))
OR (allocation_units.container_id = partitions.partition_id AND type IN (2)))
INNER JOIN sys.objects
ON partitions.object_id = objects.object_id
INNER JOIN sys.indexes
ON objects.object_id = indexes.object_id
AND partitions.index_id = indexes.index_id
WHERE allocation_units.type IN (1,2,3)
AND objects.is_ms_shipped = 0
AND dm_os_buffer_descriptors.database_id = DB_ID()
GROUP BY indexes.name,
         objects.name,
         objects.type_desc
ORDER BY COUNT(*) DESC;
~~~
#

#### Los resultados muestran el uso de la caché del búfer por índice, mostrando cuántas páginas en la memoria están limpias o sucias:

#

#### Estos datos proveen una idea de la actividad de escritura en un índice dado en este punto del tiempo. Si fuera rastrado en un periodo de días o semanas, podríamos comenzar a estimar la actividad de escritura general del índice y proyectar una tendencia. Esta investigación podría ser útil si usted estuviera buscando entender el mejor nivel posible de aislamiento para usarse en una base de datos, o si esos reportes que siempre son corridos con READ UNCOMMITED podrían ser más susceptibles a lecturas sucias que lo pensado originalmente. En este caso específico, las páginas sucias todas se relacionan con la consulta de actualización que corrimos previamente, y por lo tanto abarcan un conjunto algo limitado.

## DBCC DROPCLEANBUFFERS<a name="dbccdropcleanbuffers"></a>
![](https://blog.sqlauthority.com/wp-content/uploads/2019/03/cleanbuffer-800x351.jpg)
#### Un comando DBCC que es a menudo usado como una forma de probar una consulta y estimar de forma precisa la velocidad de ejecución, es DBCC DROPCLEANBUFFERS. Cuando se corre, este comando remueve todas las páginas limpias de la memoria para un servidor entero de base de datos, dejando atrás solamente páginas sucias, las cuales serán típicamente una pequeña minoría de datos.

#### DBCC DROPCLEANBUFFERS es un comando que típicamente debería ser corrido sólo en un ambiente que no sea de producción, e incluso entonces, sólo cuando no se está realizando pruebas de desempeño o carga. El resultado de este comando es que la caché del búfer terminará mayormente vacía. Cualquier consulta corrida después de este punto necesitará usar lecturas físicas para traer de vuelta los datos a la caché desde su sistema de almacenamiento, lo cual es, como dijimos antes, mucho más lento que la memoria.

#### Después de correr este comando en mi servidor local, la consulta de páginas sucias/impías de más antes retorna lo siguiente:

#

#### ¡Eso es todo lo que queda! Repitiendo mi aviso anterior: Trate este comando de manera similar a DBCC FREEPROCCACHEI en que no debería ser corrido en ningún servidor de producción a menos que usted esté absolutamente seguro de lo que hace.

#### Esta puede ser una herramienta útil de desarrollo debido a que usted puede correr una consulta en un ambiente de pruebas de desempeño una y otra vez sin ningún cambio en la velocidad/eficiencia debido a que se está enviando los datos de la memoria a la caché. Elimine los datos limpios del búfer entre ejecuciones y estará listo. Esto puede proveer resultados engañosos, aunque en esos ambiente de producción siempre usarán la caché del búfer, y no leerán desde su sistema de almacenamiento a menos que sea necesario. Eliminar los búferes limpios llevará a tiempos de ejecución más lentos que lo que se vería de otra forma, pero puede proveer una manera de probar las consultas en un ambiente consistente con cada ejecución.

#### Entendiendo todas estas advertencias, siéntase libre de usar esto como lo necesite para probar y obtener una visión acerca del desempeño de las consultas, las páginas leídas en la memoria como resultado de una consulta, las páginas sucias creadas por una sentencia de escritura, y así por el estilo.

## Expectativa de Vida de las Páginas<a name="expectativadevidadelaspaginas"></a>
|           |                |
|-----------------|--------------------|
|![](https://i.stack.imgur.com/4ZOtd.png) | ![](https://i.stack.imgur.com/X7ayg.png) | 
#### Cuando se discute acerca del desempeño de la memoria en SQL Server, es poco probable que avancemos unos minutos antes de que alguien pregunte acerca de la expectativa de vida de las páginas (PLE, por sus siglas en inglés). PLE es una medida de, en promedio, cuánto tiempo (en segundos) permanecerá una página en la memoria sin ser accedida, punto después del cual es removida. Esta es una métrica que deseamos que sea más alta en la medida que deseamos que nuestros datos importantes permanezcan en la caché del búfer por tanto tiempo como sea posible. Cuando la PLE se ralentiza, los datos están siendo constantemente leídos desde el disco (alias ‘lento’) a la caché del búfer, removidos desde la caché y probablemente leídos desde el disco de nuevo en un futuro cercano. ¡Esta es la receta para un SQL Server lento (y frustrante)!

#### Para ver la PLE actual en un servidor, usted puede correr la siguiente consulta, la cual pondrá el valor actual desde la vista de administración dinámica de conteo de desempeño:
# 
~~~sql
SELECT
    *
FROM sys.dm_os_performance_counters
WHERE dm_os_performance_counters.object_name LIKE '%Buffer Manager%'
AND dm_os_performance_counters.counter_name = 'Page life expectancy';
~~~
# 
# 
#### Los resultados se ven así:


#### ***cntr_value*** es el valor del contador de desempeño, y en mi silencioso servidor local es 210,275 segundos. Dado que muy pocos datos son leídos o escritos en mi SQL Server, la necesidad de remover datos desde la caché del búfer es baja, y por tanto la ***PLE*** es absurdamente alta. En un servidor de producción altamente usado, la PLE sería casi con seguridad más baja.

#### Si su servidor tiene una arquitectura NUMA (acceso de memoria no uniforme), entonces usted deseará considerar una PLE para cada nodo separadamente, lo cual puede ser hecho con la siguiente consulta:
# 
~~~sql
SELECT
    *
FROM sys.dm_os_performance_counters
WHERE dm_os_performance_counters.object_name LIKE '%Buffer Node%'
AND dm_os_performance_counters.counter_name = 'Page life expectancy';
~~~
# 

#### En un servidor sin **NUMA**, estos valores serán idénticos. En un servidor con una arquitectura NUMA, habrá múltiples filas PLE retornadas, todas ellas se sumarán al total dado para el administrador del búfer como un todo. Si usted está trabajando con NUMA, asegúrese de considerar PLE en cada nodo, en adición al total, ya que es posible que un nodo sea un cuello de botella, mientras que el total general se ve aceptable.

#### La pregunta más obvia ahora es, “¿Cuál es un buen valor para la PLE?” Para responder esta pregunta, necesitamos revisar más profundamente en el servidor para ver cuánta memoria tiene, y cuál debería ser el volumen esperado de datos siendo escritos o leídos. 300 segundos es a menudo citado como un buen valor para la PLE, pero como muchas respuestas fáciles y rápidas, esta seguramente es incorrecta.

#### Antes de considerar cómo debería verse la PLE, consideremos un poco más lo que significa. Consideremos un servidor que tiene 256GB de RAM, de lo cual 192GB están asignados a SQL Server en su configuración. Reviso la vista dm_os_sys_info y encuentro que actualmente hay cercan de 163GB enviados a la caché del búfer. Finalmente, reviso el contador de desempeño arriba y encuentro que la PLE en este servidor es 2000 segundos.

#### Basado en estas métricas, podemos saber que tenemos 163GB de memoria disponible para la caché del búfer, y los datos existirán ahí por cerca de 2000 segundos. Esto significa que estamos leyendo, en promedio, 163GB por cada 2000 segundos, lo que resulta ser aproximadamente 83MB/segundo. Este número es muy útil, ya que nos da un indicador claro de cuán activamente está siendo accedido nuestro SQL Server por aplicaciones o procesos. Antes de considerar qué es un buen PLE, necesitamos preguntarnos a nosotros mismos algunas cosas:

## **¿Cuánto tráfico esperamos en promedio por nuestras aplicaciones/servicios?**
#### ¿Hay momentos “especiales” cuando los respaldos, el mantenimiento de índices, el archivado, DBCC CheckDB, u otros procesos puedan causar que la PLE se vuelva muy lenta?
#### ¿Es la latencia un problema? ¿Hay esperas medibles que están causando que las aplicaciones se desempeñen pobremente?
#### ¿Hay esperas IO significativas en el servidor?
#### ¿Qué consultas esperamos que lean la mayor parte de los datos?
#### En otras palabras, ¡conozca sus datos! La única respuesta verdadera a la pregunta de la PLE es que un valor bueno de PLE es uno que representa el desempeño óptimo del servidor con suficiente espacio libre para responder por el crecimiento y los picos de uso. Por ejemplo, tomemos el servidor de más antes, el cual tiene 163GB de memoria dedicada a la caché del búfer, una PLE promedio de 2000 segundos y un rendimiento extrapolado de 83MB/segundo. Después de algo de investigación adicional, descubrí que el desempeño comienza a sufrir cuando la PLE cae por debajo de 1500 segundos. Desde este punto, yo hago dilige -->

<!-- C:\Users\epollack\Dropbox\SQL\Articles\Searching the SQL Server Buffer Cache\5. Buffer Cache by Table.jpg -->
#### De forma similar, podemos dividir los datos por índice en lugar de por tabla, proveyendo incluso más granularidad en el uso de la caché del búfer:
# 
~~~sql
SELECT
    indexes.name AS index_name,
    objects.name AS object_name,
    objects.type_desc AS object_type_description,
    COUNT(*) AS buffer_cache_pages,
    COUNT(*) * 8 / 1024  AS buffer_cache_used_MB
FROM sys.dm_os_buffer_descriptors
INNER JOIN sys.allocation_units
ON allocation_units.allocation_unit_id = dm_os_buffer_descriptors.allocation_unit_id
INNER JOIN sys.partitions
ON ((allocation_units.container_id = partitions.hobt_id AND type IN (1,3))
OR (allocation_units.container_id = partitions.partition_id AND type IN (2)))
INNER JOIN sys.objects
ON partitions.object_id = objects.object_id
INNER JOIN sys.indexes
ON objects.object_id = indexes.object_id
AND partitions.index_id = indexes.index_id
WHERE allocation_units.type IN (1,2,3)
AND objects.is_ms_shipped = 0
AND dm_os_buffer_descriptors.database_id = DB_ID()
GROUP BY indexes.name,
         objects.name,
         objects.type_desc
ORDER BY COUNT(*) DESC;
~~~
#

#### Esta consulta es casi la misma que nuestra última, excepto que hacemos una combinación adicional a sys.indexes, y agrupamos en el nombre del índice en adición al nombre de la tabla/vista. Los resultados proveen incluso más detalles acerca de cómo la caché del búfer está siendo usada, y pueden ser valiosos en tablas con muchos índices de uso variado:



#### Los resultados pueden ser útiles cuando se trata de determinar el nivel general de uso para un índice específico en cualquier momento. Adicionalmente, nos permite estimar cuánto de un índice está siendo leído, comparado con su tamaño general.

#### Para recolectar el porcentaje de cada tabla que está en la memoria, podemos poner esa consulta en un CTE y comparar las páginas en memoria versus el total para cada tabla:
# 
~~~sql
WITH CTE_BUFFER_CACHE AS (
    SELECT
        objects.name AS object_name,
        objects.type_desc AS object_type_description,
        objects.object_id,
        COUNT(*) AS buffer_cache_pages,
        COUNT(*) * 8 / 1024  AS buffer_cache_used_MB
    FROM sys.dm_os_buffer_descriptors
    INNER JOIN sys.allocation_units
    ON allocation_units.allocation_unit_id = dm_os_buffer_descriptors.allocation_unit_id
    INNER JOIN sys.partitions
    ON ((allocation_units.container_id = partitions.hobt_id AND type IN (1,3))
    OR (allocation_units.container_id = partitions.partition_id AND type IN (2)))
    INNER JOIN sys.objects
    ON partitions.object_id = objects.object_id
    WHERE allocation_units.type IN (1,2,3)
    AND objects.is_ms_shipped = 0
    AND dm_os_buffer_descriptors.database_id = DB_ID()
    GROUP BY objects.name,
             objects.type_desc,
             objects.object_id)
SELECT
    PARTITION_STATS.name,
    CTE_BUFFER_CACHE.object_type_description,
    CTE_BUFFER_CACHE.buffer_cache_pages,
    CTE_BUFFER_CACHE.buffer_cache_used_MB,
    PARTITION_STATS.total_number_of_used_pages,
    PARTITION_STATS.total_number_of_used_pages * 8 / 1024 AS 
    total_mb_used_by_object,
    CAST((CAST(CTE_BUFFER_CACHE.buffer_cache_pages AS DECIMAL) / 
    CAST(PARTITION_STATS.total_number_of_used_pages AS DECIMAL) 
    * 100) AS DECIMAL(5,2)) AS percent_of_pages_in_memory
FROM CTE_BUFFER_CACHE
INNER JOIN (
    SELECT 
        objects.name,
        objects.object_id,
        SUM(used_page_count) AS total_number_of_used_pages
    FROM sys.dm_db_partition_stats
    INNER JOIN sys.objects
    ON objects.object_id = dm_db_partition_stats.object_id
    WHERE objects.is_ms_shipped = 0
    GROUP BY objects.name, objects.object_id) PARTITION_STATS
ON PARTITION_STATS.object_id = CTE_BUFFER_CACHE.object_id
ORDER BY CAST(CTE_BUFFER_CACHE.buffer_cache_pages AS DECIMAL) / 
CAST(PARTITION_STATS.total_number_of_used_pages AS DECIMAL) DESC;
~~~
# 

# 
#### Esta consulta combina nuestro conjunto previo de datos con una consulta en sys.dm_db_partition_stats para comparar lo que está actualmente en la caché del búfer versus el espacio total usado por cualquier tabla dada. Las muchas operaciones CAST al final ayudan a evitar el truncado y hacen al resultado final fácil de leer. Los resultados en mi servidor local son los siguientes:



#### Estos datos nos dicen qué tablas están las zonas calientes en nuestra base de datos, y con un poco de conocimiento de su uso de aplicación, podemos determinar cuáles simplemente tienen demasiados datos residiendo en la memoria. Las tablas pequeñas son probablemente no muy importantes para nosotros aquí. Por ejemplo, las primeras cuatro en la salida anterior están debajo de un megabyte y si quisiéramos omitirlas, podríamos filtrar los resultados para retornar solamente tablas más grandes que un tamaño específico de interés.

#### Por otra parte, estos datos nos dicen que ¾ de SalesOrderDetail está en la caché del búfer. Si esto pareciera inusual, consultaría la caché del plan de consultas y determinaría si hay alguna consulta ineficiente en la tabla que está seleccionando *, o una cantidad excesivamente grande de datos. Combinando nuestras métricas desde la caché del búfer y la caché del plan, podemos idear nuevas maneras de determinar con precisión mañas consultas o aplicaciones que están jalando muchos más datos de lo que requieren.

#### Esta consulta puede ser modificada para proveer el porcentaje de un índice que está siendo usado también, de forma similar a cómo recolectamos el porcentaje de una tabla usada:
## 
# 
~~~sql
SELECT
    indexes.name AS index_name,
    objects.name AS object_name,
    objects.type_desc AS object_type_description,
    COUNT(*) AS buffer_cache_pages,
    COUNT(*) * 8 / 1024  AS buffer_cache_used_MB,
    SUM(allocation_units.used_pages) AS pages_in_index,
    SUM(allocation_units.used_pages) * 8 /1024 AS 
    total_index_size_MB,
    CAST((CAST(COUNT(*) AS DECIMAL) / CAST(SUM(allocation_units.
    used_pages) AS DECIMAL) * 100) AS DECIMAL(5,2)) AS 
    percent_of_pages_in_memory
FROM sys.dm_os_buffer_descriptors
INNER JOIN sys.allocation_units
ON allocation_units.allocation_unit_id = dm_os_buffer_descriptors.allocation_unit_id
INNER JOIN sys.partitions
ON ((allocation_units.container_id = partitions.hobt_id AND type IN (1,3))
OR (allocation_units.container_id = partitions.partition_id AND type IN (2)))
INNER JOIN sys.objects
ON partitions.object_id = objects.object_id
INNER JOIN sys.indexes
ON objects.object_id = indexes.object_id
AND partitions.index_id = indexes.index_id
WHERE allocation_units.type IN (1,2,3)
AND objects.is_ms_shipped = 0
AND dm_os_buffer_descriptors.database_id = DB_ID()
GROUP BY indexes.name,
         objects.name,
         objects.type_desc
ORDER BY CAST((CAST(COUNT(*) AS DECIMAL) / CAST(SUM
(allocation_units.used_pages) AS DECIMAL) * 100) AS DECIMAL(5,
2)) DESC;
~~~
#

#### Dado que ***sys.allocation_units*** provee algo de información acerca del tamaño de nuestros índices, evitamos la necesidad de **CTEs** y conjuntos de datos adicionales de dm_db_partition_stats. Aquí está un pedazo de los resultados, mostrando el tamaño del índice (MB y páginas) y el espacio usado de la caché del búfer (MB y páginas):



#### Si estuviéramos poco interesados en tablas/índices pequeños, podríamos añadir una cláusula HAVING a la consulta para filtrar por un índice que es más pequeño que un tamaño especificado, en MB o páginas. Estos datos proveen una vista de la eficiencia de las consultas en índices específicos y podría asistir en la limpieza de índices, el ajuste de índices o algún ajuste más granular del uso de la memoria en su SQL Server.

#### Una columna interesante en dm_os_buffer_descriptors es free_space_in_bytes. Esta columna nos dice cuán llena está cada página en la caché del búfer, y por lo tanto provee un indicador del espacio potencial desperdiciado o la ineficiencia. Podemos determinar el porcentaje de páginas que han sido tomadas por el espacio libre, en lugar de datos, para cada base de datos en nuestro servidor:
#

~~~sql
WITH CTE_BUFFER_CACHE AS
( SELECT
  databases.name AS database_name,
  COUNT(*) AS total_number_of_used_pages,
  CAST(COUNT(*) * 8 AS DECIMAL) / 1024 AS buffer_cache_total_MB,
  CAST(CAST(SUM(CAST(dm_os_buffer_descriptors.
  free_space_in_bytes AS BIGINT)) AS DECIMAL) / (1024 * 1024) AS 
  DECIMAL(20,2))  AS buffer_cache_free_space_in_MB
 FROM sys.dm_os_buffer_descriptors
 INNER JOIN sys.databases
 ON databases.database_id = dm_os_buffer_descriptors.database_id
 GROUP BY databases.name)
SELECT
 *,
 CAST((buffer_cache_free_space_in_MB / NULLIF
 (buffer_cache_total_MB, 0)) * 100 AS DECIMAL(5,2)) AS 
 buffer_cache_percent_free_space
FROM CTE_BUFFER_CACHE
ORDER BY buffer_cache_free_space_in_MB / NULLIF
(buffer_cache_total_MB, 0) DESC
~~~ 
#

#### Esto retorna una fila por base de datos que muestra la agregación de espacio libre por base de datos, sumada a través de todas las páginas en la caché del búfer para esa base de datos particular:



#### Esto es interesante, pero no muy útil todavía debido a que estos resultados no son muy específicos. Nos dicen que una base de datos puede tener un poco de espacio desperdiciado, pero no mucho sobre qué tablas son las causantes. Tomemos el mismo enfoque que hicimos anteriormente y devolvemos espacio libre por tabla en una base de datos dada:
#

~~~sql
SELECT
    objects.name AS object_name,
    objects.type_desc AS object_type_description,
    COUNT(*) AS buffer_cache_pages,
    CAST(COUNT(*) * 8 AS DECIMAL) / 1024  AS 
    buffer_cache_total_MB,
    CAST(SUM(CAST(dm_os_buffer_descriptors.free_space_in_bytes 
    AS BIGINT)) AS DECIMAL) / 1024 / 1024 AS 
    buffer_cache_free_space_in_MB,
    CAST((CAST(SUM(CAST(dm_os_buffer_descriptors.
    free_space_in_bytes AS BIGINT)) AS DECIMAL) / 1024 / 1024) / 
    (CAST(COUNT(*) * 8 AS DECIMAL) / 1024) * 100 AS DECIMAL(5,
    2)) AS buffer_cache_percent_free_space
FROM sys.dm_os_buffer_descriptors
INNER JOIN sys.allocation_units
ON allocation_units.allocation_unit_id = dm_os_buffer_descriptors.allocation_unit_id
INNER JOIN sys.partitions
ON ((allocation_units.container_id = partitions.hobt_id AND type IN (1,3))
OR (allocation_units.container_id = partitions.partition_id AND type IN (2)))
INNER JOIN sys.objects
ON partitions.object_id = objects.object_id
WHERE allocation_units.type IN (1,2,3)
AND objects.is_ms_shipped = 0
AND dm_os_buffer_descriptors.database_id = DB_ID()
GROUP BY objects.name,
            objects.type_desc,
            objects.object_id
HAVING COUNT(*) > 0
ORDER BY COUNT(*) DESC;
~~~
# 

#### Esto devuelve una fila por tabla o vista indexada que tiene al menos una página en la memoria caché del búfer ordenada primeramente por aquellos que tienen la mayor cantidad de páginas en memoria.



#### ¿Qué significa exactamente? Cuanto más espacio libre por página existe en promedio, más páginas hay que leer para retornar los datos que estamos buscando. Además, se requieren más páginas para almacenar datos, lo que significa que se necesita más espacio en la memoria y en disco para mantener nuestros datos. El espacio perdido también significa más E/S para obtener los datos que necesitamos y las consultas se ejecutan más tiempo de lo necesario a medida que se recuperan estos datos.

#### La causa más común de un exceso de espacio libre son las tablas con filas muy amplias. Puesto que una página es de 8k, si una fila pasó a ser de 5k, nunca seríamos capaces de encajar una sola fila en una página, y siempre habrá ese extra de ~3k de espacio libre que no se puede utilizar. Las tablas con muchas operaciones de inserción aleatoria pueden ser problemáticas también. Por ejemplo, una clave que no aumenta puede resultar en divisiones de página cuando los datos se escriben en diferente orden. Un GUID sería el peor de los casos, pero cualquier clave que no está aumentando de manera natural puede dar lugar a este problema hasta cierto punto.

#### A medida que los índices se fragmentan con el tiempo, la fragmentación se verá en parte como un exceso de espacio libre cuando observamos el contenido de la caché del búfer. La mayoría de estos problemas se resuelven con un diseño inteligente de bases de datos y un mantenimiento razonable de la base de datos. Este no es el lugar para entrar en detalles sobre esos temas, pero hay muchos artículos y presentaciones sobre estos temas en la red para su entretenimiento.

#### Al principio de este artículo, discutimos brevemente qué páginas sucias y limpias son y su correlación con las operaciones de escritura dentro de una base de datos. Dentro de dm_os_buffer_descriptors podemos verificar si una página está limpia o no está usando la columna is_modified. Esta nos dice si una página ha sido modificada por una operación de escritura, pero aún no se ha escrito en disco. Podemos usar esta información para contar las páginas limpias y sucias en la caché del búfer para una base de datos determinada:
# 

~~~sql
SELECT
    databases.name AS database_name,
    COUNT(*) AS buffer_cache_total_pages,
    SUM(CASE WHEN dm_os_buffer_descriptors.is_modified = 1
                THEN 1
                ELSE 0
        END) AS buffer_cache_dirty_pages,
    SUM(CASE WHEN dm_os_buffer_descriptors.is_modified = 1
                THEN 0
                ELSE 1
        END) AS buffer_cache_clean_pages,
    SUM(CASE WHEN dm_os_buffer_descriptors.is_modified = 1
                THEN 1
                ELSE 0
        END) * 8 / 1024 AS buffer_cache_dirty_page_MB,
    SUM(CASE WHEN dm_os_buffer_descriptors.is_modified = 1
                THEN 0
                ELSE 1
        END) * 8 / 1024 AS buffer_cache_clean_page_MB
FROM sys.dm_os_buffer_descriptors
INNER JOIN sys.databases
ON dm_os_buffer_descriptors.database_id = databases.database_id
GROUP BY databases.name;
~~~
# 
#### Esta consulta devuelve el número de páginas y el tamaño de los datos en MB:



#### Mi servidor no tiene mucho por el momento. Si corriera una gran sentencia de actualización, podríamos ilustrar qué veríamos cuando más operaciones de escritura están ocurriendo. Corramos la siguiente consulta:
#

~~~sql
UPDATE Sales.SalesOrderDetail
    SET OrderQty = OrderQty
~~~
# 
#### Esto es esencialmente una no-operación y no resultará en ningún cambio real a la tabla SalesOrderDetail – pero SQL Server aún pasará por el problema de actualizar cada fila en la tabla para esta columna particular. Si corremos el conteo de páginas sucias/limpias desde arriba, obtendremos algunos resultados interesantes:



#### Cerca de 2/3 de las páginas para AdventureWorks2014 en la caché del búfer están sucios. Adicionalmente, TempDB también tiene bastante actividad, lo cual es indicativo del desencadenador update/insert/delete en la tabla, lo que causó que se ejecutara una gran cantidad de T-SQL adicional. El desencadenador causó que haya bastantes lecturas contra AdventureWorks2014, así como la necesidad de trabajo de tablas en TempDB para procesar esas operaciones adicionales.

#### Como antes, podemos dividir esta tabla o índice para recolectar datos más granulares acerca del uso de la caché del búfer:
# 

~~~sql
SELECT
    indexes.name AS index_name,
    objects.name AS object_name,
    objects.type_desc AS object_type_description,
    COUNT(*) AS buffer_cache_total_pages,
    SUM(CASE WHEN dm_os_buffer_descriptors.is_modified = 1
                THEN 1
                ELSE 0
        END) AS buffer_cache_dirty_pages,
    SUM(CASE WHEN dm_os_buffer_descriptors.is_modified = 1
                THEN 0
                ELSE 1
        END) AS buffer_cache_clean_pages,
    SUM(CASE WHEN dm_os_buffer_descriptors.is_modified = 1
                THEN 1
                ELSE 0
        END) * 8 / 1024 AS buffer_cache_dirty_page_MB,
    SUM(CASE WHEN dm_os_buffer_descriptors.is_modified = 1
                THEN 0
                ELSE 1
        END) * 8 / 1024 AS buffer_cache_clean_page_MB
FROM sys.dm_os_buffer_descriptors
INNER JOIN sys.allocation_units
ON allocation_units.allocation_unit_id = dm_os_buffer_descriptors.allocation_unit_id
INNER JOIN sys.partitions
ON ((allocation_units.container_id = partitions.hobt_id AND type IN (1,3))
OR (allocation_units.container_id = partitions.partition_id AND type IN (2)))
INNER JOIN sys.objects
ON partitions.object_id = objects.object_id
INNER JOIN sys.indexes
ON objects.object_id = indexes.object_id
AND partitions.index_id = indexes.index_id
WHERE allocation_units.type IN (1,2,3)
AND objects.is_ms_shipped = 0
AND dm_os_buffer_descriptors.database_id = DB_ID()
GROUP BY indexes.name,
         objects.name,
         objects.type_desc
ORDER BY COUNT(*) DESC;
~~~

# 

#### Los resultados muestran el uso de la caché del búfer por índice, mostrando cuántas páginas en la memoria están limpias o sucias:



#### Estos datos proveen una idea de la actividad de escritura en un índice dado en este punto del tiempo. Si fuera rastrado en un periodo de días o semanas, podríamos comenzar a estimar la actividad de escritura general del índice y proyectar una tendencia. Esta investigación podría ser útil si usted estuviera buscando entender el mejor nivel posible de aislamiento para usarse en una base de datos, o si esos reportes que siempre son corridos con READ UNCOMMITED podrían ser más susceptibles a lecturas sucias que lo pensado originalmente. En este caso específico, las páginas sucias todas se relacionan con la consulta de actualización que corrimos previamente, y por lo tanto abarcan un conjunto algo limitado.


<!-- Finalizamos aqui con las Memorias y paginaciones en Sql server -->













# Información general de mantenimiento del índice SQL<a name="inf_mant_indices"><a/>

[![IMAGE ALT TEXT](https://learn.microsoft.com/es-es/sql/relational-databases/media/sql-server-index-design-guide/hash-index-buckets.png?view=sql-server-ver16)

#### El problema en un mantenimiento de índices y del rendimiento es la fragmentación del índice. Es posible que ya estés familiarizado con el término de fragmentación del sistema operativo y del disco duro. La fragmentación es lo que arruina nuestros índices y, claro, los discos duros en el entorno del sistema operativo (No tanto desde que salen las unidades físicamente). A medida que los datos entran y salen, se modifica, etc. las cosas deben moverse. Esto implica una gran cantidad de actividad de lecturas y escrituras en nuestros discos duros.

#### La fragmentación es básicamente el poder almacenar datos de forma no contigua en el disco. Entonces, la idea principal es de intentar de mantenerlo de forma contigua (en secuencia) ya que, si los datos se almacenan de manera contigua, es mucho menos el trabajo para nuestro sistema operativo y el subsistema del I/O ya que sólo se deben manejar las cosas de manera secuencial. Por otro lado, cuando los datos están en desorden, entonces el sistema operativo debe saltar por diferentes lugares. Siempre me gusta explicar las cosas usando una analogía del mundo real y para los índices, siempre uso una agenda normal o una guía telefónica para poder explicar la recuperación de datos ya es mucho más fácil de poder entender. Pero para la desfragmentación, yo creo que el mejor ejemplo sería el de un estante para libros.


# Obtener los tiempos de duración de un Job en secuancia horaria
![](https://docs.microsoft.com/es-es/sql/database-engine/availability-groups/windows/media/always-onag-datasynchronization.gif?view=sql-server-ver15)
#### Esta consulta, sirve para mostrar en forma de columnas, hora a hora, el tiempo de ejecucion de un Job determinado


# 

# Procedimiento para localizar tablas sin Closther Index en las bases de datos.<a name="tablasinclusterindex"></a>

<img src="https://s33046.pcdn.co/wp-content/uploads/2018/11/word-image-339.png?format=jpg&name=large" alt="JuveR" width="600px">

# 
~~~sql
/*
Alejandro Jimenez lunes 4 de Febrero 2019
*/

DECLARE @DataBaseNema varchar(20) = 'INABIMA'

SELECT TOP ( 10000 ) o.name, ius.user_seeks, ius.user_scans, ius.user_lookups, ius.user_updates --, *
FROM sys.indexes i
INNER JOIN sys.objects o
    ON i.object_id = o.object_id
INNER JOIN sys.partitions p
    ON  i.object_id = p.object_id
    AND i.index_id = p.index_id
INNER JOIN sys.databases sd
    ON sd.name =@DataBaseNema
LEFT OUTER JOIN sys.dm_db_index_usage_stats ius
    ON  i.object_id = ius.object_id
    AND i.index_id = ius.index_id
    AND ius.database_id = sd.database_id
WHERE i.type_desc = 'HEAP'
AND   COALESCE(ius.user_seeks, ius.user_scans, ius.user_lookups, ius.user_updates) IS NOT NULL
AND   (ius.user_seeks + ius.user_scans + ius.user_lookups + ius.user_updates) > 0
AND   sd.name <> 'tempdb'
AND   o.is_ms_shipped = 0
AND   o.type <> 'S'
ORDER BY (ius.user_seeks + ius.user_scans + ius.user_lookups + ius.user_updates) DESC, o.name;
~~~

### Por supuesto, aquí tienes un ejemplo de una consulta SQL que busca las tablas que no tienen una clave primaria definida en una base de datos:

~~~sql
--USE nombre_de_tu_base_de_datos;
SELECT
    t.name AS 'Nombre de la tabla'
FROM
    sys.tables t
WHERE
    NOT EXISTS (
        SELECT 1
        FROM sys.indexes i
        WHERE i.object_id = t.object_id AND i.is_primary_key = 1
    )
ORDER BY
    t.name;
~~~


# 
### La responsabilidad más importante de un Administrador de bases de datos es el poder garantizar que las bases de datos trabajen de una forma óptima. La manera más eficiente de hacerlo es por medio de índices. Los índices en SQL son uno de los recursos más efectivos a la hora de obtener una ganancia en el rendimiento. Sin embargo, lo que sucede con los índices es que estos se deterioran con el tiempo.
### -- Missing Index Script<a name="missinindex"></a>
# 
~~~sql
-- Missing Index Script
-- Original Author: Pinal Dave 
SELECT TOP 25
dm_mid.database_id AS DatabaseID,
dm_migs.avg_user_impact*(dm_migs.user_seeks+dm_migs.user_scans) Avg_Estimated_Impact,
dm_migs.last_user_seek AS Last_User_Seek,
OBJECT_NAME(dm_mid.OBJECT_ID,dm_mid.database_id) AS [TableName],
'CREATE INDEX [IX_' + OBJECT_NAME(dm_mid.OBJECT_ID,dm_mid.database_id) + '_'
+ REPLACE(REPLACE(REPLACE(ISNULL(dm_mid.equality_columns,''),', ','_'),'[',''),']','') 
+ CASE
WHEN dm_mid.equality_columns IS NOT NULL
AND dm_mid.inequality_columns IS NOT NULL THEN '_'
ELSE ''
END
+ REPLACE(REPLACE(REPLACE(ISNULL(dm_mid.inequality_columns,''),', ','_'),'[',''),']','')
+ ']'
+ ' ON ' + dm_mid.statement
+ ' (' + ISNULL (dm_mid.equality_columns,'')
+ CASE WHEN dm_mid.equality_columns IS NOT NULL AND dm_mid.inequality_columns 
IS NOT NULL THEN ',' ELSE
'' END
+ ISNULL (dm_mid.inequality_columns, '')
+ ')'
+ ISNULL (' INCLUDE (' + dm_mid.included_columns + ')', '') AS Create_Statement
FROM sys.dm_db_missing_index_groups dm_mig
INNER JOIN sys.dm_db_missing_index_group_stats dm_migs
ON dm_migs.group_handle = dm_mig.index_group_handle
INNER JOIN sys.dm_db_missing_index_details dm_mid
ON dm_mig.index_handle = dm_mid.index_handle
WHERE dm_mid.database_ID = DB_ID()
ORDER BY Avg_Estimated_Impact DESC
GO
~~~
# 
#### Missing index para Servidores AlwaysOn.
#### Solo funciona con Sql Server Enterprise Edition
~~~sql
-- Missing Index Script
-- Original Author: Pinal Dave 
SELECT TOP 25
dm_mid.database_id AS DatabaseID,
dm_migs.avg_user_impact*(dm_migs.user_seeks+dm_migs.user_scans) Avg_Estimated_Impact,
dm_migs.last_user_seek AS Last_User_Seek,
OBJECT_NAME(dm_mid.OBJECT_ID,dm_mid.database_id) AS [TableName],
'CREATE INDEX [IX_' + OBJECT_NAME(dm_mid.OBJECT_ID,dm_mid.database_id) + '_'
+ REPLACE(REPLACE(REPLACE(ISNULL(dm_mid.equality_columns,''),', ','_'),'[',''),']','') 
+ CASE
WHEN dm_mid.equality_columns IS NOT NULL
AND dm_mid.inequality_columns IS NOT NULL THEN '_'
ELSE ''
END
+ REPLACE(REPLACE(REPLACE(ISNULL(dm_mid.inequality_columns,''),', ','_'),'[',''),']','')
+ ']'
+ ' ON ' + dm_mid.statement
+ ' (' + ISNULL (dm_mid.equality_columns,'')
+ CASE WHEN dm_mid.equality_columns IS NOT NULL AND dm_mid.inequality_columns 
IS NOT NULL THEN ',' ELSE
'' END
+ ISNULL (dm_mid.inequality_columns, '')
+ ')'
+ ISNULL (' INCLUDE (' + dm_mid.included_columns + ')', ''+' WITH (ONLINE = ON);' )  AS Create_Statement
FROM sys.dm_db_missing_index_groups dm_mig
INNER JOIN sys.dm_db_missing_index_group_stats dm_migs
ON dm_migs.group_handle = dm_mig.index_group_handle
INNER JOIN sys.dm_db_missing_index_details dm_mid
ON dm_mig.index_handle = dm_mid.index_handle
WHERE dm_mid.database_ID = DB_ID()
ORDER BY Avg_Estimated_Impact DESC
GO
~~~

# 
## Creacion de Indices Filtrados, Usando N cores del servidor
#### Sí, en SQL Server, puedes crear un índice que utilice una cantidad específica de núcleos (cores) para mejorar el rendimiento de las consultas. Esto se conoce como un "índice particionado" o un "índice filtrado". Sin embargo, es importante destacar que SQL Server generalmente gestiona la asignación de recursos de manera automática y utiliza múltiples núcleos para procesar consultas de manera eficiente sin que necesites especificar la cantidad de núcleos en un índice.

#### Dicho esto, puedes crear un índice particionado o filtrado para mejorar el rendimiento en situaciones específicas, pero esto no implica la asignación manual de núcleos. A continuación, te explico cómo crear estos tipos de índices:

1. **Índice Particionado:** Un índice particionado divide una tabla en varias particiones y permite que SQL Server almacene y administre los datos de manera más eficiente. Para crear un índice particionado, primero debes definir una función de partición y esquema de partición en tu base de datos y luego crear el índice utilizando estas particiones. No necesitas especificar la cantidad de núcleos.

```sql
-- Ejemplo de creación de un índice particionado en SQL Server
CREATE PARTITION FUNCTION MiFuncionParticion ()
AS RANGE LEFT FOR VALUES (1, 2, 3);

CREATE PARTITION SCHEME MiEsquemaParticion
AS PARTITION MiFuncionParticion
ALL TO ([PRIMARY]);

CREATE CLUSTERED INDEX MiIndiceParticionado
ON MiTabla (Columna)
ON MiEsquemaParticion(Columna);
```

2. **Índice Filtrado:** Un índice filtrado es un índice que solo incluye un subconjunto de filas de la tabla. Esto puede ayudar a mejorar el rendimiento en consultas específicas si solo necesitas acceder a una parte de los datos.

```sql
-- Ejemplo de creación de un índice filtrado en SQL Server
CREATE NONCLUSTERED INDEX MiIndiceFiltrado
ON MiTabla (Columna)
WHERE Condición;
```

#### Ten en cuenta que la gestión de núcleos y recursos en SQL Server se realiza automáticamente a nivel del motor de base de datos. Si experimentas problemas de rendimiento, en lugar de intentar asignar núcleos manualmente, es recomendable realizar un ajuste de consultas, revisar la configuración del servidor y utilizar herramientas de monitoreo para identificar cuellos de botella y optimizar el rendimiento.


# 

# Procedimiento MeasureIndexImprovement<a name="MeasureIndexImprovement"></a>

## Descripción
El procedimiento almacenado `MeasureIndexImprovement` mide la mejora en el uso de índices en una base de datos de SQL Server entre dos fechas especificadas. Recopila datos sobre el uso de índices al inicio y al final del período dado y compara los resultados para mostrar la mejora en búsquedas (`seeks`), escaneos (`scans`), consultas (`lookups`) y actualizaciones (`updates`) para cada índice.

## Parámetros
- `@StartDate DATETIME`: La fecha de inicio para medir el uso de índices.
- `@EndDate DATETIME`: La fecha de fin para medir el uso de índices.

## Funcionalidad
1. **Recopilación de Datos Iniciales**: Recopila estadísticas de uso de índices en la fecha de inicio y las almacena en una tabla temporal.
2. **Recopilación de Datos Finales**: Recopila estadísticas de uso de índices en la fecha de fin y las almacena en otra tabla temporal.
3. **Comparación**: Compara los datos iniciales y finales para calcular la mejora en búsquedas, escaneos, consultas y actualizaciones para cada índice.
4. **Salida**: Muestra los resultados de la comparación, mostrando el nombre de la base de datos, nombre de la tabla, ID del índice, nombre del índice, estadísticas de uso iniciales, estadísticas de uso finales y la mejora en cada estadística.

## Código SQL

~~~sql
CREATE PROCEDURE MeasureIndexImprovement
    @StartDate DATETIME,
    @EndDate DATETIME
AS
BEGIN
    -- Crea una tabla temporal para almacenar el uso inicial de los índices
    CREATE TABLE #InitialIndexUsageStats (
        DatabaseName NVARCHAR(128),
        TableName NVARCHAR(128),
        IndexID INT,
        IndexName NVARCHAR(128),
        UserSeeks BIGINT,
        UserScans BIGINT,
        UserLookups BIGINT,
        UserUpdates BIGINT
    );

    -- Recopila datos sobre el uso de índices en la fecha de inicio
    INSERT INTO #InitialIndexUsageStats
    SELECT 
        DB_NAME(s.database_id) AS DatabaseName,
        OBJECT_NAME(s.object_id) AS TableName,
        s.index_id AS IndexID,
        i.name AS IndexName,
        s.user_seeks AS UserSeeks,
        s.user_scans AS UserScans,
        s.user_lookups AS UserLookups,
        s.user_updates AS UserUpdates
    FROM 
        sys.dm_db_index_usage_stats s
    INNER JOIN 
        sys.indexes i ON s.object_id = i.object_id AND s.index_id = i.index_id
    WHERE 
        s.database_id = DB_ID() 
        AND s.last_user_seek >= @StartDate
        AND s.last_user_seek < DATEADD(day, 1, @EndDate);

    -- Crea una tabla temporal para almacenar el uso final de los índices
    CREATE TABLE #FinalIndexUsageStats (
        DatabaseName NVARCHAR(128),
        TableName NVARCHAR(128),
        IndexID INT,
        IndexName NVARCHAR(128),
        UserSeeks BIGINT,
        UserScans BIGINT,
        UserLookups BIGINT,
        UserUpdates BIGINT
    );

    -- Recopila datos sobre el uso de índices en la fecha de fin
    INSERT INTO #FinalIndexUsageStats
    SELECT 
        DB_NAME(s.database_id) AS DatabaseName,
        OBJECT_NAME(s.object_id) AS TableName,
        s.index_id AS IndexID,
        i.name AS IndexName,
        s.user_seeks AS UserSeeks,
        s.user_scans AS UserScans,
        s.user_lookups AS UserLookups,
        s.user_updates AS UserUpdates
    FROM 
        sys.dm_db_index_usage_stats s
    INNER JOIN 
        sys.indexes i ON s.object_id = i.object_id AND s.index_id = i.index_id
    WHERE 
        s.database_id = DB_ID() 
        AND s.last_user_seek >= @EndDate
        AND s.last_user_seek < DATEADD(day, 1, @EndDate);

    -- Compara los datos antes y después de los cambios
    SELECT 
        COALESCE(initial.DatabaseName, final.DatabaseName) AS DatabaseName,
        COALESCE(initial.TableName, final.TableName) AS TableName,
        COALESCE(initial.IndexID, final.IndexID) AS IndexID,
        COALESCE(initial.IndexName, final.IndexName) AS IndexName,
        ISNULL(initial.UserSeeks, 0) AS InitialUserSeeks,
        ISNULL(final.UserSeeks, 0) AS FinalUserSeeks,
        (ISNULL(final.UserSeeks, 0) - ISNULL(initial.UserSeeks, 0)) AS ImprovementInSeeks,
        ISNULL(initial.UserScans, 0) AS InitialUserScans,
        ISNULL(final.UserScans, 0) AS FinalUserScans,
        (ISNULL(final.UserScans, 0) - ISNULL(initial.UserScans, 0)) AS ImprovementInScans,
        ISNULL(initial.UserLookups, 0) AS InitialUserLookups,
        ISNULL(final.UserLookups, 0) AS FinalUserLookups,
        (ISNULL(final.UserLookups, 0) - ISNULL(initial.UserLookups, 0)) AS ImprovementInLookups,
        ISNULL(initial.UserUpdates, 0) AS InitialUserUpdates,
        ISNULL(final.UserUpdates, 0) AS FinalUserUpdates,
        (ISNULL(final.UserUpdates, 0) - ISNULL(initial.UserUpdates, 0)) AS ImprovementInUpdates
    FROM 
        #InitialIndexUsageStats initial
    FULL OUTER JOIN 
        #FinalIndexUsageStats final
    ON 
        initial.DatabaseName = final.DatabaseName
        AND initial.TableName = final.TableName
        AND initial.IndexID = final.IndexID
    ORDER BY 
        COALESCE(initial.TableName, final.TableName), 
        COALESCE(initial.IndexID, final.IndexID);

    -- Limpia las tablas temporales
    DROP TABLE #InitialIndexUsageStats;
    DROP TABLE #FinalIndexUsageStats;
END;
GO

-- Ejecuta el procedimiento almacenado con las fechas deseadas
EXEC MeasureIndexImprovement '2024-05-01', '2024-06-28';
~~~

## Cómo Usarlo
1. Crea el procedimiento almacenado en tu base de datos de SQL Server ejecutando el código SQL proporcionado.
2. Ejecuta el procedimiento almacenado con las fechas de inicio y fin deseadas para medir la mejora en el uso de índices:
   ~~~sql
   EXEC MeasureIndexImprovement 'YYYY-MM-DD', 'YYYY-MM-DD';
   ~~~
   Reemplaza `'YYYY-MM-DD'` con las fechas de inicio y fin que desees.

## Ejemplo de Ejecución
Para medir la mejora en el uso de índices entre el 1 de mayo de 2024 y el 28 de junio de 2024:
~~~sql
EXEC MeasureIndexImprovement '2024-05-01', '2024-06-28';
~~~

Esto mostrará los resultados de la comparación, mostrando las estadísticas de uso iniciales y finales de los índices y la mejora en búsquedas, escaneos, consultas y actualizaciones para cada índice.





# Indices no Utilizados<a name="indicesnoutilizados"></a>
![](https://s33046.pcdn.co/wp-content/uploads/2018/05/word-image-103.png)
#### Es comun tambien que en dichos procesos algunas tablas (generalmente las muy usadas) acumulen una cantidad de indices y algunos no siempre son utilizados por la aplicacion. 
#### El mantener dichos indices empeora la performance de los inserts y tambien hacen demorar mas al optimizador pues tiene mas opciones para analizar.


#### Leyendo el libro Relational Database Index Design and the Optimizers pude ver cuantificado las demoras que puede ocasionar el tener indices de mas en tablas con millones de registros.

#### Por suerte los muchachos de Microsoft, en SQL Server 2005,2008,2012,2014, mejoraron muchisimo la metadata que se mantiene para ver que indices se utilizan y cuales no. Por ejemplo con la consulta
# 

~~~sql
--Indices no usados ***
SELECT 'NOUsado',object_name(i.object_id) AS ObjectName 
, i.name as IndexName 
, i.index_id 
FROM sys.indexes i 
INNER JOIN sys.objects o ON o.object_id = i.object_id
LEFT JOIN sys.dm_db_index_usage_stats s 
ON i.object_id=s.object_id AND i.index_id=s.index_id AND database_id = DB_ID() 
WHERE objectproperty(o.object_id,'IsUserTable') = 1 AND s.index_id IS NULL 
ORDER BY objectname,i.index_id,indexname ASC

~~~
# 
# 


~~~sql
DECLARE @JobName VARCHAR(255) = null -- 'TablasFechasAccesos'
  
;WITH JobHistory AS
(
  SELECT
     @@servername as ServerName,
     a.run_date
    ,a.run_time / 10000 AS [HOUR]
    ,(a.run_duration / 10000 * 60 * 60  -- Hours
     + a.run_duration % 10000 / 100 * 60    -- Minutes
     + a.run_duration % 100         -- Seconds
     ) / 60.0 AS [DurationMinutes]
  FROM
    msdb.dbo.sysjobhistory a WITH(NOLOCK)
    INNER JOIN msdb.dbo.sysjobs b WITH(NOLOCK) --Ob
    ON
      a.[job_id] = b.[job_id]
      AND( b.[name] = @JobName or @JobName is null)
      AND step_id = 0
      AND run_status = 1
)
SELECT *
FROM
  JobHistory    
  PIVOT
  ( SUM(DurationMinutes)
    FOR [HOUR] 
    IN  ([00],[01],[02],[03],[04],[05]
        ,[06],[07],[08],[09],[10],[11]
        ,[12],[13],[14],[15],[16],[17]
        ,[18],[19],[20],[21],[22],[23])
  ) AS p
~~~

# 

# Tablas de montón<a name="tablasmonton"><a/>
![](https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRVThSd-LNtk5AvCmeFjEojJJY6Z7twd_IYng&usqp=CAU)
#### Las tablas de montón son tablas que contienen índices no Agrupados. Esto significa que las filas de información en la tabla de montón, no están almacenadas en ningún orden particular en cada página de información. Además no hay un orden particular para controlar la secuencia de páginas de información, que no está unida en una lista conectada. Como resultado, recuperar información de insertar o modificar en la tabla montón será muy lento y puede ser fragmentado más fácilmente.

#### Para más información sobre tablas de montón revisar Resumen de estructura de tablas SQL Server

#### Necesitas primero identificar las tablas montón en tu base de datos y concentrarte solo en las tablas grandes, ya que el Optimizador de Consultas de SQL Server no se beneficiará de los índices creados en tablas más pequeñas. Tablas de montón pueden ser detectadas al consultar objetos sys.indexes system, en conjunción con otros sistemas de vistas de catálogo, para recuperar información significante, como se muestra en el Detectar Indices no utilizados en SQLServer<a name="indicesnoutilizados2"><a/>
# 

# Detectar Indices no utilizados en SQLServer
## Me he basado en las siguientes consultas:

#### He utilizado las siguientes consultas añado las fuentes para poder obtener más información.
#### Esta primera indica aquellos indices que no se realizan consultas de lectura solo de escritura actualizaciones y inserciones, por lo que es una sobrecarga del sistema por lo que son candidatos a ser eliminados.
# 
~~~sql
USE [tuBBDD] /* Replace with your Database Name */
GO
--TOTALLY UN-USED INDEXES
SELECT DB_NAME(s.database_id) as [DB Name], 
OBJECT_NAME(s.[object_id]) AS [Table Name]
, i.name AS [Index Name], i.index_id,
i.is_disabled, i.is_hypothetical, i.has_filter
, i.fill_factor
, i.is_unique,
s.user_updates AS [Total Writes],
(s.user_seeks + s.user_scans + s.user_lookups) AS [Total Reads],
s.user_updates - (s.user_seeks + s.user_scans + s.user_lookups) AS [Difference],
(partstats.used_page_count / 128.0) AS [IndexSizeinMB]
FROM sys.dm_db_index_usage_stats AS s WITH (NOLOCK)
INNER JOIN sys.indexes AS i WITH (NOLOCK)
ON s.[object_id] = i.[object_id]
AND s.index_id = i.index_id
AND s.database_id = DB_ID()
INNER JOIN sys.dm_db_partition_stats AS partstats
ON i.object_id = partstats.object_id AND i.index_id = partstats.index_id
WHERE OBJECTPROPERTY(s.[object_id],'IsUserTable') = 1
AND user_updates > (user_seeks + user_scans + user_lookups)
AND (s.user_lookups=0 AND s.user_scans=0 AND s.user_seeks=0)
AND i.index_id > 1
ORDER BY [Difference] DESC, [Total Writes] DESC, [Total Reads] ASC OPTION (RECOMPILE);
GO
~~~
# 
# 
#### La siguiente consulta, muestra aquellos indices que tengan mas consultas de escritura que de lectura.
#### Debes estudiar cada indice si es candidato a ser eliminado.
# 


~~~sql
USE [tuBBDD] /* Replace with your Database Name */
GO
--INDEXES WITH WRITES > READS
SELECT DB_NAME(s.database_id) as [DB Name]
, OBJECT_NAME(s.[object_id]) AS [Table Name]
, i.name AS [Index Name], i.index_id,
i.is_disabled, i.is_hypothetical
, i.has_filter, i.fill_factor, i.is_unique,
s.user_updates AS [Total Writes],
(s.user_seeks + s.user_scans + s.user_lookups) AS [Total Reads],
s.user_updates - (s.user_seeks + s.user_scans + s.user_lookups) AS [Difference],
(partstats.used_page_count / 128.0) AS [IndexSizeinMB]
FROM sys.dm_db_index_usage_stats AS s WITH (NOLOCK)
INNER JOIN sys.indexes AS i WITH (NOLOCK)
ON s.[object_id] = i.[object_id]
AND s.index_id = i.index_id
AND s.database_id = DB_ID()
INNER JOIN sys.dm_db_partition_stats AS partstats
ON i.object_id = partstats.object_id AND i.index_id = partstats.index_id
WHERE OBJECTPROPERTY(s.[object_id],'IsUserTable') = 1
AND (s.user_lookups<>0 OR s.user_scans<>0 OR s.user_seeks<>0)
AND s.user_updates > (s.user_seeks + s.user_scans + s.user_lookups)
AND i.index_id > 1
ORDER BY [Difference] DESC, [Total Writes] DESC, [Total Reads] ASC OPTION (RECOMPILE);
GO
~~~
Fuente: thesqldude.com

# 
#### Esta consulta complementa la anterior para decir que indices podrías eliminar.
#### Se debe prestar atención User Scan, User Lookup y User Update antes de eliminar el Index.
#### Si el valor de User Scan, User Lookup y User Update es alto y de User Seek bajo necesitas revisar el Indice
# 

~~~sql
-- Unused Index Script
-- Original Author: Pinal Dave 
SELECT TOP 25
o.name AS ObjectName
, i.name AS IndexName
, i.index_id AS IndexID
, dm_ius.user_seeks AS UserSeek
, dm_ius.user_scans AS UserScans
, dm_ius.user_lookups AS UserLookups
, dm_ius.user_updates AS UserUpdates
, p.TableRows
, 'DROP INDEX ' + QUOTENAME(i.name)
+ ' ON ' + QUOTENAME(s.name) + '.'
+ QUOTENAME(OBJECT_NAME(dm_ius.OBJECT_ID)) AS 'drop statement'
FROM sys.dm_db_index_usage_stats dm_ius
INNER JOIN sys.indexes i ON i.index_id = dm_ius.index_id 
AND dm_ius.OBJECT_ID = i.OBJECT_ID
INNER JOIN sys.objects o ON dm_ius.OBJECT_ID = o.OBJECT_ID
INNER JOIN sys.schemas s ON o.schema_id = s.schema_id
INNER JOIN (SELECT SUM(p.rows) TableRows, p.index_id, p.OBJECT_ID
FROM sys.partitions p GROUP BY p.index_id, p.OBJECT_ID) p
ON p.index_id = dm_ius.index_id AND dm_ius.OBJECT_ID = p.OBJECT_ID
WHERE OBJECTPROPERTY(dm_ius.OBJECT_ID,'IsUserTable') = 1
AND dm_ius.database_id = DB_ID()
AND i.type_desc = 'nonclustered'
AND i.is_primary_key = 0
AND i.is_unique_constraint = 0
ORDER BY (dm_ius.user_seeks + dm_ius.user_scans + dm_ius.user_lookups) ASC
GO
~~~
Fuente: blog.sqlauthority.com

# 

# 

~~~sql
/*
Insertado por Alejandro Jimenez 
Miercoles 27 de Enero del 2021
*/
SELECT OBJECT_NAME(IDX.object_id)  Table_Name
      , IDX.name  Index_name
      , PAR.rows  NumOfRows
      , IDX.type_desc  TypeOfIndex
FROM sys.partitions PAR
INNER JOIN sys.indexes IDX ON PAR.object_id = IDX.object_id  AND PAR.index_id = IDX.index_id AND IDX.type = 0
INNER JOIN sys.tables TBL
ON TBL.object_id = IDX.object_id and TBL.type ='U'
~~~

# 

# How Bad Are Your Indexes?<a name="badnc"><a/>

#### ** IMPORTANTE **: cada vez que considere eliminar un índice, siempre verifique a través de patrones de uso, entrevistas con usuarios, etc. que el índice es realmente "eliminable"; *no* quiere ser el que elimine un "malo" índice solo para descubrir que es necesario para la ejecución de la nómina mensual, o los informes de bonificación trimestrales, o algún otro proceso comercial crítico. Muy a menudo, los índices "malos" solo se usan periódicamente, pero son muy importantes. Una alternativa a considerar en lugar de eliminar el índice por completo es verificar si el índice se puede eliminar y luego volver a crear cuando sea necesario, pero a menudo el proceso de creación del índice incurre en demasiada sobrecarga para que esto sea viable.
#

## Posibles índices NC incorrectos<a name="escrituraslecturas"></a>
# 

~~~sql
-- Possible Bad NC Indexes (writes > reads)  (Query 47) (Bad NC Indexes)
SELECT OBJECT_NAME(s.[object_id]) AS [Table Name], i.name AS [Index Name], i.index_id,
i.is_disabled, i.is_hypothetical, i.has_filter, i.fill_factor,
user_updates AS [Total Writes], user_seeks + user_scans + user_lookups AS [Total Reads],
user_updates - (user_seeks + user_scans + user_lookups) AS [Difference]
FROM sys.dm_db_index_usage_stats AS s WITH (NOLOCK)
INNER JOIN sys.indexes AS i WITH (NOLOCK)
ON s.[object_id] = i.[object_id]
AND i.index_id = s.index_id
WHERE OBJECTPROPERTY(s.[object_id],'IsUserTable') = 1
AND s.database_id = DB_ID()
AND user_updates > (user_seeks + user_scans + user_lookups)
AND i.index_id > 1
ORDER BY [Difference] DESC, [Total Writes] DESC, [Total Reads] ASC OPTION (RECOMPILE);
-- Look for indexes with high numbers of writes and zero or very low numbers of reads
-- Consider your complete workload, and how long your instance has been running
-- Investigate further before dropping an index!
~~~

# 
### La consulta se basa en tablas/vistas específicas de la base de datos (como sys.indexes) y, por lo tanto, devuelve resultados para el contexto de la base de datos actual.
# 
### Lo primero que quería hacer era envolver la consulta en mi pequeño amigo indocumentado sp_msforeachdb.
# 


~~~sql
EXEC sp_msforeachdb '
/* MODIFIED from Glenn - Possible Bad NC Indexes (writes > reads)  (Query 58) (Bad NC Indexes) */
SELECT ''?'' as DBName,o.Name AS [Table Name], i.name AS [Index Name],
user_updates AS [Total Writes], user_seeks + user_scans + user_lookups AS [Total Reads],
user_updates - (user_seeks + user_scans + user_lookups) AS [Difference],
i.index_id,
i.is_disabled, i.is_hypothetical, i.has_filter, i.fill_factor
FROM sys.dm_db_index_usage_stats AS s WITH (NOLOCK)
INNER JOIN [?].sys.indexes AS i WITH (NOLOCK)
ON s.[object_id] = i.[object_id]
AND i.index_id = s.index_id
INNER JOIN [?].sys.objects as o WITH (nolock)
on i.object_ID=o.Object_ID
WHERE o.type = ''U''
AND s.database_id = DB_ID(''?'')
/* AND user_updates > (user_seeks + user_scans + user_lookups) */
AND i.index_id > 1
AND user_updates - (user_seeks + user_scans + user_lookups) >75000
ORDER BY [Difference] DESC, [Total Writes] DESC, [Total Reads] ASC;
'
~~~

# 

#### La consulta tiene todos los artefactos estándar de sp_msforeachdb, como el marcador de posición del signo de interrogación para el nombre de la base de datos esparcido por todas partes para establecer el contexto adecuado para todas las tablas y vistas específicas de la base de datos (como [?].sys.indexes).
#
#### Aquí fue donde surgió el problema específico de la versión: SQL Server 2008 introdujo el concepto de índices filtrados y, por lo tanto, se agregó una nueva columna (has_filter) a sys.indexes. El resultado es que al ejecutar la consulta anterior (que proviene del script de consulta SQL 2008 de Glenn) se produce un error de columna inexistente.
#
#### Una solución a esto podría haber sido tener una versión modificada de la consulta sin la columna ofensiva, y se alinearía con la forma en que Glenn publica sus consultas, con diferentes scripts para cada versión de SQL Server.
#
#### Para *mi* propósito, quería un solo script que pudiera ejecutar contra cualquier SQL Server 2005+, y la lógica de verificación de versión lo permite.
#
#### Aquí está la versión verificada del script Bad Indexes For All Databases:

#

~~~sql
/*
Bad Indexes DMV For All Databases
http://www.sqlskills.com/blogs/glenn/category/dmv-queries/
Tested on MSSQL 2005/2008/2008R2/2012/2014
*/
SET NOCOUNT ON
DECLARE @SQLVersion char(4)
SET @SQLVersion = left(cast(SERVERPROPERTY('productversion') as varchar),4)
/* PRINT @SQLVersion */
IF LEFT(@SQLVersion,1) NOT IN ('1','9') /* Not 2005+ */
BEGIN
 PRINT 'SQL Server Version Not Supported By This Script'
END
ELSE
BEGIN
 IF @SQLVersion = '9.00' /* 2005 */
 BEGIN
 /* SQL 2005 Version - removes i.has_filter column */
 EXEC sp_msforeachdb '
 /*
 MODIFIED from Glenn - Possible Bad NC Indexes (writes > reads)  (Query 58) (Bad NC Indexes)
 */
 SELECT ''?'' as DBName,o.Name AS [Table Name], i.name AS [Index Name],
 user_updates AS [Total Writes], user_seeks + user_scans + user_lookups AS [Total Reads],
 user_updates - (user_seeks + user_scans + user_lookups) AS [Difference],
 i.index_id,
 i.is_disabled, i.is_hypothetical, i.fill_factor
 FROM sys.dm_db_index_usage_stats AS s WITH (NOLOCK)
 INNER JOIN [?].sys.indexes AS i WITH (NOLOCK)
 ON s.[object_id] = i.[object_id]
 AND i.index_id = s.index_id
 INNER JOIN [?].sys.objects as o WITH (nolock)
 on i.object_ID=o.Object_ID
 WHERE o.type = ''U''
 AND s.database_id = DB_ID(''?'')
 /* AND user_updates > (user_seeks + user_scans + user_lookups) */
 AND i.index_id > 1
 AND user_updates - (user_seeks + user_scans + user_lookups) >75000
 ORDER BY [Difference] DESC, [Total Writes] DESC, [Total Reads] ASC;'
 END
 ELSE
 BEGIN
 EXEC sp_msforeachdb '
 /*
 MODIFIED from Glenn - Possible Bad NC Indexes (writes > reads)  (Query 58) (Bad NC Indexes)
 */
 SELECT ''?'' as DBName,o.Name AS [Table Name], i.name AS [Index Name],
 user_updates AS [Total Writes], user_seeks + user_scans + user_lookups AS [Total Reads],
 user_updates - (user_seeks + user_scans + user_lookups) AS [Difference],
 i.index_id,
 i.is_disabled, i.is_hypothetical, i.has_filter, i.fill_factor
 FROM sys.dm_db_index_usage_stats AS s WITH (NOLOCK)
 INNER JOIN [?].sys.indexes AS i WITH (NOLOCK)
 ON s.[object_id] = i.[object_id]
 AND i.index_id = s.index_id
 INNER JOIN [?].sys.objects as o WITH (nolock)
 on i.object_ID=o.Object_ID
 WHERE o.type = ''U''
 AND s.database_id = DB_ID(''?'')
 /* AND user_updates > (user_seeks + user_scans + user_lookups) */
 AND i.index_id > 1
 AND user_updates - (user_seeks + user_scans + user_lookups) >75000
 ORDER BY [Difference] DESC, [Total Writes] DESC, [Total Reads] ASC;'
 END
END
~~~

# 
#### Esto hizo exactamente lo que quería, devolviendo todos los índices no agrupados con al menos 75 000 escrituras más que lecturas (mi umbral elegido) en todas las bases de datos en la instancia de SQL Server 2005+.

#


# 
# Identificando índices duplicados en SQL Server<a name="indicesduplicados"><a/>
![](https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRn518FNxZ9TzIFTj0hEBKuCkWQUDuq3LpFBQ&usqp=CAU)

#### Un problema común que se puede encontrar en SQL Server son los índices duplicados parcial o totalmente. Los índices son por regla general buenos para mejorar el rendimiento de una base de datos, pero el exceso de índices en una base de datos puede causar que SQL Server gaste mucho tiempo actualizándolos cuando no necesariamente hará uso de ellos.


#### Este es el caso de los índices duplicados, estos nos pueden causar los siguientes problemas:

    Degradación del rendimiento que proviene del overhead 
    causado por el mantenimiento de updates, inserts y deletes

    Incremento en las actividades del log de transacciones
     (llenando los logs, discos y haciendo que Log Shipping falle)

       Incremento en el tamaño de los backups (los índices hacen
     los backups mas grandes, requiriendo mas espacio en disco,
    creando tiempos de mantenimiento mas altos y consumiendo
    más energía para poder realizarlos, además de impactar el
    rendimiento del servidor mientras este se realiza).


## ¿Pero que es un índice duplicado y como lo detecto?

#### Digamos que tenemos la tabla de empleados, la cual posee la siguiente estructura:



#### Y ahora digamos que tenemos dos índices creados para esa tabla:

    - 1. IX_General: Indexa las columnas Codigo_Empleado y Nombre
    - 2. IX_General_Identificacion: Indexa las columnas Codigo_Empleado, Nombre y Numero_Identificacin_Personal

#### En este caso, ambos índices indexan las columnas Codigo_Empleado y Nombre, por lo que se podría decir que uno de ellos solo causa trabajo extra al motor de base de datos. Ahora bien, ¿Como determino cual de los índices borrar?

#### En este punto, se necesita recurrir a la experiencia que se tenga del sistema, en general, se necesita determinar como se realizan las búsquedas en esta tabla. Por ejemplo, si siempre se busca información por Nombre, entonces lo mejor será dejar el índice IX_General, porque es mas pequeño y eficiente, pero si por otro lado, la búsqueda más común fuera por Numero_Identificacion_Personal, lo mejor será entonces quedarse con el índice IX_General_Identificacion, porque este índice incluye la columna que mas se utiliza, volviendo al otro índice obsoleto.

### ***Tenga en cuenta que antes de borrar un índice, debe también verificar que no se estén utilizando sentencias con un index hint que la utilice, de otra forma la eliminación del índice provocará que su sentencia falle.***

## El siguiente procedimiento le ayudará a identificar los índices duplicados en su base de datos:
# 

~~~sql

create procedure [dbo].[usp_duplicateindexes]

@tablename varchar(255)

as

set nocount on

print @tablename

--dump sp_helpindex into temp table

if object_id('tempdb..#helpindex') > 0 drop table #helpindex

create table #helpindex (

index_name varchar (900) not null primary key

, index_description varchar (1000) null

, index_keys varchar (1000) null)

insert #helpindex exec sp_helpindex @tablename

--add [inccols] to temp table & cursor over output, adding included col defs

alter table #helpindex add inccols varchar(1000) null

declare cr cursor for

select si.name, sc.name

from sysobjects so

join sysindexes si on so.id = si.id

join sys.index_columns ic on si.id = ic.object_id and si.indid = ic.index_id

join sys.columns sc on ic.object_id = sc.object_id and ic.column_id = sc.column_id

where so.xtype = 'U'

and so.name = @tablename

and ic.is_included_column = 1

order by si.name, ic.index_column_id

declare @siname varchar(1000), @scname varchar(1000)

open cr

fetch next from cr into @siname, @scname

while @@fetch_status = 0

begin

update #helpindex set inccols = isnull(inccols , '') + @scname + ', ' where index_name = @siname

fetch next from cr into @siname, @scname

end

update #helpindex set inccols = left(inccols, datalength(inccols) - 2) where right(inccols, 2) = ', '

close cr

deallocate cr

--dump duplicates into second temp table & pump results if there are any

if object_id('tempdb..#helpindex2') > 0 drop table #helpindex2

create table #helpindex2 (

index_name varchar (900) not null primary key

, index_description varchar (1000) null

, index_keys varchar (1000) null

, inccols varchar(1000) null

)

insert into #helpindex2

select hi.index_name, hi.index_description, hi.index_keys, hi.inccols

from #helpindex hi

join #helpindex h2 on hi.index_keys=h2.index_keys

and hi.index_description=h2.index_description

and hi.index_name<>h2.index_name

if @@rowcount > 0

select @tablename as "tablename", * from #helpindex2 order by index_name, index_keys, inccols

--cleanup temp objects

if object_id('tempdb..#helpindex2') > 0 drop table #helpindex2

if object_id('tempdb..#helpindex') > 0 drop table #helpindex
~~~

### luego procederemos a Ejecutarlo de la siguiente forma.

~~~sql
exec sp_MSForEachTable 'usp_duplicateindexes''?'''
~~~


# 

# 
# Conceptos básicos del diseño de índices<a name="disenoindices"><a/>
![](https://learn.microsoft.com/es-es/sql/relational-databases/media/sql-server-index-design-guide/hash-index-buckets.png?view=sql-server-ver16)
#### Piense en un libro corriente: al final del libro hay un índice en el que puede localizar rápidamente la información del libro. El índice es una lista ordenada de palabras clave y, junto a cada palabra clave, hay un conjunto de números de página que redirigen a las páginas en las que aparece cada palabra clave. Un índice de SQL Server es parecido: es una lista ordenada de valores y para cada valor hay punteros a las páginas de datos en las que se encuentran estos valores. El propio índice se almacena en páginas, lo que conforma las páginas de índice de SQL Server. En un libro corriente, si el índice abarca varias páginas y tiene que buscar punteros a todas las páginas que contienen, por ejemplo, la palabra "SQL", tendría que pasar las páginas hasta encontrar la página de índice que contiene la palabra clave "SQL". Desde allí, seguiría los punteros a todas las páginas del libro. Esto se podría optimizar aún más si al principio del índice se crea una sola página que contiene una lista alfabética de dónde se puede encontrar cada letra. Por ejemplo: "De la A a la D - página 121", "De la E a la G - página 122", y así sucesivamente. Esta página adicional eliminaría el paso de tener que pasar las páginas por el índice para encontrar la posición de inicio. Esta página no existe en los libros corrientes, pero sí en un índice de SQL Server. Esta página se denomina "página raíz" del índice. La página raíz es la página inicial de la estructura de árbol que se usa en un índice de SQL Server. Siguiendo la analogía del árbol, las páginas finales que contienen punteros a los datos reales se conocen como "páginas hoja" del árbol.
#### Un índice de SQL Server es una estructura en disco o en memoria asociada con una tabla o vista que acelera la recuperación de filas de la tabla o vista. Un índice contiene claves generadas a partir de una o varias columnas de la tabla o la vista. En el caso de los índices en disco, dichas claves están almacenadas en una estructura de árbol (árbol B) que permite que SQL Server busque de forma rápida y eficiente la fila o las filas asociadas a los valores de cada clave.
#### Los índices almacenan los datos organizados de forma lógica como una tabla con filas y columnas, y físicamente almacenados en un formato de datos por fila llamado almacén de filas 1, o bien en un formato de datos por columna llamado almacén de columnas .
##### La selección de los índices apropiados para una base de datos y su carga de trabajo es una compleja operación que busca el equilibrio entre la velocidad de la consulta y el costo de actualización. Los índices estrechos, o con pocas columnas en la clave de índice, necesitan menos espacio en el disco y son menos susceptibles de provocar sobrecargas debido a su mantenimiento. Por otra parte, la ventaja de los índices anchos es que cubren más consultas. Puede que tenga que experimentar con distintos diseños antes de encontrar el índice más eficaz. Es posible agregar, modificar y quitar índices sin que esto afecte al esquema de la base de datos o al diseño de la aplicación. Por lo tanto, no debe dudar en experimentar con índices diferentes.
#### El optimizador de consultas de SQL Server elige de forma confiable el índice más eficaz en la mayoría de los casos. La estrategia general de diseño de índices debe proporcionar una buena selección de índices al optimizador de consultas y confiar en que tomará la decisión correcta. Así se reduce el tiempo de análisis y se obtiene un buen rendimiento en diversas situaciones. Para saber qué índices utiliza el optimizador de consultas para determinada consulta, en SQL Server Management Studio, en el menú Consulta , seleccione Incluir plan de ejecución real.
#### No equipare siempre la utilización de índices con un buen rendimiento ni el buen rendimiento al uso eficaz del índice. Si la utilización de un índice contribuyera siempre a producir el mejor rendimiento, el trabajo del optimizador de consultas sería muy sencillo. En realidad, una elección incorrecta de índice puede provocar un rendimiento bajo. Por tanto, la tarea del optimizador de consultas consiste en seleccionar un índice o una combinación de índices solo si mejora el rendimiento, y evitar la recuperación indizada cuando afecte al mismo.
 ####  Los almacenes de filas han sido la forma tradicional de almacenar los datos de una tabla relacional. En SQL Server, "almacén de filas" hace referencia a la tabla en la que el formato de almacenamiento de datos subyacente es un montón, un árbol B (índice agrupado) o una tabla optimizada para memoria.

# Tareas del diseño de índices<a name="tareadisind"></a>
#
 ### 1- Las siguientes tareas componen la estrategia recomendada para el diseño de índices:
### Comprender las características de la propia base de datos.
### Por ejemplo, si es una base de datos de procesamiento de transacciones en línea (OLTP) con modificaciones de datos frecuentes que deben tener un alto rendimiento. A partir de SQL Server 2014 (12.x), las tablas y los índices optimizados para memoria son especialmente adecuados en este escenario, ya que proporcionan un diseño sin bloqueos temporales. Para obtener más información, en esta guía podrá ver Índices de tablas optimizadas para memoria, Nonclustered Index for Memory-Optimized Tables Design Guidelines (Guía de diseño de índices no agrupados para tablas optimizadas para memoria) y Hash Index for Memory-Optimized Tables Design Guidelines (Guía de diseño de índices de hash para tablas optimizadas para memoria).
#
### O bien, el ejemplo de una base de datos de sistema de ayuda a la toma de decisiones (DSS) o almacenamiento de datos (OLAP) que debe procesar con rapidez conjuntos de datos muy grandes. A partir de SQL Server 2012 (11.x), los índices de almacén de columnas son especialmente adecuados para los conjuntos de datos de almacenamiento de datos comunes. Los índices de almacén de columnas pueden transformar la experiencia de almacenamiento de datos de los usuarios, ya que permite un rendimiento más rápido en las consultas habituales de almacenamiento de datos, como el filtrado, la agregación, la agrupación y la combinación en estrella de consultas. Para obtener más información, vea Introducción a los índices de almacén de columnas o Directrices para diseñar índices de almacén de columnas en esta guía.
### 2 - Comprender las características de las consultas utilizadas con frecuencia. Por ejemplo, saber que una consulta utilizada con frecuencia une dos o más tablas facilitará la determinación del mejor tipo de índices que se puede utilizar.
### 3-  Comprender las características de las columnas utilizadas en las consultas. Por ejemplo, un índice es idóneo para columnas que tienen un tipo de datos entero y además son columnas con valores NULL o no NULL. En el caso de columnas que tengan subconjuntos de datos bien definidos, puede usar un índice filtrado en SQL Server 2008 y en versiones posteriores. Para obtener más información, vea Directrices generales para diseñar índices filtrados en esta guía.
### 4 - Determinar qué opciones de índice podrían mejorar el rendimiento al crear o mantener el índice. Por ejemplo, la creación de un índice agrupado en una tabla grande se beneficiaría de la opción de índice ONLINE. La opción ONLINE permite que la actividad simultánea en los datos subyacentes continúe mientras el índice se crea o regenera. Para obtener más información, consulte Establecer opciones de índice.
### 5 -Determinar la ubicación de almacenamiento óptima para el índice. Un índice no clúster se puede almacenar en el mismo grupo de archivos que la tabla subyacente o en un grupo distinto. La ubicación de almacenamiento de índices puede mejorar el rendimiento de las consultas aumentando el rendimiento de las operaciones de E/S en disco. Por ejemplo, el almacenamiento de un índice no clúster en un grupo de archivos que se encuentra en un disco distinto que el del grupo de archivos de la tabla puede mejorar el rendimiento, ya que se pueden leer varios discos al mismo tiempo.
### O bien, los índices clúster y no clúster pueden utilizar un esquema de particiones en varios grupos de archivos. Las particiones facilitan la administración de índices y tablas grandes al permitir el acceso y la administración de subconjuntos de datos rápidamente y con eficacia, mientras se mantiene la integridad de la colección global. Para obtener más información, vea Partitioned Tables and Indexes. Al considerar la posibilidad de utilizar particiones, determine si el índice debe alinearse; es decir, si las particiones se crean esencialmente del mismo modo que la tabla o de forma independiente.

# Directrices generales para diseñar índices
### Los administradores de bases de datos más experimentados pueden diseñar un buen conjunto de índices, pero esta tarea es muy compleja, consume mucho tiempo y está sujeta a errores, incluso con cargas de trabajo y bases de datos con un grado de complejidad no excesivo. La comprensión de las características de la base de datos, las consultas y las columnas de datos facilita el diseño de los índices.

# 

# Consideraciones acerca de la base de datos<a name="consibasedatos"></a>
### Cuando diseñe un índice, tenga en cuenta las siguientes directrices acerca de la base de datos:
 - Si se usa un gran número de índices en una tabla, el rendimiento de las instrucciones INSERT, UPDATE, DELETE y MERGE se verá afectado, ya que todos los índices deben ajustarse adecuadamente a medida que cambian los datos de la tabla. Por ejemplo, si una columna se usa en varios índices y ejecuta una instrucción UPDATE que modifica datos de esa columna, se deben actualizar todos los índices que contengan esa columna, así como la columna de la tabla base subyacente (índice de montón o agrupado).
      - Evite crear demasiados índices en tablas que se actualizan con mucha frecuencia y mantenga los índices estrechos, es decir, defínalos con el menor número de columnas posible.
      - Utilice un número mayor de índices para mejorar el rendimiento de consultas en tablas con pocas necesidades de actualización, pero con grandes volúmenes de datos. Un gran número de índices contribuye a mejorar el rendimiento de las consultas que no modifican datos, como las instrucciones SELECT, ya que el optimizador de consultas dispone de más índices entre los que elegir para determinar el método de acceso más rápido.
- La indización de tablas pequeñas puede no ser una solución óptima, porque puede provocar que el optimizador de consultas tarde más tiempo en realizar la búsqueda de los datos a través del índice que en realizar un simple recorrido de la tabla. De este modo, es posible que los índices de tablas pequeñas no se utilicen nunca; sin embargo, sigue siendo necesario su mantenimiento a medida que cambian los datos de la tabla.
 - Los índices en vistas pueden mejorar de forma significativa el rendimiento si la vista contiene agregaciones, combinaciones de tabla o una mezcla de agregaciones y combinaciones. No es necesario hacer referencia de forma explícita a la vista en la consulta para que el optimizador de consultas la utilice.
 - Utilice el Asistente para la optimización de motor de base de datos para analizar las bases de datos y crear recomendaciones de índices. Para obtener más información, vea [Database Engine Tuning Advisor](https://docs.microsoft.com/es-es/sql/relational-databases/performance/database-engine-tuning-advisor?view=sql-server-ver15)

# 

## Eliminar todos los indices que no fueron creados ONLNE =ON,y Crearlos nuevamente de forma ONLINE=ON<a name="6.8"></a>

#### Para lograr esto, primero necesitas obtener una lista de todos los índices que no están creados con la opción ONLINE = ON, eliminarlos y luego volver a crearlos con la opción ONLINE = ON. Puedes hacerlo a través de un script SQL en SQL Server. Asegúrate de tomar precauciones antes de ejecutar estos comandos en un entorno de producción, ya que eliminar y recrear índices puede causar bloqueos temporales en las tablas afectadas. Aquí tienes un ejemplo de cómo podrías hacerlo:

~~~sql
-- Declarar una variable temporal para almacenar los nombres de las tablas
DECLARE @TableName NVARCHAR(128);

-- Declarar un cursor para recorrer todas las tablas
DECLARE TableCursor CURSOR FOR
SELECT name
FROM sys.tables;

-- Variables para almacenar el nombre del índice y el nombre de la tabla
DECLARE @IndexName NVARCHAR(128);
DECLARE @IndexTableName NVARCHAR(128);

-- Variable para almacenar el comando SQL dinámico
DECLARE @SQLCommand NVARCHAR(MAX);

-- Abrir el cursor
OPEN TableCursor;

-- Recorrer las tablas
FETCH NEXT FROM TableCursor INTO @TableName;
WHILE @@FETCH_STATUS = 0
BEGIN
    -- Cursor para recorrer los índices de la tabla
    DECLARE IndexCursor CURSOR FOR
    SELECT name, object_name(object_id) as TableName
    FROM sys.indexes
    WHERE object_id = OBJECT_ID(@TableName) AND is_disabled = 0 AND type_desc <> 'HEAP' AND type_desc <> 'XML';

    -- Recorrer los índices
    FETCH NEXT FROM IndexCursor INTO @IndexName, @IndexTableName;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Generar y ejecutar el comando SQL para eliminar el índice
        SET @SQLCommand = 'DROP INDEX ' + QUOTENAME(@IndexTableName) + '.' + QUOTENAME(@IndexName);
        EXEC sp_executesql @SQLCommand;

        -- Generar y ejecutar el comando SQL para recrear el índice con ONLINE = ON
        SET @SQLCommand = 'CREATE INDEX ' + QUOTENAME(@IndexName) + ' ON ' + QUOTENAME(@IndexTableName) + ' (YourColumns) WITH (ONLINE = ON)';
        EXEC sp_executesql @SQLCommand;

        FETCH NEXT FROM IndexCursor INTO @IndexName, @IndexTableName;
    END

    -- Cerrar y desasignar el cursor de índices
    CLOSE IndexCursor;
    DEALLOCATE IndexCursor;

    FETCH NEXT FROM TableCursor INTO @TableName;
END

-- Cerrar y desasignar el cursor de tablas
CLOSE TableCursor;
DEALLOCATE TableCursor;

~~~
# 
#### En este código, se utiliza un cursor para recorrer todas las tablas de la base de datos y otro cursor para recorrer los índices de cada tabla. Para cada índice, se ejecuta una instrucción DROP INDEX para eliminarlo y luego se ejecuta una instrucción CREATE INDEX para recrearlo con la opción ONLINE = ON.

#### Asegúrate de ajustar la parte (YourColumns) con las columnas adecuadas de tus índices y de realizar pruebas en un entorno de desarrollo o copia de seguridad antes de aplicar este script en producción.





# 
## para mas informacion sobre la creacion y mantenimiento de indices en Sql Server ver las paginas [Ver Documentacion](https://docs.microsoft.com/es-es/sql/relational-databases/sql-server-index-design-guide?view=sql-server-ver15#:~:text=Un%20%C3%ADndice%20de%20SQL%20Server%20es%20una%20estructura%20en%20disco,de%20la%20tabla%20o%20vista.&text=Un%20%C3%ADndice%20contiene%20claves%20generadas,la%20tabla%20o%20la%20vista.)

# 

## Listado de los indices que tiene una Base de Datos<a name="6.9"></a>
####  Por supuesto, puedes utilizar la siguiente consulta para obtener una lista de los índices presentes en una base de datos específica en SQL Server:

~~~sql
USE TuBaseDeDatos;

SELECT 
    OBJECT_NAME(object_id) AS NombreObjeto,
    name AS NombreIndice,
    type_desc AS Tipo,
    CASE WHEN is_primary_key = 1 THEN 'Sí' ELSE 'No' END AS EsClavePrimaria,
    CASE WHEN is_unique = 1 THEN 'Sí' ELSE 'No' END AS EsUnico
FROM 
    sys.indexes
WHERE 
    type IN (1,2) -- Índices clustered y no agrupados
ORDER BY 
    OBJECT_NAME(object_id), name;
~~~

#### Asegúrate de reemplazar "TuBaseDeDatos" con el nombre de la base de datos que estás utilizando. Esta consulta mostrará los siguientes detalles para cada índice:

- Nombre del objeto (tabla o vista) al que pertenece el índice.
- Nombre del índice.
- Tipo de índice (clustered o nonclustered).
- Si el índice es una clave primaria o no.
- Si el índice es único o no.

#### Esta consulta filtra los tipos de índices para mostrar solo los índices clustered y nonclustered. Si necesitas información sobre otros tipos de índices, puedes ajustar la consulta según tus necesidades.

# 


# Evaluación de Índices en SQL Server<a name="3113"></a>

## Descripción General
Este script tiene como objetivo evaluar la efectividad de los últimos índices creados en una base de datos de SQL Server. A través del análisis de los índices más recientes, se busca determinar si estos han tenido un impacto positivo en el rendimiento de la base de datos, y cuantificar el impacto en términos de uso de CPU, memoria y almacenamiento.

El código se divide en varias partes utilizando Common Table Expressions (CTEs) que permiten la evaluación de los índices desde distintas perspectivas: la creación reciente, el uso de los índices y el impacto en términos de memoria.

## Componentes del Código

### 1. **RecentIndexes**
En esta sección, se seleccionan los índices creados recientemente en la base de datos, filtrando únicamente tablas de usuario (`o.type = 'U'`). Se incluyen detalles relevantes como el nombre del índice, la tabla a la que pertenece, el tipo de índice, y si es único o una clave primaria. Los índices se ordenan de manera descendente por el identificador del índice (`index_id`) para listar los más recientes primero.

### 2. **IndexEffectiveness**
Esta sección permite evaluar la efectividad de cada índice considerando su uso y actualizaciones. Los datos se obtienen de la vista de sistema `sys.dm_db_index_usage_stats`, que contiene información sobre búsquedas (`user_seeks`), exploraciones (`user_scans`), y actualizaciones (`user_updates`) realizadas sobre los índices. También se proporciona un cálculo del `effectiveness_ratio`, que muestra la relación entre la cantidad de lecturas y las actualizaciones realizadas sobre el índice.

### 3. **IndexImpact**
Esta parte del código proporciona información sobre el impacto del índice en términos de uso de memoria y almacenamiento. Se calculan dos métricas principales: el uso de memoria (`memory_usage_mb`) y el almacenamiento total utilizado (`total_storage_mb`). Los valores se obtienen de la vista `sys.dm_db_partition_stats` y se expresan en megabytes (MB).

### 4. **Consulta Final**
La consulta final combina los resultados de las tres CTEs para proporcionar una visión integral de los índices recientes, mostrando:
- **Nombre del Índice** y **Tabla**.
- **Tipo de Índice**, si es único (**is_unique**) y si es clave primaria (**is_primary_key**).
- **Uso del Índice**: la cantidad de búsquedas, exploraciones, y actualizaciones.
- **Impacto en Rendimiento**: el uso de memoria y almacenamiento.

Los resultados se ordenan de manera descendente para mostrar los índices más recientes primero.

## Código Completo
```sql
WITH RecentIndexes AS
(
    SELECT TOP 100 PERCENT
        i.name AS index_name,
        i.object_id,
        i.index_id,
        i.type_desc,
        i.is_unique,
        i.is_primary_key,
        i.fill_factor,
        OBJECT_NAME(i.object_id) AS table_name
    FROM sys.indexes i
    JOIN sys.objects o ON i.object_id = o.object_id
    WHERE o.type = 'U' -- Only user tables
    ORDER BY i.index_id DESC
),
IndexEffectiveness AS
(
    SELECT
        i.name AS index_name,
        i.object_id,
        s.user_seeks + s.user_scans + s.user_lookups AS usage_count,
        s.user_updates AS update_count,
        s.last_user_seek,
        s.last_user_scan,
        s.last_user_lookup,
        s.last_user_update,
        CASE
            WHEN s.user_updates = 0 THEN 'N/A'
            ELSE CAST((s.user_seeks + s.user_scans + s.user_lookups) / CAST(s.user_updates AS FLOAT) AS VARCHAR(50))
        END AS effectiveness_ratio
    FROM sys.dm_db_index_usage_stats s
    JOIN sys.indexes i ON s.object_id = i.object_id AND s.index_id = i.index_id
    WHERE database_id = DB_ID()
),
IndexImpact AS
(
    SELECT
        i.index_id,
        i.name AS index_name,
        i.object_id,
        ps.used_page_count * 8.0 / 1024 AS memory_usage_mb, -- Memory usage in MB
        (ps.in_row_data_page_count + ps.lob_used_page_count + ps.row_overflow_used_page_count) * 8.0 / 1024 AS total_storage_mb -- Storage usage in MB
    FROM sys.dm_db_partition_stats ps
    JOIN sys.indexes i ON ps.object_id = i.object_id AND ps.index_id = i.index_id
)
SELECT
    r.index_name,
    r.table_name,
    r.type_desc,
    r.is_unique,
    r.is_primary_key,
    r.fill_factor,
    ie.usage_count,
    ie.update_count,
    ie.last_user_seek,
    ie.last_user_scan,
    ie.last_user_lookup,
    ie.last_user_update,
    ie.effectiveness_ratio,
    ii.memory_usage_mb,
    ii.total_storage_mb
FROM RecentIndexes r
LEFT JOIN IndexEffectiveness ie ON r.index_name = ie.index_name AND r.object_id = ie.object_id
LEFT JOIN IndexImpact ii ON r.index_name = ii.index_name AND r.object_id = ii.object_id
ORDER BY r.index_id DESC;
```

## Uso del Script
- **Evaluación de Impacto**: Ejecutar este script permitirá evaluar si los índices recién creados están siendo utilizados de forma efectiva y si están mejorando el rendimiento de la base de datos.
- **Análisis de Recursos**: Los resultados obtenidos también mostrarán el uso de memoria y almacenamiento, ayudando a identificar si algún índice está consumiendo demasiados recursos y podría necesitar ajuste o eliminación.

## Recomendaciones
- Ejecuta el script en un entorno de pruebas antes de usarlo en producción.
- Monitorea los índices que tienen bajo `effectiveness_ratio` o un alto uso de memoria para optimizar la base de datos.

## Consideraciones Finales
La efectividad de los índices depende de cómo las consultas se ejecutan contra la base de datos. Un índice que no se utiliza adecuadamente puede afectar el rendimiento de la base de datos, ocupando espacio y ralentizando las operaciones de inserción o actualización. Este script es útil para detectar esos índices y tomar acciones correctivas. Puedes ajustar la lógica según las necesidades específicas de tu entorno.







# 

# 
# Cuanta data puedo perder<a name="dataperder"></a>
![](https://www.powerdata.es/hs-fs/hubfs/images/seguridad%20de%20datos%20cs.jpg?width=703&height=468&name=seguridad%20de%20datos%20cs.jpg)

#### Antes de empezar a trabajar en algo, necesitamos saber que todas nuestras bases de datos de usuarios están obteniendo respaldado. Esta parte de nuestro script SQL Server sp_Blitz® comprueba si ha habido un copia de seguridad completa en los últimos 7 días.

#### A menudo, alguien configura planes de mantenimiento para respaldar bases de datos específicas al verificar su nombres. Verificaron todos los nombres de la base de datos que estaban presentes en ese momento, pero luego en el futuro, otras personas agregaron más bases de datos, sin saber que necesitaban verificar más cajas para hacer una copia de seguridad.

#### O tal vez sus usuarios agregan bases de datos todo el tiempo, pero su herramienta de respaldo no detecta ellos hasta una copia de seguridad completa de fin de semana. Buenas noticias, también podemos solucionarlo, sigue leyendo.

#### En casos excepcionales, como en el caso de bases de datos de varios terabytes, a veces hay una copia de seguridad completa ocurre solo una vez al mes, y las copias de seguridad diferenciales se realizan con mayor frecuencia.
#### Nuestro Blitz solo verifica los últimos 7 días, por lo que verá alertas aquí después del 7 Del mes.

#### ¿Son sus copias de seguridad menos perfectas de lo que pensaba? Chequea aquí.?
#### Para ver cuántos datos podría perder por base de datos durante las últimas semanas,
## ejecutar esta consulta:
# 
~~~sql
CREATE TABLE #backupset (backup_set_id INT, 
database_name NVARCHAR(128), backup_finish_date DATETIME
, type CHAR(1), 
next_backup_finish_date DATETIME);

INSERT INTO #backupset (backup_set_id, database_name, backup_finish_date, type)
SELECT backup_set_id, database_name, backup_finish_date, type
FROM msdb.dbo.backupset WITH (NOLOCK)
WHERE backup_finish_date >= convert(varchar(10),getdate()-31,120)
AND database_name NOT IN ('master', 'model', 'msdb');
CREATE CLUSTERED INDEX CL_database_name_backup_finish_date ON #backupset (database_name, backup_finish_date);
 
UPDATE #backupset
SET next_backup_finish_date = 
(SELECT TOP 1 backup_finish_date FROM #backupset bsNext 
WHERE bs.database_name = bsNext.database_name 
AND bs.backup_finish_date = bsNext.backup_finish_date 
ORDER BY bsNext.backup_finish_date)
FROM #backupset bs;
 
SELECT bs1.database_name, MAX(DATEDIFF(mi, bs1.
backup_finish_date, bs1.next_backup_finish_date)) AS 
max_minutes_of_data_loss,
'SELECT bs.database_name, bs.type, bs.backup_start_date, bs.
backup_finish_date, DATEDIFF(mi, COALESCE((SELECT TOP 1 bsPrior.
backup_finish_date FROM msdb.dbo.backupset bsPrior WHERE bs.
database_name = bsPrior.database_name AND bs.backup_finish_date &
gt; bsPrior.backup_finish_date ORDER BY bsPrior.
backup_finish_date DESC), ''1900/1/1''), bs.backup_finish_date) 
AS minutes_since_last_backup, DATEDIFF(mi, bs.backup_start_date,
 bs.backup_finish_date) AS backup_duration_minutes, CASE DATEDIFF
 (ss, bs.backup_start_date, bs.backup_finish_date) WHEN 0 THEN 0
  ELSE CAST(( bs.backup_size / ( DATEDIFF(ss, bs.
  backup_start_date, bs.backup_finish_date) ) / 1048576 ) AS 
  INT) END AS throughput_mb_sec FROM msdb.dbo.backupset bs WHERE 
  database_name = ''' + database_name + ''' AND bs.
  backup_start_date &gt; DATEADD(dd, -14, GETDATE()) ORDER BY bs
  backup_start_date' AS more_info_query

FROM #backupset bs1
GROUP BY bs1.database_name
ORDER BY bs1.database_name
 
DROP TABLE #backupset;
GO
~~~

#

# Query de los tamanos de los backup de base de datos<a name="querybackup"><a/>
![](https://docs.oracle.com/es/solutions/back-up-oracle-databases-into-government-cloud/img/oci-db-cloud-backup-module-architecture.png)
#### Query que nos muestra el tamano de os backup de base de datos ralizados en un tiempo dado
# 
~~~sql

/*
Query que nos muestra el tamano de os backup de base de datos ralizados en un tiempo dado
Creado por Alejandro Jimenez 2017- febrero 7...
*/
  DECLARE @Server varchar(40)
  Set @Server = Convert(varchar(35), ServerProperty('machinename')) + '\' + @@ServiceName

select 

            @Server As 'Servidor - Instancia'
        ,FR.Database_Name
  --      ,DateDiff(Day, FR.Backup_Finish_Date, GetDate()) As 'Full_Dias'
        ,convert(varchar(10), FR.Backup_Finish_Date, 120)  As 'Full_Termino'
        ,Convert(Char,Convert(Numeric(12,2),(FR.Backup_Size / 1024 / 1024))) As Full_Tamanho_MB
        ,type As Tipo
--*

 from 
 msdb.dbo.backupset As FR
 where FR.Backup_Finish_Date between convert(varchar(10),Getdate()-60,120) and convert(varchar(10),Getdate(),120)
                    and Type = 'D'

 order by database_name, Full_Termino
~~~

# 
# Query Envio por correo Electronico del  tamanos de los backup de base de datos<a name="querybackup2"><a/>
# 
~~~sql

/*
Query de los ultimos Backup realizados en la base de datos del 10.0.0.252
Alejandro JImenez Rosa ------
*/


USE msdb
GO
SET NOCOUNT ON
GO

DECLARE @Server varchar(40)

Set @Server = Convert(varchar(35), ServerProperty('machinename')) + '\' + @@ServiceName

declare @datos table (

    data1 varchar(50)
    ,data2 varchar(30)
    ,data3  int
    ,data4 datetime
    ,data5 VARCHAR(20)
    ,data6 int
    ,data7 datetime
    ,data8 int
    ,data9 VARCHAR(20)
    ,data10 int
    ,data11 datetime
    ,data12 VARCHAR(20)
)


insert into @datos
     SELECT 
         td = @Server 
        ,td = FR.Database_Name 
        ,td =DateDiff(Day, FR.Backup_Finish_Date, GetDate()) 
        ,td =FR.Backup_Finish_Date  
        ,td =Convert(Char,Convert(Numeric(12,2),(FR.Backup_Size / 1024 / 1024))) 
        ,td =DateDiff(Day, DR.Backup_Finish_Date, GetDate()) 
        ,td =DR.Backup_Finish_Date  
        ,td = Case 
            When DR.Backup_Finish_Date Is Null Then Null
            Else DateDiff(Day, FR.Backup_Finish_Date, DR.Backup_Finish_Date)
        End 
        ,td =Convert(Char,Convert(Numeric(12,2),(DR.Backup_Size / 1024 / 1024))) 
        ,td =DateDiff(Minute, TR.Backup_Finish_Date, GetDate()) 
        ,td =TR.Backup_Finish_Date 
        ,td =Convert(Char,Convert(Numeric(12,2),(TR.Backup_Size / 1024 / 1024))) 
    FROM 
        msdb.dbo.backupset As FR
    LEFT OUTER JOIN
        msdb.dbo.backupset As TR
    ON
        TR.Database_Name = FR.Database_Name
    AND TR.Type = 'L'
    AND TR.Backup_Finish_Date =
        (
            (SELECT Max(Backup_Finish_Date) 
            FROM    msdb.dbo.backupset B2 
            WHERE   B2.Database_Name = FR.Database_Name 
            And B2.Type = 'L')
        )
    LEFT OUTER JOIN
        msdb.dbo.backupset As DR
    ON
        DR.Database_Name = FR.Database_Name
    AND DR.Type = 'I'
    AND DR.Backup_Finish_Date =
        (
            (SELECT Max(Backup_Finish_Date) 
            FROM    msdb.dbo.backupset B2 
            WHERE B2.Database_Name = FR.Database_Name 
              And B2.Type = 'I')
        )
    WHERE
        FR.Type = 'D' -- full backups only
    AND FR.Backup_Finish_Date = 
        (
            SELECT Max(Backup_Finish_Date) 
            FROM msdb.dbo.backupset B2 
            WHERE B2.Database_Name = FR.Database_Name 
            And   B2.Type = 'D'
        )
    And FR.Database_Name In (SELECT name FROM master.dbo.sysdatabases) 
    And FR.Database_Name Not In ('tempdb','pubs','northwind','model'
    ,'bima','DB_Ponches','Ponches_old1','PonchesOld','RRHHbk','RRHH'
    ,'WebDb','UNIPAGODB','Prestamos','DatosIMP' ,'Pruebas','BD1','CONTDESA' 
    ,'MINERD_V2', 'PruebaMVC','INABIMA_V2','RegistroActivos','Ponches')
 
UNION ALL
     SELECT
         td =@Server
        ,td =Name 
        ,td =NULL
        ,td =NULL
        ,td =NULL 
        ,td =NULL
        ,td =NULL 
        ,td =NULL
        ,td =NULL
        ,td =NULL
        ,td =NULL
        ,td =NULL
    FROM 
        master.dbo.sysdatabases As Record
    WHERE
        Name Not In(SELECT DISTINCT Database_Name FROM msdb.dbo.backupset)
    And Name Not In ('tempdb','pubs','northwind'

    ,'model','bima','DB_Ponches','Ponches_old1','PonchesOld',
    'RRHHbk'
    ,'RRHH','WebDb','UNIPAGODB','Prestamos','DatosIMP' ,
    'ponches','TA100SQL_new','TA100SQL', 'DW','dbINABIMA2',
    'RegistroActivos','Ponches')
    ORDER BY
        1, 2



/*
2021.05.18
 Alejandro Jimenez
 declarando y asignadno email a a envia el archivo 
*/

/*
Declaracion de variables que conforman el html que sera enviado 

*/
declare @Body NVARCHAR(MAX),
    @Tablehead varchar(1000),
    @tableTail varchar(1000),
    @fecha varchar(10) = convert(varchar(10) , getdate(), 120)


SET @TableTail = '</table></body></html>' ;

SET @TableHead = '<html><head>' + '<style>'
    + 'td {border: solid black;border-width: 1px;
    padding-left:5px;padding-right:5px;padding-top:1px;
    padding-bottom:1px;font: 11px arial} '

    + '</style>' + '</head>' + '<body>' + '<h1>Backup del Sql
     Server : ' + @Server+ ' en Fecha :' + @fecha +'  </h1> '

    + '<b>Modificaciones al Padron Electroral del INABIMA</b>' 

    --+ '<b> no Comprendidos entre las 7:00 AM y 18:00 PM </b>'
    --+'<b>(No contempla los usuarios de transdoc...) </b>'
    --+'<br>'
    + '<br><b>Fecha y hora de envio: </b>'+ CONVERT(VARCHAR(50), GETDATE(), 100) 
    + ' <br> <table cellpadding=0 cellspacing=0 border=0>' 

    + '<tr> <td bgcolor=#63ccff><b>Servidor - Instancia</b></td>'
    + '<td bgcolor=#63ccff><b>DataBase Name</b></td>'
    + '<td bgcolor=#ffee58><b>Full_Dias</b></td>'
    + '<td bgcolor=#63ccff><b>Full_Termino</b></td>'
    + '<td bgcolor=#63ccff><b>Full_Tamanho_MB</b></td>'
    + '<td bgcolor=#ffee58><b>Diff_Dias</b></td>'
    + '<td bgcolor=#63ccff><b>Diff_Termino</b></td>'
    + '<td bgcolor=#63ccff><b>Dias_Full_Diff</b></td>'
    + '<td bgcolor=#63ccff><b>Diff_Termino</b></td>'
    + '<td bgcolor=#63ccff><b>Diff_Tamanho_MB</b></td>'
    + '<td bgcolor=#63ccff><b>Tran_Minutos</b></td>'
    + '<td bgcolor=#63ccff><b>Tran_Tamanho_MB</b></td></tr>' ;


set @Body = (

    select 
        td = data1 , ''
        ,td = data2 , ''
        ,td = ISNULL(data3,0) , ''
        ,td = data4 , ''
        ,td =  convert(Varchar(12), data5) , ''
        ,td =ISNULL( data6,0) , ''
        ,td = ISNULL(data7,'1900-01-01') , ''
        ,td = ISNULL(data8 ,0), ''
        ,td =  convert(varchar(7), ISNULL(data9,0)), ''
        ,td = ISNULL(data10,0) , ''
        ,td = ISNULL(data11,'1900-01-01') , ''
        ,td = convert(varchar(17), ISNULL(data12, 0) ), ''
from @datos

  
            FOR   XML RAW('tr'),
                  ELEMENTS
            )


SELECT  @Body = @TableHead + ISNULL(@Body, '') + @TableTail

/*
Enviar Correo electronico 
alejandro Jimenez 
2019-11-20 
*/

EXEC sp_send_dbmail 
  @profile_name='SqlMail',
  @copy_recipients ='jose.jimenez@INABIMA.GOB.DO',
  @recipients=  'jose.jimenez@INABIMA.GOB.DO', --; ja.jimenezrosa@gmail.com',
  @subject='Reporte de Registros Modificados en el padrón del INABIMA.',
  @body=@Body ,
  @body_format = 'HTML' ;


~~~
# 


# Query de los ultimos Backup realizados  en un Servidor de Bases de datos.<a name="ultimobackup"></a>
# 
~~~sql

/*
Query de los ultimos Backup realizados en la base de datos del 10.0.0.252
Alejandro JImenez Rosa ------
*/


USE master 
GO
SET NOCOUNT ON
GO
DECLARE @Server varchar(40)
 
Set @Server = Convert(varchar(35), ServerProperty('machinename')) + '\' + @@ServiceName
 
BEGIN TRY
    SELECT 
         @Server As 'Servidor - Instancia'
        ,FR.Database_Name
        ,DateDiff(Day, FR.Backup_Finish_Date, GetDate()) As 'Full_Dias'
        ,FR.Backup_Finish_Date  As 'Full_Termino'
        ,Convert(Char,Convert(Numeric(12,2),(FR.Backup_Size / 1024 / 1024))) As Full_Tamanho_MB
        ,DateDiff(Day, DR.Backup_Finish_Date, GetDate()) As 'Diff_Dias'
        ,DR.Backup_Finish_Date  As 'Diff_Termino'
        ,Case 
            When DR.Backup_Finish_Date Is Null Then Null
            Else DateDiff(Day, FR.Backup_Finish_Date, DR.Backup_Finish_Date)
        End As 'Dias_Full_Diff'
        ,Convert(Char,Convert(Numeric(12,2),(DR.Backup_Size / 1024 / 1024))) As Diff_Tamanho_MB
        ,DateDiff(Minute, TR.Backup_Finish_Date, GetDate()) As 'Tran_Minutos'
        ,TR.Backup_Finish_Date As 'Tran_Termino'
        ,Convert(Char,Convert(Numeric(12,2),(TR.Backup_Size / 1024 / 1024))) As Tran_Tamanho_MB
    FROM 
        msdb.dbo.backupset As FR
    LEFT OUTER JOIN
        msdb.dbo.backupset As TR
    ON
        TR.Database_Name = FR.Database_Name
    AND TR.Type = 'L'
    AND TR.Backup_Finish_Date =
        (
            (SELECT Max(Backup_Finish_Date) 
            FROM    msdb.dbo.backupset B2 
            WHERE   B2.Database_Name = FR.Database_Name 
            And B2.Type = 'L')
        )
    LEFT OUTER JOIN
        msdb.dbo.backupset As DR
    ON
        DR.Database_Name = FR.Database_Name
    AND DR.Type = 'I'
    AND DR.Backup_Finish_Date =
        (
            (SELECT Max(Backup_Finish_Date) 
            FROM    msdb.dbo.backupset B2 
            WHERE B2.Database_Name = FR.Database_Name 
              And B2.Type = 'I')
        )
    WHERE
        FR.Type = 'D' -- full backups only
    AND FR.Backup_Finish_Date = 
        (
            SELECT Max(Backup_Finish_Date) 
            FROM msdb.dbo.backupset B2 
            WHERE B2.Database_Name = FR.Database_Name 
            And   B2.Type = 'D'
        )
    And FR.Database_Name In (SELECT name FROM master.dbo.
    sysdatabases) 

    And FR.Database_Name Not In ('tempdb','pubs','northwind',
    'model','bima','DB_Ponches','Ponches_old1','PonchesOld',
    'RRHHbk','RRHH','WebDb','UNIPAGODB','Prestamos','DatosIMP' ,
    'ponches','TA100SQL_new','TA100SQL22')

 
UNION ALL
 
    SELECT
         @Server
        ,Name
        ,NULL
        ,NULL
        ,NULL 
        ,NULL
        ,NULL 
        ,NULL
        ,NULL
        ,NULL
        ,NULL
        ,NULL
    FROM 
        master.dbo.sysdatabases As Record
    WHERE
        Name Not In(SELECT DISTINCT Database_Name FROM msdb.dbo.backupset)
    And Name Not In ('tempdb','pubs','northwind','model','bima',
    'DB_Ponches','Ponches_old1','PonchesOld','RRHHbk','RRHH',
    'WebDb','UNIPAGODB','Prestamos','DatosIMP' ,'ponches',
    'TA100SQL_new','TA100SQL22')
    ORDER BY
        1, 2
END TRY
BEGIN CATCH
    SELECT message_id, text FROM sys.messages WHERE message_id = @@ERROR AND language_id = 1033
END CATCH
~~~

#

# Query Que muestra la ultimos Restore realizados a un Servidor de Bases de datos.<a name="queryrestoresql"></a>
![](https://learn.microsoft.com/es-es/sql/relational-databases/backup-restore/media/bnrr-rmfull1-db-failure-pt.gif?view=sql-server-ver16)

#### El mismo es utilizado para ver las restauraciones que hacemos en el servidor de restauracion.  Mas puede ser utilizado para lo que queramos. 

#### en realidad solo nos muestra un listado de restauraciones con sus respectivas fecha.
# 

~~~sql
SELECT rs.destination_database_name, 
    rs.restore_date, 
    bs.backup_start_date, 
    bs.backup_finish_date, 
    bs.database_name as source_database_name, 
    bmf.physical_device_name as backup_file_used_for_restore
    FROM msdb..restorehistory rs
        INNER JOIN msdb..backupset bs
        ON rs.backup_set_id = bs.backup_set_id
        INNER JOIN msdb..backupmediafamily bmf 
        ON bs.media_set_id = bmf.media_set_id 
        ORDER BY rs.restore_date DESC
~~~
#  

# Limpiar y Reducir el Log de Transacciones SQL Server. [Fuente SoporteSQL](https://soportesql.wordpress.com/2014/04/22/limpiar-y-reducir-el-log-de-transacciones-sql-server/)  <a name="limpiarlog"></a>

<img src="https://soportesql.files.wordpress.com/2014/04/fa932-log.png?format=jpg&name=large" alt="JuveR" width="800px">

## Script de Ejemplo que permite limpiar y reducir el log de transacciones de una base de datos, no es posible limpiar el log sin realizar primero un backup del log, realizaremos nuestro ejemplo con una base de datos a la que llamaremos PrimaveraNew
# 


~~~sql
--Para Limpiar el Log de Transacciones es necesario realizar un Backup del Log
--Backup log PrimaveraNeW
to disk  =‘C:\test\BackupLog.bak’


--–Una vez hecho el backup consultamos el nombre lógico de los archivos del log
sp_helpdb PrimaveraNeW
~~~
# 

#### Resultado:
<img src="https://soportesql.files.wordpress.com/2014/04/fa932-log.png?format=jpg&name=large" alt="JuveR" width="800px">


#### El Siguiente Código nos permite realizar la reduccion de los log de la base de datos.  El mismo puede ser utilizado como ejemplo para nuestros trabajos
# 

~~~sql
--- Alejandro Jimenez Rosa
--- 11 de Marzo 2022

---— Antes de truncar el log cambiamos el modelo de recuperación a SIMPLE.
ALTER DATABASE PrimaveraNeW
SET RECOVERY SIMPLE;
GO
–Reducimos el log de transacciones a  1 MB.
DBCC SHRINKFILE(PrimaveraNeW_Log, 1);
GO
— Cambiamos nuevamente el modelo de recuperación a Completo.
ALTER DATABASE PrimaveraNeW
SET RECOVERY FULL;
GO
~~~
# 

## Seguimiento en Tiempo Real de Operaciones de Backup y Restore<a name="tiemporestore"></a>
<img src="https://community.netapp.com/t5/image/serverpage/image-id/24675iA413E45406EBE109/image-dimensions/802x333?v=v2&name=large" alt="JuveR" width="800px">




#### Este código SQL utiliza las vistas dinámicas sys.dm_exec_requests y sys.dm_exec_sql_text para recopilar datos sobre las solicitudes en ejecución. A través del uso de CROSS APPLY, vincula la información de sys.dm_exec_requests con el texto del SQL subyacente utilizando sys.dm_exec_sql_text. La consulta final devuelve los siguientes campos:

#### SPID (identificador de sesión): renombrado como session_id del sys.dm_exec_requests.
#### command: tipo de comando en ejecución, como 'BACKUP DATABASE' o 'RESTORE DATABASE'.
#### Query (consulta): el texto de la consulta SQL actual, obtenido a través de sys.dm_exec_sql_text.
#### start_time: momento en el que la solicitud de ejecución comenzó.
#### percent_complete: porcentaje de completitud de la tarea en ejecución.
#### estimated_completion_time: tiempo estimado de finalización de la tarea, calculado utilizando estimated_completion_time y ajustado a la hora actual (getdate()).
#### La cláusula WHERE filtra los resultados para mostrar solo las solicitudes que involucran comandos de copia de seguridad o restauración de bases de datos, utilizando la condición r.command in ('BACKUP DATABASE','RESTORE DATABASE').
# 
#### En resumen, este query es útil para monitorear y obtener detalles específicos sobre las operaciones de copia de seguridad y restauración de bases de datos en el entorno de SQL Server.

~~~sql
SELECT session_id as SPID, command, a.text AS Query, start_time, percent_complete, dateadd(second,estimated_completion_time/1000, getdate()) as estimated_completion_time

FROM sys.dm_exec_requests r CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) a

WHERE r.command in ('BACKUP DATABASE','RESTORE DATABASE')
~~~

# 


### Documentación del Script SQL para Monitoreo de Operaciones de Backup y Restore<a name="tiempobkrestore"></a>

#### Descripción
Este script SQL permite monitorear el estado de las operaciones de respaldo y restauración de bases de datos en el servidor de base de datos actual.

#### Detalles del Script
~~~sql
USE master;

SELECT 
    session_id as SPID, 
    command, 
    a.text AS Query, 
    start_time, 
    percent_complete, 
    dateadd(second, estimated_completion_time/1000, getdate()) as estimated_completion_time
FROM 
    sys.dm_exec_requests r 
    CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) a
WHERE 
    r.command in ('BACKUP DATABASE', 'RESTORE DATABASE');
~~~

#### Explicación
- **USE master;**: Especifica que la consulta se ejecutará en la base de datos `master`.
- **SELECT ...**: Recupera información relevante de las operaciones actuales de respaldo y restauración en curso:
  - `session_id`: Identificador de sesión (SPID) para la operación.
  - `command`: Tipo de comando en ejecución (BACKUP DATABASE o RESTORE DATABASE).
  - `a.text AS Query`: Consulta SQL en ejecución.
  - `start_time`: Hora de inicio de la operación.
  - `percent_complete`: Porcentaje completado de la operación.
  - `dateadd(second, estimated_completion_time/1000, getdate()) as estimated_completion_time`: Estimación de tiempo de finalización de la operación.
- **FROM sys.dm_exec_requests r CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) a**: Utiliza las vistas del sistema `sys.dm_exec_requests` y `sys.dm_exec_sql_text` para obtener información detallada sobre las consultas en ejecución.
- **WHERE r.command in ('BACKUP DATABASE', 'RESTORE DATABASE');**: Filtra las consultas en ejecución para mostrar solo las operaciones de respaldo y restauración de bases de datos.

#### Enlace de Búsqueda
Puedes encontrar más información sobre las vistas del sistema utilizadas y cómo interpretar los resultados en la documentación oficial de Microsoft SQL Server:

[Documentación de sys.dm_exec_requests](https://docs.microsoft.com/sql/relational-databases/system-dynamic-management-views/sys-dm-exec-requests-transact-sql)

[Documentación de sys.dm_exec_sql_text](https://docs.microsoft.com/sql/relational-databases/system-dynamic-management-views/sys-dm-exec-sql-text-transact-sql)

Este formato estructurado proporciona una visión clara y organizada del script, facilitando su comprensión y referencia futura.



# Performance.

## Informes del tablero

#### Vamos al SQL Server Management Studio (SSMS) y lo primero es que te voy a llevar a través de los informes del panel de control listos para usar de todos los niveles. Puedes encontrarlos haciendo clic con el botón derecho en la instancia de SQL Server en el Explorador de objetos y, en el menú contextual, encontrará Informes > Informes estándar:

<img src="https://www.sqlshack.com/wp-content/uploads/2018/08/word-image-149.png?format=jpg&name=large" alt="JuveR" width="800px">



#### Todos los informes del panel de control son bastante útiles, y no los revisaremos todos, ya que esto requeriría mucho tiempo/ palabras, aunque puedes revisarlos todos cuando tengas la oportunidad. Para mostrar un ejemplo, escoge el Panel del servidor en el menú contextual. Este informe nos brinda mucha información sobre el estado actual de la instancia de SQL Server, incluida su configuración, versión, servicios y actividad:
#
#### Adicionalmente, en el nivel de la base de datos, si hacemos clic con el botón derecho en una base de datos y accedemos a los informes, tenemos todo tipo de informes de uso de disco, eventos de copia de seguridad y restauración, principales transacciones, estadísticas de índices, etc.

<img src="https://www.sqlshack.com/wp-content/uploads/2018/08/word-image-152.png?format=jpg&name=large" alt="JuveR" width="800px">

#### Entonces, todos estos informes del panel de control son excelentes, son fáciles de consumir y trabajar con ellos.

#### **Monitor de actividad**

#### Ahora, vamos a ver el Monitor de actividad el cual es un monitor en tiempo real dentro de SQL Server que podemos utilizar para poder monitorear todo, desde el rendimiento hasta los costos de I/O hasta consultas más complejas, etc. Para iniciar el Monitor de actividad, haga clic con el botón derecho en la instancia de SQL Server en el Explorador de objetos y desde el menú contextual, seleccione Monitor de actividad. También puede iniciarlo desde la barra de herramientas Estándar, haciendo clic en el icono del Monitor de actividad:

<img src="https://www.sqlshack.com/wp-content/uploads/2018/08/word-image-153.png?format=jpg&name=large" alt="JuveR" width="800px">

#### El Monitor de actividad generalmente ha sido una de las herramientas de acceso si algo sale mal de repente con SQL Server. Lo primero que vemos, cuando activamos el Monitor de actividad es el panel Información general. También, esta herramienta tiene los siguientes paneles expandibles y colapsables: Esperas de recursos, I/O de archivos de datos, Consultas valiosas recientes y Consultas valiosas activas:
![]()
<img src="https://i.blogs.es/b40d07/monitor-de-actividad/1366_2000.jpg?format=jpg&name=large" alt="JuveR" width="800px">


#### **Procesos**: nos brindan la capacidad de ver los procesos que se ejecutan actualmente para que podamos gestionarlos. Al hacer clic con el botón derecho aparece el menú contextual desde el cual se pueden finalizar, rastrear en el Analizador de SQL Server (más información sobre este tema más adelante), verlo como un plan de ejecución, y por último, pero no menos importante, los detalles de la sesión que muestra un diálogo que muestra la última T -Secuencia de comandos de SQL:
![]()
<img src="https://www.sqlshack.com/wp-content/uploads/2018/08/word-image-155.png?format=jpg&name=large" alt="JuveR" width="800px">

#### **Espera de recursos** – muestra información sobre las espera de recursos:

![]()
<img src="https://www.sqlshack.com/wp-content/uploads/2018/08/word-image-156.png?format=jpg&name=large" alt="JuveR" width="800px">


#### **I/O del archivo de datos** – muestra la información del I/O del archivo de datos actual que se produce a nivel de archivo:
![]()
<img src="https://www.sqlshack.com/wp-content/uploads/2018/08/word-image-157.png?format=jpg&name=large" alt="JuveR" width="800px">

#### Consultas valiosas recientes/activas – muestra consultas valiosas recientes/activas que utilizan muchos recursos (memoria, actividad del disco, red):

![]()
<img src="https://www.sqlshack.com/wp-content/uploads/2018/08/word-image-158.png?format=jpg&name=large" alt="JuveR" width="800px">
#### Es un excelente punto de partida para poder encontrar qué consultas están causando problemas, ocupando demasiados recursos, etc., porque una vez que se encuentran, se pueden ver como el plan de ejecución para que se puedan encontrar fácilmente los puntos calientes:

![]()
<img src="https://www.sqlshack.com/wp-content/uploads/2018/08/word-image-159.png?format=jpg&name=large" alt="JuveR" width="800px">
## Principales DMV para el administrador

#### Vamos a echar un vistazo a los principales DMV que todos los administradores de BDs deberían saber. Estos son los DMV que siempre deberías tener en tu bolsillo. Para obtener una lista rápida de todos los DMO (DMV y DMF), simplemente consúltela siguiente lista:
# 

~~~sql
-- List of all DMOs (DMVs & DMFs)
SELECT name, 
       type, 
       type_desc
FROM sys.system_objects so
WHERE so.name LIKE 'dm_%'
ORDER BY so.name;
~~~
# 

#### Esto devolverá todos los DMV y DMF en SQL Server. Mire la columna de tipo y observe que “V” significa una vista y “IF” para una función:

![](https://www.sqlshack.com/wp-content/uploads/2018/08/word-image-160.png)


#### La consulta anterior devolvió 243 DMO en un sistema. Aquí está la lista de las más útiles:

## Ejecución

#### sys.dm_exec_connections = Conexión establecida
#### sys.dm_exec_sessions = Sesiones autenticadas
#### sys.dm_exec_requests = Solicitudes actuales

## Ejecución (consulta relacionada)

#### sys.dm_exec_cached_plans = Planes de ejecución en caché
#### sys.dm_exec_query_plan = Mostrar plan para un plan_handle dado en caché
#### sys.dm_exec_query_stats = Estadísticas de rendimiento de consultas
#### sys.dm_exec_sql_text = Texto SQL dado un sql_handle

## Índice

#### sys.dm_db_index_physical_stats = Tamaño del índice y fragmentación
#### sys.dm_db_index_usage_stats = Uso del índice a través del optimizador de consultas
#### sys.dm_db_missing_index_details = Descubra los índices faltantes

## OS

#### sys.dm_os_performance_counters = Lista de todos los contadores y valores de rendimiento de SQL Server
#### sys.dm_os_schedulers = Detectar la presión de la CPU
#### sys.dm_os_waiting_tasks = Tareas en espera de recursos
#### sys.dm_os_wait_stats = Todos los tipos de espera y estadísticas

## I/O

#### sys.dm_io_virtual_file_stats = Estadísticas de E / S para datos y archivos de registro
#### sys.dm_io_pending_io_requests = Solicitudes de E / S pendientes

## CLR

#### sys.dm_clr_loaded_assemblies = Ensamblados cargados
#### sys.dm_clr_tasks = Tareas relacionadas con CLR

## Los libros en línea (docs.microsoft.com) tienen una gran cantidad de información general para todos los DMO. Siéntase libre de copiar cualquier nombre de la cuadrícula de resultados, péguelo en el navegador y búsquelo. Lo más factible es que el primer artículo en la parte superior sea de MS docs que muestre la descripción general y el uso de T-SQL.







#
## 
# Consultar ultima fecha de acceso Login MS SQL Server<a name="consultaulfechaacceso"></a>

#### Es muy posible que en algún momento hayas pensado en que estaría bien saber cuándo ha sido el último acceso a una determinada tabla de tu base de datos SQL Server, ¿no se os ocurre ningún caso? Imaginemos que hemos modificado cierto código provocando que una tabla deje de utilizarse y pueda ser eliminada , ¿estamos seguros que ningún otro código o aplicación acceden a esa tabla? A continuación os explicaré cómo podemos saber la última vez que una tabla ha sido accedida en SQL Server.


###### query 1
# 

~~~SQL

SELECT -- [id]
      [ServidorDB]
      ,[Tabla]
      ,max([Fecha_Acceso]) Fecha_Acceso
      --,[fecha_Ejecucion]
  FROM [Db_Analisis].[TablasFechasAccesos]
    where Fecha_Acceso is not null
      --and [Tabla] = 
      and [ServidorDB] = 'inabima'
    group by
          [ServidorDB]
      ,[Tabla]

    order by Fecha_Acceso desc

GO
~~~
# 

###### query 2
# 

~~~SQL
-- Comprobamos los accesos
SELECT tab.name AS Tablename,
       user_seeks, user_scans, user_lookups, user_updates,
       last_user_seek, last_user_scan, last_user_lookup, last_user_update
FROM sys.dm_db_index_usage_stats ius 
INNER JOIN sys.tables tab ON (tab.object_id = ius.object_id)
WHERE database_id = DB_ID(N'AdventureWorks')
  AND tab.name = 'Employee'
~~~
# 


# B.Devolver agregados de recuentos de filas para una consulta
#### En el ejemplo siguiente se devuelve información de agregado de recuento de filas (filas totales, filas mínimas, filas máximas y últimas filas) para las consultas.
# 

~~~sql
SELECT qs.execution_count,  
    SUBSTRING(qt.text,qs.statement_start_offset/2 +1,   
                 (CASE WHEN qs.statement_end_offset = -1   
                       THEN LEN(CONVERT(nvarchar(max), qt.text)) * 2   
                       ELSE qs.statement_end_offset end -  
                            qs.statement_start_offset  
                 )/2  
             ) AS query_text,   
     qt.dbid, dbname= DB_NAME (qt.dbid), qt.objectid,   
     qs.total_rows, qs.last_rows, qs.min_rows, qs.max_rows  
FROM sys.dm_exec_query_stats AS qs   
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS qt   
WHERE qt.text like '%SELECT%'    
--and objectid = 562153098
ORDER BY qs.execution_count DESC;  
~~~
# 


## Documentación sobre la Latencia de Discos y Cómo Manejarla en SQL Server<a name="disklatency"></a>

<img src="https://acf.geeknetic.es/imagenes/auto/23/11/10/6ik-micron-lanza-la-memoria-de-baja-latencia-y-velocidades-de-hasta-8.000-mhz-para-servidores-en-capacid.png?format=jpg&name=large" alt="JuveR" width="800px">

**Autor: Jose Alejandro Jimenez Rosa**

#### Introducción

La latencia de discos es un aspecto crítico en la gestión del rendimiento de sistemas de almacenamiento, especialmente en servidores SQL. La latencia se refiere al tiempo que transcurre desde que se envía una solicitud de lectura o escritura al disco hasta que la operación se completa. Una alta latencia puede llevar a un rendimiento deficiente del sistema, afectando la productividad y la eficiencia operativa. Esta documentación explora en detalle qué es la latencia de discos, sus causas, cómo medirla y las estrategias para reducirla en el contexto de SQL Server.

#### ¿Qué es la Latencia de Discos?

La latencia de discos es el retraso entre una solicitud de E/S (Entrada/Salida) y la respuesta del disco. Se mide en milisegundos (ms) y puede verse influenciada por varios factores, incluyendo la velocidad del disco, la carga de trabajo, la interfaz de conexión y la configuración del sistema. La latencia es un componente esencial del tiempo de respuesta total del sistema, y su reducción es crucial para mejorar el rendimiento general.

#### Causas de la Latencia de Discos

1. **Velocidad del Disco**: Los discos duros (HDD) mecánicos tienden a tener mayor latencia en comparación con las unidades de estado sólido (SSD) debido a sus partes móviles.
2. **Carga de Trabajo**: Una alta carga de trabajo puede aumentar la latencia debido a la cola de solicitudes de E/S.
3. **Interfaz de Conexión**: La interfaz del disco (SATA, SAS, NVMe) puede afectar significativamente la latencia.
4. **Configuración del Sistema**: La configuración del sistema operativo y del SQL Server también puede influir en la latencia.

#### Cómo Medir la Latencia de Discos en SQL Server

Existen varias formas de verificar problemas de latencia de discos en SQL Server, utilizando vistas de gestión dinámica (DMVs) y herramientas como `dbatools`.

##### Uso de DMVs

Desde SQL Server 2005, Microsoft introdujo la vista de gestión dinámica `sys.dm_io_virtual_file_stats`, que reporta actividades de lectura y escritura de discos para archivos de datos y de registros.

##### Consulta para Medir Latencia

A continuación, se presenta una consulta basada en el trabajo de Paul Randal de SQLSkills, con una columna adicional para categorizar rápidamente los valores de latencia.

~~~sql
SELECT
   [ReadLatency] =
        CASE WHEN [num_of_reads] = 0
            THEN 0 ELSE ([io_stall_read_ms] / [num_of_reads]) END,
   [WriteLatency] =
        CASE WHEN [num_of_writes] = 0
            THEN 0 ELSE ([io_stall_write_ms] / [num_of_writes]) END,
   [Latency] =
        CASE WHEN ([num_of_reads] = 0 AND [num_of_writes] = 0)
            THEN 0 ELSE ([io_stall] / ([num_of_reads] + [num_of_writes])) END,
   [Latency Desc] = 
         CASE 
            WHEN ([num_of_reads] = 0 AND [num_of_writes] = 0) THEN 'N/A' 
            ELSE 
               CASE WHEN ([io_stall] / ([num_of_reads] + [num_of_writes])) < 2 THEN 'Excellent'
                    WHEN ([io_stall] / ([num_of_reads] + [num_of_writes])) < 6 THEN 'Very good'
                    WHEN ([io_stall] / ([num_of_reads] + [num_of_writes])) < 11 THEN 'Good'
                    WHEN ([io_stall] / ([num_of_reads] + [num_of_writes])) < 21 THEN 'Poor'
                    WHEN ([io_stall] / ([num_of_reads] + [num_of_writes])) < 101 THEN 'Bad'
                    WHEN ([io_stall] / ([num_of_reads] + [num_of_writes])) < 501 THEN 'Yikes!'
               ELSE 'YIKES!!'
               END 
         END, 
   [AvgBPerRead] =
        CASE WHEN [num_of_reads] = 0
            THEN 0 ELSE ([num_of_bytes_read] / [num_of_reads]) END,
   [AvgBPerWrite] =
        CASE WHEN [num_of_writes] = 0
            THEN 0 ELSE ([num_of_bytes_written] / [num_of_writes]) END,
   [AvgBPerTransfer] =
        CASE WHEN ([num_of_reads] = 0 AND [num_of_writes] = 0)
            THEN 0 ELSE
                (([num_of_bytes_read] + [num_of_bytes_written]) /
                ([num_of_reads] + [num_of_writes])) END,
   LEFT ([mf].[physical_name], 2) AS [Drive],
   DB_NAME ([vfs].[database_id]) AS [DB],
   [mf].[physical_name]
FROM
   sys.dm_io_virtual_file_stats (NULL,NULL) AS [vfs]
   JOIN sys.master_files AS [mf]
   ON [vfs].[database_id] = [mf].[database_id]
      AND [vfs].[file_id] = [mf].[file_id]
ORDER BY [Latency] DESC;
GO
~~~

Esta consulta ayuda a interpretar rápidamente los resultados de latencia. Los valores de latencia se clasifican de la siguiente manera:

| Latencia       | Descripción  |
|----------------|--------------|
| 0 a 1 ms       | Excelente    |
| 2 a 5 ms       | Muy bueno    |
| 6 a 10 ms      | Bueno        |
| 11 a 20 ms     | Pobre        |
| 21 a 100 ms    | Malo         |
| 101 a 500 ms   | ¡Ay!         |
| más de 500 ms  | ¡¡AY!!       |

##### Uso de dbatools

`dbatools.io` ofrece una herramienta llamada `Test-DbaDiskSpeed`, que realiza pruebas de velocidad del disco y proporciona un informe detallado.

~~~cmd
Test-DbaDiskSpeed -SqlInstance localhost -SqlCredential sa | Format-Table -Property Database, SizeGB, FileName, FileID, FileType, DiskLocation, Reads, AverageReadStall, ReadPerformance, Writes, AverageWriteStall, WritePerformance, 'Avg Overall Latency' | Out-String -Width 4096 |out-file c:\temp\DbaDiskSpeed.txt
~~~

Este comando ejecuta una prueba de velocidad de disco en la instancia de SQL Server especificada y genera un archivo de salida con los resultados.

#### Estrategias para Reducir la Latencia de Discos

1. **Actualizar a SSDs**: Los discos de estado sólido ofrecen menor latencia en comparación con los HDDs tradicionales.
2. **Optimizar la Configuración del Sistema**: Ajustar configuraciones del sistema operativo y del SQL Server para optimizar el rendimiento de E/S.
3. **Distribuir la Carga de Trabajo**: Balancear la carga de trabajo entre varios discos para evitar cuellos de botella.
4. **Monitorización Continua**: Utilizar herramientas y scripts para monitorear continuamente la latencia y tomar acciones proactivas.

#### Conclusión

La gestión de la latencia de discos es esencial para mantener un rendimiento óptimo en los servidores SQL. Medir y entender la latencia mediante DMVs y herramientas como `dbatools` permite a los administradores identificar cuellos de botella y aplicar estrategias para mejorar el rendimiento. Mantener una baja latencia asegura que el sistema responda de manera eficiente, mejorando así la productividad y la satisfacción del usuario final.











# 
# SQL Server memory use by database and object<a name="disklatency2"></a>
## Problem
#### For many people, the way that SQL Server uses memory can be a bit of an enigma. A large percentage of the memory your SQL Server instance utilizes is consumed by buffer pool (essentially, data). Without a lot of digging, it can be hard to tell which of your databases consume the most buffer pool memory, and even more so, which objects within those databases. This information can be quite useful, for example, if you are considering an application change to split your database across multiple servers, or trying to identify databases that are candidates for consolidation.

## Solution
#### A Dynamic Management View (DMV) introduced in SQL Server 2005, called sys.dm_os_buffer_descriptors, contains a row for every page that has been cached in the buffer pool. Using this DMV, you can quickly determine which database(s) are utilizing the majority of your buffer pool memory. Once you have identified the databases that are occupying much of the buffer pool, you can drill into them individually. In the following query, I first find out exactly how big the buffer pool currently is (from the DMV sys.dm_os_performance_counters), allowing me to calculate the percentage of the buffer pool being used by each database:
# 
# 

~~~sql
-- Note: querying sys.dm_os_buffer_descriptors
-- requires the VIEW_SERVER_STATE permission.

DECLARE @total_buffer INT;

SELECT @total_buffer = cntr_value
FROM sys.dm_os_performance_counters 
WHERE RTRIM([object_name]) LIKE '%Buffer Manager'
AND counter_name = 'Database Pages';

;WITH src AS
(
  SELECT 
  database_id, db_buffer_pages = COUNT_BIG(*)
  FROM sys.dm_os_buffer_descriptors
  --WHERE database_id BETWEEN 5 AND 32766
  GROUP BY database_id
)
SELECT
[db_name] = CASE [database_id] WHEN 32767 
THEN 'Resource DB' 
ELSE DB_NAME([database_id]) END,
db_buffer_pages,
db_buffer_MB = db_buffer_pages / 128,
db_buffer_percent = CONVERT(DECIMAL(6,3), 
db_buffer_pages * 100.0 / @total_buffer)
FROM src
ORDER BY db_buffer_MB DESC; 
~~~
# 
# 


#### In the above query, I've included the system databases, but you can exclude them by uncommenting the WHERE clause within the CTE. Note that the actual filter may need to change with future versions of SQL Server; for example, in SQL Server 2012, there is a new database for Integration Services called SSISDB. You may want to keep an eye on system databases just to have a complete picture, seeing as there isn't much you can do about their buffer pool usage anyway - unless you are using master or msdb for your own custom objects.

#### That all said, here are partial results from an instance on my local virtual machine:


<img src="https://www.mssqltips.com/tipImages2/2393_memory_a.png?format=jpg&name=large" alt="JuveR" width="800px">

#### Clearly, the SQLSentry database - while only representing 258 MB - occupies about 70% of my buffer pool for this instance. So now I know that I can drill into that database specifically if I want to track down the objects that are taking up most of that memory. You can once again use the sys.dm_os_buffer_descriptors only this time, instead of aggregating the page counts at the database level, we can utilize a set of catalog views to determine the number of pages (and therefore amount of memory) dedicated to each object.
# 
# 

~~~sql
USE SQLSentry;
GO

;WITH src AS
(
  SELECT
  [Object] = o.name,
  [Type] = o.type_desc,
  [Index] = COALESCE(i.name, ''),
  [Index_Type] = i.type_desc,
  p.[object_id],
  p.index_id,
  au.allocation_unit_id
  FROM sys.partitions AS p
  INNER JOIN sys.allocation_units AS au ON p.hobt_id = au.container_id
  INNER JOIN sys.objects AS o ON p.[object_id] = o.[object_id]
  INNER JOIN sys.indexes AS i ON o.[object_id] = i.[object_id] AND p.index_id = i.index_id
  WHERE
  au.[type] IN (1,2,3)
  AND o.is_ms_shipped = 0
)
SELECT
src.[Object],
src.[Type],
src.[Index],
src.Index_Type,
buffer_pages = COUNT_BIG(b.page_id),
buffer_mb = COUNT_BIG(b.page_id) / 128
FROM src
INNER JOIN sys.dm_os_buffer_descriptors AS b ON src.allocation_unit_id = b.allocation_unit_id
WHERE
b.database_id = DB_ID()
GROUP BY
src.[Object],
src.[Type],
src.[Index],
src.Index_Type
ORDER BY
buffer_pages DESC;
~~~
# 
# 
#### Here are the results from this database. Notice that I've captured both clustered and non-clustered indexes, for clustered tables and heaps, and for illustrative purposes I have also created an indexed view.

<img src="https://www.mssqltips.com/tipImages2/2393_memory_b.png?format=jpg&name=large" alt="JuveR" width="800px">

#### Please keep in mind that the buffer pool is in constant flux, and that this latter query has explicitly filtered out system objects, so the numbers won't always add up nicely. Still, this should give you a fairly good idea of which objects are using your buffer pool the most.

#### When investigating the performance of your servers, buffer pool data is only a part of the picture, but it's one that is often overlooked. Including this data will help you to make better and more informed decisions about direction and scale.

# 
# Listar todos los Procedimientos Almacenados de una Base de Datos<a name="procalmacenados"></a>
# 

~~~sql
SELECT ROUTINE_NAME FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE ROUTINE_TYPE = 'PROCEDURE'
   ORDER BY ROUTINE_NAME
~~~
# 
# 

# A.Buscar las consultas TOP N<a name="buscarconsultatop"></a>
#### En el siguiente ejemplo se devuelve información acerca de las cinco primeras consultas clasificadas por el promedio de tiempo de CPU. Este ejemplo agrega las consultas según su hash de consulta para que las consultas lógicamente equivalentes se agrupen según su consumo acumulado de los recursos.
# 

~~~sql
SELECT TOP 5 query_stats.query_hash AS "Query Hash",   @@SERVERNAME ,
    SUM(query_stats.total_worker_time) / SUM(query_stats.execution_count) AS "Avg CPU Time",  
    MIN(query_stats.statement_text) AS "Statement Text"  
FROM   
    (SELECT QS.*,   
    SUBSTRING(ST.text, (QS.statement_start_offset/2) + 1,  
    ((CASE statement_end_offset   
        WHEN -1 THEN DATALENGTH(ST.text)  
        ELSE QS.statement_end_offset END   
            - QS.statement_start_offset)/2) + 1) AS statement_text  
     FROM sys.dm_exec_query_stats AS QS  
     CROSS APPLY sys.dm_exec_sql_text(QS.sql_handle) as ST) as query_stats  
GROUP BY query_stats.query_hash  
ORDER BY 2 DESC; 
~~~
# 

# 
# Espacios en disco y ocupados por db<a name="espacioendiscodb"></a>
# 

~~~sql
/*
SQL SERVER – Disk Space Monitoring – Detecting Low Disk Space on Server
*/
EXEC MASTER..xp_fixeddrives
GO

/*
El query en cuestion nos presenta 3 columnas Logical_name, Drive letter y FreeSapce en MB.
*/

SELECT DISTINCT dovs.logical_volume_name AS LogicalName,
dovs.volume_mount_point AS Drive,
CONVERT(INT,dovs.available_bytes/1048576.0) AS FreeSpaceInMB
,convert(varchar(10), getdate(),120) Date_Verif
FROM sys.master_files mf
CROSS APPLY sys.dm_os_volume_stats(mf.database_id, mf.FILE_ID) dovs
ORDER BY FreeSpaceInMB ASC
GO
--We can further modify above query to also include database name in the query as well.
SELECT DISTINCT DB_NAME(dovs.database_id) DBName,
dovs.logical_volume_name AS LogicalName,
dovs.volume_mount_point AS Drive,
CONVERT(INT,dovs.available_bytes/1048576.0) AS FreeSpaceInMB
FROM sys.master_files mf
CROSS APPLY sys.dm_os_volume_stats(mf.database_id, mf.FILE_ID) dovs
ORDER BY FreeSpaceInMB ASC
GO

--If you see a database name, multiple times, it is because your 
--database has multiple files and they are on different drives. You 
--can modify above query one more time to even include the details of actual file location.

SELECT DISTINCT @@SERVERNAME "ServerName", DB_NAME(dovs.database_id) DBName,
        mf.physical_name PhysicalFileLocation,
        dovs.logical_volume_name AS LogicalName,
        dovs.volume_mount_point AS Drive,
        CONVERT(INT,dovs.available_bytes/1048576.0) AS FreeSpaceInMB
        ,convert(varchar(10), getdate(),120) Date_Verif
FROM sys.master_files mf
        CROSS APPLY sys.dm_os_volume_stats(mf.database_id, mf.FILE_ID) dovs
ORDER BY FreeSpaceInMB ASC
GO
~~~
# 
# 

# Vía 2: Rendimiento de las consultas<a name="rendimientoconsultas2"></a>
# Seguimiento de SP
#### Al realizar el seguimiento de su aplicación SQL Server, vale la pena familiarizarse con los procedimientos almacenados que se usan para el seguimiento. Si usa una interfaz gráfica (SQL Server Profiler) para realizar el seguimiento, puede aumentar la carga del sistema entre un 15 y un 25 por ciento. 

#### Si puede usar procedimientos almacenados en su seguimiento, este valor puede reducirse a la mitad.
#### Cuando sé que el sistema tiene un cuello de botella en algún lugar y deseo determinar qué instrucciones SQL  actuales están probando problemas en el servidor, ejecuto la consulta siguiente. Esta consulta me permite  ver las distintas instrucciones y los recursos que están usando actualmente, así como instrucciones que  necesitan ser revisadas para mejorar el rendimiento. Para obtener más información acerca de los seguimientos  de SQL, consulte msdn2.microsoft.com/ms191006.aspx.
# 

~~~sql

/*
Alejandro Jimenez 
01 de agosto del 2016

Vía 2: Rendimiento de las consultas
Seguimiento de SP
Al realizar el seguimiento de su aplicación SQL Server, vale la pena familiarizarse con los procedimientos 
almacenados que se usan para el seguimiento. Si usa una interfaz gráfica (SQL Server Profiler) para realizar 
el seguimiento, puede aumentar la carga del sistema entre un 15 y un 25 por ciento. Si puede usar procedimientos 
almacenados en su seguimiento, este valor puede reducirse a la mitad.
Cuando sé que el sistema tiene un cuello de botella en algún lugar y deseo determinar qué instrucciones SQL
 actuales están probando problemas en el servidor, ejecuto la consulta siguiente. Esta consulta me permite 
 ver las distintas instrucciones y los recursos que están usando actualmente, así como instrucciones que 
 necesitan ser revisadas para mejorar el rendimiento. Para obtener más información acerca de los seguimientos 
 de SQL, consulte msdn2.microsoft.com/ms191006.aspx.
*/

SELECT  
    substring(text,qs.statement_start_offset/2 
        ,(CASE     
            WHEN qs.statement_end_offset = -1 THEN len(convert(nvarchar(max), text)) * 2  
            ELSE qs.statement_end_offset  
        END - qs.statement_start_offset)/2)  
    ,qs.plan_generation_num as recompiles 
    ,qs.execution_count as execution_count 
    ,qs.total_elapsed_time - qs.total_worker_time as total_wait_time 
    ,qs.total_worker_time as cpu_time 
    ,qs.total_logical_reads as reads 
    ,qs.total_logical_writes as writes 
FROM sys.dm_exec_query_stats qs 
    CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) st 
    LEFT JOIN sys.dm_exec_requests r  
        ON qs.sql_handle = r.sql_handle 
ORDER BY 3 DESC 
~~~
# 
# 

# 10 procedimientos almacenados con mayor tiempo transcurrido<a name="10procmayortiemeje"></a>

#### procedimientos almacenados identificados con el mayor promedio de tiempo transcurrido.
# 

~~~sql
/*
Alejandro Jimenez Rosa.

En el siguiente ejemplo se devuelve información acerca de los diez 
procedimientos almacenados identificados con el mayor promedio de tiempo 
transcurrido.

*/

SELECT TOP 10 d.object_id, d.database_id,DB_NAME(database_id) DB ,  OBJECT_NAME(object_id, database_id) 'proc name',   
    d.cached_time, d.last_execution_time, d.total_elapsed_time,  
    d.total_elapsed_time/d.execution_count AS [avg_elapsed_time],  
    d.last_elapsed_time, d.execution_count  
FROM sys.dm_exec_procedure_stats AS d  
ORDER BY [total_worker_time] DESC;  
~~~
# 

# Las consultas SQL más ejecutadas.<a name="lasconsultassqlmasejecutadas"></a>

<img src="https://mundo-tips.com/wp-content/uploads/2020/05/SQL-Query-Optimization.jpg?format=jpg&name=large" alt="JuveR" width="700px">

#### En las tareas de administración de SQL Server, es necesario recabar información; especialmente a fin de conocer las sentencias que más hacen trabajar al servidor. Por ello, es de gran utilidad conocer cuáles son las consultas SQL que más se ejecutan y cuál es su consumo de CPU. SQL Server es un sistema que ayuda a la gestión de las bases de datos. Un producto de Microsoft que está basado en el modelo relacional, pero que además, se utiliza para el rendimiento de instancias en el motor de la base de datos. Esto es, depurar procedimientos o llevar a cabo pruebas de esfuerzo.

#### Lo habitual es que, entre las consultas en SQL Server que más se ejecutan, se encuentren consultas de selección o básicas. Pero también pueden darse cualquiera de los otros tipos de consultas, como consultas de descripción, con predicado o de acción.
# 

~~~sql
SELECT TOP 10
qs.execution_count,
SUBSTRING(qt.text,qs.statement_start_offset/2,
(case when qs.statement_end_offset = -1
then len(convert(nvarchar(max), qt.text)) * 2
else qs.statement_end_offset end -qs.statement_start_offset)/2)
as query_text,
qt.dbid, dbname=db_name(qt.dbid),
qt.objectid
FROM sys.dm_exec_query_stats qs
cross apply sys.dm_exec_sql_text(qs.sql_handle) as qt
ORDER BY
qs.execution_count DESC
~~~
# 
# 

# Consultas SQL con mayor consumo de CPU.<a name="consultassqlmayorconsumodecpu"></a>
<img src="https://linube.com/blog/wp-content/uploads/consultas-sql-min.png?format=jpg&name=large" alt="JuveR" width="800px">

#### En ocasiones, es posible que nuestro SQL Server tenga un gran consumo de CPU. Una buena forma de saber de dónde viene ese consumo excesivo de CPU es realizar consultas. De esta forma podremos saber cuáles son las que más sobrecargan, de media, nuestro servidor. Este consumo elevado de CPU en el servidor puede deberse a diferentes motivos; desde fallos en la memoria del servidor a espacio insuficiente. También es posible que esto se deba a la presencia de algún elemento malicioso que ejecuta demasiada actividad aunque no sea visible.En cualquier caso, el consumo de CPU es un aspecto que no debe descuidarse en un servidor. Ya que esto podría afectar al rendimiento del servidor y provocar problemas de operatividad
# 
##### Para conocer dónde se encuentra el problema, podemos recurrir a un script. De esta forma podremos saber cuáles son las consultas en SQL con un consumo más elevado de CPU. Unas consultas que pueden estar sobrecargando la CPU de nuestro servidor.
# 

~~~sql
SELECT TOP 10
qs.total_worker_time/qs.execution_count as [Avg CPU Time],
SUBSTRING(qt.text,qs.statement_start_offset/2,
(case when qs.statement_end_offset = -1
then len(convert(nvarchar(max), qt.text)) * 2
else qs.statement_end_offset end -qs.statement_start_offset)/2)
as query_text,
qt.dbid, dbname=db_name(qt.dbid),
qt.objectid
FROM sys.dm_exec_query_stats qs
cross apply sys.dm_exec_sql_text(qs.sql_handle) as qt
ORDER BY
[Avg CPU Time] DESC
~~~
# 

## Detener un proceso de auditoría en SQL Server generalmente implica deshabilitar o detener la auditoría en sí. Aquí te muestro cómo hacerlo:<a name="13"></a>

<img src="https://i.ytimg.com/vi/wOdycyG4yx0/maxresdefault.jpg?format=jpg&name=large" alt="JuveR" width="800px">


1. **Detener una auditoría de servidor**:

   Si deseas detener una auditoría de nivel de servidor, puedes utilizar el siguiente comando:

   ~~~sql
   ALTER SERVER AUDIT NombreDeTuAuditoria WITH (STATE = OFF);
   ~~~

   Asegúrate de reemplazar `NombreDeTuAuditoria` con el nombre real de tu auditoría.

2. **Detener una auditoría de base de datos**:

   Si deseas detener una auditoría de nivel de base de datos, utiliza el siguiente comando:

   ~~~sql
   ALTER DATABASE AUDIT SPECIFICATION NombreDeTuAuditoria WITH (STATE = OFF);
   ~~~

   Nuevamente, asegúrate de reemplazar `NombreDeTuAuditoria` con el nombre real de tu auditoría de base de datos.

3. **Detener una sesión de auditoría**:

   Las auditorías en SQL Server se ejecutan a través de sesiones de auditoría. Para detener una sesión de auditoría, puedes utilizar el siguiente comando:

   ~~~sql
   ALTER SERVER AUDIT SPECIFICATION NombreDeTuSesion WITH (STATE = OFF);
   ~~~

   Reemplaza `NombreDeTuSesion` con el nombre real de tu sesión de auditoría.

4. **Eliminar una auditoría o sesión de auditoría**:

   Si deseas eliminar completamente una auditoría o sesión de auditoría, puedes usar el siguiente comando:

   ~~~sql
   DROP SERVER AUDIT NombreDeTuAuditoria;
   ~~~

   O

   ~~~sql
   DROP DATABASE AUDIT SPECIFICATION NombreDeTuAuditoria;
   ~~~

   O

   ~~~sql
   DROP SERVER AUDIT SPECIFICATION NombreDeTuSesion;
   ~~~

   Ten en cuenta que eliminar una auditoría o sesión de auditoría borrará todos los datos relacionados con ella, por lo que ten cuidado al utilizar este comando.

#### Recuerda que para ejecutar estos comandos, generalmente necesitas permisos de administrador o permisos adecuados en tu instancia de SQL Server.
#



#


# Tablas que Contienen un mombre de Campo.<a name="buscarnombrecampo"></a>
#### Es posible que quieres saber en cuales tablas esta el campo SocialSecurity , iva ect. Pero seria ineficiente por no decir (una locura ) buscarlos Uno por uno.

#### anexo un query que puede resultarte util.
# 

~~~sql
declare @Campo varchar(50) = 'his'
SELECT 
    Inf.TABLE_CATALOG
    ,Inf.TABLE_SCHEMA
    ,inf.TABLE_NAME 
    ,inf.COLUMN_NAME
    ,inf.data_type+'('+ convert(varchar(4), inf.CHARACTER_MAXIMUM_LENGTH)+')' Data_Type
    --,inf.CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS  as Inf
      Join sys.tables tbl 
            on Inf.TABLE_NAME = tbl.name
        
where Column_name like '%'+  @Campo + '%'
    and TABLE_SCHEMA = 'dbo'
    and CHARACTER_MAXIMUM_LENGTH <20

order by TABLE_NAME
~~~
# 


# Aquí una forma mas simple en el supuesto caso que solo quisiéramos ver las tablas y sus respectivos esquemas.<a name="tablasesquemascons"></a>
# 

~~~sql

/*
En un artículo anterior mostraba un Script para Listar todas las 
tablas de una base de datos con sus respectivos tamaños. 

Aquí una forma mas simple en el supuesto caso que solo 
quisiéramos ver las tablas y sus respectivos esquemas.
*/




SELECT * FROM INFORMATION_SCHEMA.TABLES 
WHERE table_type='BASE TABLE' 

and  table_schema in ('Tablas_Viejas','Desactivadas')
ORDER BY table_name

SELECT * FROM INFORMATION_SCHEMA.TABLES 
WHERE table_type='BASE TABLE' 

and  table_schema in ('dbo')
ORDER BY table_name
~~~
# 




# Listado de todos los objetos de una base de datos<a name="14.3"></a>
    Solicitado por Yolanca Suarez , Banco Popular Dominicano..2024-03-19
#### Para obtener los enlaces de servidor (linked servers) y otros objetos similares de una base de datos en SQL Server, puedes consultar el sistema de metadatos del servidor. Puedes utilizar consultas en SQL para acceder a esta información. Aquí tienes un ejemplo de cómo hacerlo:

~~~sql
-- Consulta para obtener los linked servers y otros objetos similares
SELECT
    name AS Nombre_Objeto,
    CASE 
        WHEN type_desc = 'SQL_LINKED_SERVER' THEN 'Linked Server'
        WHEN type_desc = 'SQL_SERVER_LOGIN' THEN 'Login'
        WHEN type_desc = 'SQL_SCALAR_FUNCTION' THEN 'Función Escalar'
        WHEN type_desc = 'SQL_STORED_PROCEDURE' THEN 'Procedimiento Almacenado'
        WHEN type_desc = 'SQL_TRIGGER' THEN 'Trigger'
        WHEN type_desc = 'SQL_VIEW' THEN 'Vista'
        -- Agrega más tipos de objetos según sea necesario
        ELSE type_desc
    END AS Tipo_Objeto
FROM sys.objects
WHERE type_desc IN ('SQL_LINKED_SERVER', 'SQL_SERVER_LOGIN', 'SQL_SCALAR_FUNCTION', 'SQL_STORED_PROCEDURE', 'SQL_TRIGGER', 'SQL_VIEW')
~~~
#### Esta consulta seleccionará todos los objetos de la base de datos que sean linked servers, logins, funciones escalares, procedimientos almacenados, triggers o vistas, y mostrará su nombre y tipo correspondiente.

#### Por favor, ten en cuenta que necesitas tener permisos suficientes en el servidor SQL Server para ejecutar esta consulta y acceder a la información del sistema de metadatos.



#
# Query de la ultima vez que se ejecuto en procedimiento<a name="ultejecproc1"></a>

#### Query para determiner la ultima vez que se ejecuto un procedimiento en una base de datos
#### Para esto buscamos en la tabla sys.dm.exec_procedure_stats
# 

~~~sql
/*
Alejandro Jimenez Rosa
AJ Miercoles 27 de julio del 2016 
para resolver problema en produccion (verificacion de procedimiento )
*/

declare @procedimiento varchar(100)
set @procedimiento = 'sigXPNumerarCorrespondenciaExterna'

SELECT d.object_id, d.database_id, OBJECT_NAME(object_id, database_id) 'proc name',   DB_NAME(),
    d.cached_time, d.last_execution_time, d.total_elapsed_time,  
    d.total_elapsed_time/d.execution_count AS [avg_elapsed_time],  
    d.last_elapsed_time, d.execution_count  
FROM sys.dm_exec_procedure_stats AS d  
where OBJECT_NAME(object_id, database_id)  = @procedimiento 
ORDER BY last_execution_time desc
~~~
# 


#

# Cuando fue la ultima que se uso una tabla?<a name="ultejecproc3"></a>
#### Hace rato que no escribia, he andado como siempre en mucha cosa. Estoy jugando un poco con PostGreSQL y Azure, seguramente empezare a incluir esa informacion en futuras entradas a este blog.

#### La respuesta  a la pregunta del titulo me ha servido muchas veces como administrador de una base de datos a lo largo de los años.
#### Esta consulta esta basada en una vista de systema que analiza el uso de los indices de nuestras tablas.
# 

~~~sql
declare @dbname VARCHAR(50) = 'INABIMA'

SELECT  
        DB_NAME(a.database_id) Database_Name ,
        b.name Table_Name ,
        MAX(ISNULL(last_user_update,'2001-01-01')) last_user_update ,
        MAX(ISNULL(last_user_seek,'2001-01-01')) last_user_seek ,
        MAX(ISNULL(last_user_scan,'2001-01-01')) last_user_scan ,
        MAX(ISNULL(last_user_lookup,'2001-01-01')) last_user_lookup
FROM    sys.dm_db_index_usage_stats a
        INNER JOIN sys.tables b ON b.object_id = a.object_id
        INNER JOIN sys.indexes c ON c.object_id = a.object_id
                                    AND c.index_id = a.index_id
WHERE DB_NAME(a.database_id) = @dbname
GROUP BY a.database_id ,
        b.name
ORDER BY a.database_id ,
        b.name 
~~~
# 


# Utilizando este mismo codigo podemos determinar cuando fue la ultima vez que se utilizo uno de nuestros indices<a name="ultejecproc2"></a>
# 

~~~sql
SELECT  DB_NAME(a.database_id) Database_Name ,
        b.name Table_Name ,
        c.name Index_Name ,
        MAX(ISNULL(last_user_update,'2001-01-01')) last_user_update ,
        MAX(ISNULL(last_user_seek,'2001-01-01')) last_user_seek ,
        MAX(ISNULL(last_user_scan,'2001-01-01')) last_user_scan ,
        MAX(ISNULL(last_user_lookup,'2001-01-01')) last_user_lookup
FROM    sys.dm_db_index_usage_stats a
        INNER JOIN sys.tables b ON b.object_id = a.object_id
        INNER JOIN sys.indexes c ON c.object_id = a.object_id
                                    AND c.index_id = a.index_id
WHERE   a.database_id = DB_ID()
GROUP BY a.database_id ,
        b.name ,
        c.name
ORDER BY a.database_id ,
        b.name ,
        c.name;
~~~
# 





# Cambiar el Collation en una instancia SQL Server<a name="cambiarcollattionsql"></a>


#### El collation o intercalación de nuestra base de datos va a definir qué caracter se asocia con el valor almacenado. Por lo tanto, un mismo valor almacenado puede tener una representación diferente dependiendo del collation asignado.

#### Esto solo aplica a formatos no unicode. La desventaja de los formatos unicode es que ocupan un mayor tamaño de almacenamiento.

#### Vemos cómo cambiar el collation de nuestra base de datos SQL Server.

## Cambiar Collation
#### En la siguiente sentencia vamos a establecer «single_user» en nuestra base de datos «PRODB»  y cambiaremos la intercalación a «SQL_Latin1_General_CP1_CI_AS«.

#### Por último, volvemos a poner la base de datos en «multi_user«.

#### Recuerda acordar una ventana de mantenimiento si esta base de datos está en producción.
# 


~~~sql
USE MASTER
GO
ALTER DATABASE PRODB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO
ALTER DATABASE PRODB COLLATE SQL_Latin1_General_CP1_CI_AS;
GO
ALTER DATABASE PRODB SET MULTI_USER;
GO
~~~
# 


# Cambio del Esquema de una tabla por Query<a name="cambiarsquemad"></a>

#### El codigó para cambiar el esquema de una tabla es el siguente:
# 


~~~sql
ALTER SCHEMA esquema_nuevo TRANSFER esquema_viejo.Tabla;
~~~
# 



# Cuanto Ocupan mis tablas<a name="cuantoocupantablas"></a> 


<img src="https://1.bp.blogspot.com/-V5aQzyPZa8k/XkHd2064YtI/AAAAAAAACmw/_me-o2Wq7BQ0r-RDNeeWaPQ68aJU_iPMQCLcBGAsYHQ/s640/tama%25C3%25B1o-base-de-datos-sql-server.png?format=jpg&name=large" alt="JuveR" width="800px">

###### espacio fisico  Alejadnro Jimenez
# 
#### Qiery que trae cuantos rows tenemos asi como cuantos mb tengo ocupados por esa tabla
~~~sql
SELECT

t.NAME AS Tabla,

s.Name AS Esquema,

p.rows AS NumeroDeFilas,

CAST(ROUND(((SUM(a.total_pages) * 8) / 1024.00), 2) AS NUMERIC(36, 2)) AS TotalEspacio_MB,

CAST(ROUND(((SUM(a.used_pages) * 8) / 1024.00), 2) AS NUMERIC(36, 2)) AS EspacioUtilizado_MB,

CAST(ROUND(((SUM(a.total_pages) - SUM(a.used_pages)) * 8) / 1024.00, 2) AS NUMERIC(36, 2)) AS EspacioNoUtilizado_MB

FROM

sys.tables t

INNER JOIN sys.indexes i ON t.OBJECT_ID = i.object_id

INNER JOIN sys.partitions p ON i.object_id = p.OBJECT_ID AND i.index_id = p.index_id

INNER JOIN sys.allocation_units a ON p.partition_id = a.container_id

LEFT OUTER JOIN sys.schemas s ON t.schema_id = s.schema_id

GROUP BY t.Name, s.Name, p.Rows

ORDER BY TotalEspacio_MB desc
~~~

####  query anterio este fue sustituido por de arriba

~~~sql

select name
  ,(select top 1 row_count from sys.dm_db_partition_stats where object_id=s.object_id)
  ,modify_date
  ,(select  convert(decimal(8,2),(SUM (	CASE
WHEN (index_id < 2) THEN (in_row_data_page_count + lob_used_page_count + row_overflow_used_page_count)
ELSE lob_used_page_count + row_overflow_used_page_count
END
)*0.0078125 ))
FROM sys.dm_db_partition_stats
WHERE object_id = s.object_id) as PESO_TABLA
from sys.tables s
where type_desc = 'USER_TABLE'
order by PESO_TABLA desc
~~~
# 
<!-- 

# Defragmentación, al rescate<a name="desfragmentacionalrescate"></a>
![](https://greyphillips.com/Guides/assets/img/Database_Maintenance.png)




#### Para evitar el deterioro del rendimiento en nuestro servidor, deberemos mantener nuestros índices en un estado de fragmentación óptimo. Lo podremos lograr sencillamente siguiendo estos pasos.

#### Primer paso: detectar fragmentación en los índices de tu base de datos. Para ello, nos basaremos en la vista de sistema sys.dm_db_index_physical_stats, que encapsularemos en la siguiente query:
# 


~~~sql
SELECT DB_NAME(database_id) AS DatabaseName, database_id, 
OBJECT_NAME(ips.object_id) AS TableName, ips.object_id,

i.name AS IndexName, i.index_id, p.rows,

ips.partition_number, index_type_desc, alloc_unit_type_desc, 
index_depth, index_level,
avg_fragmentation_in_percent, fragment_count, avg_fragment_size_in_pages, page_count,
avg_page_space_used_in_percent, record_count, ghost_record_count, version_ghost_record_count, min_record_size_in_bytes,
max_record_size_in_bytes, avg_record_size_in_bytes, forwarded_record_count
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL , NULL, 'LIMITED') ips
INNER JOIN sys.indexes i ON i.object_id = ips.object_id AND i.index_id = ips.index_id
INNER JOIN sys.partitions p ON p.object_id = i.object_id AND p.index_id = i.index_id
WHERE avg_fragmentation_in_percent > 10.0 AND ips.index_id > 0 AND page_count > 1000
ORDER BY avg_fragmentation_in_percent DESC
~~~
# 


# Servidores Standar Edition Sql server ,no soportan (ONLINE=ON)

#### Segundo paso: ejecutar un script para defragmentar los índices con problemas. El script determina si hay que hacer un Reorganize o un Rebuild para cada índice:
# 

#### Esta es una fragmentacion estandar , para servidores de sql server Standar.  en la misma se realizaran las defragmentaion de los indices de la db seleccionada

~~~sql
-- Ensure a USE  statement has been executed first.
SET NOCOUNT ON;
DECLARE @objectid int;
DECLARE @indexid int;
DECLARE @partitioncount bigint;
DECLARE @schemaname nvarchar(130); 
DECLARE @objectname nvarchar(130); 
DECLARE @indexname nvarchar(130); 
DECLARE @partitionnum bigint;
DECLARE @partitions bigint;
DECLARE @frag float;
DECLARE @command nvarchar(4000); 
-- Conditionally select tables and indexes from the sys.dm_db_index_physical_stats function 
-- and convert object and index IDs to names.
SELECT
    object_id AS objectid,
    index_id AS indexid,
    partition_number AS partitionnum,
    avg_fragmentation_in_percent AS frag
INTO #work_to_do
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL , NULL, 
'LIMITED')
WHERE avg_fragmentation_in_percent > 10.0 AND index_id > 0 AND 
page_count > 1000;

-- Declare the cursor for the list of partitions to be processed.
DECLARE partitions CURSOR FOR SELECT * FROM #work_to_do;

-- Open the cursor.
OPEN partitions;

-- Loop through the partitions.
WHILE (1=1)
    BEGIN;
        FETCH NEXT
           FROM partitions
           INTO @objectid, @indexid, @partitionnum, @frag;
        IF @@FETCH_STATUS < 0 BREAK;
        SELECT @objectname = QUOTENAME(o.name), @schemaname = QUOTENAME(s.name)
        FROM sys.objects AS o
        JOIN sys.schemas as s ON s.schema_id = o.schema_id
        WHERE o.object_id = @objectid;
        SELECT @indexname = QUOTENAME(name)
        FROM sys.indexes
        WHERE  object_id = @objectid AND index_id = @indexid;
        SELECT @partitioncount = count (*)
        FROM sys.partitions
        WHERE object_id = @objectid AND index_id = @indexid;

-- 30 is an arbitrary decision point at which to switch between reorganizing and rebuilding.
     IF @frag < 30.0
       SET @command = N'ALTER INDEX ' + @indexname + N' ON ' + 
       @schemaname + N'.' + @objectname + N' REORGANIZE';
     IF @frag >= 30.0
         SET @command = N'ALTER INDEX ' + @indexname + N' ON ' + 
         @schemaname + N'.' + @objectname + N' REBUILD';
     IF @partitioncount > 1
            SET @command = @command + N' PARTITION=' + CAST
            (@partitionnum AS nvarchar(10));
        EXEC (@command);
        PRINT N'Executed: ' + @command;
    END;

-- Close and deallocate the cursor.
CLOSE partitions;
DEALLOCATE partitions;

-- Drop the temporary table.
DROP TABLE #work_to_do;
GO
~~~


# Servidores Interprise Edition Sql server 

#### Segundo paso: ejecutar un script para defragmentar los índices con problemas. El script determina si hay que hacer un Reorganize o un Rebuild para cada índice:

#### En esta versión modificada del script, se ha agregado la opción WITH (ONLINE = ON) en las instrucciones ALTER INDEX para que las operaciones se realicen en línea, lo que minimizará el bloqueo de las tablas y permitirá que las consultas y las inserciones continúen sin interrupciones. 

####  También se ha incluido una condición adicional para decidir si se realiza una reconstrucción en línea basada en el tamaño de la tabla y el nivel de fragmentación. Las reorganizaciones se seguirán realizando en línea. 

#### ***Debemos tener en cuenta que la disponibilidad de la opción ONLINE puede depender de la edición de SQL Server que estemos utilizando.***
#####   ***Este query solo funciona con Sql Server Interprise Edition.***
# 


~~~sql
-- Ensure a USE statement has been executed first.
-- Asegurarse de que se haya ejecutado una instrucción USE primero.
SET NOCOUNT ON;
DECLARE @objectid INT;
DECLARE @indexid INT;
DECLARE @partitioncount BIGINT;
DECLARE @schemaname NVARCHAR(130);
DECLARE @objectname NVARCHAR(130);
DECLARE @indexname NVARCHAR(130);
DECLARE @partitionnum BIGINT;
DECLARE @partitions BIGINT;
DECLARE @frag FLOAT;
DECLARE @command NVARCHAR(4000);

-- Condición para seleccionar tablas e índices de la función sys.dm_db_index_physical_stats
-- y convertir los IDs de objetos e índices en nombres.
SELECT
    object_id AS objectid,
    index_id AS indexid,
    partition_number AS partitionnum,
    avg_fragmentation_in_percent AS frag
INTO #work_to_do
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, 'LIMITED')
WHERE avg_fragmentation_in_percent > 10.0 AND index_id > 0 AND
page_count > 1000;

-- Declarar el cursor para la lista de particiones a procesar.
DECLARE partitions CURSOR FOR SELECT * FROM #work_to_do;

-- Abrir el cursor.
OPEN partitions;

-- Loop a través de las particiones.
WHILE (1=1)
BEGIN
    FETCH NEXT
    FROM partitions
    INTO @objectid, @indexid, @partitionnum, @frag;
    IF @@FETCH_STATUS < 0 BREAK;

    SELECT @objectname = QUOTENAME(o.name), @schemaname = QUOTENAME(s.name)
    FROM sys.objects AS o
    JOIN sys.schemas AS s ON s.schema_id = o.schema_id
    WHERE o.object_id = @objectid;

    SELECT @indexname = QUOTENAME(name)
    FROM sys.indexes
    WHERE  object_id = @objectid AND index_id = @indexid;

    SELECT @partitioncount = COUNT(*)
    FROM sys.partitions
    WHERE object_id = @objectid AND index_id = @indexid;

    -- 30 es un punto de decisión arbitrario para cambiar entre reorganización y reconstrucción.
    IF @frag < 30.0
        SET @command = N'ALTER INDEX ' + @indexname + N' ON ' + 
        @schemaname + N'.' + @objectname + N' REORGANIZE';
    ELSE IF @frag >= 30.0 AND @partitioncount <= 1
        SET @command = N'ALTER INDEX ' + @indexname + N' ON ' + 
        @schemaname + N'.' + @objectname + N' REBUILD WITH (ONLINE = ON)';
    ELSE IF @frag >= 30.0 AND @partitioncount > 1
        SET @command = N'ALTER INDEX ' + @indexname + N' ON ' + 
        @schemaname + N'.' + @objectname + N' REBUILD PARTITION=' + 
        CAST(@partitionnum AS NVARCHAR(10)) + N' WITH (ONLINE = ON)';

    BEGIN TRY
        EXEC (@command);
        PRINT N'Executed: ' + @command;
    END TRY
    BEGIN CATCH
        PRINT N'Error executing: ' + @command;
        -- Puedes registrar el error o realizar cualquier otra acción aquí si es necesario.
    END CATCH
END;

-- Cerrar y liberar el cursor.
CLOSE partitions;
DEALLOCATE partitions;

-- Eliminar la tabla temporal.
DROP TABLE #work_to_do;
GO

~~~
# 


# Servidores Interprise Edition Sql server , OPTIMIZADO, Puede ejecutarse de forma constante, sin interferir con las operaciones del servidor.   Especial para bases de datos Muy Grandes y que necesitan ser defragmentadas.

## defragmentar con intervalos de 10 indices y excluye los que ya fueron leidos para mayor eficiencia


~~~sql
-- Asegurarse de que se haya ejecutado una instrucción USE primero.
SET NOCOUNT ON;
DECLARE @objectid INT;
DECLARE @indexid INT;
DECLARE @partitioncount BIGINT;
DECLARE @schemaname NVARCHAR(130);
DECLARE @objectname NVARCHAR(130);
DECLARE @indexname NVARCHAR(130);
DECLARE @partitionnum BIGINT;
DECLARE @partitions BIGINT;
DECLARE @frag FLOAT;
DECLARE @command NVARCHAR(4000);

-- Condición para seleccionar tablas e índices de la función sys.dm_db_index_physical_stats

-- y convertir los IDs de objetos e índices en nombres.


declare @datos table

(

id int

,indexs int

,partic int

,frag float

)


-- SI AL TABLA TEMPORAL EXISTE ELIMINALA.
    BEGIN TRY
        DROP TABLE #work_to_do;
    END TRY
    BEGIN CATCH
         PRINT N'error executing';
    END CATCH


 

while exists (
SELECT  top 10
    object_id AS objectid,
    index_id AS indexid,
    partition_number AS partitionnum,
    avg_fragmentation_in_percent AS frag
--INTO #work_to_do
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, 'LIMITED')
WHERE avg_fragmentation_in_percent > 10.0 AND index_id > 0 AND
page_count > 1000
and  object_id  not in
    (
        select id from @datos
    )
)
begin
SELECT top 10
    object_id AS objectid,
    index_id AS indexid,
    partition_number AS partitionnum,
    avg_fragmentation_in_percent AS frag
INTO #work_to_do
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, 'LIMITED')
WHERE avg_fragmentation_in_percent > 10.0 AND index_id > 0 AND
page_count > 1000
and  object_id  not in
    (
    select id from @datos
    )
;

-- Declarar el cursor para la lista de particiones a procesar.
DECLARE partitions CURSOR FOR SELECT * FROM #work_to_do;
-- Abrir el cursor.
OPEN partitions;

-- Loop a través de las particiones.
WHILE (1=1)
BEGIN
    FETCH NEXT
    FROM partitions
    INTO @objectid, @indexid, @partitionnum, @frag;
    IF @@FETCH_STATUS < 0 BREAK;

    SELECT @objectname = QUOTENAME(o.name), @schemaname = QUOTENAME(s.name)
    FROM sys.objects AS o
    JOIN sys.schemas AS s ON s.schema_id = o.schema_id
    WHERE o.object_id = @objectid;

    SELECT @indexname = QUOTENAME(name)
    FROM sys.indexes
    WHERE  object_id = @objectid AND index_id = @indexid;

    SELECT @partitioncount = COUNT(*)
    FROM sys.partitions
    WHERE object_id = @objectid AND index_id = @indexid;

    -- 30 es un punto de decisión arbitrario para cambiar entre reorganización y reconstrucción.

    IF @frag < 30.0
        SET @command = N'ALTER INDEX ' + @indexname + N' ON ' +
        @schemaname + N'.' + @objectname + N' REORGANIZE';
    ELSE IF @frag >= 30.0 AND @partitioncount <= 1
        SET @command = N'ALTER INDEX ' + @indexname + N' ON ' +
        @schemaname + N'.' + @objectname + N' REBUILD WITH (ONLINE = ON)';
    ELSE IF @frag >= 30.0 AND @partitioncount > 1
        SET @command = N'ALTER INDEX ' + @indexname + N' ON ' +
        @schemaname + N'.' + @objectname + N' REBUILD PARTITION=' +
        CAST(@partitionnum AS NVARCHAR(10)) + N' WITH (ONLINE = ON)';
    BEGIN TRY
        EXEC (@command);
        PRINT N'Executed: ' + @command;
    END TRY
    BEGIN CATCH
        PRINT N'Error executing: ' + @command;
        -- Puedes registrar el error o realizar cualquier otra acción aquí si es necesario.
    END CATCH
END;
-- Cerrar y liberar el cursor.
CLOSE partitions;
DEALLOCATE partitions;

insert into @datos
select * from  #work_to_do

-- Eliminar la tabla temporal.
DROP TABLE #work_to_do;

Print 'Defragmentados 10 registros---'
end
GO
~~~

 -->


<!-- trajandoahora -->
#
# 

# Defragmentación, al Rescate<a name="desfragmentacionalrescate"></a>

![Database Maintenance](https://greyphillips.com/Guides/assets/img/Database_Maintenance.png)

Para evitar el deterioro del rendimiento en nuestro servidor, debemos mantener nuestros índices en un estado de fragmentación óptimo. A continuación, se detallan los pasos necesarios para detectar y corregir la fragmentación de índices en SQL Server.

## Paso 1: Detectar Fragmentación en los Índices

Primero, necesitamos identificar la fragmentación en los índices de nuestra base de datos. Utilizaremos la vista de sistema `sys.dm_db_index_physical_stats`, encapsulada en la siguiente consulta SQL:

```sql
SELECT DB_NAME(database_id) AS DatabaseName, database_id, 
OBJECT_NAME(ips.object_id) AS TableName, ips.object_id,
i.name AS IndexName, i.index_id, p.rows,
ips.partition_number, index_type_desc, alloc_unit_type_desc, 
index_depth, index_level,
avg_fragmentation_in_percent, fragment_count, avg_fragment_size_in_pages, page_count,
avg_page_space_used_in_percent, record_count, ghost_record_count, version_ghost_record_count, min_record_size_in_bytes,
max_record_size_in_bytes, avg_record_size_in_bytes, forwarded_record_count
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL , NULL, 'LIMITED') ips
INNER JOIN sys.indexes i ON i.object_id = ips.object_id AND i.index_id = ips.index_id
INNER JOIN sys.partitions p ON p.object_id = i.object_id AND p.index_id = i.index_id
WHERE avg_fragmentation_in_percent > 10.0 AND ips.index_id > 0 AND page_count > 1000
ORDER BY avg_fragmentation_in_percent DESC
```

Esta consulta devuelve información detallada sobre la fragmentación de los índices en la base de datos actual, permitiéndonos identificar los índices que requieren atención.

## Paso 2: Defragmentar los Índices

### Para SQL Server Standard Edition

En SQL Server Standard Edition, no podemos utilizar la opción `ONLINE=ON`. Utilizaremos el siguiente script para determinar si debemos reorganizar (`REORGANIZE`) o reconstruir (`REBUILD`) cada índice con problemas:

```sql
-- Ensure a USE statement has been executed first.
SET NOCOUNT ON;
DECLARE @objectid int;
DECLARE @indexid int;
DECLARE @partitioncount bigint;
DECLARE @schemaname nvarchar(130); 
DECLARE @objectname nvarchar(130); 
DECLARE @indexname nvarchar(130); 
DECLARE @partitionnum bigint;
DECLARE @partitions bigint;
DECLARE @frag float;
DECLARE @command nvarchar(4000); 
-- Conditionally select tables and indexes from the sys.dm_db_index_physical_stats function 
-- and convert object and index IDs to names.
SELECT
    object_id AS objectid,
    index_id AS indexid,
    partition_number AS partitionnum,
    avg_fragmentation_in_percent AS frag
INTO #work_to_do
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL , NULL, 'LIMITED')
WHERE avg_fragmentation_in_percent > 10.0 AND index_id > 0 AND 
page_count > 1000;

-- Declare the cursor for the list of partitions to be processed.
DECLARE partitions CURSOR FOR SELECT * FROM #work_to_do;

-- Open the cursor.
OPEN partitions;

-- Loop through the partitions.
WHILE (1=1)
    BEGIN;
        FETCH NEXT
           FROM partitions
           INTO @objectid, @indexid, @partitionnum, @frag;
        IF @@FETCH_STATUS < 0 BREAK;
        SELECT @objectname = QUOTENAME(o.name), @schemaname = QUOTENAME(s.name)
        FROM sys.objects AS o
        JOIN sys.schemas as s ON s.schema_id = o.schema_id
        WHERE o.object_id = @objectid;
        SELECT @indexname = QUOTENAME(name)
        FROM sys.indexes
        WHERE  object_id = @objectid AND index_id = @indexid;
        SELECT @partitioncount = count (*)
        FROM sys.partitions
        WHERE object_id = @objectid AND index_id = @indexid;

-- 30 is an arbitrary decision point at which to switch between reorganizing and rebuilding.
     IF @frag < 30.0
       SET @command = N'ALTER INDEX ' + @indexname + N' ON ' + 
       @schemaname + N'.' + @objectname + N' REORGANIZE';
     IF @frag >= 30.0
         SET @command = N'ALTER INDEX ' + @indexname + N' ON ' + 
         @schemaname + N'.' + @objectname + N' REBUILD';
     IF @partitioncount > 1
            SET @command = @command + N' PARTITION=' + CAST
            (@partitionnum AS nvarchar(10));
        EXEC (@command);
        PRINT N'Executed: ' + @command;
    END;

-- Close and deallocate the cursor.
CLOSE partitions;
DEALLOCATE partitions;

-- Drop the temporary table.
DROP TABLE #work_to_do;
GO
```

### Para SQL Server Enterprise Edition

En SQL Server Enterprise Edition, podemos realizar la defragmentación en línea utilizando la opción `ONLINE = ON`, minimizando el bloqueo de las tablas:

```sql
-- Ensure a USE statement has been executed first.
SET NOCOUNT ON;
DECLARE @objectid INT;
DECLARE @indexid INT;
DECLARE @partitioncount BIGINT;
DECLARE @schemaname NVARCHAR(130);
DECLARE @objectname NVARCHAR(130);
DECLARE @indexname NVARCHAR(130);
DECLARE @partitionnum BIGINT;
DECLARE @partitions BIGINT;
DECLARE @frag FLOAT;
DECLARE @command NVARCHAR(4000);

-- Condición para seleccionar tablas e índices de la función sys.dm_db_index_physical_stats
-- y convertir los IDs de objetos e índices en nombres.
SELECT
    object_id AS objectid,
    index_id AS indexid,
    partition_number AS partitionnum,
    avg_fragmentation_in_percent AS frag
INTO #work_to_do
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, 'LIMITED')
WHERE avg_fragmentation_in_percent > 10.0 AND index_id > 0 AND
page_count > 1000;

-- Declarar el cursor para la lista de particiones a procesar.
DECLARE partitions CURSOR FOR SELECT * FROM #work_to_do;

-- Abrir el cursor.
OPEN partitions;

-- Loop a través de las particiones.
WHILE (1=1)
BEGIN
    FETCH NEXT
    FROM partitions
    INTO @objectid, @indexid, @partitionnum, @frag;
    IF @@FETCH_STATUS < 0 BREAK;

    SELECT @objectname = QUOTENAME(o.name), @schemaname = QUOTENAME(s.name)
    FROM sys.objects AS o
    JOIN sys.schemas AS s ON s.schema_id = o.schema_id
    WHERE o.object_id = @objectid;

    SELECT @indexname = QUOTENAME(name)
    FROM sys.indexes
    WHERE  object_id = @objectid AND index_id = @indexid;

    SELECT @partitioncount = COUNT(*)
    FROM sys.partitions
    WHERE object_id = @objectid AND index_id = @indexid;

    -- 30 es un punto de decisión arbitrario para cambiar entre reorganización y reconstrucción.
    IF @frag < 30.0
        SET @command = N'ALTER INDEX ' + @indexname + N' ON ' + 
        @schemaname + N'.' + @objectname + N' REORGANIZE';
    ELSE IF @frag >= 30.0 AND @partitioncount <= 1
        SET @command = N'ALTER INDEX ' + @indexname + N' ON ' + 
        @schemaname + N'.' + @objectname + N' REBUILD WITH (ONLINE = ON)';
    ELSE IF @frag >= 30.0 AND @partitioncount > 1
        SET @command = N'ALTER INDEX ' + @indexname + N' ON ' + 
        @schemaname + N'.' + @objectname + N' REBUILD PARTITION=' + 
        CAST(@partitionnum AS NVARCHAR(10)) + N' WITH (ONLINE = ON)';

    BEGIN TRY
        EXEC (@command);
        PRINT N'Executed: ' + @command;
    END TRY
    BEGIN CATCH
        PRINT N'Error executing: ' + @command;
        -- Puedes registrar el error o realizar cualquier otra acción aquí si es necesario.
    END CATCH
END;

-- Cerrar y liberar el cursor.
CLOSE partitions;
DEALLOCATE partitions;

-- Eliminar la tabla temporal.
DROP TABLE #work_to_do;
GO
```

### Optimización para Bases de Datos Muy Grandes

Para bases de datos muy grandes que necesitan ser defragmentadas sin interferir con las operaciones del servidor, se puede utilizar el siguiente script optimizado. Este script defragmenta en intervalos de 10 índices y excluye los que ya fueron leídos para mayor eficiencia:

```sql
-- Asegurarse de que se haya ejecutado una instrucción USE primero.
SET NOCOUNT ON;
DECLARE @objectid INT;
DECLARE @indexid INT;
DECLARE @partitioncount BIGINT;
DECLARE @schemaname NVARCHAR(130);
DECLARE @objectname NVARCHAR(130);
DECLARE @indexname NVARCHAR(130);
DECLARE @partitionnum BIGINT;
DECLARE @partitions BIGINT;
DECLARE @frag FLOAT;
DECLARE @command NVARCHAR(4000);

-- Condición para seleccionar tablas e índices de

 la función sys.dm_db_index_physical_stats
-- y convertir los IDs de objetos e índices en nombres.
DECLARE @datos TABLE
(
    id INT,
    indexs INT,
    partic INT,
    frag FLOAT
)

-- SI AL TABLA TEMPORAL EXISTE ELIMINALA.
BEGIN TRY
    DROP TABLE #work_to_do;
END TRY
BEGIN CATCH
    PRINT N'error executing';
END CATCH

WHILE EXISTS (
SELECT TOP 10
    object_id AS objectid,
    index_id AS indexid,
    partition_number AS partitionnum,
    avg_fragmentation_in_percent AS frag
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, 'LIMITED')
WHERE avg_fragmentation_in_percent > 10.0 AND index_id > 0 AND
page_count > 1000
AND object_id NOT IN
    (
        SELECT id FROM @datos
    )
)
BEGIN
    SELECT TOP 10
        object_id AS objectid,
        index_id AS indexid,
        partition_number AS partitionnum,
        avg_fragmentation_in_percent AS frag
    INTO #work_to_do
    FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, 'LIMITED')
    WHERE avg_fragmentation_in_percent > 10.0 AND index_id > 0 AND
    page_count > 1000
    AND object_id NOT IN
    (
        SELECT id FROM @datos
    );

    -- Declarar el cursor para la lista de particiones a procesar.
    DECLARE partitions CURSOR FOR SELECT * FROM #work_to_do;
    -- Abrir el cursor.
    OPEN partitions;

    -- Loop a través de las particiones.
    WHILE (1=1)
    BEGIN
        FETCH NEXT
        FROM partitions
        INTO @objectid, @indexid, @partitionnum, @frag;
        IF @@FETCH_STATUS < 0 BREAK;

        SELECT @objectname = QUOTENAME(o.name), @schemaname = QUOTENAME(s.name)
        FROM sys.objects AS o
        JOIN sys.schemas AS s ON s.schema_id = o.schema_id
        WHERE o.object_id = @objectid;

        SELECT @indexname = QUOTENAME(name)
        FROM sys.indexes
        WHERE  object_id = @objectid AND index_id = @indexid;

        SELECT @partitioncount = COUNT(*)
        FROM sys.partitions
        WHERE object_id = @objectid AND index_id = @indexid;

        -- 30 es un punto de decisión arbitrario para cambiar entre reorganización y reconstrucción.
        IF @frag < 30.0
            SET @command = N'ALTER INDEX ' + @indexname + N' ON ' +
            @schemaname + N'.' + @objectname + N' REORGANIZE';
        ELSE IF @frag >= 30.0 AND @partitioncount <= 1
            SET @command = N'ALTER INDEX ' + @indexname + N' ON ' +
            @schemaname + N'.' + @objectname + N' REBUILD WITH (ONLINE = ON)';
        ELSE IF @frag >= 30.0 AND @partitioncount > 1
            SET @command = N'ALTER INDEX ' + @indexname + N' ON ' +
            @schemaname + N'.' + @objectname + N' REBUILD PARTITION=' +
            CAST(@partitionnum AS NVARCHAR(10)) + N' WITH (ONLINE = ON)';
        BEGIN TRY
            EXEC (@command);
            PRINT N'Executed: ' + @command;
        END TRY
        BEGIN CATCH
            PRINT N'Error executing: ' + @command;
            -- Puedes registrar el error o realizar cualquier otra acción aquí si es necesario.
        END CATCH
    END;
    -- Cerrar y liberar el cursor.
    CLOSE partitions;
    DEALLOCATE partitions;

    INSERT INTO @datos
    SELECT * FROM  #work_to_do

    -- Eliminar la tabla temporal.
    DROP TABLE #work_to_do;

    PRINT 'Defragmentados 10 registros---'
END
GO
```

### Consideraciones Finales

- **Mantenimiento Regular:** Realizar estas operaciones de manera regular ayuda a mantener el rendimiento óptimo de la base de datos.
- **Evaluación de Fragmentación:** Ajustar los umbrales de fragmentación (`avg_fragmentation_in_percent`) y el tamaño mínimo de página (`page_count`) según las necesidades específicas de su entorno.
- **Planificación de Mantenimiento:** Programar estas tareas durante períodos de baja actividad para minimizar el impacto en los usuarios.


# 
# 

# Detectando actividad del servidor.<a name="dectectandoactenservidor"></a>
<img src="https://i.pinimg.com/originals/56/99/84/569984584af7d9c9224bd4a1a8ab7039.jpg?format=jpg&name=large" alt="JuveR" width="800">
# 


~~~sql
/*
Alejandro Jimenez   Agosto 01 2016
Determinación de la actividad del servidor

*/
SELECT es.session_id 
    ,DB_NAME(ES.database_id) DBNAME
    ,es.program_name 
    ,es.login_name 
    ,es.nt_user_name 
    ,es.login_time 
    ,es.host_name 
    ,es.cpu_time 
    ,es.total_scheduled_time 
    ,es.total_elapsed_time 
    ,es.memory_usage 
    ,es.logical_reads 
    ,es.reads 
    ,es.writes 
    ,st.text 
    --,es.database_id
    
FROM sys.dm_exec_sessions es 
    LEFT JOIN sys.dm_exec_connections ec  
        ON es.session_id = ec.session_id 
    LEFT JOIN sys.dm_exec_requests er 
        ON es.session_id = er.session_id 
    OUTER APPLY sys.dm_exec_sql_text (er.sql_handle) st 

    where                    es.session_id > 50    -- < 50 system sessions 
and login_time >'2019-09-11 01:00:00'
--ORDER BY es.cpu_time DESC 
ORDER BY login_time desc
~~~
# 

## Actividad del servidor para extraer en caso de que el servidor sea 2008 o menor
~~~sql


-- Eliminar la db temporal en caso que la misma ya exista
-- drop table db_temp
-- go

 
--Creacion de la base de datos db_temp para poder hacer el analisis de los datos
--y extraer lo que se requiere. 

--create table db_temp

--(

--SPID INT

--, Status varchar(50)

--,login varchar(50)

--,hostname varchar(50)

--,blkby varchar(50)

--,DBname varchar(50)

--,command varchar(500)

--,CPUTime int

--,DiskIO int

--,LastBatch varchar(15)

--,ProgramName varchar(500)

--,SPID2 INT

--,Requestid int

 

--)

 

 

 
--Ejecutar este comando y copiar en resultado en la tabla para poder ser analizado
--sp_who2
 

--Ejecutar este query para exytraer los datos solicitados.

SELECT [login]

      ,[hostname]

      ,[blkby]

      ,[DBname]


      ,MIN( [LastBatch]) "Fecha Minima"

      ,max( [LastBatch]) "Fecha Maxima"

      ,[ProgramName]


  FROM [master].[dbo].[db_temp]

 

  group by

        [login]

      ,[hostname]

      ,[blkby]

      ,[DBname]

      ,[ProgramName]

~~~




#
#### Nota este proceso fue creado por mi para enviar las actividades del serviro via correo electronico desde la base de datos Sql server en formatos HTML.
# 



~~~sql
USE [msdb]
GO
/****** Object:  StoredProcedure [dbo].[sp_EnviarActividad_Servidor10_0_0_252]   
 Script Date: 29/10/2020 03:51:55 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
NOTIFICACION
actividad del servidor del ultimo dia 
enviado por correo .
tenemos una tabla llamada notificacionesCorreos
 desde la misma controlamos las personas a las que se le enviara
  el reporte en html

 Alejandro Jimenez 
 2019-10-16
*/

ALTER procedure [dbo].[sp_EnviarActividad_Servidor10_0_0_252]
as

declare  @ActiviadadDelServidorTemp  table
(
       [DataBaseName] varchar(50)
      , [program_name] varchar(150)
      , [login_name] varchar(100)
      ,[nt_user_name] varchar(100)
      ,[login_time] datetime
      ,[host_name] varchar(50)
      ,[cpu_time] int
      ,[total_scheduled_time] int
      ,[total_elapsed_time] int
      ,[memory_usage] int 
      ,[logical_reads] int 
      ,[reads] int 
      ,[writes] int 
      )



insert into @ActiviadadDelServidorTemp
exec sp_ActiviadadDelServidorTemp

declare @email varchar(100) =
( SELECT 
      
      [correo]
      
  FROM  [AuditoriaDB].[dbo].[NotificacionesCorreos]
  WHERE ID =1002
  )

DECLARE @Body NVARCHAR(MAX),
    @TableHead VARCHAR(1000),
    @TableTail VARCHAR(1000)
    --,@dias int = 2
    ,@fecha varchar(10) = convert(varchar(10), getdate(),120)

SET @TableTail = '</table></body></html>' ;
SET @TableHead = '<html><head>' + '<style>'
    + 'td {border: solid black;border-width: 1px;padding-left:5px;padding-right:5px;padding-top:1px;padding-bottom:1px;font: 11px arial} '
    + '</style>' + '</head>' + '<body>' + '<h1>Reporte de Eventos en el Servidor 10.0.0.252 al dia : ' + @fecha +'  </h1> '
    + '<b>LogicalRead Mayor 100 || Write Mayor 0 || horas No laborables || No Usuarios de TRANSDOC</b>' 
    + '<br><b>Fecha y hora de envio: </b>'+ CONVERT(VARCHAR(50), GETDATE(), 100) 
    + ' <br> <table cellpadding=0 cellspacing=0 border=0>' 

    + '<tr> <td bgcolor=#E6E6FA><b>DataBaseName</b></td>'
    + '<td bgcolor=#E6E6FA><b>Program_Name</b></td>'
    + '<td bgcolor=#E6E6FA><b>login_Name</b></td>'
    + '<td bgcolor=#ffffb3><b>nt_user_name</b></td>'
    + '<td bgcolor=#E6E6FA><b>Login_Time</b></td>'
    + '<td bgcolor=#E6E6FA><b>Host_Name</b></td>'
    + '<td bgcolor=#E6E6FA><b>Cpu_Time</b></td>'
    + '<td bgcolor=#E6E6FA><b>Total_Scheduled_Time</b></td>'
    + '<td bgcolor=#E6E6FA><b>Total_Elapsed_Time</b></td>'
    + '<td bgcolor=#E6E6FA><b>Logical_Reads</b></td>'
    + '<td bgcolor=#E6E6FA><b>Reads</b></td>'
    + '<td bgcolor=#E6E6FA><b>Writes</b></td></tr>' ;

SET @Body = (

SELECT 
       td = [DataBaseName] , ''
      ,td =  [program_name] , ''
      ,td = [login_name], ''
      ,td = [nt_user_name], ''
      ,td =  [login_time], ''
      ,td  =  [host_name], ''
      ,td = [cpu_time], ''
      ,td = [total_scheduled_time], ''
      ,td = [total_elapsed_time], ''
      ,td = [logical_reads], ''
      ,td = [reads], ''
      ,td = [writes], ''
  FROM @ActiviadadDelServidorTemp
  order by login_time desc
            FOR   XML RAW('tr'),
                  ELEMENTS
            )


SELECT  @Body = @TableHead + ISNULL(@Body, '') + @TableTail

/*
Enviar Correo electronico 
alejandro Jimenez 
2019-10-16 
*/
EXEC sp_send_dbmail 
  @profile_name='SqlMail',
  @copy_recipients ='jose.jimenez@INABIMA.GOB.DO',
  @recipients=  @email,  --'jose.jimenez@INABIMA.GOB.DO', --; ja.jimenezrosa@gmail.com',
  @subject='Monitoreo de instancias y Bases de Datos SQL Server 10.0.0.252',
  @body=@Body ,
  @body_format = 'HTML' ;
~~~

# 


## Este query es una consulta SQL que se utiliza para recopilar información sobre las sesiones en una instancia de SQL Server en tiempo real. Proporciona información detallada sobre las sesiones en ejecución, sus consultas, bloqueos, y más. Aquí está una descripción de las partes clave de este query:<a name="20.1"></a>

1. `SELECT`: Esta es la cláusula de selección que define las columnas que se mostrarán en los resultados de la consulta.

2. Lista de columnas seleccionadas: Cada columna en la lista representa un atributo específico que se recopilará para cada sesión en ejecución. Algunos ejemplos de las columnas seleccionadas incluyen `session_id`, `status`, `login_name`, `database_name`, `host_name`, `program_name`, `blocking_session_id`, `command`, `reads`, `writes`, `cpu_time`, `wait_type`, `wait_time`, `last_wait_type`, `wait_resource`, `transaction_isolation_level`, `object_name`, `query_text`, y `query_plan`.

3. `FROM`: Esta cláusula especifica las tablas y vistas de las que se extraerán los datos. El query utiliza múltiples tablas del sistema, incluyendo `sys.dm_exec_connections`, `sys.dm_exec_sessions`, `sys.dm_exec_requests`, `sys.dm_exec_sql_text`, y `sys.dm_exec_query_plan`.

4. `OUTER JOIN`: Se utilizan uniones externas para combinar los datos de diferentes tablas, asegurando que se incluyan todas las sesiones en ejecución y que los datos se muestren incluso si no hay correspondencias en todas las tablas.

5. `WHERE`: La cláusula WHERE establece condiciones de filtrado para limitar los resultados a sesiones en ejecución que cumplan con ciertos criterios. Por ejemplo, excluye la sesión actual (`@@SPID`) y solo muestra las sesiones con un estado de 'running'.

6. `ORDER BY`: La cláusula ORDER BY especifica el orden en el que se presentarán los resultados. En este caso, las sesiones se ordenan por su identificador de sesión (`session_id`).

#### En resumen, este query recopila información sobre las sesiones en ejecución en una instancia de SQL Server, incluyendo detalles como el estado de la sesión, el nombre de inicio de sesión, la base de datos en uso, el host y programa desde el que se conecta, la consulta actual, el tiempo de CPU, el tipo de espera, los recursos de espera, el nivel de aislamiento de transacción, y otros atributos relevantes. Esta información es útil para monitorear y diagnosticar el rendimiento de la base de datos y las sesiones activas en SQL Server.

~~~sql
 SELECT

              es.session_id

              ,es.status

              ,es.login_name

              ,DB_NAME(er.database_id) as database_name

              ,es.host_name

              ,es.program_name

              ,er.blocking_session_id

              ,er.command

              ,es.reads

              ,es.writes

              ,es.cpu_time

              ,er.wait_type

              ,er.wait_time

              ,er.last_wait_type

              ,er.wait_resource

              ,CASE es.transaction_isolation_level WHEN 0 THEN 'Unspecified'

              WHEN 1 THEN 'ReadUncommitted'

              WHEN 2 THEN 'ReadCommitted'

              WHEN 3 THEN 'Repeatable'

              WHEN 4 THEN 'Serializable'

              WHEN 5 THEN 'Snapshot'

              END AS transaction_isolation_level

              ,OBJECT_NAME(st.objectid, er.database_id) as object_name

              ,SUBSTRING(st.text, er.statement_start_offset / 2,

              (CASE WHEN er.statement_end_offset = -1 THEN LEN(CONVERT(nvarchar(max), st.text)) * 2

              ELSE er.statement_end_offset END - er.statement_start_offset) / 2) AS query_text

              ,ph.query_plan

              FROM sys.dm_exec_connections ec

              LEFT OUTER JOIN sys.dm_exec_sessions es ON ec.session_id = es.session_id

              LEFT OUTER JOIN sys.dm_exec_requests er ON ec.connection_id = er.connection_id

              OUTER APPLY sys.dm_exec_sql_text(sql_handle) st

              OUTER APPLY sys.dm_exec_query_plan(plan_handle) ph

              WHERE ec.session_id  <> @@SPID

              AND es.status = 'running'

ORDER BY es.session_id;
~~~


# 



# Fecha Ultima restauracion de Un Backup<a name ="ultimarestauracion"></a>
<img src="https://2.bp.blogspot.com/-3PA74bncZU4/Vq9r-ULqrcI/AAAAAAAAAds/g5cD6s5JEr0/s640/copia-seguridad-windows-recuperacion-sistema.jpg?format=jpg&name=large" alt="JuveR" width="800px">
# 


~~~sql
SELECT rs.destination_database_name, 
    rs.restore_date, 
    bs.backup_start_date, 
    bs.backup_finish_date, 
    bs.database_name as source_database_name, 
    bmf.physical_device_name as backup_file_used_for_restore
    FROM msdb..restorehistory rs
        INNER JOIN msdb..backupset bs
        ON rs.backup_set_id = bs.backup_set_id
        INNER JOIN msdb..backupmediafamily bmf 
        ON bs.media_set_id = bmf.media_set_id 
        ORDER BY rs.restore_date DESC
~~~
# 


# Ultiimos Backup realizados en una base de datos.<a name ="ultimosbackup3"></a>
![](https://smoothcloud.co/wp-content/uploads/2022/06/nubeprivada.png)
# 
#### Las copias de seguridad de SQL Server proveen una importante solución para proteger datos críticos que están almacenados en bases de datos SQL. Y para minimizar el riego de pérdida de datos, usted necesita asegurarse de que respalda sus bases de datos regularmente tomando en consideración los cambios aplicados a sus datos. Es una buena práctica probar sus copias de seguridad restaurando archivos de copias de seguridad al azar a un ambiente de pruebas y verificar que los archivos no estén corruptos.
#### 
#### En adición al desastre normal de pérdida de datos, el DBA puede beneficiarse de copias de seguridad si hay un fallo de medios en uno de los discos o cualquier daño de hardware, un borrado o eliminación accidental aplicados por uno de los usuarios o usualmente copiar los datos desde un servidor a otro para propósitos como configurar un sitio con reflejo o Grupos de Disponibilidad AlwaysOn.
# 


~~~sql

/*
Query de los ultimos Backup realizados en la base de datos del 10.0.0.252
Alejandro JImenez Rosa ------
*/


USE master 
GO
SET NOCOUNT ON
GO





 
DECLARE @Server varchar(40)
 
Set @Server = Convert(varchar(35), ServerProperty('machinename')) + '\' + @@ServiceName
 
BEGIN TRY
    SELECT 
         @Server As 'Servidor - Instancia'
        ,FR.Database_Name
        ,DateDiff(Day, FR.Backup_Finish_Date, GetDate()) As 'Full_Dias'
        ,FR.Backup_Finish_Date  As 'Full_Termino'
        ,Convert(Char,Convert(Numeric(12,2),(FR.Backup_Size / 1024 / 1024))) As Full_Tamanho_MB
        ,DateDiff(Day, DR.Backup_Finish_Date, GetDate()) As 'Diff_Dias'
        ,DR.Backup_Finish_Date  As 'Diff_Termino'
        ,Case 
            When DR.Backup_Finish_Date Is Null Then Null
            Else DateDiff(Day, FR.Backup_Finish_Date, DR.Backup_Finish_Date)
        End As 'Dias_Full_Diff'
        ,Convert(Char,Convert(Numeric(12,2),(DR.Backup_Size / 1024 / 1024))) As Diff_Tamanho_MB
        ,DateDiff(Minute, TR.Backup_Finish_Date, GetDate()) As 'Tran_Minutos'
        ,TR.Backup_Finish_Date As 'Tran_Termino'
        ,Convert(Char,Convert(Numeric(12,2),(TR.Backup_Size / 1024 / 1024))) As Tran_Tamanho_MB
    FROM 
        msdb.dbo.backupset As FR
    LEFT OUTER JOIN
        msdb.dbo.backupset As TR
    ON
        TR.Database_Name = FR.Database_Name
    AND TR.Type = 'L'
    AND TR.Backup_Finish_Date =
        (
            (SELECT Max(Backup_Finish_Date) 
            FROM    msdb.dbo.backupset B2 
            WHERE   B2.Database_Name = FR.Database_Name 
            And B2.Type = 'L')
        )
    LEFT OUTER JOIN
        msdb.dbo.backupset As DR
    ON
        DR.Database_Name = FR.Database_Name
    AND DR.Type = 'I'
    AND DR.Backup_Finish_Date =
        (
            (SELECT Max(Backup_Finish_Date) 
            FROM    msdb.dbo.backupset B2 
            WHERE B2.Database_Name = FR.Database_Name 
              And B2.Type = 'I')
        )
    WHERE
        FR.Type = 'D' -- full backups only
    AND FR.Backup_Finish_Date = 
        (
            SELECT Max(Backup_Finish_Date) 
            FROM msdb.dbo.backupset B2 
            WHERE B2.Database_Name = FR.Database_Name 
            And   B2.Type = 'D'
        )
    And FR.Database_Name In (SELECT name FROM master.dbo.sysdatabases) 
    And FR.Database_Name Not In ('tempdb','pubs','northwind',
    'model'

    ,'bima','DB_Ponches','Ponches_old1','PonchesOld','RRHHbk',
    'RRHH'
    ,'WebDb','UNIPAGODB','Prestamos','DatosIMP' ,'Pruebas','BD1',
    'CONTDESA' 
    ,'MINERD_V2', 'PruebaMVC','INABIMA_V2','RegistroActivos',
    'Ponches')
 
UNION ALL
 
    SELECT
         @Server
        ,Name
        ,NULL
        ,NULL
        ,NULL 
        ,NULL
        ,NULL 
        ,NULL
        ,NULL
        ,NULL
        ,NULL
        ,NULL
    FROM 
        master.dbo.sysdatabases As Record
    WHERE
        Name Not In(SELECT DISTINCT Database_Name FROM msdb.dbo.backupset)
    And Name Not In ('tempdb','pubs','northwind'

    ,'model','bima','DB_Ponches','Ponches_old1','PonchesOld',
    'RRHHbk'
    ,'RRHH','WebDb','UNIPAGODB','Prestamos','DatosIMP' ,
    'ponches','TA100SQL_new','TA100SQL', 'DW','dbINABIMA2',
    'RegistroActivos','Ponches')
    ORDER BY
        1, 2
END TRY
BEGIN CATCH
    SELECT message_id, text FROM sys.messages WHERE message_id = @@ERROR AND language_id = 1033
END CATCH
~~~
# 


# Cuantos Core Tiene mi base de datos<a name="cuantoscoretengo"></a>
# 
<img src="https://hardzone.es/app/uploads/2019/07/Sistema-01.jpg?format=jpg&name=large" alt="JuveR" width="800px">
#
~~~sql
select scheduler_id, cpu_id, status, is_online 
from sys.dm_os_schedulers 
where status = 'VISIBLE ONLINE'
go

xp_cmdshell 'WMIC CPU Get DeviceID,NumberOfCores,NumberOfLogicalProcessors'
go
~~~

# 


#

# USUARIOS<a name="usuarios"></a>
![](https://www.osi.es/sites/default/files/images/imagen-decorativa-infografia-cuentas-usuario.png)
# Query de los usuarios y sus roles en una Base de Datos
# 


~~~sql

/*Querys that display the users and Roles from Sql server 2012.


I make this Query in order of an Store Procedure tha appears on
 TRANSDOC Database on june 22 2016
It is not supose to be there , Bbut aparently the sistem need to 
have a owner database user, in order to proces his will
*/
SELECT
  p.name rol,
  p.principal_id id_rol,
  m.name usuario,
  m.principal_id id_usuario
FROM sys.database_role_members rm
  INNER JOIN sys.database_principals p
    ON rm.role_principal_id = p.principal_id
  INNER JOIN sys.database_principals m
    ON rm.member_principal_id = m.principal_id
ORDER BY p.name

/*Query de olos usuarios y sus Rol ID*/
SELECT a.name, a.type_desc, a.is_disabled , a.principal_id
FROM sys.server_principals a
WHERE type_desc IN('SQL_LOGIN', 'WINDOWS_LOGIN', 'WINDOWS_GROUP');
~~~
# 




# Lista de permisos por Usuario<a name="listausuariosdb"></a>
# 

Este codigo nos lista todos los permisos de los usuarios creados e nuna base de datos,  esto es util en caso de que se quiera hacer una migracion o compracion con otros servidores o DB's
~~~sql
--- LISTAR PERMISOS DE LOS USUARIOS
select dp.NAME usuario, dp.type_desc AS tipo, o.NAME AS nombre_de_objeto,
p.permission_name nombre_de_permiso,
p.state_desc AS permisos from sys.database_permissions p
left    OUTER JOIN sys.all_objects o on p.major_id = o.OBJECT_ID
inner   JOIN sys.database_principals dp on  p.grantee_principal_id
= dp.principal_id
order by
usuario
~~~
# 


Este codigo nos lista los usuarios de todas las bases de datos de un servidor especifico.

es util en caso que se quiera extraer todas las db's y no nos es necesario hacerlo manual una por una

```sql
DECLARE @DBName NVARCHAR(128)
DECLARE @SQL NVARCHAR(MAX)

-- Crear tabla temporal para almacenar los resultados de todas las bases de datos
IF OBJECT_ID('tempdb..#PermisosUsuarios') IS NOT NULL
    DROP TABLE #PermisosUsuarios

CREATE TABLE #PermisosUsuarios (
    DBName NVARCHAR(128),
    Usuario NVARCHAR(128),
    Tipo NVARCHAR(128),
    NombreObjeto NVARCHAR(128),
    NombrePermiso NVARCHAR(128),
    Permisos NVARCHAR(128)
)

-- Cursor para recorrer todas las bases de datos del servidor
DECLARE db_cursor CURSOR FOR
SELECT name
FROM sys.databases
WHERE state_desc = 'ONLINE'  -- Excluir bases de datos offline
  AND name NOT IN ('master', 'tempdb', 'model', 'msdb') -- Excluir las bases del sistema

OPEN db_cursor
FETCH NEXT FROM db_cursor INTO @DBName

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Crear consulta dinámica para extraer los permisos de cada base de datos
    SET @SQL = N'
    USE [' + @DBName + '];
    INSERT INTO #PermisosUsuarios (DBName, Usuario, Tipo, NombreObjeto, NombrePermiso, Permisos)
    SELECT 
        ''' + @DBName + ''', 
        dp.NAME AS Usuario, 
        dp.type_desc AS Tipo, 
        o.NAME AS NombreObjeto, 
        p.permission_name AS NombrePermiso, 
        p.state_desc AS Permisos
    FROM 
        sys.database_permissions p
    LEFT OUTER JOIN 
        sys.all_objects o ON p.major_id = o.OBJECT_ID
    INNER JOIN 
        sys.database_principals dp ON p.grantee_principal_id = dp.principal_id
    ORDER BY 
        dp.NAME;'

    -- Ejecutar la consulta para la base de datos actual
    EXEC sp_executesql @SQL

    FETCH NEXT FROM db_cursor INTO @DBName
END

-- Cerrar y liberar el cursor
CLOSE db_cursor
DEALLOCATE db_cursor

-- Mostrar los resultados
SELECT *
FROM #PermisosUsuarios
ORDER BY DBName, Usuario

-- Opcional: Limpiar la tabla temporal si no deseas mantenerla
-- DROP TABLE #PermisosUsuarios
```

### Descripción:

1. **Cursor**: Este cursor recorre todas las bases de datos de la instancia que están en estado "ONLINE", excluyendo las bases de datos del sistema (`master`, `tempdb`, `model`, `msdb`).
   
2. **Consulta dinámica**: Por cada base de datos, se ejecuta la consulta que extrae los permisos de los usuarios en esa base de datos. No necesitas especificar el nombre de las bases de datos de forma manual.

3. **Tabla temporal**: Todos los resultados de cada base de datos se almacenan en la tabla temporal `#PermisosUsuarios`.

4. **Resultados**: Al final, se seleccionan todos los datos almacenados en la tabla temporal y se muestran los permisos de cada usuario en cada base de datos.

Este código está diseñado para ejecutarse en un servidor SQL Server y devolver los permisos de los usuarios en todas las bases de datos sin necesidad de modificarlo o especificar manualmente los nombres de las bases.



---







# Número de sesiones de cada usuario  sql server<a name="numeroseccionessqlserver"></a>
# 


~~~sql
--- número de sesiones de cada usuario  sql server 2008
SELECT login_name
,COUNT(session_id) AS session_count
FROM sys.dm_exec_sessions
GROUP BY login_name;
~~~

# Objetos Modificacos en los ultimos 10 Dias<a name="objectosmodificadosultimosdias"></a>
# 


~~~sql
SELECT name AS object_name 
  ,SCHEMA_NAME(schema_id) AS schema_name
  ,type_desc
  ,create_date
  ,modify_date
FROM sys.objects
WHERE modify_date > GETDATE() - 10
ORDER BY modify_date;
~~~
# 



# GENESIS<a name="sistemaponchesgenesis"></a>
<img src="https://hitek.com.do/wp-content/uploads/2019/10/reloj-hitek-1024x400.png?format=jpg&name=large" alt="JuveR" width="800px">

#### Esta base de datos corresponde al sistema de ponches del INABIMA.

#### A continuacion algunos de los trabajos realizados en la misma.


# Ejecutar procesure que Actualiza las tablas con los datos de los ponches para poder ejecutar el reporte de RRHH.<a name="genesiscargadatosreloj1"></a>
# 


~~~sql
declare @fecha varchar(10)
select @fecha from
openquery( [SOLUFLEX RRHH], N'EXECUTE PROCEDURE SPA_ACTUALIZA_PONCHESRELOJ ( ''2021-08-01'' , ''2021-10-07'')')
~~~

# 




# Cargar Datos Reloj<a name="genesiscargadatosreloj"></a>
# 


~~~sql
declare @fecha varchar(10) ;
declare @hora  varchar(10);
truncate table [Genesis].[PonchesDB].[DatosReloj_Cargar_temporal]

Insert into [Genesis].[PonchesDB].[DatosReloj_Cargar_temporal]
(
[NOMBRE]
      ,[CEDULA]
      ,[COD_RELOJ]
      ,[FECHA]
      ,[HORA]
      ,[CLOCKID]
      ,[TIPO_PONCHE]
)
SELECT  RTRIM(LTRIM(B.FIRSTNAME))+' '+ RTRIM(LTRIM(B.LASTNAME)) AS NOMBRE
      , REPLACE(USER1,'-','') AS CEDULA  
      ,badge COD_RELOJ, CAST(DATE AS DATE) AS FECHA
     , CAST(SUBSTRING(TIME,1,2)+':'+SUBSTRING(TIME,3,2)+':'+SUBSTRING(TIME,5,2) AS TIME) AS HORA
       , CLOCKID
       ,CASE WHEN   A.TIME BETWEEN '060000' AND '091000' THEN 'ENTRADA NORMAL'   
              WHEN   A.TIME BETWEEN '091000' AND '103000' THEN 'ENTRADA TARDE' 
              WHEN   A.TIME BETWEEN '110000' AND '150000' THEN 'ALMUERZO' 
              WHEN   A.TIME BETWEEN '160000' AND '230000' THEN 'SALIDA' ELSE  'NO AUTORIZADO' END TIPO_PONCHE

FROM [Genesis].[dbo].rawdata A RIGHT JOIN [Genesis].[dbo].employee B ON (B.EMPLNUM = A.badge)

set @fecha = (select max(fecha) from [Genesis].[PonchesDB].[DatosReloj_Cargar]) ;
set @hora  = (select max(HORA) from [Genesis].[PonchesDB].[DatosReloj_Cargar] where FECHA = @fecha ) ;

print @fecha
print @hora

Insert into [Genesis].[PonchesDB].[DatosReloj_Cargar]
(
[NOMBRE]
      ,[CEDULA]
      ,[COD_RELOJ]
      ,[FECHA]
      ,[HORA]
      ,[CLOCKID]
      ,[TIPO_PONCHE]
)
select 
a.[NOMBRE]
      ,a.[CEDULA]
      ,a.[COD_RELOJ]
      ,a.[FECHA]
      ,a.[HORA]
      ,a.[CLOCKID]
      ,a.[TIPO_PONCHE]
  from 
[Genesis].[PonchesDB].[DatosReloj_Cargar_temporal] a
left join [Genesis].[PonchesDB].[DatosReloj_Cargar] b
 on 
 (
 a.NOMBRE = b.NOMBRE
 and a.CEDULA = b.CEDULA
 and a.COD_RELOJ = b.COD_RELOJ
 
 and a.FECHA = b.FECHA
 and a.HORA = b.HORA
 and a.CLOCKID = b.CLOCKID
 and a.TIPO_PONCHE = b.TIPO_PONCHE
 
 )
where b.NOMBRE is null and a.FECHA is not null
~~~
# 


# 

# Horas de Almuerzo<a name="genesishorasdealmuerzo"></a>
# 


~~~sql

use msdb
go


declare @fecha varchar(10) = 
(
select min(Fecha) from [Genesis].[PonchesDB].[DatosReloj_Cargar] 
    where 
    --fecha = @fecha
HORA > '11:00:00' AND HORA < '15:30:00'
        and enviado = 0
        )


declare @PivotPonches table
(
Cedula varchar(13)
,Nombres varchar(150)
,Fecha varchar(10)
,Entrada varchar(10)
,Sal_almuerzo varchar(10)
,Ent_Almuerzo Varchar(10)
,Min_Almuerzo int
,Salida VArchar(10)
,Salida2 VArchar(10)
,numPonches int
,id int
)


insert into @PivotPonches
(
Cedula
,Nombres
,id
)
select a.cedula, p.Nombre
    ,ROW_NUMBER() over(order by a.cedula) as row#

 from [Genesis].PonchesDB.horarioEmpleados a
join [Genesis].PonchesDB.DescripcionHoratios b
        on a.idTipoPonche = b.id
join [Genesis].[PonchesDB].[PersonalDB] P
            on a.cedula = P.cedula2

        where b.act = 1
            and b.Dias = DATENAME(weekday, @fecha)



/*
=====
*/


update  a
    set a.Entrada = b.Hora
      ,a.Fecha = @fecha
from  @PivotPonches a,
(
select 
  --distinct

     A.cedula  --, ''
    ,isNull( B.FECHA,@fecha) Fecha --,''
    ,IsNull(B.HORA,'00:00:00' ) Hora --, ''
    ,isNull(B.COD_RELOJ,'') Reloj --, ''
    --,td = 'No Definido', ''
    ,ROW_NUMBER() over(partition by a.cedula order by b.hora) 
    NumeroPonche  -- ,''
from [Genesis].[PonchesDB].[horarioEmpleados] A
left join (
SELECT  RTRIM(LTRIM(B.FIRSTNAME))+' '+ RTRIM(LTRIM(B.LASTNAME)) 
AS NOMBRE
      , REPLACE(USER1,'-','') AS CEDULA  
      ,badge COD_RELOJ, CAST(DATE AS DATE) AS FECHA
     , min(CAST(SUBSTRING(TIME,1,2)+':'+SUBSTRING(TIME,3,2)+':'
     +SUBSTRING(TIME,5,2) AS TIME)) AS HORA
       , CLOCKID
       ,CASE WHEN   A.TIME BETWEEN '060000' AND '091000' THEN 'ENTRADA NORMAL'   
              WHEN   A.TIME BETWEEN '091000' AND '103000' THEN 'ENTRADA TARDE' 
              WHEN   A.TIME BETWEEN '110000' AND '150000' THEN 'ALMUERZO' 
              WHEN   A.TIME BETWEEN '160000' AND '230000' THEN 'SALIDA' ELSE  'NO AUTORIZADO' END TIPO_PONCHE
    ,ROW_NUMBER() Over(partition by REPLACE(USER1,'-','')  order by REPLACE(USER1,'-','') ,
    SUBSTRING(TIME,1,2)+':'+SUBSTRING(TIME,3,2)+':'+SUBSTRING(TIME,5,2) ) Row#
FROM [Genesis].[dbo].rawdata A 
RIGHT 
--left
JOIN [Genesis].[dbo].employee B ON (B.EMPLNUM = A.badge) 
            where CAST(DATE AS DATE) = @fecha 
group by
   b.firstname,b.lastname
   ,b.user1
   ,badge, date
   ,clockid,a.time

)  	B ON A.cedula = b.CEDULA 

) b
where a.Cedula = b.cedula
            and b.NumeroPonche = 1 


/*
=====================================================================================================
*/




/*
=====================================================================================================
*/


update  a
    set a.Sal_almuerzo = b.Hora
      --,a.Fecha = @fecha
from  @PivotPonches a,
(
select 
  --distinct

     A.cedula  --, ''
    ,isNull( B.FECHA,@fecha) Fecha --,''
    ,IsNull(B.HORA,'00:00:00' ) Hora --, ''
    ,isNull(B.COD_RELOJ,'') Reloj --, ''
    --,td = 'No Definido', ''
    ,ROW_NUMBER() over(partition by a.cedula order by b.hora) NumeroPonche  -- ,''
from [Genesis].[PonchesDB].[horarioEmpleados] A
left join (
SELECT  RTRIM(LTRIM(B.FIRSTNAME))+' '+ RTRIM(LTRIM(B.LASTNAME)) AS NOMBRE
      , REPLACE(USER1,'-','') AS CEDULA  
      ,badge COD_RELOJ, CAST(DATE AS DATE) AS FECHA
     , min(CAST(SUBSTRING(TIME,1,2)+':'+SUBSTRING(TIME,3,2)+':'+SUBSTRING(TIME,5,2) AS TIME)) AS HORA
       , CLOCKID
       ,CASE WHEN   A.TIME BETWEEN '060000' AND '091000' THEN
        'ENTRADA NORMAL'   
              WHEN   A.TIME BETWEEN '091000' AND '103000' THEN 
              'ENTRADA TARDE' 
              WHEN   A.TIME BETWEEN '110000' AND '150000' THEN 
              'ALMUERZO' 
              WHEN   A.TIME BETWEEN '160000' AND '230000' THEN 
              'SALIDA' ELSE  'NO AUTORIZADO' END TIPO_PONCHE

    ,ROW_NUMBER() Over(partition by REPLACE(USER1,'-','') 
     order  by REPLACE(USER1,'-','')
      ,SUBSTRING(TIME,1,2)+':'+SUBSTRING

    (TIME,3,2)+':'+SUBSTRING(TIME,5,2) ) Row#
FROM [Genesis].[dbo].rawdata A 
RIGHT 
--left
JOIN [Genesis].[dbo].employee B ON (B.EMPLNUM = A.badge) 
            where CAST(DATE AS DATE) = @fecha 
group by
   b.firstname,b.lastname
   ,b.user1
   ,badge, date
   ,clockid,a.time

)  	B ON A.cedula = b.CEDULA 

) b
where a.Cedula = b.cedula
            and b.NumeroPonche = 2 


update  a
    set a.Ent_Almuerzo = b.Hora
      --,a.Fecha = @fecha
from  @PivotPonches a,
(
select 
  --distinct

     A.cedula  --, ''
    ,isNull( B.FECHA,@fecha) Fecha --,''
    ,IsNull(B.HORA,'00:00:00' ) Hora --, ''
    ,isNull(B.COD_RELOJ,'') Reloj --, ''
    --,td = 'No Definido', ''
    ,ROW_NUMBER() over(partition by a.cedula order by b.hora) 
    NumeroPonche  -- ,''
from [Genesis].[PonchesDB].[horarioEmpleados] A
left join (
SELECT  RTRIM(LTRIM(B.FIRSTNAME))+' '+ RTRIM(LTRIM(B.LASTNAME)) AS NOMBRE
      , REPLACE(USER1,'-','') AS CEDULA  
      ,badge COD_RELOJ, CAST(DATE AS DATE) AS FECHA

     , ISNULL( min(CAST(SUBSTRING(TIME,1,2)+':'+SUBSTRING(TIME,3,
     2)+':'+SUBSTRING(TIME,5,2) AS TIME)),'00:00:00') AS HORA

       , CLOCKID
       ,CASE WHEN   A.TIME BETWEEN '060000' AND '091000' THEN 'ENTRADA NORMAL'   
              WHEN   A.TIME BETWEEN '091000' AND '103000' THEN 'ENTRADA TARDE' 
              WHEN   A.TIME BETWEEN '110000' AND '150000' THEN 'ALMUERZO' 
              WHEN   A.TIME BETWEEN '160000' AND '230000' THEN 'SALIDA' ELSE  'NO AUTORIZADO' END TIPO_PONCHE
    ,ROW_NUMBER() Over(partition by REPLACE(USER1,'-','')  order 
    by REPLACE(USER1,'-','') ,SUBSTRING(TIME,1,2)+':'+SUBSTRING
    (TIME,3,2)+':'+SUBSTRING(TIME,5,2) ) Row#
FROM [Genesis].[dbo].rawdata A 
RIGHT 
--left
JOIN [Genesis].[dbo].employee B ON (B.EMPLNUM = A.badge) 
            where CAST(DATE AS DATE) = @fecha 
group by
   b.firstname,b.lastname
   ,b.user1
   ,badge, date
   ,clockid,a.time

)  	B ON A.cedula = b.CEDULA 

) b
where a.Cedula = b.cedula
            and b.NumeroPonche = 3


update  a
    set a.Salida = b.Hora
    ,Min_Almuerzo = IsNull(datediff(minute, Sal_almuerzo , Ent_Almuerzo),0 )
      --,a.Fecha = @fecha
from  @PivotPonches a,
(
select 
  --distinct

     A.cedula  --, ''
    ,isNull( B.FECHA,@fecha) Fecha --,''
    ,IsNull(B.HORA,'00:00:00' ) Hora --, ''
    ,isNull(B.COD_RELOJ,'') Reloj --, ''
    --,td = 'No Definido', ''
    ,ROW_NUMBER() over(partition by a.cedula order by b.hora) NumeroPonche  -- ,''
from [Genesis].[PonchesDB].[horarioEmpleados] A
left join (
SELECT  RTRIM(LTRIM(B.FIRSTNAME))+' '+ RTRIM(LTRIM(B.LASTNAME)) AS NOMBRE
      , REPLACE(USER1,'-','') AS CEDULA  
      ,badge COD_RELOJ, CAST(DATE AS DATE) AS FECHA

     , ISNULL( min(CAST(SUBSTRING(TIME,1,2)+':'+SUBSTRING(TIME,3,
     2)+':'+SUBSTRING(TIME,5,2) AS TIME)),'00:00:00') AS HORA

       , CLOCKID
       ,CASE WHEN   A.TIME BETWEEN '060000' AND '091000' THEN 'ENTRADA NORMAL'   
              WHEN   A.TIME BETWEEN '091000' AND '103000' THEN 'ENTRADA TARDE' 
              WHEN   A.TIME BETWEEN '110000' AND '150000' THEN 'ALMUERZO' 
              WHEN   A.TIME BETWEEN '160000' AND '230000' THEN 
              'SALIDA' ELSE  'NO AUTORIZADO' END TIPO_PONCHE

    ,ROW_NUMBER() Over(partition by REPLACE(USER1,'-','')  order 
    by REPLACE(USER1,'-','') ,SUBSTRING(TIME,1,2)+':'+SUBSTRING(TIME,3,2)+':'+SUBSTRING(TIME,5,2) ) Row#
FROM [Genesis].[dbo].rawdata A 
RIGHT 
--left
JOIN [Genesis].[dbo].employee B ON (B.EMPLNUM = A.badge) 
            where CAST(DATE AS DATE) = @fecha 
group by
   b.firstname,b.lastname
   ,b.user1
   ,badge, date
   ,clockid,a.time

)  	B ON A.cedula = b.CEDULA 

) b
where a.Cedula = b.cedula
            and b.NumeroPonche = 4


update  a
    set a.Salida2 = b.Hora
    --,Min_Almuerzo = IsNull(datediff(minute, Sal_almuerzo , Ent_Almuerzo),0 )
      --,a.Fecha = @fecha
from  @PivotPonches a,
(
select 
  --distinct

     A.cedula  --, ''
    ,isNull( B.FECHA,@fecha) Fecha --,''
    ,IsNull(B.HORA,'00:00:00' ) Hora --, ''
    ,isNull(B.COD_RELOJ,'') Reloj --, ''
    --,td = 'No Definido', ''
    ,ROW_NUMBER() over(partition by a.cedula order by b.hora) 
    NumeroPonche  -- ,''
from [Genesis].[PonchesDB].[horarioEmpleados] A
left join (
SELECT  RTRIM(LTRIM(B.FIRSTNAME))+' '+ RTRIM(LTRIM(B.LASTNAME)) AS NOMBRE
      , REPLACE(USER1,'-','') AS CEDULA  
      ,badge COD_RELOJ, CAST(DATE AS DATE) AS FECHA
     ,ISNULL( min(CAST(SUBSTRING(TIME,1,2)+':'+SUBSTRING(TIME,3,2)+':'+SUBSTRING(TIME,5,2) AS TIME)) 
     ,'00:00:00')AS HORA
       , CLOCKID
       ,CASE WHEN   A.TIME BETWEEN '060000' AND '091000' THEN 'ENTRADA NORMAL'   
              WHEN   A.TIME BETWEEN '091000' AND '103000' THEN 'ENTRADA TARDE' 
              WHEN   A.TIME BETWEEN '110000' AND '150000' THEN 'ALMUERZO' 
              WHEN   A.TIME BETWEEN '160000' AND '230000' THEN 
              'SALIDA' ELSE  'NO AUTORIZADO' END TIPO_PONCHE
    ,ROW_NUMBER() Over(partition by REPLACE(USER1,'-','')  
    order by REPLACE(USER1,'-','') ,SUBSTRING(TIME,1,2)+':'+SUBSTRING(TIME,3,2)+':'+SUBSTRING(TIME,5,2) ) Row#
FROM [Genesis].[dbo].rawdata A 
RIGHT 
--left
JOIN [Genesis].[dbo].employee B ON (B.EMPLNUM = A.badge) 
            where CAST(DATE AS DATE) = @fecha 
group by
   b.firstname,b.lastname
   ,b.user1
   ,badge, date
   ,clockid,a.time

)  	B ON A.cedula = b.CEDULA 

) b
where a.Cedula = b.cedula
            and b.NumeroPonche = 5

/*
=====================================================================================================
*/

declare @email varchar(500) = 
(

SELECT 
      [Email]
  FROM [AuditoriaDB].[dbo].[tblParametros]
  where id = 6
)

DECLARE @Body NVARCHAR(MAX),
    @TableHead VARCHAR(1000),
    @TableTail VARCHAR(1000)
    ,@dias int = 2

if exists (
select * from  @PivotPonches
)
begin

SET @TableTail = '</table></body></html>' ;
SET @TableHead = '<html><head>' + '<style>'
    + 'td {border: solid black;border-width: 1px;
    padding-left:5px;padding-right:5px;padding-top:1px;
    padding-bottom:1px;font: 11px arial} '
    + '</style>' + '</head>' + '<body>' + '<h1>Reporte de Eventos horas de Almuerzo del: ' + @fecha +'  </h1> '
    + CONVERT(VARCHAR(50), GETDATE(), 100) 
    + ' <br> <table cellpadding=0 cellspacing=0 border=0>' 
    + '<tr> <td bgcolor=#E6E6FA><b>Cédula</b></td>'
    + '<td bgcolor=#E6E6FA><b>Nombres</b></td>'
    + '<td bgcolor=#E6E6FA><b>Fecha</b></td>'
    + '<td bgcolor=#ffffb3><b>Entrada</b></td>'
    + '<td bgcolor=#ffffb3><b>Sal_Almuerzo</b></td>'
    + '<td bgcolor=#ffffb3><b>Ent_Almuerzo</b></td>'
    + '<td bgcolor=#ffffb3><b>Minutos</b></td>'
    + '<td bgcolor=#ffffb3><b>Salida</b></td>'
    --+ '<td bgcolor=#E6E6FA><b>Tipo_ponche</b></td>'
    --+ '<td bgcolor=#E6E6FA><b>Código Reloj</b></td>'
    --+ '<td bgcolor=#E6E6FA><b>Sucursal</b></td>
    + '</tr>' ;

SET @Body = (

select 
    td = cedula, ''
    ,td = nombres, ''
    ,td = Fecha , ''
    ,td = isnull(Entrada,'00:00:00'), ''
    , td =isnull(Sal_almuerzo,'00:00:00') , ''
    ,td = isnull(Ent_Almuerzo,'00:00:00') , ''
    ,td = isnull(Min_Almuerzo,0)-60 , ''

    ,td = isnull( Salida,'00:00:00') , ''
 from @PivotPonches 
        where (Min_Almuerzo > 65 or Min_Almuerzo < 5)
                    and cedula  not in 
                (
                
                select Cedula
                    from  [Genesis].[PonchesDB].VacacionesRH
                    where  getdate() between fecha_Inicio and fecha_fin


                )

    order by nombres
 
            FOR   XML RAW('tr'),
                  ELEMENTS
            )



SELECT  @Body = @TableHead + ISNULL(@Body, '') + @TableTail



EXEC sp_send_dbmail 
  @profile_name='SqlMail',
  @copy_recipients ='jose.jimenez@INABIMA.GOB.DO; francis.rodriguez@inabima.gob.do' , 
  @recipients=  @email,  --'jose.jimenez@INABIMA.GOB.DO', --; ja.jimenezrosa@gmail.com',
  @subject='Reporte de Eventos horas de Almuerzo.',
  @body=@Body ,
  @body_format = 'HTML' ;


end

if exists (
select * from  @PivotPonches
)
begin

exec [Genesis].[dbo].[sp_EnviarCorreosDepto] @fecha

while exists(
select top 1 
   emailsupervisor
from
[genesis].[PonchesDB].[SupervisoresCorreos] 
Where  [activarEnvioCorreo]= 1
and enviado = 0
)
begin


set @email = 
(
        select top 1 
           [EMAILSUPERVISOR]
        from
        [genesis].[PonchesDB].[SupervisoresCorreos] 
            Where  [activarEnvioCorreo]= 1
                and enviado = 0
)



SET @TableTail = '</table></body></html>' ;
SET @TableHead = '<html><head>' + '<style>'
    + 'td {border: solid black;border-width: 1px;padding-left:5px;padding-right:5px;padding-top:1px;
    padding-bottom:1px;font: 11px arial} '
    + '</style>' + '</head>' + '<body>' + '<h1>Reporte de Eventos horas de Almuerzo del: ' + @fecha +   '   </h1> '
    + CONVERT(VARCHAR(50), GETDATE(), 100) 
    + ' <br> <table cellpadding=0 cellspacing=0 border=0>' 
    + '<tr> <td bgcolor=#E6E6FA><b>Cédula</b></td>'
    + '<td bgcolor=#E6E6FA><b>Nombres</b></td>'
    + '<td bgcolor=#E6E6FA><b>Fecha</b></td>'
    + '<td bgcolor=#ffffb3><b>Entrada</b></td>'
    + '<td bgcolor=#ffffb3><b>Sal_Almuerzo</b></td>'
    + '<td bgcolor=#ffffb3><b>Ent_Almuerzo</b></td>'
    + '<td bgcolor=#ffffb3><b>Minutos</b></td>'
    + '<td bgcolor=#ffffb3><b>Salida</b></td>'
    + '</tr>' ;

SET @Body = (


select 
    td = cedula, ''
    ,td = nombres, ''
    ,td = Fecha , ''
    ,td = isnull(Entrada,'00:00:00'), ''
    , td =isnull(Sal_almuerzo,'00:00:00') , ''
    ,td = isnull(Ent_Almuerzo,'00:00:00') , ''
    ,td = isnull(Min_Almuerzo,0)-60 , ''

    ,td = isnull( Salida,'00:00:00') , ''
 from @PivotPonches 
        where (Min_Almuerzo > 65 or Min_Almuerzo < 5)
                    and cedula  not in 
                (
                
                select Cedula
                    from  [Genesis].[PonchesDB].VacacionesRH
                    where  getdate() between fecha_Inicio and fecha_fin


                )
    and cedula in (
                select CEDULA_EMP from genesis.[PonchesDB].[SupervisoresCorreos] where EMAILSUPERVISOR = @email
                )


/*===========================*/

    order by nombres
 
            FOR   XML RAW('tr'),
                  ELEMENTS
            )



SELECT  @Body = @TableHead + ISNULL(@Body, '') + @TableTail

EXEC sp_send_dbmail 
  @profile_name='SqlMail',
  @copy_recipients ='jose.jimenez@INABIMA.GOB.DO' , -- ; francis.rodriguez@inabima.gob.do' , 
  @recipients=  @email,  --'jose.jimenez@INABIMA.GOB.DO', --; ja.jimenezrosa@gmail.com',
  @subject='Reporte de Eventos horas de Almuerzo.',
  @body=@Body ,
  @body_format = 'HTML' ;


  update [genesis].[PonchesDB].[SupervisoresCorreos] 
    set enviado = 1 
        Where  [activarEnvioCorreo]= 1
        and enviado = 0
        and [EMAILSUPERVISOR] = @email
  end

  update [Genesis].[PonchesDB].[DatosReloj_Cargar] 
    set enviado = 1
    where fecha = @fecha
        AND HORA > '11:00:00' AND HORA < '15:30:00'


end
~~~
# 



# Persona que deben Ponchas Salida y no Ponchan
# 


~~~sql
declare @email varchar(500) = 
(

SELECT 
      [Email]
  FROM [AuditoriaDB].[dbo].[tblParametros]
  where id = 6
)


while exists (
select distinct top 1 fecha, enviado from [Genesis].[PonchesDB].[DatosReloj_Cargar]
where enviado = 0 AND HORA < '23:00:00'

order by fecha asc

)
begin

DECLARE @Body NVARCHAR(MAX),
    @TableHead VARCHAR(1000),
    @TableTail VARCHAR(1000)
    ,@dias int = 2
    ,@fecha varchar(10) 
    
    /*
    
    Asignar fecha a enviar al personal de resursos humanos
    */
set @fecha = (
select distinct top 1 fecha from [Genesis].PonchesDB.[DatosReloj_Cargar]
where enviado < 3 AND HORA < '23:00:00'
order by fecha asc


)


--set @fecha = '2019-05-27'

SET @TableTail = '</table></body></html>' ;
SET @TableHead = '<html><head>' + '<style>'
    + 'td {border: solid black;border-width: 1px;
    padding-left:5px;padding-right:5px;padding-top:1px;padding-bottom:1px;font: 11px arial} '
    + '</style>' + '</head>' + '<body>' + 
    '<h1>Reporte de Eventos Personas No Poncharon En el Dia el: ' + @fecha +'  </h1> '
    + CONVERT(VARCHAR(50), GETDATE(), 100) 
    + ' <br> <table cellpadding=0 cellspacing=0 border=0>' 
    + '<tr> <td bgcolor=#E6E6FA><b>Cédula</b></td>'
    + '<td bgcolor=#E6E6FA><b>Nombres</b></td>'
    + '<td bgcolor=#E6E6FA><b>Fecha</b></td>'
    + '<td bgcolor=#ffffb3><b>Hora</b></td>'
    + '<td bgcolor=#E6E6FA><b>Tipo_ponche</b></td>'
    + '<td bgcolor=#E6E6FA><b>Código Reloj</b></td>'
    + '<td bgcolor=#E6E6FA><b>Sucursal</b></td></tr>' ;

SET @Body = (
select 

    td =  A.cedula, ''
    , td = Per.NOMBRE,''
    --,a.CEDULA
    , td =isNull( B.FECHA,@fecha),''
    ,td = IsNull(B.HORA,'00:00:00' ), ''
    ,td = IsNull(B.TIPO_PONCHE,'No poncho' ), ''
    ,td = isNull(B.COD_RELOJ,''), ''
    ,td = 'No Definido', ''
    
from [Genesis].[PonchesDB].[horarioEmpleados] A
left join (
SELECT  RTRIM(LTRIM(B.FIRSTNAME))+' '+ RTRIM(LTRIM(B.LASTNAME)) AS NOMBRE
      , REPLACE(USER1,'-','') AS CEDULA  
      ,badge COD_RELOJ, CAST(DATE AS DATE) AS FECHA
     , CAST(SUBSTRING(TIME,1,2)+':'+SUBSTRING(TIME,3,2)+':'+SUBSTRING(TIME,5,2) AS TIME) AS HORA
       , CLOCKID
       ,CASE WHEN   A.TIME BETWEEN '060000' AND '091000' THEN 'ENTRADA NORMAL'   
              WHEN   A.TIME BETWEEN '091000' AND '103000' THEN 'ENTRADA TARDE' 
              WHEN   A.TIME BETWEEN '110000' AND '150000' THEN 'ALMUERZO' 
              WHEN   A.TIME BETWEEN '160000' AND '230000' THEN 'SALIDA' ELSE  'NO AUTORIZADO' END TIPO_PONCHE


FROM [Genesis].[dbo].rawdata A 
RIGHT 
--left
JOIN [Genesis].[dbo].employee B ON (B.EMPLNUM = A.badge) 
            where CAST(DATE AS DATE) = @fecha 
            and 
            SUBSTRING(TIME,1,2)+':'+SUBSTRING(TIME,3,2)+':'+SUBSTRING(TIME,5,2)  < '11:00:00'

)  	B ON A.cedula = b.CEDULA


 join [Genesis].[PonchesDB].[PersonalDB] Per
                on per.cedula2 = a.cedula

join 
 (
 
select * from [Genesis].[PonchesDB].[DescripcionHoratios] where  dias = DATENAME(weekday ,getdate()) and act = 1
 ) c on c.id = A.idTipoPonche
    Where b.hora is null


 order by per.NOMBRE 


            FOR   XML RAW('tr'),
                  ELEMENTS
            )



SELECT  @Body = @TableHead + ISNULL(@Body, '') + @TableTail


EXEC sp_send_dbmail 
  @profile_name='SqlMail',
  @copy_recipients ='jose.jimenez@INABIMA.GOB.DO',
  @recipients=  @email,  --'jose.jimenez@INABIMA.GOB.DO', --; ja.jimenezrosa@gmail.com',
  @subject='Query Result',
  @body=@Body ,
  @body_format = 'HTML' ;

  update [Genesis].[PonchesDB].[DatosReloj_Cargar] 
    set enviado = 1
    where fecha = @fecha
    AND HORA < '11:00:00'


end 
~~~
# 


#
# personas que deben ponchas y no ponchan con envio a supervisores<a name="genesispersonasdebenponcharynoponc"></a>
# 


~~~sql
/*
Query de los ponches de entrada personas que deben ponchas y no ponchan.
Alejandro Jimenez 2019-06-07
*/

declare @Correo varchar(100) ;
declare @Mensaje varchar(1000);

declare @email varchar(500) = 
(

SELECT 
      [Email]
  FROM [AuditoriaDB].[dbo].[tblParametros]
  where id = 6
)
--set @email = 'jose.jimenez@inabima.gob.do'

update  [Genesis].[PonchesDB].[DatosReloj_Cargar]
    set enviado = 3 where fecha = '2019-06-11'

update [Genesis].[PonchesDB].[DatosReloj_Cargar]
set enviado = 0 where fecha  =convert(varchar(10),getdate(),120)

while exists (
select distinct top 1 fecha, enviado from [Genesis].[PonchesDB].[DatosReloj_Cargar]
where enviado = 0 
    and fecha > convert(varchar(10),getdate()-3,120)
AND HORA < '11:00:00'

order by fecha asc

)
begin

DECLARE @Body NVARCHAR(MAX),
    @TableHead VARCHAR(1000),
    @TableTail VARCHAR(1000)
    ,@dias int = 2
    ,@fecha varchar(10) 
    
    /*
    
    Asignar fecha a enviar al personal de resursos humanos
    */
set @fecha = (
select distinct top 1 fecha from [Genesis].PonchesDB.[DatosReloj_Cargar]
where enviado = 0 AND HORA < '11:00:00'
order by fecha asc
)
--set @fecha = '2019-05-27'
SET @TableTail = '</table></body></html>' ;
SET @TableHead = '<html><head>' + '<style>'
    + 'td {border: solid black;border-width: 1px;
    padding-left:5px;padding-right:5px;padding-top:1px;
    padding-bottom:1px;font: 11px arial} '
    + '</style>' + '</head>' + '<body>' + '<h1>Reporte de 
    Eventos Personas No Poncharon el: ' + @fecha +'  </h1> '
    + CONVERT(VARCHAR(50), GETDATE(), 100) 
    + ' <br> <table cellpadding=0 cellspacing=0 border=0>' 
    + '<tr> <td bgcolor=#E6E6FA><b>Cédula</b></td>'
    + '<td bgcolor=#E6E6FA><b>Nombres</b></td>'
    + '<td bgcolor=#E6E6FA><b>Fecha</b></td>'
    + '<td bgcolor=#ffffb3><b>Hora</b></td>'
    + '<td bgcolor=#E6E6FA><b>Tipo_ponche</b></td>'
    + '<td bgcolor=#E6E6FA><b>Código Reloj</b></td>'
    + '<td bgcolor=#E6E6FA><b>Sucursal</b></td></tr>' ;

SET @Body = (
select 
    td =  A.cedula, ''
    , td = Per.NOMBRE,''
    , td =isNull( B.FECHA,@fecha),''
    ,td = IsNull(B.HORA,'00:00:00' ), ''
    ,td = IsNull(B.TIPO_PONCHE,'No poncho' ), ''
    ,td = isNull(B.COD_RELOJ,''), ''
    ,td = 'No Definido', ''
    
from [Genesis].[PonchesDB].[horarioEmpleados] A
left join (
SELECT  RTRIM(LTRIM(B.FIRSTNAME))+' '+ RTRIM(LTRIM(B.LASTNAME)) AS NOMBRE
      , REPLACE(USER1,'-','') AS CEDULA  
      ,badge COD_RELOJ, CAST(DATE AS DATE) AS FECHA
     , CAST(SUBSTRING(TIME,1,2)+':'+SUBSTRING(TIME,3,2)+':'+SUBSTRING(TIME,5,2) AS TIME) AS HORA
       , CLOCKID
       ,CASE WHEN   A.TIME BETWEEN '060000' AND '091000' THEN 'ENTRADA NORMAL'   
              WHEN   A.TIME BETWEEN '091000' AND '103000' THEN 'ENTRADA TARDE' 
              WHEN   A.TIME BETWEEN '110000' AND '150000' THEN 'ALMUERZO' 
              WHEN   A.TIME BETWEEN '160000' AND '230000' THEN 'SALIDA' ELSE  'NO AUTORIZADO' END TIPO_PONCHE
FROM [Genesis].[dbo].rawdata A 
RIGHT 
--left
JOIN [Genesis].[dbo].employee B ON (B.EMPLNUM = A.badge) 
            where CAST(DATE AS DATE) = @fecha 
            and 
            SUBSTRING(TIME,1,2)+':'+SUBSTRING(TIME,3,2)+':'+SUBSTRING(TIME,5,2)  < '11:00:00'

)  	B ON A.cedula = b.CEDULA

 join [Genesis].[PonchesDB].[PersonalDB] Per
                on per.cedula2 = a.cedula
join 
 (
select * from [Genesis].[PonchesDB].[DescripcionHoratios] where  dias = DATENAME(weekday ,@fecha) and act = 1
 ) c on c.id = A.idTipoPonche
    Where b.hora is null

 order by per.NOMBRE 


            FOR   XML RAW('tr'),
                  ELEMENTS
            )

SELECT  @Body = @TableHead + ISNULL(@Body, '') + @TableTail

/*
=======================================================================================================
Inicio de bucles para envio de correos a los encargados de depto
Alejandro Jimenez Viernes 14 de Junio 2019
*/

exec [Genesis].[dbo].[sp_EnviarCorreosDepto] @fecha

update [Genesis].[PonchesDB].[SupervisoresCorreos]
set enviado = 1

update [Genesis].[PonchesDB].[SupervisoresCorreos]
set enviado = 0 where EMAILSUPERVISOR = 'evelyn.estrella@inabima.gob.do'

while exists(
select top 1 
   emailsupervisor
from
[genesis].[PonchesDB].[SupervisoresCorreos] 
Where  [activarEnvioCorreo]= 1 and EMAILSUPERVISOR = 'evelyn.estrella@inabima.gob.do'
and enviado = 0
)
begin

set @Correo = 
(
        select top 1 
           [EMAILSUPERVISOR]
        from
        [genesis].[PonchesDB].[SupervisoresCorreos] 
            Where  [activarEnvioCorreo]= 1
                and enviado = 0
)
/*
=============================================================================================================
*/
set @mensaje = ''
Set @Mensaje ='' + ( select distinct top 1 isnull(Depto,'') 
from [genesis].[PonchesDB].[SupervisoresCorreos] 
where [EMAILSUPERVISOR]  = @Correo)

Set @Mensaje += '</br> SUPERVISOR: '+ ( select top 1 isnull
([SUPERVISOR],'') 
from [genesis].[PonchesDB].[SupervisoresCorreos] 
where [EMAILSUPERVISOR]  = @Correo)
--print @correo

SET @TableTail = '</table></body></html>' ;
SET @TableHead = '<html><head>' + '<style>'
    + 'td {border: solid black;border-width: 1px;
    padding-left:5px;padding-right:5px;padding-top:1px;
    padding-bottom:1px;font: 11px arial} '
    + '</style>' + '</head>' + '<body>' + '<h2 
    Color="darkblue">Reporte de Eventos Personas No Poncharon el ' +@fecha + '</h2>'+
                            '<h4>' + @Mensaje+ '</h4>'
    + CONVERT(VARCHAR(50), GETDATE(), 100) 
    + ' <br> <table cellpadding=0 cellspacing=0 border=0>' 
    + '<tr> <td bgcolor=#E6E6FA><b>Cédula</b></td>'
    + '<td bgcolor=#E6E6FA><b>Nombres</b></td>'
    + '<td bgcolor=#E6E6FA><b>Fecha</b></td>'
    + '<td bgcolor=#ffffb3><b>Hora</b></td>'
    + '<td bgcolor=#E6E6FA><b>Tipo_ponche</b></td>'
    + '<td bgcolor=#E6E6FA><b>Código Reloj</b></td>'
    + '<td bgcolor=#E6E6FA><b>Sucursal</b></td></tr>' ;

SET @Body = (
select 
    td =  A.cedula, ''
    , td = Per.NOMBRE,''
    , td =isNull( B.FECHA,@fecha),''
    ,td = IsNull(B.HORA,'00:00:00' ), ''
    ,td = IsNull(B.TIPO_PONCHE,'No poncho' ), ''
    ,td = isNull(B.COD_RELOJ,''), ''
    ,td = 'No Definido', ''
    
from [Genesis].[PonchesDB].[horarioEmpleados] A
left join (
SELECT  RTRIM(LTRIM(B.FIRSTNAME))+' '+ RTRIM(LTRIM(B.LASTNAME)) AS NOMBRE
      , REPLACE(USER1,'-','') AS CEDULA  
      ,badge COD_RELOJ, CAST(DATE AS DATE) AS FECHA
     , CAST(SUBSTRING(TIME,1,2)+':'+SUBSTRING(TIME,3,2)+':'+SUBSTRING(TIME,5,2) AS TIME) AS HORA
       , CLOCKID
       ,CASE WHEN   A.TIME BETWEEN '060000' AND '091000' THEN 'ENTRADA NORMAL'   
              WHEN   A.TIME BETWEEN '091000' AND '103000' THEN 'ENTRADA TARDE' 
              WHEN   A.TIME BETWEEN '110000' AND '150000' THEN 'ALMUERZO' 
              WHEN   A.TIME BETWEEN '160000' AND '230000' THEN 'SALIDA' ELSE  'NO AUTORIZADO' END TIPO_PONCHE


FROM [Genesis].[dbo].rawdata A 
RIGHT 
--left
JOIN [Genesis].[dbo].employee B ON (B.EMPLNUM = A.badge) 
            where CAST(DATE AS DATE) = @fecha 
            and 
            SUBSTRING(TIME,1,2)+':'+SUBSTRING(TIME,3,2)+':'+SUBSTRING(TIME,5,2)  < '11:00:00'

)  	B ON A.cedula = b.CEDULA

 join [Genesis].[PonchesDB].[PersonalDB] Per
                on per.cedula2 = a.cedula
join 
 (
 
select * from [Genesis].[PonchesDB].[DescripcionHoratios] where  dias = DATENAME(weekday ,@fecha) and act = 1
 ) c on c.id = A.idTipoPonche
 
 
 join  [genesis].[PonchesDB].[SupervisoresCorreos]  Sper 
            on Sper.[CEDULA_EMP] = per.cedula2
                    and Sper.[EMAILSUPERVISOR] = @correo
    Where b.hora is null

 order by per.NOMBRE 

            FOR   XML RAW('tr'),
                  ELEMENTS
            )

SELECT  @Body = @TableHead + ISNULL(@Body, '') + @TableTail
declare @correo1 varchar(1000);
set @Correo1 = 'jose.jimenez@inabima.gob.do'

EXEC sp_send_dbmail 
  @profile_name='SqlMail',
  @copy_recipients ='',
  @recipients=  @correo1,    -----   @email,  --'jose.jimenez@INABIMA.GOB.DO', --; ja.jimenezrosa@gmail.com',
  @subject= @Mensaje  ,
  @body=@Body ,
  @body_format = 'HTML' ;
/*
=============================================================================================================
*/
update [genesis].[PonchesDB].[SupervisoresCorreos] 
    set enviado = 1 
        Where  [activarEnvioCorreo]= 1
        and enviado = 0
        and [EMAILSUPERVISOR] = @correo
end

/*

*/
  update [Genesis].[PonchesDB].[DatosReloj_Cargar] 
    set enviado = 1
    where fecha = @fecha
    AND HORA < '11:00:00'
end 
~~~

# Ponches Entrada Fuera del Horario
# 


~~~sql
/*
Query de los ponches de entrada fuera de Horario.
Alejandro Jimenez 2019-06-07
*/
use msdb
go

declare @email varchar(500) = 
(

SELECT 
      [Email]
  FROM [AuditoriaDB].[dbo].[tblParametros]
  where id = 6
)


while exists (
select distinct top 1 fecha, enviado from [Genesis].[PonchesDB].[DatosReloj_Cargar]
where enviado = 1 AND HORA < '11:00:00'

order by fecha asc

)
begin

DECLARE @Body NVARCHAR(MAX),
    @TableHead VARCHAR(1000),
    @TableTail VARCHAR(1000)
    ,@dias int = 2
    ,@fecha varchar(10) 
    
    /*
    Asignar fecha a enviar al personal de resursos humanos
    */
set @fecha = (select distinct top 1 fecha 
from [Genesis].PonchesDB.[DatosReloj_Cargar]
where enviado = 1 AND HORA < '11:00:00'
order by fecha asc
)

SET @TableTail = '</table></body></html>' ;
SET @TableHead = '<html><head>' + '<style>'
    + 'td {border: solid black;border-width: 1px;
    padding-left:5px;padding-right:5px;padding-top:1px;
    padding-bottom:1px;font: 11px arial} '
    + '</style>' + '</head>' + '<body>' + '<h1>Reporte de Eventos Entrada Tardias : ' + @fecha +'  </h1> '
    + CONVERT(VARCHAR(50), GETDATE(), 100) 
    + ' <br> <table cellpadding=0 cellspacing=0 border=0>' 
    + '<tr> <td bgcolor=#E6E6FA><b>Cédula</b></td>'
    + '<td bgcolor=#E6E6FA><b>Nombres</b></td>'
    + '<td bgcolor=#E6E6FA><b>Fecha</b></td>'
    + '<td bgcolor=#ffffb3><b>Hora</b></td>'
    + '<td bgcolor=#E6E6FA><b>Tipo_ponche</b></td>'
    + '<td bgcolor=#E6E6FA><b>Código Reloj</b></td>'
    + '<td bgcolor=#E6E6FA><b>Sucursal</b></td></tr>' ;

SET @Body = (
select 
    td =  h.cedula, ''
    , td = a.NOMBRE,''
    --,a.CEDULA
    , td = a.FECHA,''
    ,td = a.HORA, ''
    ,td = a.TIPO_PONCHE, ''
    ,td = a.COD_RELOJ, ''
    ,td = IsNull(c.descrip,'No Definido'), ''
 from [Genesis].[PonchesDB].[DatosReloj_Cargar] a
 left join [Genesis].[PonchesDB].[horarioEmpleados] h on h.cedula = a.CEDULA and a.FECHA = @fecha
 join [Genesis].[PonchesDB].[DescripcionHoratios] D on D.id = h.idTipoPonche 
  left Join [Genesis].[dbo].[clock] c on c.id = a.CLOCKID	
    where (a.HORA > D.entrada  and a.HORA < D.almuerzo )
                or a.HORA is null

 group by
    h.cedula 
    ,a.NOMBRE
    --,a.CEDULA
    ,a.FECHA
    ,a.HORA
    ,a.TIPO_PONCHE
    ,a.COD_RELOJ
    ,a.CLOCKID
    ,c.descrip
 order by fecha desc


            FOR   XML RAW('tr'),
                  ELEMENTS
            )

SELECT  @Body = @TableHead + ISNULL(@Body, '') + @TableTail

EXEC sp_send_dbmail 
  @profile_name='SqlMail',
  @copy_recipients ='jose.jimenez@INABIMA.GOB.DO',
  @recipients=  @email,  --'jose.jimenez@INABIMA.GOB.DO', --; ja.jimenezrosa@gmail.com',
  @subject='Query Result',
  @body=@Body ,
  @body_format = 'HTML' ;

  update [Genesis].[PonchesDB].[DatosReloj_Cargar] 
    set enviado = 2
    where fecha = @fecha
    AND HORA < '11:00:00'


end 
~~~
# 


# query Insertar datos reloj a soluflex<a name="queryinsertardatossoluflex25"></a>
# 


~~~sql

/*
=================================================================
*/

declare @fecha varchar(10) ;
declare @hora  varchar(10);
truncate table [Genesis].[PonchesDB].[DatosReloj_Cargar_temporal]

Insert into [Genesis].[PonchesDB].[DatosReloj_Cargar_temporal]
(
[NOMBRE]
      ,[CEDULA]
      ,[COD_RELOJ]
      ,[FECHA]
      ,[HORA]
      ,[CLOCKID]
      ,[TIPO_PONCHE]
)
SELECT  RTRIM(LTRIM(B.FIRSTNAME))+' '+ RTRIM(LTRIM(B.LASTNAME)) AS NOMBRE
      , REPLACE(USER1,'-','') AS CEDULA  
      ,badge COD_RELOJ, CAST(DATE AS DATE) AS FECHA
     , CAST(SUBSTRING(TIME,1,2)+':'+SUBSTRING(TIME,3,2)+':'+SUBSTRING(TIME,5,2) AS TIME) AS HORA
       , CLOCKID
       ,CASE WHEN   A.TIME BETWEEN '060000' AND '091000' THEN 'ENTRADA NORMAL'   
              WHEN   A.TIME BETWEEN '091000' AND '103000' THEN 'ENTRADA TARDE' 
              WHEN   A.TIME BETWEEN '110000' AND '150000' THEN 'ALMUERZO' 
              WHEN   A.TIME BETWEEN '160000' AND '230000' THEN 'SALIDA' ELSE  'NO AUTORIZADO' END TIPO_PONCHE
FROM [Genesis].[dbo].rawdata A RIGHT JOIN [Genesis].[dbo].employee B ON (B.EMPLNUM = A.badge)

set @fecha  =
(
select isNull(Fecha,'2017-01-01')  from  openquery( [SOLUFLEX RRHH],
'select  max(fecha) as fecha from datosreloj ')
)


set @hora  = 
(
select isNull(Hora,'00:00:00') from  openquery( [SOLUFLEX RRHH],
'select  max(hora) as Hora from datosreloj ')
)

/*
Registro de carga de datos desde Sql hacia soluflex.
alejandro JImenez 
2019-06-18

*/

Insert into openquery( [SOLUFLEX RRHH],
'select nombre, cedula, cod_reloj, fecha, hora,clockid,tipo_ponche from  datosreloj '
)

select 
a.[NOMBRE]
      ,a.[CEDULA]
      ,a.[COD_RELOJ]
      ,a.[FECHA]
      ,a.[HORA]
      ,a.[CLOCKID]
      ,a.[TIPO_PONCHE]

  from 
[Genesis].[PonchesDB].[DatosReloj_Cargar_temporal] a
left join 
(
select * from  openquery( [SOLUFLEX RRHH],
'select  * from datosreloj ') 
) b
 on 
 (
 a.NOMBRE = b.NOMBRE
 and a.CEDULA = b.CEDULA
 and a.COD_RELOJ = b.COD_RELOJ
 
 and a.FECHA = b.FECHA
 and a.HORA = b.HORA
 and a.CLOCKID = b.CLOCKID
 and a.TIPO_PONCHE = b.TIPO_PONCHE
 
 )
where b.NOMBRE is null and a.FECHA is not null
~~~
# 


# 
# Salida de ************ verificaciones<a name="geneissalidasinabiama"></a>
# 


~~~sql
/*
Query de los ponches de entrada fuera de Horario.
Alejandro Jimenez 2019-06-07
*/

declare @Mensaje varchar(1000);

declare @email varchar(500) = 
(

SELECT 
      [Email]
  FROM [AuditoriaDB].[dbo].[tblParametros]
  where id = 6
)


declare @fecha1 date

set @fecha1 =
(  select distinct top 1 min(fecha) As Fecha
--, enviado 
from [Genesis].[PonchesDB].[DatosReloj_Cargar]
where enviado = 0 AND HORA >  '14:00:00'
)


while exists (
select distinct top 1 fecha, enviado 
from [Genesis].[PonchesDB].[DatosReloj_Cargar]
where  (HORA <  '14:00:00' and fecha  = convert(Varchar(10),
 dateadd(DAY,1,@fecha1),120) )  --or @fecha1 is not null

)
begin

DECLARE @Body NVARCHAR(MAX),
    @TableHead VARCHAR(1000),
    @TableTail VARCHAR(1000)
    ,@dias int = 2
    ,@fecha varchar(10) 
    
    /*
    Asignar fecha a enviar al personal de resursos humanos
    Reporte de Eventos Salidas
    */
set @fecha = (
select distinct top 1 fecha from [Genesis].PonchesDB.[DatosReloj_Cargar]
where enviado < 2 AND HORA > '14:00:00'
order by fecha asc
)

SET @TableTail = '</table></body></html>' ;
SET @TableHead = '<html><head>' + '<style>'
    + 'td {border: solid black;border-width: 1px;
    padding-left:5px;padding-right:5px;padding-top:1px;
    padding-bottom:1px;font: 11px arial} '
    + '</style>' + '</head>' + '<body>' + '<h1>Reporte de Eventos Salidas : ' + @fecha +'  </h1> '
    + CONVERT(VARCHAR(50), GETDATE(), 100) 
    + ' <br> <table cellpadding=0 cellspacing=0 border=0>' 
    + '<tr> <td bgcolor=#E6E6FA><b>Cédula</b></td>'
    + '<td bgcolor=#E6E6FA><b>Nombres</b></td>'
    + '<td bgcolor=#E6E6FA><b>Fecha</b></td>'
    + '<td bgcolor=#ffffb3><b>Hora</b></td>'
    + '<td bgcolor=#E6E6FA><b>Tipo_ponche</b></td>'
    + '<td bgcolor=#E6E6FA><b>Código Reloj</b></td>'
    + '<td bgcolor=#E6E6FA><b>Sucursal</b></td></tr>' ;

SET @Body = (
select 
    td =  h.cedula, ''
    , td = a.NOMBRE,''
    , td = a.FECHA,''
    ,td = max(a.HORA), ''
    ,td = 'Salida', ''
    ,td = a.COD_RELOJ, ''
    ,td = IsNull(c.descrip,'No Definido'), ''
 from [Genesis].[PonchesDB].[DatosReloj_Cargar] a
 left join [Genesis].[PonchesDB].[horarioEmpleados] h on h.cedula = a.CEDULA and a.FECHA = @fecha
 join [Genesis].[PonchesDB].[DescripcionHoratios] D on D.id = h.idTipoPonche 
  left Join [Genesis].[dbo].[clock] c on c.id = a.CLOCKID	

   join 
  (
  
    select h.Cedula, Max(a.hora) horaSalida
from   [Genesis].[PonchesDB].[DatosReloj_Cargar] a
 left join [Genesis].[PonchesDB].[horarioEmpleados] h on h.cedula = a.CEDULA and a.FECHA = @fecha
 join [Genesis].[PonchesDB].[DescripcionHoratios] D on D.id = h.idTipoPonche 
        where hora >  D.regresoA
  group by h.cedula
  ) Sali on Sali.cedula = h.cedula and Sali.horaSalida = a.HORA
        where Sali.horaSalida < D.salida
 group by
    h.cedula 
    ,a.NOMBRE
    ,a.FECHA
    ,a.COD_RELOJ
    ,a.CLOCKID
    ,c.descrip
 order by a.NOMBRE 
            FOR   XML RAW('tr'),
                  ELEMENTS
            )

SELECT  @Body = @TableHead + ISNULL(@Body, '') + @TableTail

EXEC sp_send_dbmail 
  @profile_name='SqlMail',
  @copy_recipients ='jose.jimenez@INABIMA.GOB.DO',
  @recipients=  @email,  --'jose.jimenez@INABIMA.GOB.DO', --; ja.jimenezrosa@gmail.com',
  @subject='Reporte de Eventos Salidas :',
  @body=@Body ,
  @body_format = 'HTML' ;

  update [Genesis].[PonchesDB].[DatosReloj_Cargar] 
    set enviado = 2
    where fecha = @fecha
    AND HORA > '14:00:00'

    set @fecha1 = dateadd(DAY,1,@fecha1)


/*
====================================================================*/

/*
======================================================================
Inicio de bucles para envio de correos a los encargados de depto
Alejandro Jimenez Viernes 19 de Junio 2019
Reporte de Eventos Personas No Poncharon el:
================================================================
*/
declare @Correo varchar(100);

exec [Genesis].[dbo].[sp_EnviarCorreosDepto] @fecha

while exists(
select top 1 
   emailsupervisor
from
[genesis].[PonchesDB].[SupervisoresCorreos] 
Where  [activarEnvioCorreo]= 1
and enviado = 0
)
begin

set @Correo = 
(
        select top 1 
           [EMAILSUPERVISOR]
        from
        [genesis].[PonchesDB].[SupervisoresCorreos] 
            Where  [activarEnvioCorreo]= 1
                and enviado = 0
)
/*
============================================================================
*/
set @mensaje = ''
Set @Mensaje ='' + ( select distinct top 1 isnull(Depto,'')
 from [genesis].[PonchesDB].[SupervisoresCorreos] 
 where [EMAILSUPERVISOR]  = @Correo)
Set @Mensaje += '</br> SUPERVISOR: '+ ( select top 1 isnull([SUPERVISOR],'') 
from [genesis].[PonchesDB].[SupervisoresCorreos]
 where [EMAILSUPERVISOR]  = @Correo)
--print @correo

SET @TableTail = '</table></body></html>' ;
SET @TableHead = '<html><head>' + '<style>'
    + 'td {border: solid black;border-width: 1px;
    padding-left:5px;padding-right:5px;padding-top:1px;
    padding-bottom:1px;font: 11px arial} '
    + '</style>' + '</head>' + '<body>' + 
    '<h1>Reporte de Eventos Personas No Poncharon el: ' + @fecha +'  </h1> '
    + '<h4>' + @Mensaje+ '</h4>'
    + CONVERT(VARCHAR(50), GETDATE(), 100) 
    + ' <br> <table cellpadding=0 cellspacing=0 border=0>' 
    + '<tr> <td bgcolor=#E6E6FA><b>Cédula</b></td>'
    + '<td bgcolor=#E6E6FA><b>Nombres</b></td>'
    + '<td bgcolor=#E6E6FA><b>Fecha</b></td>'
    + '<td bgcolor=#ffffb3><b>Hora</b></td>'
    + '<td bgcolor=#E6E6FA><b>Tipo_ponche</b></td>'
    + '<td bgcolor=#E6E6FA><b>Código Reloj</b></td>'
    + '<td bgcolor=#E6E6FA><b>Sucursal</b></td></tr>' ;

SET @Body = (
select 
    td =  A.cedula, ''
    , td = Per.NOMBRE,''
    , td =isNull( B.FECHA,@fecha),''
    ,td = IsNull(B.HORA,'00:00:00' ), ''
    ,td = IsNull(B.TIPO_PONCHE,'No poncho' ), ''
    ,td = isNull(B.COD_RELOJ,''), ''
    ,td = 'No Definido', ''
    
from [Genesis].[PonchesDB].[horarioEmpleados] A
left join (
SELECT  RTRIM(LTRIM(B.FIRSTNAME))+' '+ RTRIM(LTRIM(B.LASTNAME)) AS NOMBRE
      , REPLACE(USER1,'-','') AS CEDULA  
      ,badge COD_RELOJ, CAST(DATE AS DATE) AS FECHA
     , CAST(SUBSTRING(TIME,1,2)+':'+SUBSTRING(TIME,3,2)+':'+SUBSTRING(TIME,5,2) AS TIME) AS HORA
       , CLOCKID
       ,CASE WHEN   A.TIME BETWEEN '060000' AND '091000' THEN 'ENTRADA NORMAL'   
              WHEN   A.TIME BETWEEN '091000' AND '103000' THEN 'ENTRADA TARDE' 
              WHEN   A.TIME BETWEEN '110000' AND '150000' THEN 'ALMUERZO' 
              WHEN   A.TIME BETWEEN '160000' AND '230000' THEN 'SALIDA' ELSE  'NO AUTORIZADO' END TIPO_PONCHE


FROM [Genesis].[dbo].rawdata A 
RIGHT 
--left
JOIN [Genesis].[dbo].employee B ON (B.EMPLNUM = A.badge) 
            where CAST(DATE AS DATE) = @fecha 
            and 
            SUBSTRING(TIME,1,2)+':'+SUBSTRING(TIME,3,2)+':'+SUBSTRING(TIME,5,2)  < '11:00:00'

)  	B ON A.cedula = b.CEDULA


 join [Genesis].[PonchesDB].[PersonalDB] Per
                on per.cedula2 = a.cedula

join 
 (
 
select * from [Genesis].[PonchesDB].[DescripcionHoratios] where  dias = DATENAME(weekday ,getdate()) and act = 1
 ) c on c.id = A.idTipoPonche

join  [genesis].[PonchesDB].[SupervisoresCorreos]  Sper 
            on Sper.[CEDULA_EMP] = a.cedula
                    and Sper.[EMAILSUPERVISOR] = @correo

    Where b.hora is null
            and REPLACE(A.cedula,'-','')  not in 
                (
                
                select Cedula
                    from  [Genesis].[PonchesDB].VacacionesRH
                    where  getdate() between fecha_Inicio and fecha_fin


                )


/*====================================================================*/
                and A.cedula not in 
                (
                
                select Cedula
                    from  [Genesis].[PonchesDB].VacacionesRH
                    where  getdate() between fecha_Inicio and fecha_fin


                )

 order by per.NOMBRE 

            FOR   XML RAW('tr'),
                  ELEMENTS
            )


SELECT  @Body = @TableHead + ISNULL(@Body, '') + @TableTail

--set @Correo = 'jose.jimenez@inabima.gob.do'

EXEC sp_send_dbmail 
  @profile_name='SqlMail',
  @copy_recipients ='jose.jimenez@INABIMA.GOB.DO',
  @recipients=  @correo,  --'jose.jimenez@INABIMA.GOB.DO', --; ja.jimenezrosa@gmail.com',
  @subject='Reporte de entradas Tardias.',
  @body=@Body ,
  @body_format = 'HTML' ;


  update [genesis].[PonchesDB].[SupervisoresCorreos] 
    set enviado = 1 
        Where  [activarEnvioCorreo]= 1
        and enviado = 0
        and [EMAILSUPERVISOR] = @correo
  end

    update [Genesis].[PonchesDB].[DatosReloj_Cargar] 
    set enviado = 2
    where fecha = @fecha
    AND HORA < '11:00:00'
/*
envios de Correos personas que no poncharon salidas en el dia
===========================================================================
*/
SET @TableTail = '</table></body></html>' ;
SET @TableHead = '<html><head>' + '<style>'
    + 'td {border: solid black;border-width: 1px;
    padding-left:5px;padding-right:5px;padding-top:1px;
    padding-bottom:1px;font: 11px arial} '
    + '</style>' + '</head>' + '<body>' + 
    '<h1>Reporte de Eventos Personas No Poncharon el: ' + @fecha +'  </h1> '
    + CONVERT(VARCHAR(50), GETDATE(), 100) 
    + ' <br> <table cellpadding=0 cellspacing=0 border=0>' 
    + '<tr> <td bgcolor=#E6E6FA><b>Cédula</b></td>'
    + '<td bgcolor=#E6E6FA><b>Nombres</b></td>'
    + '<td bgcolor=#E6E6FA><b>Fecha</b></td>'
    + '<td bgcolor=#ffffb3><b>Hora</b></td>'
    + '<td bgcolor=#E6E6FA><b>Tipo_ponche</b></td>'
    + '<td bgcolor=#E6E6FA><b>Código Reloj</b></td>'
    + '<td bgcolor=#E6E6FA><b>Sucursal</b></td></tr>' ;

SET @Body = (
select 

    td =  A.cedula, ''
    , td = Per.NOMBRE,''
    --,a.CEDULA
    , td =isNull( B.FECHA,@fecha),''
    ,td = IsNull(B.HORA,'00:00:00' ), ''
    ,td = IsNull(B.TIPO_PONCHE,'No poncho' ), ''
    ,td = isNull(B.COD_RELOJ,''), ''
    ,td = 'No Definido', ''
    
from [Genesis].[PonchesDB].[horarioEmpleados] A

left join (
SELECT  RTRIM(LTRIM(B.FIRSTNAME))+' '+ RTRIM(LTRIM(B.LASTNAME)) AS NOMBRE
      , REPLACE(USER1,'-','') AS CEDULA  
      ,badge COD_RELOJ, CAST(DATE AS DATE) AS FECHA
     , CAST(SUBSTRING(TIME,1,2)+':'+SUBSTRING(TIME,3,2)+':'+SUBSTRING(TIME,5,2) AS TIME) AS HORA
       , CLOCKID
       ,CASE WHEN   A.TIME BETWEEN '060000' AND '091000' THEN 'ENTRADA NORMAL'   
              WHEN   A.TIME BETWEEN '091000' AND '103000' THEN 'ENTRADA TARDE' 
              WHEN   A.TIME BETWEEN '110000' AND '150000' THEN 'ALMUERZO' 
              WHEN   A.TIME BETWEEN '160000' AND '230000' THEN 'SALIDA' ELSE  'NO AUTORIZADO' END TIPO_PONCHE


FROM [Genesis].[dbo].rawdata A 
RIGHT 
--left
JOIN [Genesis].[dbo].employee B ON (B.EMPLNUM = A.badge) 
            where CAST(DATE AS DATE) = @fecha 
            and 
            SUBSTRING(TIME,1,2)+':'+SUBSTRING(TIME,3,2)+':'+SUBSTRING(TIME,5,2)  < '11:00:00'

)  	B ON A.cedula = b.CEDULA


 join [Genesis].[PonchesDB].[PersonalDB] Per
                on per.cedula2 = a.cedula

join 
 (
 
select * from [Genesis].[PonchesDB].[DescripcionHoratios] where  dias = DATENAME(weekday ,getdate()) and act = 1
 ) c on c.id = A.idTipoPonche

    Where b.hora is null
            and REPLACE(A.cedula,'-','')  not in 
                (
                
                select Cedula
                    from  [Genesis].[PonchesDB].VacacionesRH
                    where  getdate() between fecha_Inicio and fecha_fin

                )

 order by per.NOMBRE 


            FOR   XML RAW('tr'),
                  ELEMENTS
            )

SELECT  @Body = @TableHead + ISNULL(@Body, '') + @TableTail

EXEC sp_send_dbmail 
  @profile_name='SqlMail',
  @copy_recipients ='',
  @recipients=  @email,  --'jose.jimenez@INABIMA.GOB.DO', --; ja.jimenezrosa@gmail.com',
  @subject='Query Result',
  @body=@Body ,
  @body_format = 'HTML' ;

    /*=====================================================================*/

    while exists(
select top 1 
   emailsupervisor
from
[genesis].[PonchesDB].[SupervisoresCorreos] 
Where  [activarEnvioCorreo]= 1
and enviado = 0
)
begin

set @Correo = 
(
        select top 1 
           [EMAILSUPERVISOR]
        from
        [genesis].[PonchesDB].[SupervisoresCorreos] 
            Where  [activarEnvioCorreo]= 1
                and enviado = 0
)
/*reporte personas no salidas
===========================================================================
*/
set @mensaje = ''
Set @Mensaje ='' + ( select distinct top 1 isnull(Depto,'') 
from [genesis].[PonchesDB].[SupervisoresCorreos]
 where [EMAILSUPERVISOR]  = @Correo)
Set @Mensaje += '</br> SUPERVISOR: '+ ( select top 1 isnull([SUPERVISOR],'') 
from [genesis].[PonchesDB].[SupervisoresCorreos] where [EMAILSUPERVISOR]  = @Correo)
--print @correo

SET @TableTail = '</table></body></html>' ;
SET @TableHead = '<html><head>' + '<style>'
    + 'td {border: solid black;border-width: 1px;
    padding-left:5px;padding-right:5px;padding-top:1px;
    padding-bottom:1px;font: 11px arial} '
    + '</style>' + '</head>' + '<body>' + 
    '<h1>Reporte de Eventos Salidas : ' + @fecha +'  </h1> '
    + '<h4>' + @Mensaje+ '</h4>'
    + CONVERT(VARCHAR(50), GETDATE(), 100) 
    + ' <br> <table cellpadding=0 cellspacing=0 border=0>' 
    + '<tr> <td bgcolor=#E6E6FA><b>Cédula</b></td>'
    + '<td bgcolor=#E6E6FA><b>Nombres</b></td>'
    + '<td bgcolor=#E6E6FA><b>Fecha</b></td>'
    + '<td bgcolor=#ffffb3><b>Hora</b></td>'
    + '<td bgcolor=#E6E6FA><b>Tipo_ponche</b></td>'
    + '<td bgcolor=#E6E6FA><b>Código Reloj</b></td>'
    + '<td bgcolor=#E6E6FA><b>Sucursal</b></td></tr>' ;

SET @Body = (
select 
    td =  A.cedula, ''
    , td = a.NOMBRE,''
    , td =isNull( a.FECHA,@fecha),''
    ,td = IsNull(a.HORA,'00:00:00' ), ''
    ,td = IsNull(a.TIPO_PONCHE,'No poncho' ), ''
    ,td = isNull(a.COD_RELOJ,''), ''
    ,td = 'No Definido', ''
    
 from [Genesis].[PonchesDB].[DatosReloj_Cargar] a
 left join [Genesis].[PonchesDB].[horarioEmpleados] h on h.cedula = a.CEDULA and a.FECHA = @fecha
 join [Genesis].[PonchesDB].[DescripcionHoratios] D on D.id = h.idTipoPonche 
  left Join [Genesis].[dbo].[clock] c on c.id = a.CLOCKID	

   join 
  (
  
    select h.Cedula, Max(a.hora) horaSalida
from   [Genesis].[PonchesDB].[DatosReloj_Cargar] a
 left join [Genesis].[PonchesDB].[horarioEmpleados] h on h.cedula = a.CEDULA and a.FECHA = @fecha
 join [Genesis].[PonchesDB].[DescripcionHoratios] D on D.id = h.idTipoPonche 
        where hora >  D.regresoA
  group by h.cedula
  ) Sali on Sali.cedula = h.cedula and Sali.horaSalida = a.HORA

        where Sali.horaSalida < D.salida
                    and REPLACE(A.cedula,'-','')  not in 
                (
                
                select Cedula
                    from  [Genesis].[PonchesDB].VacacionesRH
                    where  getdate() between fecha_Inicio and fecha_fin
                )

 order by a.NOMBRE 

            FOR   XML RAW('tr'),
                  ELEMENTS
            )


SELECT  @Body = @TableHead + ISNULL(@Body, '') + @TableTail


EXEC sp_send_dbmail 
  @profile_name='SqlMail',
  @copy_recipients ='jose.jimenez@INABIMA.GOB.DO',
  @recipients=  @correo,  --'jose.jimenez@INABIMA.GOB.DO', --; ja.jimenezrosa@gmail.com',
  @subject='Reporte de entradas Tardias.',
  @body=@Body ,
  @body_format = 'HTML' ;



  update [genesis].[PonchesDB].[SupervisoresCorreos] 
    set enviado = 1 
        Where  [activarEnvioCorreo]= 1
        and enviado = 0
        and [EMAILSUPERVISOR] = @correo
  end

    /*======================================================================*/

end 
~~~
# 


# 
# Ejecucion de procedure de soluflex que cargar los datos del reporte de Ponches<a name="procedurecargadatossoluflex"></a>
![](https://static.wixstatic.com/media/7fcb76_c2e0a583d06547cfa053a3a237edfc4c~mv2.png/v1/fill/w_618,h_160,al_c,q_85,usm_0.66_1.00_0.01/Logo_Soluflex_FINAL_2.webp)

#### La ejecucion de este procedure al momento de realizar esta documentacion fue para cargar los datos del reloj de ponches correspondientes al periodo Marzo 1 al Marzo 31 del 2021

## Para esto Ejecutamos lo siguiente.
# 


~~~sql
declare @fecha varchar(10)

select @fecha from
openquery( [SOLUFLEX RRHH], N'EXECUTE PROCEDURE
 SPA_ACTUALIZA_PONCHESRELOJ ( ''2021-03-01'' , ''2021-03-31'')')
~~~
# 





### Ademas tenemos el procedimiento original el cual es utilizado para cargar los ponches de  reloj a partir de la ultima fecha de carga de ponches.
# 


~~~sql
declare @fecha varchar(10)

select @fecha from
openquery( [SOLUFLEX RRHH], N'EXECUTE PROCEDURE 
SPA_ACTUALIZA_PONCHESRELOJ ( (select Max(fecha_ponche)+1 from 
ta_ponchesReloj) ,current_date-2)')

~~~
# 







# Sincronizar datos tabla TA_ponchesreloj con datos de sql server<a name="ta_ponchesrelojjob"></a>

#### Para cargar los datos del informe de ponches creado por el Sr. Jorge Villalona, se procederá a crear un proceso de sincronización de datos entre los registros de tomados de Soluflex y la base de datos Sql.
![](https://www.tecnologia-informatica.com/wp-content/uploads/2018/09/que-es-sincronizacion-1-2.jpeg)

# 


~~~sql

/*
Alejandro Jimenez 
Jueves 21 de Abril del 2022
Sincronizando datos de poches soluflex para las tablas de Sql server Genesis
ta-pochesreloj  para los reportes del sr Jorge Villalona
*/

insert into TA_PONCHESRELOJ
select * from
openquery( [SOLUFLEX RRHH], N'Select * from TA_PONCHESRELOJ')
--WHERE FECHA_PONCHE = '2020-02-04'
    WHERE NOT EXISTS
    (
        SELECT * FROM TA_PONCHESRELOJ
    )


~~~
# 



#### Vamos a construir un job de servidor Sql usando este código.
#### El job se ejecutará cada 10 minutos para sincronizar los datos de la base de datos soluflex con las bases de datos del servidor sql.

# 



# Query para la Sincronizacion de los empleados de soluflex con el Reloj.<a name="17.7"></a>

#### Porque las licencias del reloj de control de asistencias expiraron. Nos encontramos en la necesidad de realizar cargas manuales a las Bases de Datos del nuevo personal.

#### Decidimos crear una consulta a partir de la base de datos soluflex e insertarla en la base de datos de genesis.

#### Nos permitirá obtener los nuevos empleados de la base de datos de Recursos Humanos. Por tanto, no será necesario insertar nuevos empleados en de Db.
# 



~~~sql

USE [Genesis]
GO


TRUNCATE TABLE [PonchesDB].[SupervisoresCorreos]
GO

SELECT [id]
      ,[NOMBRE]
      ,[CEDULA_EMP]
      ,[SUPERVISOR]
      ,[EMAILSUPERVISOR]
      ,[DEPTO]
      ,[DIVISION]
      ,[activarEnvioCorreo]
      ,[enviado]
      ,[CorreoResguardado]
      ,[depto1]
      ,[emailsupervisor_bk]
  FROM [PonchesDB].[SupervisoresCorreos]
GO



INSERT INTO [PonchesDB].[SupervisoresCorreos]
select
CONVERT(INT,cODEMP)
--0 id
,Nombre
,REPLACE(cedula,'-','')
,supervisor
,Emailsupervisor
,Depto
,Division
,1
,0
,EMAILSUPERVISOR
,Depto
,Emailsupervisor
 from  openquery( [SOLUFLEX RRHH],
'select * from spa_empleados')
WHERE ESTATUS = 'A'
GO



~~~
# 


#### Este código sería parte de un código mucho más grande que describiremos a continuación, debe ejecutarse en un trabajo todos los días a las 6:00 a.m.
#### para asegurarnos de que nuestros datos estén sincronizados
# 


~~~sql

USE [Genesis]
GO

insert into  [Genesis].[PonchesDB].[DescripcionHoratios]
(
    id 
    ,dias
    ,entrada
    ,almuerzo
    ,regresoA
    ,Salida
    ,act
)
SELECT id 
, dias 
, entrada
,'11:30:00','15:30:00'
, salida
, act
 from  openquery( [SOLUFLEX RRHH],
'select * from descripcionhorarios')
--WHERE ESTATUS = 'A'
go

select * from 
[Genesis].[PonchesDB].[DescripcionHoratios]

TRUNCATE TABLE [PonchesDB].[SupervisoresCorreos]
GO

SELECT [id]
      ,[NOMBRE]
      ,[CEDULA_EMP]
      ,[SUPERVISOR]
      ,[EMAILSUPERVISOR]
      ,[DEPTO]
      ,[DIVISION]
      ,[activarEnvioCorreo]
      ,[enviado]
      ,[CorreoResguardado]
      ,[depto1]
      ,[emailsupervisor_bk]
  FROM [PonchesDB].[SupervisoresCorreos]
GO

INSERT INTO [PonchesDB].[SupervisoresCorreos]
select
CONVERT(INT,cODEMP)
--0 id
,Nombre
,REPLACE(cedula,'-','')
,supervisor
,Emailsupervisor
,Depto
,Division
,1
,0
,EMAILSUPERVISOR
,Depto
,Emailsupervisor
 from  openquery( [SOLUFLEX RRHH],
'select * from spa_empleados')
WHERE ESTATUS = 'A'
GO

SELECT [id]
      ,[NOMBRE]
      ,[CEDULA_EMP]
      ,[SUPERVISOR]
      ,[EMAILSUPERVISOR]
      ,[DEPTO]
      ,[DIVISION]
      ,[activarEnvioCorreo]
      ,[enviado]
      ,[CorreoResguardado]
      ,[depto1]
      ,[emailsupervisor_bk]
  FROM [PonchesDB].[SupervisoresCorreos]
  --WHERE EMAILSUPERVISOR = 'ruben.estrella@inabima.gob.do'
GO



insert into [PonchesDB].[horarioEmpleadosBks]
(
    cedula
    ,idTipoPonche
    ,fechaInicio
    ,fechaFinal
    ,estatus
)
SELECT a.cedula, a.idTipoPonche,a.fechaInicio,a.fechaFinal ,a.estatus FROM 
[PonchesDB].[horarioEmpleados] a
join 
(
SELECT 
HORARIOID
,HORARIO
,REPLACE(cedula,'-','') CEDULA
,NOMBRE
 from  openquery( [SOLUFLEX RRHH],
'select * from spa_empleados')
WHERE ESTATUS = 'A'
) b
   on a.cedula = b.CEDULA and a.idTipoPonche != b.horarioID
ORDER BY CEDULA, fechaInicio




UPDATE a

SET  idTipoPonche = b.horarioID
        ,a.fechaInicio = convert(varchar(10),getdate(),120)

from  [PonchesDB].[horarioEmpleados] a,
(
SELECT 
HORARIOID
,HORARIO
,REPLACE(cedula,'-','') CEDULA
,NOMBRE
 from  openquery( [SOLUFLEX RRHH],
'select * from spa_empleados')
WHERE ESTATUS = 'A'
)
b
where a.cedula = b.CEDULA and a.idTipoPonche != b.horarioID

~~~
# 



# Sincronizar Vacaciones

### primera parte carga de vacaciones
# 


~~~sql

declare @tabla table
(
id varchar(10)
, fechaInicio varchar(10)
,fechaFinal varchar(10)
,cedula varchar(13)
)


insert into @tabla
select * from openquery( [SOLUFLEX RRHH],
'select a.id,a.fechaefec, a.fechaf, e.cedula
   from accperemp a left join empleados e on (e.codigo=a.codemp) where codaccper in ( ''007'',''011'') 
    and fecha>''2019-01-01'' 
    and e.cedula is not null 
    and a.aplicado=''T''
   order by a.id desc'
)





insert into [PonchesDB].[VacacionesRH]
(
    [idSoluflex]
    ,[Fecha_Inicio]
      ,[Fecha_Fin]
      ,[Cedula]
)
select * from @tabla
Where id >
(
select  Max(isnull(idSoluflex,0))
from [PonchesDB].[VacacionesRH]
)

~~~

### Segunda parte Cargar Vacaciones soluflex.

# 


~~~sql
USE [Genesis]
GO
/****** Object:  StoredProcedure [dbo].[sp_Sincronizar_Soluflex_VacacionesPermisos]   

 Script Date: 13/07/2021 10:15:10 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER Procedure [dbo].[sp_Sincronizar_Soluflex_VacacionesPermisos]
as
truncate table  [PonchesDB].[VacacionesRH]



insert into  [PonchesDB].[VacacionesRH]
(
    Fecha_Inicio
    ,Fecha_Fin
    ,Fecha_a_Trabajar
    ,Cedula
    ,Nombre
    ,Departamento
    ,Localidad
    ,idSoluflex
)
select FECHAi,FECHAF,fecha_trabajo,replace(cedula,'-',''),NOMBRE,

DEPARTAMENTO,SUCURSAL,nUMERO  
from  openquery( [SOLUFLEX RRHH],
'select * from spa_licenciasponches')

~~~
# 


# 

## Jobs Colocados en Disbles Utilizados por Soluflex<a name="soluflexjobdisable"></a>
    Ponches Soluflex
    Limpiar tablas de supervisores para envios
    DatosDelReloj
    DatosDelReloj_CargaVacaciones
    DatosDelReloj_Sinc_Empleados
#### Estos procesos del servidor Sql de las tablas de Génesis utilizadas para los golpes no funcionan.
#### Esto se debe a que esta base de datos ya no está en servicio.







# 

# Notificar cambios en el padron Electoral<a name="notificarcambios2"></a>
#
![](https://www.diariolibre.com/binrepository/546x292/0c0/0d0/none/10904/BKBP/image-content-5565560-20150923132934_14617159_20200821143255.jpg)
# 

~~~sql
/****** Object:  StoredProcedure [dbo].[sp_ModificacionesPadron]    Script Date: 04/11/2020 08:36:21 a.m. ******/
--USE [AuditoriaDB]
--GO


/*
NOTIFICACION
de los registros modificados en el padron
usando  html y sql

 Alejandro Jimenez 
 2019-10-20
*/

if exists
(
SELECT 'CEDULA: '+ a.[CEDULA] 
, a.[NOMBRES] 
,a.[APELLIDO1]
, a.[APELLIDO2]
,a.[ComputerName] 
--,b.pc
,b.[usuario]
,b.[Comentario]
--, [username] 
,CONVERT(VARCHAR(20), [FechaRegistroAudi],120) As Fecha_Reg
 FROM [AuditoriaDB].[dbo].[CEDULADOS_Audit] a
 left join  [AuditoriaDB].[dbo].[Pc_Usuario_Inabima] b  on (ltrim( A.ComputerName) = ltrim( b.Pc))

 WHERE ENVIADO IS NULL
)
begin

declare  @ModificacionesPadron  table
(
    Cedula varchar(30)
    ,Nombres varchar(30)
    ,apellido1 varchar(20)
    ,apellido2 Varchar(20)
    ,Computador varchar(20)
    ,usuario varchar(30)
    ,Comentario varchar(100)
    ,Fecha varchar(30)
    
      )



insert into @ModificacionesPadron

SELECT 'CEDULA: '+ a.[CEDULA] 
, a.[NOMBRES] 
,a.[APELLIDO1]
, a.[APELLIDO2]
,a.[ComputerName] 
--,b.pc
,b.[usuario]
,b.[Comentario]
--, [username] 
,CONVERT(VARCHAR(20), [FechaRegistroAudi],120) As Fecha_Reg
 FROM [AuditoriaDB].[dbo].[CEDULADOS_Audit] a
 left join  [AuditoriaDB].[dbo].[Pc_Usuario_Inabima] b  on (ltrim( A.ComputerName) = ltrim( b.Pc))

 WHERE ENVIADO IS NULL


 update [AuditoriaDB].[dbo].[CEDULADOS_Audit] 
        set ENVIADO = 1 
        where ENVIADO is null



declare @email varchar(1000) =
( select email from [AuditoriaDB].[dbo].[tblParametros] where id = 3)



DECLARE @Body NVARCHAR(MAX),
    @TableHead VARCHAR(1000),
    @TableTail VARCHAR(1000)
    --,@dias int = 2
    ,@fecha varchar(10) = convert(varchar(10), getdate(),120)



SET @TableTail = '</table></body></html>' ;
SET @TableHead = '<html><head>' + '<style>'
    + 'td {border: solid black;border-width: 1px;
    padding-left:5px;padding-right:5px;padding-top:1px;
    padding-bottom:1px;font: 11px arial} '
    + '</style>' + '</head>' + '<body>' + 
    '<h1>Reporte de Registros Modificados en el Padron dia : ' + @fecha +'  </h1> '
    + '<b>Modificaciones al Padron Electroral del INABIMA</b>' 
    --+ '<b> no Comprendidos entre las 7:00 AM y 18:00 PM </b>'
    --+'<b>(No contempla los usuarios de transdoc...) </b>'
    --+'<br>'
    + '<br><b>Fecha y hora de envio: </b>'+ CONVERT(VARCHAR(50), GETDATE(), 100) 
    + ' <br> <table cellpadding=0 cellspacing=0 border=0>' 

    + '<tr> <td bgcolor=#E6E6FA><b>Cedula</b></td>'
    + '<td bgcolor=#E6E6FA><b>Nombres</b></td>'
    + '<td bgcolor=#E6E6FA><b>Apellido1</b></td>'
    + '<td bgcolor=#ffffb3><b>Apellido2</b></td>'
    + '<td bgcolor=#E6E6FA><b>Computadora</b></td>'
    + '<td bgcolor=#E6E6FA><b>Usuario</b></td>'
    + '<td bgcolor=#E6E6FA><b>Comentario</b></td>'
    + '<td bgcolor=#E6E6FA><b>Fecha</b></td></tr>' ;

SET @Body = (

SELECT --[session_id]
    td =Cedula  , '',
    td = Nombres ,'',
    td = apellido1,'',
    td = apellido2 ,'',
    td = Computador ,'',
    td = isNull(usuario,'') ,'',
    td = isnull(Comentario,'') ,'',
    td = Fecha ,''
  FROM @ModificacionesPadron
  order by Fecha desc

  
            FOR   XML RAW('tr'),
                  ELEMENTS
            )



SELECT  @Body = @TableHead + ISNULL(@Body, '') + @TableTail

/*
Enviar Correo electronico 
alejandro Jimenez 
2019-11-20 
*/

EXEC sp_send_dbmail 
  @profile_name='SqlMail',
  @copy_recipients ='jose.jimenez@INABIMA.GOB.DO',
  @recipients=  @email,  --'jose.jimenez@INABIMA.GOB.DO', --; ja.jimenezrosa@gmail.com',
  @subject='Reporte de Registros Modificados en el padrón del INABIMA.',
  @body=@Body ,
  @body_format = 'HTML' ;


end
~~~
# 



# Consulta para enviar por correo de e-Flow citas<a name="consultaseflowcitas"></a>
![](https://gdm-catalog-fmapi-prod.imgix.net/ProductScreenshot/a6161d80-6b28-4106-9fe3-970967401140.png?w=600&h=450&fit=fill&fill=blur&auto=format&q=50)
#### Crearemos una consulta de las Citas del Sistema **E-FLOW** para ser enviadas via Correo electronico al personal de servicio al Cliente tanto de Plaza Aurora como de la CEDE CENTRAL.

#### Inicialmente la idea es que esta consulta se envíe de lunes a viernes a las 3:00 p.m., en lo que estamos en pruebas, que me llegue a mí, luego incluimos al personal de atención al usuario de Plaza Aurora, yo te suministraría los correos a los que esto debe llegar.

#### El servidor está en el 10.0.0.168 es un SQL Express Edition, por teléfono te informo de las credenciales de acceso.
#

#### Esta solicitud de información fue realizada originalmente por el Sr. Teodoro Mejía quien está coordinando la parte de atención al usuario en plaza aurora. Lamentablemente el sistema que se utiliza para citas no provee esta información, no de esta forma, por lo que tuvimos que recurrir a hacerla directa desde las bases de datos.
# 
#### procederemoa a realizar un procedure que inserte los datos en el Servidor de produccion desde el servidor de E-FLOW.
# 


~~~SQL
ALTER procedure sp_enviarCitasSedna
as
/*Eliminamos los registros en caso de que el proceso 
se ejecute varias veces */
delete  [10.0.0.252].[AuditoriaDB].[dbo].[notificacionSEDNA] 
where convert(varchar(10), fechaHoraCita, 120)
 = convert(varchar(10), getdate()+1, 120)

/*
Alejandro JImenez 
2021.4.15
Insertamos los datos en el servidor sql de produccion

esto para poder realizar el envio de los datos desde el 

servidor Mail de Sql server.
*/
INSERT INTO [10.0.0.252].[AuditoriaDB].[dbo].[notificacionSEDNA]
           ([NumeroDocumento]
           ,[Nombres]
           ,[Apellidos]
           ,[FechaHoraCita]
           ,[CodigoCita]
           ,[Servicio]
           ,[CreadaPor])
select dac.ClientDocumentNumber as NumeroDocumento,
       UPPER(dac.ClientName) as Nombres,
       UPPER(dac.ClientLastName) as Apellidos,
       da.AppointmentDate as FechaHoraCita,
       da.AppointmentCode as CodigoCita,
       ds.[Description] as Servicio,
       UPPER(da.UserCode) CreadaPor
     --Into [10.0.0.252].[AuditoriaDB].[dbo].[notificacionSEDNA]
  from dbo.Appointment da
  left join dbo.AppointmentClient dac
    on ( da.AppointmentClientId = dac.AppointmentClientId )
  left join dbo.AppointmentByService das
    on ( da.AppointmentId = das.AppointmentId )
  left join dbo.[Service] ds
    on ( das.ServiceId = ds.ServiceId )
 where CAST(AppointmentDate as DATE) = CAST(GETDATE() + 1 as DATE)
 order by AppointmentDate asc;

 --Activar envio de correo via sqlmail
--esto hace que se dispare un Tregger para que reporte sea enviado 

insert into  [10.0.0.252].[AuditoriaDB].[dbo].[enviarSEDNA]
select fecha = convert(varchar(10), getdate(),120)
        , enviar = 1

go
~~~
# 


#### Como se podra notar para que esto funcione debemos tener un LinkServer hacia el servidor 10.0.0.252 que seria en este caso el servidor de produccion.

#### Esto me permitira de una forma indirecta utilizar los recursos de **Servidor de Correos Sql** de este servidor.

***La Cuestion de la falta de Servicios de Job en el Servidor de E-FLOW lo veremos mas adelante.***


### Creacion de Store Procedure que Envia las notificaciones de las citas via SqlMail.

# 


~~~sql

/*
NOTIFICACION
de los Datos del Servidor SEDNA.

 Alejandro Jimenez 
 2021.4.15
*/

alter procedure sp_EnviarCitasSEDNA
AS
if exists
(
 SELECT * from AuditoriaDB.dbo.enviarSEDNA WHERE enviar = 1 and fecha= convert(varchar(10),Getdate(), 120)
)
begin

-- en este lugar colocaremos una lista que se encuentra en una 
tabla creado para estos fines.
--   dicha lista de correos debera ser consumida por el sql y 
asi podremos actualizarla a gusto sin tener que modificar el codigo.
declare @email varchar(1000) = 'jose.jimenez@inabima.gob.do'
-- ============================================================================================
DECLARE @Body NVARCHAR(MAX),
    @TableHead VARCHAR(1000),
    @TableTail VARCHAR(1000)
    --,@dias int = 2
    ,@fecha varchar(10) = convert(varchar(10), getdate()+1,120)

SET @TableTail = '</table></body></html>' ;
SET @TableHead = '<html><head>' + '<style>'
    + 'td {border: solid black;border-width: 1px;
    padding-left:5px;padding-right:5px;padding-top:1px;
    padding-bottom:1px;font: 11px arial} '
    + '</style>' + '</head>' + '<body>' +
     '<h1>Consulta para enviar por correo de e-Flow citas: ' + @fecha +'  </h1> '
    + '<b>Registros de citas de e-Flow</b>' 
    + '<br><b>Fecha y hora de envio: </b>'+ CONVERT(VARCHAR(50), GETDATE()+1, 100) 
    + ' <br> <table cellpadding=0 cellspacing=0 border=0>' 
    + '<tr> <td bgcolor=#E6E6FA><b>NumeroDocumento</b></td>'
    + '<td bgcolor=#E6E6FA><b>Nombres</b></td>'
    + '<td bgcolor=#E6E6FA><b>Apellidos</b></td>'
    + '<td bgcolor=#ffffb3><b>FechaHoraCita</b></td>'
    + '<td bgcolor=#E6E6FA><b>CódigoCita</b></td>'
    + '<td bgcolor=#E6E6FA><b>Servicio</b></td>'
    + '<td bgcolor=#E6E6FA><b>CreadoPor</b></td></tr>' ;

SET @Body = (

SELECT td=[NumeroDocumento] ,''
      ,td=[Nombres] ,''
      ,td=[Apellidos] ,''
      ,td=[FechaHoraCita] ,''
      ,td=[CodigoCita] ,''
      ,td=[Servicio] ,''
      ,td=[CreadaPor] ,''
  FROM [AuditoriaDB].[dbo].[notificacionSEDNA]
 
    Where convert(varchar(10), fechaHoraCita, 120) = convert(varchar(10), getdate()+1, 120)
 order by [FechaHoraCita] desc

            FOR   XML RAW('tr'),
                  ELEMENTS
            )



SELECT  @Body = @TableHead + ISNULL(@Body, '') + @TableTail

-- Envio por correo Electronico utilizando el servidor SqlMail
EXEC sp_send_dbmail 
  @profile_name='SqlMail',
  @copy_recipients ='jose.jimenez@INABIMA.GOB.DO',
  @recipients=  @email,  
  @subject='Citas E-flow',
  @body=@Body ,
  @body_format = 'HTML' ;



-- Realizamos la Catulizacion de la tabla  AuditoriaDB.dbo.enviarSEDNA
-- con la misma controlamos que este envio no se realice nuevamente por error.

update AuditoriaDB.dbo.enviarSEDNA
    set enviar = 0;

end
~~~
# 



para disparar este store procedure lo haremos a travez del siguiente codigo.
el mismo se colocar en el servidor de produccion en la tabla **[enviarSEDNA]** 
# 

~~~sql
-- the definition of the function.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alejandro Jimenez
-- Create date: 2021.04.15
-- Description:	Tabla de control para los envios de correos electronicos de las citas del E-FLOW
-- =============================================
CREATE TRIGGER enviarCorreosSedna on dbo.enviarSEDNA
FOR INSERT
as
EXEC msdb.dbo.sp_EnviarCitasSEDNA
GO
~~~
# 



## Disparar una Tarea Automatica del servidor 10.0.0.168 **(Sql Express no tinene Ni job ni sql Mail)**
# 
![](https://img.freepik.com/vector-premium/icono-lampara-idea-glifo-linea-contorno-relleno-version-colorida-contorno-bombilla-abstracto-relleno_662353-164.jpg)
# 

#### Para estos propósitos podemos crear una conexión al servidor SQL usando los comandos cmd.

#### Crearemos una conexión y dispararemos un procedimiento que se encuentra en las bases de datos de E-flow.

#### El código SQL que tenemos en nuestros servidores hará el resto.

#### Luego solo tenemos que crear una tarea programada de Windows Server 2016 para este caso y dispararla en los períodos que queramos.

# 


~~~cmd
@ECHO OFF
ECHO ----------------------------------------------------------------------------
ECHO Insertando datos para Ser Enviados proceso E-FLOW
ECHO Fecha: 2021.4.15
ECHO Alejandro Jimenez
ECHO ----------------------------------------------------------------------------

CLS
Sqlcmd -S SEDNA\SQLEXPRESS -d Appointment -U sa -P sa -Q "sp_enviarCitasSedna"
Sqlcmd.close()
CLS
@EXIT
ECHO successfully finished....
ECHO exit /b 0
~~~
# 


Este codigo realiza la conexion al Servidor y dispara el procedure que queremos para este caso.

# 

# Reporte de Variacion Espacio en Disco K:\ <a name="reporteespacioendiscok"></a>
![](https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSCo4xsDe7NTcu8R6Gb6gIVsz9nziuLA6D6Aw&usqp=CAU)


### este reporte nos muestra el espacio disponible en el disco de en el cual se ecuentra la base de datos TRANSDOC.

# 


~~~sql
declare @email varchar(1000) = 
( select email from [AuditoriaDB].[dbo].[tblParametros] where id = 8)



DECLARE @Body NVARCHAR(MAX),
    @TableHead VARCHAR(1000),
    @TableTail VARCHAR(1000)
    --,@dias int = 2
    ,@fecha varchar(10) = convert(varchar(10), getdate(),120)



SET @TableTail = '</table></body></html>' ;
SET @TableHead = '<html><head>' + '<style>'
    + 'td {border: solid black;border-width: 1px;
    padding-left:5px;padding-right:5px;padding-top:1px;
    padding-bottom:1px;font: 11px arial} '
    + '</style>' + '</head>' + '<body>' + 
    '<h1>Reporte de Variacion Espacio en Disco K:\ Servidor 10.0.0.252 de fecha : ' + @fecha +'  </h1> '
    + '<b>Variaciones de Espacio en disco K:\ Servidor 10.0.0.252</b>' 
    --+ '<b> no Comprendidos entre las 7:00 AM y 18:00 PM </b>'
    --+'<b>(No contempla los usuarios de transdoc...) </b>'
    --+'<br>'
    + '<br><b>Fecha y hora de envio: </b>'+ CONVERT(VARCHAR(50), GETDATE(), 100) 
    + ' <br> <table cellpadding=0 cellspacing=0 border=0>' 

    + '<tr> <td bgcolor=#E6E6FA><b>ServerName</b></td>'
    + '<td bgcolor=#E6E6FA><b>DBName</b></td>'
    + '<td bgcolor=#E6E6FA><b>LogicalName</b></td>'
    + '<td bgcolor=#ffffb3><b>Drive</b></td>'
    + '<td bgcolor=#E6E6FA><b>FreeSpaceGB</b></td>'
    + '<td bgcolor=#E6E6FA><b>Date</b></td>'
    + '<td bgcolor=#E6E6FA><b>FreeSpaceGB_DateBefore</b></td>'
    + '<td bgcolor=#E6E6FA><b>DateBefore</b></td>'

    + '<td bgcolor=#E6E6FA><b>Differences in GB</b></td></tr>' ;


SET @Body = (

SELECT top 20 
    td =		 [ServerName] , ''
      ,td =		[DBName], ''
      --,[PhysicalFileLocation]
      ,td =		[LogicalName], ''
      ,td =		a.[Drive] , ''
      --,[FreeSpaceInMB]
      ,td =		a.[FreeSpaceInGB], ''
       ,td =	[Date_verif] , '' 

      ,td =		b.FreeSpaceInGB, ''
      ,td =		 b.FechaReal
      ,td =		convert(int, a.FreeSpaceInGB) - convert(int, b.FreeSpaceInGB) , ''
     
  FROM [AuditoriaDB].[dbo].[Db_Space_ServerDisk_Pdr] a
  join
  (
  select FreeSpaceInGB,  convert(varchar(10), dateadd(d,1, 
  convert(date, Date_verif)),120) fecha, Date_verif FechaReal ,
  Drive from [AuditoriaDB].[dbo].[Db_Space_ServerDisk_Pdr] 

  ) b on a.Drive = b.drive  and a.Date_verif = b.fecha

  where a.drive = 'k:\'
  order by Date_verif desc


  
            FOR   XML RAW('tr'),
                  ELEMENTS
            )



SELECT  @Body = @TableHead + ISNULL(@Body, '') + @TableTail

/*
Enviar Correo electronico 
alejandro Jimenez 
2019-11-20 
*/



EXEC sp_send_dbmail 
  @profile_name='SqlMail',
  @copy_recipients ='jose.jimenez@INABIMA.GOB.DO',
  @recipients=  @email,  --'jose.jimenez@INABIMA.GOB.DO', --; ja.jimenezrosa@gmail.com',
  @subject='Reporte de Variacion Espacio en Disco K:\ Servidor 10.0.0.252 ',
  @body=@Body ,
  @body_format = 'HTML' ;


~~~
# 



# REMISIÓN ENCUESTA DE SATISFACCIÓN SERVICIOS DE MENSAJERIA<a name="encuestamensajeria"></a> 


![](https://www.beetrack.com/hubfs/Modelo%20de%20encuesta%20de%20satisfaccion%20del%20cliente.jpg)


#### Con el objetivo de evaluar a nuestros colaboradores de mensajería para mejorar la calidad en los servicios brindados, solicitamos interpongan de sus buenos y valiosos servicios a los fines de que sea completada una breve encuesta de satisfacción de la gestión realizada por los colaboradores Wilber Peña Escolástico, Wilselin Ramos y Raúl Mayora.

## Esta Solicitud fue realizada por el Departamento de Mesa DE ENTRADA  en la persona de ***Paola Ogando*** la misma quiere que este correo le sea entregado  cada dos (2) meses a un listado de supervisores o encargados de departamentos.

#### Procedimos a realizar dicha solicitud via Sql Server, integrando ***Html con Sql S*** para estos fines.  Documentamos el Caso, no por su dificultad mas si por ser un caso unico en el cual se integra la pagina Html dentro del correo sql de forma fija.   

#### Esto en Realidad lo hace ser mas simple, pero no teniamos un ejemplo de un caso similar hasta ahora.

##  Realizar el envio de las encuestas a los encargados.
#### Para Esto ejecutamos el siguiente codigo.
# 


~~~sql
/*
Alejandro Jimenez Rosa

*/
declare @listaCorreos varchar(max) = 
(SELECT listamail from  AuditoriaDB.DBO.mensajeria_mail 
where id = 1)


exec [dbo].[sp_CorreoEncuestaMensajeria] @listaCorreos

~~~
# 


#  
#### En la ***tabla mensajeria_mail*** se encentra el listdo de los encargado a los cuales se debe envia la encuesta.  Esta conformado en una lista y como se puede apreciar es el registro con el ***id # 1***



#### Anexo el procedimiento que realiza el envio del  HTML  utilizando sql server para realizar las encuestas de satisfaccion de mensajeria.

# 


~~~sql
USE [msdb]
GO
/****** Object:  StoredProcedure [dbo].[sp_CorreoEncuestaMensajeria]   
 Script Date: 14/07/2021 07:33:16 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[sp_CorreoEncuestaMensajeria]
    @emailSupervisorVC varchar(max)
as

DECLARE @Body NVARCHAR(MAX)
=
'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    
<!-- 
    <div style="margin-bottom: 50px; " >
        <img src="https://inabima.gob.do/wp-content/uploads/2021/04/LOGO-inabima.jpg" 
        alt="HTML5 Icon" 
        >
    </div> -->
    <div style="margin-bottom: 50px; " >
        <img src="data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAoHCBYSERgRERUVGBISEhgYGRgZEhkYGBoRGBgaHBgaGRkcIS8lHR8rHxgYJjgmKy8xNTU1GiY7QDs0Py81NTQBDAwMEA8QHxISHzQsJCs0NEA0NDQxNjo0NDQ0NDQxNDQ0NDQ0NjQxNDE0NDY0PTQ0NDQ0NDQ0NDY0NDQ9NTQ0NP/AABEIAOEA4QMBIgACEQEDEQH/xAAcAAEAAQUBAQAAAAAAAAAAAAAABwEDBAUGAgj/xABKEAACAQMBBAUGCQkHAwUAAAABAgADBBESBQYhMQcTIkFRMmFxgZPSQlJUkZKhscHRFBYjRGJygoPCFzNDU6Ky4iSj8BVjZHSU/8QAGgEBAAMBAQEAAAAAAAAAAAAAAAECAwQFBv/EAC0RAAICAQIEBQMFAQEAAAAAAAABAhEDBBIhMUFRBRMUYaFSkbEVMmJxgeFC/9oADAMBAAIRAxEAPwCZoiIAiIgCIiAIiIAiIgCIiAIiIAiIgCIiAIiIAiIgCIiAIiIAiIgCIiAIiIAiIgCIiAIiIAiIgCIiAUiY13eU6KGpWdEQc2dgoHrJxOauukXZ9M464uf2KTuPpAY+uQ2kRaOviajYG3ad9SNagKnV6ioZ6ZTURz055gcs+M28kkREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREApOP3330TZ69XTAe6ZcqhPZQHk74444HA5nHcOM3e8e1ls7Wpcvx6teC/GqE4RfWxE+d727etUetVbVUqNqdvFj4eYAAAdwAEpJ0VlKi7tTada6qdbcuzv3ZPBR4IvJR6J0+4u5TXrC4uAVtFPnDVSO5T3L4t6h3ke9w9yTeEXFyCtqp4Dk1U+A/Y8T38h4yR9rb22dlSHaDhKgpCnQ0MysAeBXUAoAHeR4SIQbZWMerOio0VpqEQBUUBQoGAFHAAAchL0xbG7StSStTOadVFdDjGUYZHDu4GZGZoaHqJ5zGYB6iIgCIiAIiIAiIgCIiAIiIAiIgCIiAIiIAiIgCIiARd0zX5C29sM4Zmqt59A0qD9Nj6ppNwtyDdkXF0pW1U5VTwNYj6wnn+F3cOMy+mVT+VUCeRoMB6Q/H/cJzu6+17g31shuK5pm5pLpNZymguo06c4xjhiZP93Ezf7icr+8p2lu9VxppUUzhV+Co7Kqo7+QA9EgP8opkVhSpBS7611kVdNNSWKKdIw3EnJzkKRw7513ntzUs6yrTNR+rJRAcaqq9pOOR8IKefdIAtmZFf8AcIOfjccekkBx6zO/TRTTJkTXudtYX1iFdRTdUFNkQlMJjCOgByisuCMcsHB4Ti95re8samDc3DUWPYfrn4/stx4MPr5jvAu9G98w2g9ECmU/JlQsAA2igFVDqzx8oBhjmw5Ynb72AGkEZQyOxDKeRGM8+4g8QRxBE49Ztxpt8jt0WXbkSpNPoyKP/Wbn5TX9u/4zpdwNsVmvRSq1ajrUpsMO7Nh17QI1Hhw1Tnds7JNuwYEtRY9lu8HnpbwYfWOI78bDcJc7RpY7g59WhpyY5200+B7ufHhlp5SilyfQmiIidp8wIiIAiIgCIiAIiIAiIgCIiAIiIAiIgCIiAIiIBH3S7sw1LNLhR2rap2uH+FU7J/1aD6jIo2NcrSuqFVzhKVxTdiASQiOrMQBxPAHhPpC7tlq02pVAClRSrA96sMET573n3fqbPuDRfJQ5NN8cHp9x/eHIjx8xEzkupSS6ksf2mbP/AMyp/wDnqe7I7c7POr/rHwxH6jV4Y/KPP/7y/QPjw5ObHYmx3u6mhMKiDL1CCURD3nHMnkF7z6zCzvHbTItydEkbl3VktzWrUKjOeopqxNq9NU0KFJ1twy5Gccz58GbDae0Grvk8FXyV8B4nzzXWtslGmtCipWmhzx4s7nm7nvY/MBwHCXJ4eu10sz2x5fk9zR6Xy1ulz/BQhWUoyhkcYZTyI9PcRzBHEGXtyN3equnuAdVJaemm3DVlj2lYdxUKOPI6siUt6DVGCIMsx/8ACfNO4sLUUqYRe7mfFjzM18MU232X59hrM2yLjF8Xz/ozIiJ7Z44iIgCIiAIiIAiIgCIiAIiIAiIgCIiAUiJot5d56OzwhrhyKmrToUHyQM5yR4iEm3SBvYnO7b3uoWaUalUVCtypKaUBOAFPa48PLEythbepXtA16BbSrMpDABgV48RnvGCPTJ2urrgRZuJrdtbGo3tI0bhAyHiDyZW7irc1Mw92t6KO0A7UA4FIrq1qB5QJGME+Ew9v78W9lXNvVFRnCqx0KpA1cgcsOOBn1iNjbquItHCbR6MK6VgKDo9Bm4u3B6a95ZB5fAcNPMnkOc3lvZrb01t6SMiIc9pcO74wXc44scegDgJ3eyr9LmglxTyUqqGXIwQO8EdxByJyT9JdkDgpX4HH90OYP705c+klmjti67m2DLHDLc1bMRVJ4AE+gZmwtNi1ah4rpXxbh8y85uNibx212jPbtnqxl1KlWUYJGQe44PEcOEtbu73W9/r6gVB1Sqza0C9ls4xx/ZM5IeEKLuTbr/Dqn4hJqoqjZ7P2alBcKMseZPM/gPNM+cjsnf61uq6W9MVQ9UkKWpgLkKWwTnzGbLeTeajs8Ia+s9aWChFDHsgEk5I4cR889OGHYlGKr2OGUnJ7m7N7E1WwNt076j19EME1svbXB1Lz4Zmh2h0jWlCs9FxVLUnKsyopXUpw2Dq44OR6pdQk3SRW0dpEt03DKGByCAQfEHlLkqSIiIAiIgCIiAIiIAiIgCIiAIlMxAEjDpo8i2/eq/7UknzhOkzYFxepRFsgcoX1ZdVxqC48o+YzTC0ppsh8jnOlBsWdgfCi5+ZKU87vVm2TtWpZOT1FwAqk/tZNB/rKHznzTc7+bs3N3bWlOhTDPRpMrg1FXDFEAGSePFT80z+kLdVrylTqW6g3FE4xkLqpNzGTwyCAR6/GbRnHaovrf/CrTuzT9DZ007kngFNPPmwr5nM2tSnf3d7cV6lNOso1TS11FTNQ4WhjUeJCoOU6Xd7d29tbC8pikBXuAi0x1i8jqV2znhhWJld2ujZWpMdoK61dZCqlUYFMAYyRkZJ1eqS5RUpSsU+Bl9EO09dtUtWPao1NajwpVBnH01f6QnB7u3T06tY07Rbksjgo1NnCLr8vSoJ83d6Z2u6u691YbTZ1TNo3WU9XWLnqidSErnOQQo9Zmo2Tu1tW0qO9tTRWqAqSXpt2C2eGTwPKE43KmuNDjwMjopp09Ny/WZrGhjq9JGKYz29XJsnA4cvXPPQ7+s//AF6f9c3e4+5ta0664uWU1qtFqaorZwGIZi7cixKry5YPE54eOjbdq5s+v/KUCdZSRVw6tll158k8OYkSlF7qfYVyI1sA1Kmt6mdVvd0+A8MF1+coR/FOp39uxe3rhDmlaWBqDHxiofn59dIeqZ+x9y7gbPvLetTC1KnVtSGtTqqU8sBkHhnlx+NPWwty7mnZXoqIPyi4orTpr1inKji2WzgZOkfwy7nG918URTNluBfi22JUuG5Unrv6SMYHrOBI+srdKlhdV6tSmLnrabIrOod+0Wqsqk5OesPLvWdkd2r5djixSkOte6Zqg6xOFEdocc4OWC8PMZl7I6NKJtkN11guSpLhag0hiTpHAccDHfKKcU275smmzedHO0/yjZ1PUcvRzSbjnyPIz5yhQzq5H3RtsO7snqpc0wtKoqkEOrDrVODwBzxB/wBMkCYZElJ1yLLkeolIlCSsSkrAEREAREQBERAKSOaiXSVDUUXDKUSmydvGKl5cEVAPFAtPOPgP4YkjSklOiGcDbWjVCylbhgu0F/SFrmmWpuxLhkZhjTgKWXskYIxxlDY1nYNi41/ke0Mduoo65a6Lb5GQurQ76c8x6BiQMRiW3sUcLTotcsKpW4FNr2kF1GtTPVC3RamUyCF1qRkjmD48b27KOLntC5DinW/KTU16GrGqDS0F+yezrxo4BSAZ2mIxI3dBRGlol4KX5My3DlreiquWdSadeoGqKXPkuirVXJ4gaPGXS1V0Y3C3QuhY6KOha2gVkp1FreR2dRcZBbnlMZkjYjEl5PYURzcU6/WOFF11+bguf0vVmzNs4ohD5GrrOqwF7WoOfGWrinesj2ypXaoj00WpqZAyUabvTqBzwyS1AMO9lcSS8RiPM9hRyeyL13F2GWur1GNVA1OoAKbW1EAI5GkEPq7IOc54TnqdOrookC6Fv19LIdLpm1i3cViVUh9BfRjPZ1ZPKSbiMSFOugoj/eWnXN+xpC409QfIFUJjqLkHLDsHtmn2cai2kg8Jae1ru9dFaulR7i30PprjSgWmdWonQU1jio4+VnnJExK4k+ZwXAURvRatUdXrC5pa6F3yp13enUNWtjQE7OoKQV1AggLjmJes1qIKFwaVf9Fa3bFVa5Ku9J6fUN1bHUC+pyEYZ4kccCSFiMRv9hRGZtrtEp0nW4BtnqM7ipUdtLGg+tWU4qMC1XCHhgEYOMTYb10rk16wodfouLdaeaevCsgeqWBHkllV0yOOXQTvMRiPM43Qoju7e6L3DhLgU7jCgqz6hRt6tNKnVoO0jPT69gRxbII7pZrmq1uW010RU7CKl0yuUuahVWA/SqHULx5rqXuGJJWIjf7CiPtpWbqtZ1S4Us9oca7ippRirVgFRssAR2tPGW2t7gXNZx14puVCaTWKtpqWhOpWPYwuvTgcQz5PDjIuIjexRwFvcXCO1WslwEq3KVxpDuRSFV109WgLL+jNHKY4kMcc53dJ9ShhnBAIyCDg+IPEGXJWVbsUIiJBIiIgHJ7175Js6olN6Lv1qFgysoHZOCMH0j55pV6V6Hfb1/pUz/VPXS/Y6rWlcAcaNUqT4JUHvKnzyI514cMJxtmcpNMl+n0qWx8qjcL/AAofseZdPpNsT5RrL6aLH/bmQrE0emgRvZO9Pf6wb9YA/ep1F+1ZmW+9li5wt3b58DVVT8zET58iQ9LHo2N7PpijdI4yjqw8VYH7Jfny+oxy4ejhNjabauaP91cVk8wqsR9EnEo9I+jJ3n0fEgiy39v6f+OHHhUpqw+ddJ+udBZdK1QHFxbqw7zTqFT6lYH7RM3p5rlxLbkSvE5DZvSJZVuDu1FvCqukfSGV+udTbXCVFD02VkbkysGB9BExlGUeaJTTL8REgkREQBERAEREAREQBERAEREAREQBERANXvBswXdrUtyQOsQgMRkK44q2PMQDIyforuR5NegfTrX7FMmCJeGWUFSIcUyFn6Mb4cmtz/Nf76csVOjm/X4FJv3aw/qAk4RNPUzK7EQBX3Mv052rnzqUf/a0wKuwrpPKtrgfyXP2CfR0Sy1UuqGxHzFVQocOrKfBlKn5jPIM+m6tFXGGVWHgVB+2au63Ys6v95a0CfEUlVvpKAZdavuiNh88RJquujWxfJRatMn4tViB6A2RNDe9FDAE0LkE9wqU8fOyH+maLUwZXYyM5k7Pv6ts2u3qNTbOcq2Af3hyb1zd7R3GvqAJNAuo+FTYPw8dPl/VOdqIUbS6srDmrKVI9IPGaqUZrhxIpomjo73oq36VEuAuuho7a8NQfXzXkCNPMc88hO1EiXocf/qLlfGlTPzM/wCMloTz80VGbSNYu0ViImRYREQBERAEREAREQBERAEREAREQBKSsQDzKzEvr+nQAatURFJwC7hQT4DPMzVvvdZD9Ypn0HV9khtLmXjjnL9qb/pG/icnW3+s15M7H9mk/wBpAExm6R7buSsf4VH9Ur5ke5qtJnfKL+x2kricG3SVR+DQqn0lR98sN0mDutm9dUD7pHmx7l1oNQ//ACSHEjo9Jv8A8b/vf8ZUdJg77Y+qqPdjzYdy36fqfp+USHiYG0tkULpdNxSSoO7UuSPQ3Meozk6XSVRPlUKo9BU/eJnW3SBaMcMaiZ+MhI+dcyyyx6Mzlo88ecWa2rs2hsJzd0RUanXApdUWBKtksGDtxIwMYOT55dTpJofCoVh9A/1TG6QNp0bizRqFRXArgHSwODpbmO6R3MsuWW7melovD8WTFc07t+xKydIlqea1l9KA/YTL6b+2R51HHpo1PuWRFEz86R0PwnC+/wByZV31sj/jj103H2rLq73WR/WaY9Jx9okKxJ89lX4Ri+p/BOabyWjcrmh7VPxmTT2nRbyatM+ioD98gPE8lB4D5pPnvsZvwePST+x9CLcoeTKf4hPYqA8iPnnzyFHhPauw5Mw9DEfZJ8/2KvwftL4PoQGVzIAW/rL5NasPRWcffL6bbuV8m4re0Y/aZPnrsUfg8+kkTxGZBy7zXg5XNX51P2ibjdra1/dXK0luH0AhnYpTOKYPH4PM8h5zJWVN1Rjk8MyY4ucmqRLWZWeVE9TY80REQBERANbtvZaXdBqNTkw4HvDjyWHnBkJbSsXtqrUaowyH1Fe5h5jJ9M53e3dxb2l2cLXQHQ3j+yx+Kfq5zLLDcrXM9DQazyJVLk/ghqJcuaDUmanUUqynDKeYMUaL1P7tHf8AdRm+wTkpn0u+NXfAtxNxabr3lXitBwPF9KD/AFEH6ptbfo+u2PbNFB53Zj8wXH1yyxyfQxnq8EOcl9zkokgUujNvhXI/hpfi0zKfRtRHlV6p9AUfcZZYZdjCXiWnXW/8ZGcSUx0c23x630l92cBvnZpYXQt0V2RqQcMagBySwIxpxwKxLFJK2MfiOHJLar+xmbm7Hp3ldqNUsFFPWCpAOQwHeDw4zsT0cW3+ZWH8S+7OH3M3io2tVrhxUKilpKKqltTuuCpLAEcDniDw5GdoOlCz+JcD+WnvzoxYHKN7Ty9dq5xzNQlSpFW6NaHdWrD6B/png9GlLur1fWqH7pfXpNsjz64emj+BM9DpLsfjVR/Jaaen/icnr8/1swj0aJ3XD+zX8Z5PRmO65PsR702X9pNh8ep7B/wlf7SLD/MqewqfhHpn9LLfqOo+v8GpPRn4XX/Y/wCc8N0ZN3XS+u3/AOc3Y6Rtn/5rewqe7Lq9IGzz+sY9NKp7sj038WT+paj6vhHNno0qd1ynroMP655PRtW/z6R/lsPvnUrv1s8/rKetHH2rLg31sD+tUvnP4SPTez+S36nqPq+Ecc3Rzcd1WkfUw+6W26Orrueif4mH9M7pd77A8ruh7QS7S3ls3IVLqgSSAAKq5JPIDjIenXZkrxPUd19iPD0e3fcaHtH9yd1upsAWVDScNVc5dvE9wHmH4nvnQYjERxxi7Rnm1ubNHbN8D1ERLnIIiIAiIgCUIlYgGuudkUKr9ZVo03cDGpqascekiZdOiqjCqAPAAAS7EiiXJtVYxGJWJJAiIgFJHPSVuvXvK1Cpb09WlKiudSDSuQV4MwzntAfXiSNEhq1TLQm4O0QO25O0MBVtGCA5wa1DJb4zfpOJ7vN3d+bf5jbR+SN7Wh78nyUnRHUSiqSRSa3u5MgT8xto/JG9tQ9+PzG2j8kb21D35PmIxLeqn2RXYiA/zG2j8kb2tD34/MbaPyRva0Pfk+RHqp9kNiID/MbaPyRva0Pfj8xto/JG9rQ9+T5iMR6qfZDYiA/zG2j8kb21D34/MbaPyRvbUPfk+YjEeqn2Q2IgP8xdo/JG9tQ9+SBuPuKLXFzdANc47K5BWlnw7i37Xd3eJ7zESk88pKiVFICViJiWEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQD//2Q==" 
        alt="HTML5 Icon" 
        >
    </div>

    <h1>
        Buenas tardes estimados,
    </h1>
    <p style="font-size: 20px;">
        Con el objetivo de evaluar a nuestros colaboradores de mensajería para mejorar la calidad en los servicios brindados, solicitamos interpongan de sus buenos y 
        valiosos servicios a los fines de que sea completada una breve encuesta de satisfacción de la gestión realizada por los 
        colaboradores  <strong>Wilber Peña Escolástico, Wilselin Ramos y Raúl Mayora.</strong> 
    </p>

    <li>
        <a href="https://forms.office.com/Pages/ResponsePage.aspx?id=2kxlrbvqc0u1nr5OmH-PrnYcBkpYTzVDlx1515JPfF9UNEJETzVZVlM2NThHTUI3MU9QNlg3SzhXTS4u" >
            <strong>
                Wilber Peña Escolástico.
            </strong>
        </a>
    </li>
    <li>    
        <a href="https://forms.office.com/pages/responsepage.aspx?id=2kxlrbvqc0u1nr5OmH-Prv4wqDaVJV1Fqx4OE-v03xVURjFaMEUxMlI3VzE5OUoxSzgyN1A3T0Q0Si4u" >
            <strong>
                Wilselin Ramos
            </strong>
        </a>
    </li>
    <!-- <li>
        <a href="https://forms.office.com/pages/responsepage.aspx?id=2kxlrbvqc0u1nr5OmH-Prv4wqDaVJV1Fqx4OE-v03xVURjFaMEUxMlI3VzE5OUoxSzgyN1A3T0Q0Si4u" >
            <strong>
                Raúl Mayora
            </strong>
        </a>
    </li> -->


    <p style="font-size: 20px;">
        ¡Tu opinión es importante para nosotros, ayudamos a mejorar!
    </p>

    <p style="font-size: 20px; font-style:italic; font-weight: 700;">

        Muchas gracias por tu colaboración.
    </p>

    <br>
    <br>
    <div>
        <img src="http://inabima.gob.do/wp-content/uploads/2021/03/imagen.png" 
        alt="HTML5 Icon" 
        >
    </div>



</body>
</html>
'

    --,@dias int = 2
--	,@fecha varchar(10) = convert(varchar(10), getdate(),120)



EXEC sp_send_dbmail 
  @profile_name='SqlMail',
  --@copy_recipients ='jose.jimenez@INABIMA.GOB.DO',
  @recipients=  @emailSupervisorVC,
  --@recipients=  @emailSupervisor, 
  @subject='REMISIÓN ENCUESTA DE SATISFACCIÓN SERVICIOS DE MENSAJERIA',
  @body=@Body ,
  @body_format = 'HTML' ;

~~~
# 








Saludos cordiales,




# Reporte de Registros Modificados en las tablas de Afiliados del INABIMA<a name="repafiliadosinabima"></a> 
#### Reporte de notificacion de las modificaciones en la tabla de Afiliados al Plan de retiro de **************.

![](imagenes/reporteAfiliados.jpg)
# 


~~~sql
USE [msdb]
GO
/****** Object:  StoredProcedure [dbo].[sp_NotificarCambiosAfiliados]    
Script Date: 31/08/2021 12:14:31 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[sp_NotificarCambiosAfiliados]
as

/*
Declare Variables for DML
*/

while exists (
SELECT 
  'Registro modificado para la Cedula numero :' 
   +  [Cag_Cedula]+' Con los nombres : '+ ''+ ' Apellidos : ' 
    + [cag_APELLIDO1] + ' ' + ISNULL([cag_APELLIDO2],'') + ' '
    + '' + ' ' + ' Desde la Computadora : ' + '' 
    + ' Con el Usuario de Sistemas:  ' 
  FROM [AuditoriaDB].[dbo].[tblAfiliados_Audit] 
  WHERE ENVIADO IS NULL or enviado = 0

  )
begin



declare @email varchar(1000) = 
( select email from [AuditoriaDB].[dbo].[tblParametros] where id = 8)
--'jose.jimenez@inabima.gob.do'


 
DECLARE @ReportingDate varchar(10);
 
 -- Reporting date will from the beginning of the current week
SET @ReportingDate = convert(varchar(10), getdate(), 120)
--SET @ReportingPeriodEnd = DATEADD(WEEK, DATEDIFF(WEEK, 0, DATEADD(YEAR, -3, GETDATE())) + 1, 0);
 


 /*
Declare Variables for HTML
*/
 DECLARE @Body NVARCHAR(MAX) 
DECLARE @Style NVARCHAR(MAX)= '';
 
/*
Define CSS for html to use
*/
SET @Style += +N'<style type="text/css">' + N'.tg  {border-collapse:collapse;border-spacing:0;border-color:#aaa;}'

    + N'.tg td{font-family:Arial, sans-serif;font-size:14px;
    padding:10px 5px;border-style:solid;border-width:1px;
    overflow:hidden;word-break:normal;border-color:#aaa;
    color:#333;background-color:#fafafa;}'

    + N'.tg th{font-family:Arial, sans-serif;font-size:14px;
    font-weight:normal;padding:10px 5px;border-style:solid;
    border-width:1px;overflow:hidden;word-break:normal;
    border-color:#aaa;color:#fff;background-color:#0039cb;}'

    + N'.tg .tg-9ajh{font-weight:bold;background-color:#0039cb; 
    color:#FFF}' + N'.tg .tg-hgcj{font-weight:bold;
    text-align:center}'

    + N'</style>';



/*
Declare Variables for HTML
*/
 
DECLARE @tableHTML NVARCHAR(MAX)= '';

DECLARE @IMAGENTHML NVARCHAR(1000) =		   
'<div style="margin-bottom: 50px; " ><img src="https://lh3.
googleusercontent.com/proxy/5BGJvOMR_Vsub62ydbn2peBSjRjSLnNvuTuV_Ar9p3esa6KnNB1e9inbajHN4bME-
QJW7kaeUJANLs-QG0GHVeF7wl8LG73g4MTFwVk"alt="HTML5 Icon"></
div>'   
   
           ;



 
SET @tableHTML += @Style + @tableHTML + N'<H2>Reporte de 
Registros Modificados en las tablas de Afiliados del INABIMA.' + 
CAST(@ReportingDate  AS CHAR(10)) + '</H2>'


+  N'<table class="tg">' --DEFINE TABLE

/*
Define Column Headers and Column Span for each Header Column
*/

/*
Define Column Sub-Headers
*/


    + '<tr>'
   --+ '<tr> <class="tg-9ajh"><b>Cedula</b></td>'
    + '<td class="tg-9ajh"><b>Cedula</b></td>'
    + '<td class="tg-9ajh"><b>Nombres</b></td>'
    + '<td class="tg-9ajh"><b>Genero</b></td>'
    + '<td class="tg-9ajh"><b>Sueldo</b></td>'
    + '<td class="tg-9ajh"><b>Fecha Ingreso</b></td>'
    + '<td class="tg-9ajh"><b>Es/No Docente</b></td>'
    + '<td class="tg-9ajh"><b>Evento</b></td>'
    + '<td class="tg-9ajh"><b>Fecha_Registro</b></td>'
    + '<td class="tg-9ajh"><b>Computadora</b></td>'
    + '<td class="tg-9ajh"><b>Usuario</b></td>'
    + '<td class="tg-9ajh"><b>Descripcion</b></td></tr>' 
/*
Define data for table and cast to xml
*/

/*
Define data for table and cast to xml
*/
    + CAST(( SELECT --a.[Id]
     td=		 'Cedula: ' +a.[Cag_Cedula] , ''
      ,td=		  a.[Cag_Nombre1] + ' '+ isnull(a.[Cag_Nombre2],
      '') + ' ' + isnull( [Cag_Apellido1],'') + ' ' + isnull( 
        [Cag_Apellido2],'')  , ''
      ,td=		 Case a.[Cag_Sexo] when 'M' then 'Masculino' 
      when 'F' then 'Femenino' else '-------' end , ''
      ,td=		 a.[Cag_Sueldo] , ''
      ,td=		 a.[Cag_FIngreso] , ''
      ,td=		 Case a.[cag_esdocente] when 1 then 'Docente' 
      else 'No Docente' end , ''
      ,td=		 substring( a.[audit_Action],0,17) , ''
      ,td=		 a.[FechaRegistroAudi]  , ''
      ,td=		 a.[Computername] , ''
      ,td=		 b.[usuario] , ''
     ,td=		 b.[Comentario] , ''
  FROM [AuditoriaDB].[dbo].[tblAfiliados_Audit] a
  left join  [AuditoriaDB].[dbo].[Pc_Usuario_Inabima] b  on (ltrim( A.ComputerName) = ltrim( b.Pc))
 WHERE ( ENVIADO != 1)
 --WHERE  convert(varchar(10), a.FechaRegistroAudi, 120) = '2021-08-31'

FOR
             XML PATH('tr') ,
                 TYPE
           ) AS NVARCHAR(MAX)) + N'</table>';
           



set @Body = @tableHTML +@IMAGENTHML
 


 EXEC sp_send_dbmail 
  @profile_name='SqlMail',
  @copy_recipients ='jose.jimenez@INABIMA.GOB.DO',
  @recipients=  @email,  --'jose.jimenez@INABIMA.GOB.DO', --; ja.jimenezrosa@gmail.com',
  @subject='Reporte de Registros Modificados en las tablas de Afiliados del INABIMA.',
  @body=@Body ,
  @body_format = 'HTML' ;



update [AuditoriaDB].[dbo].[tblAfiliados_Audit]
set ENVIADO = 1
where ENVIADO != 1

end
~~~
# 


###  Este reporte tiene la particularidad de tener un archivo de Css integrado en el es decir los estilos se manejan a traves de una variable Styles.



# Cargar Registros de Llamadas de la central Telefonica<a name="registrosdellamadas"></a>


procedimiento Sp_CDRReportTotal2 se ejecuta para colocar los datos de forma que puedan ser consumidos por el excel 
# 


~~~sql

alter procedure Sp_CDRReportTotal2
as

delete CDRReportTotal

insert into CDRReportTotal
select 
    
    --[Destination]
    --case when [Destination] = '1000' Then 'Desde Recepcion' else Destination end Origen
    cast(date as varchar(7)) Periodo
    ,subString([Dst_Channel],0,8) Destino
    ,status
    ,count(*)  Total

--Into  CDRReportTotal
FROM [dbo].[CDRReport]

where subString([Dst_Channel],5,1)  in ('1','2','3','4','5','6','7','8','9')

group by 
    
    --[Destination]
    --cast(date as varchar(10)),
    cast(date as varchar(7)) ,
    subString([Dst_Channel],0,8)
    ,status

Order by   Destino , Status

go
~~~

procedimiento Sp_CDRReportTotal se ejecuta para colocar los datos de forma que puedan ser consumidos por el excel 
~~~sql

alter procedure Sp_CDRReportTotal
as

delete CDRReportTotal


insert into CDRReportTotal
select 
    
    --[Destination]
    --case when [Destination] = '1000' Then 'Desde Recepcion' else Destination end Origen
    cast(date as varchar(10)) Periodo
    ,subString([Dst_Channel],0,8) Destino
    ,status
    ,count(*)  Total

--Into  CDRReportTotal
FROM [dbo].[CDRReport]

where subString([Dst_Channel],5,1)  in ('1','2','3','4','5','6','7','8','9')

group by 
    
    --[Destination]
    --cast(date as varchar(10)),
    date,
    subString([Dst_Channel],0,8)
    ,status

Order by cast(date as varchar(10)),  Destino , Status

go


~~~
# 




Actualizar el registro Historico de llamadas para la central Telefonica.
~~~sql

USE [AuditoriaDB]
GO


insert into [dbo].[CDRReport_Historico]
SELECT [Date]
      ,[Source]
      ,[Ring_Group]
      ,[Destination]
      ,[Src_Channel]
      ,[Account_Code]
      ,[Dst_Channel]
      ,[Status]
      ,[Duration]
      ,[UniqueID]
      ,[Recording]
      ,[Cnum]
      ,[Cnam]
      ,[OutboundCnum]
      ,[DID]


  FROM [dbo].[CDRReport]

  

GO
~~~
# 




#### [Conectar Link Server un dominio de Windows y leer Informacion]<a name="leerdominio"></a>

## Crear Linked Server
#### Lo primero que haremos será crear nuestro Linked Server, la interfaz de servicio de Active Directory, también conocida como ASDI, a Active Directory usando el siguiente código:
# 


~~~sql
USE [master]
GO

/****** Object:  LinkedServer [ADSI]    
Script Date: 28/11/2022 11:12:50 a.m. ******/
EXEC master.dbo.sp_addlinkedserver @server = N'ADSI', 
@srvproduct=N'Active Directory Service Interfaces', 
@provider=N'ADSDSOObject', @datasrc=N'adsdatasource'

 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'ADSI',
@useself=N'False',@locallogin=NULL,
@rmtuser=N'INABIMASD\Administrator',@rmtpassword='########'

GO

EXEC master.dbo.sp_serveroption @server=N'ADSI', @optname=N'collation compatible', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'ADSI', @optname=N'data access', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'ADSI', @optname=N'dist', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'ADSI', @optname=N'pub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'ADSI', @optname=N'rpc', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'ADSI', @optname=N'rpc out', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'ADSI', @optname=N'sub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'ADSI', @optname=N'connect timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'ADSI', @optname=N'collation name', @optvalue=null
GO

EXEC master.dbo.sp_serveroption @server=N'ADSI', @optname=N'lazy schema validation', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'ADSI', @optname=N'query timeout', @optvalue=N'600000'
GO

EXEC master.dbo.sp_serveroption @server=N'ADSI', @optname=N'use remote collation', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'ADSI', @optname=N'remote proc transaction promotion', @optvalue=N'true'
GO
~~~
# 


#
#### Asegúrese de Colocar los valores correctos a la variables variables @rmtuser y @rmtpassword que son (nombre de usuario y contraseña) Estas deben tener acceso al Active Directory.

# 


#### Así es como se descompone la conexión LDAP:
#### LDAP://DOMAIN.com/OU=Players,DC=DOMAIN,DC=com
#### **LDAP://Domain.com** - es el nombre de un controlador de dominio
#### **/OU=Jugadores** - esta es la Unidad de Organización, en nuestro caso (Jugadores)
#### ,**DC**: este es el nombre de dominio dividido por nombre de dominio y extensión
#### Entonces... LDAP://DomainControllerName.com/OU=OrganizationalUnit,DC=DOMINIO,DC=NOMBRE
# 


~~~sql
SELECT * FROM OpenQuery
(
ADSI,
'SELECT *
FROM  ''LDAP://inabimasd.local/CN=COMPUTERS,DC=inabimasd,DC=local''
 
') AS tblADSI
--WHERE objectClass =  ''''
~~~

~~~sql
SELECT * FROM OpenQuery
(
ADSI,
'SELECT pager, displayName, telephoneNumber, sAMAccountName,
mail, mobile, facsimileTelephoneNumber, department, physicalDeliveryOfficeName, givenname
FROM  ''LDAP://inabimasd.local/CN=Users,DC=inabimasd,DC=local''
') AS tblADSI
--WHERE objectClass =  ''''
~~~



~~~sql
SELECT * FROM OpenQuery
(
ADSI,
'SELECT pager, displayName, telephoneNumber, sAMAccountName,
mail, mobile, facsimileTelephoneNumber, department, physicalDeliveryOfficeName, givenname
FROM  ''LDAP://inabimasd.local/CN=Users,DC=inabimasd,DC=local''
') AS tblADSI
--WHERE objectClass =  ''''
~~~
#
# 


# Listar jobs SQL Server<a name="listajob28"></a>
~~~sql
USE msdb
Go


SELECT dbo.sysjobs.Name AS 'Job Name', 
    'Job Enabled' = CASE dbo.sysjobs.Enabled
        WHEN 1 THEN 'Yes'
        WHEN 0 THEN 'No'
    END,
    'Frequency' = CASE dbo.sysschedules.freq_type
        WHEN 1 THEN 'Once'
        WHEN 4 THEN 'Daily'
        WHEN 8 THEN 'Weekly'
        WHEN 16 THEN 'Monthly'
        WHEN 32 THEN 'Monthly relative'
        WHEN 64 THEN 'When SQLServer Agent starts'
    END, 
    'Start Date' = CASE active_start_date
        WHEN 0 THEN null
        ELSE
        substring(convert(varchar(15),active_start_date),1,4) + '/' + 
        substring(convert(varchar(15),active_start_date),5,2) + '/' + 
        substring(convert(varchar(15),active_start_date),7,2)
    END,
    'Start Time' = CASE len(active_start_time)
        WHEN 1 THEN cast('00:00:0' + right(active_start_time,2) as char(8))
        WHEN 2 THEN cast('00:00:' + right(active_start_time,2) as char(8))
        WHEN 3 THEN cast('00:0' 
                + Left(right(active_start_time,3),1)  
                +':' + right(active_start_time,2) as char (8))
        WHEN 4 THEN cast('00:' 
                + Left(right(active_start_time,4),2)  
                +':' + right(active_start_time,2) as char (8))
        WHEN 5 THEN cast('0' 
                + Left(right(active_start_time,5),1) 
                +':' + Left(right(active_start_time,4),2)  
                +':' + right(active_start_time,2) as char (8))
        WHEN 6 THEN cast(Left(right(active_start_time,6),2) 
                +':' + Left(right(active_start_time,4),2)  
                +':' + right(active_start_time,2) as char (8))
    END,
--	active_start_time as 'Start Time',
    CASE len(run_duration)
        WHEN 1 THEN cast('00:00:0'
                + cast(run_duration as char) as char (8))
        WHEN 2 THEN cast('00:00:'
                + cast(run_duration as char) as char (8))
        WHEN 3 THEN cast('00:0' 
                + Left(right(run_duration,3),1)  
                +':' + right(run_duration,2) as char (8))
        WHEN 4 THEN cast('00:' 
                + Left(right(run_duration,4),2)  
                +':' + right(run_duration,2) as char (8))
        WHEN 5 THEN cast('0' 
                + Left(right(run_duration,5),1) 
                +':' + Left(right(run_duration,4),2)  
                +':' + right(run_duration,2) as char (8))
        WHEN 6 THEN cast(Left(right(run_duration,6),2) 
                +':' + Left(right(run_duration,4),2)  
                +':' + right(run_duration,2) as char (8))
    END as 'Max Duration',
    CASE(dbo.sysschedules.freq_subday_interval)
        WHEN 0 THEN 'Once'
        ELSE cast('Every ' 
                + right(dbo.sysschedules.freq_subday_interval,2) 
                + ' '
                +     CASE(dbo.sysschedules.freq_subday_type)
                            WHEN 1 THEN 'Once'
                            WHEN 4 THEN 'Minutes'
                            WHEN 8 THEN 'Hours'
                        END as char(16))
    END as 'Subday Frequency'
FROM dbo.sysjobs 
LEFT OUTER JOIN dbo.sysjobschedules 
ON dbo.sysjobs.job_id = dbo.sysjobschedules.job_id
INNER JOIN dbo.sysschedules ON dbo.sysjobschedules.schedule_id = dbo.sysschedules.schedule_id 
LEFT OUTER JOIN (SELECT job_id, max(run_duration) AS run_duration
        FROM dbo.sysjobhistory
        GROUP BY job_id) Q1
ON dbo.sysjobs.job_id = Q1.job_id
WHERE Next_run_time = 0

UNION

SELECT dbo.sysjobs.Name AS 'Job Name', 
    'Job Enabled' = CASE dbo.sysjobs.Enabled
        WHEN 1 THEN 'Yes'
        WHEN 0 THEN 'No'
    END,
    'Frequency' = CASE dbo.sysschedules.freq_type
        WHEN 1 THEN 'Once'
        WHEN 4 THEN 'Daily'
        WHEN 8 THEN 'Weekly'
        WHEN 16 THEN 'Monthly'
        WHEN 32 THEN 'Monthly relative'
        WHEN 64 THEN 'When SQLServer Agent starts'
    END, 
    'Start Date' = CASE next_run_date
        WHEN 0 THEN null
        ELSE
        substring(convert(varchar(15),next_run_date),1,4) + '/' + 
        substring(convert(varchar(15),next_run_date),5,2) + '/' + 
        substring(convert(varchar(15),next_run_date),7,2)
    END,
    'Start Time' = CASE len(next_run_time)
        WHEN 1 THEN cast('00:00:0' + right(next_run_time,2) as char(8))
        WHEN 2 THEN cast('00:00:' + right(next_run_time,2) as char(8))
        WHEN 3 THEN cast('00:0' 
                + Left(right(next_run_time,3),1)  
                +':' + right(next_run_time,2) as char (8))
        WHEN 4 THEN cast('00:' 
                + Left(right(next_run_time,4),2)  
                +':' + right(next_run_time,2) as char (8))
        WHEN 5 THEN cast('0' + Left(right(next_run_time,5),1) 
                +':' + Left(right(next_run_time,4),2)  
                +':' + right(next_run_time,2) as char (8))
        WHEN 6 THEN cast(Left(right(next_run_time,6),2) 
                +':' + Left(right(next_run_time,4),2)  
                +':' + right(next_run_time,2) as char (8))
    END,
--	next_run_time as 'Start Time',
    CASE len(run_duration)
        WHEN 1 THEN cast('00:00:0'
                + cast(run_duration as char) as char (8))
        WHEN 2 THEN cast('00:00:'
                + cast(run_duration as char) as char (8))
        WHEN 3 THEN cast('00:0' 
                + Left(right(run_duration,3),1)  
                +':' + right(run_duration,2) as char (8))
        WHEN 4 THEN cast('00:' 
                + Left(right(run_duration,4),2)  
                +':' + right(run_duration,2) as char (8))
        WHEN 5 THEN cast('0' 
                + Left(right(run_duration,5),1) 
                +':' + Left(right(run_duration,4),2)  
                +':' + right(run_duration,2) as char (8))
        WHEN 6 THEN cast(Left(right(run_duration,6),2) 
                +':' + Left(right(run_duration,4),2)  
                +':' + right(run_duration,2) as char (8))
    END as 'Max Duration',
    CASE(dbo.sysschedules.freq_subday_interval)
        WHEN 0 THEN 'Once'
        ELSE cast('Every ' 
                + right(dbo.sysschedules.freq_subday_interval,2) 
                + ' '
                +     CASE(dbo.sysschedules.freq_subday_type)
                            WHEN 1 THEN 'Once'
                            WHEN 4 THEN 'Minutes'
                            WHEN 8 THEN 'Hours'
                        END as char(16))
    END as 'Subday Frequency'
FROM dbo.sysjobs 
LEFT OUTER JOIN dbo.sysjobschedules ON dbo.sysjobs.job_id = dbo.sysjobschedules.job_id
INNER JOIN dbo.sysschedules ON dbo.sysjobschedules.schedule_id = dbo.sysschedules.schedule_id 
LEFT OUTER JOIN (SELECT job_id, max(run_duration) AS run_duration
        FROM dbo.sysjobhistory
        GROUP BY job_id) Q1
ON dbo.sysjobs.job_id = Q1.job_id
WHERE Next_run_time <> 0

ORDER BY [Start Date],[Start Time]
~~~
# 


#

# Listado de jobs Sql Server con dias de ejecucion , step y la cuenta que los ejectuta<a name="listajob282"></a>

#### En esta publicación, le mostraré una consulta que le permite enumerar varias propiedades de los trabajos del Agente SQL Server, incluidos horarios, pasos, comandos ejecutados, categorías y mucho más. Esto es especialmente útil para la auditoría y el inventario de rutina.

#### Traté de crear un script completo, enumerando prácticamente todas las propiedades de Trabajos, Pasos y Horarios, donde el trabajo aparecerá más de una vez en la lista si tiene más de 1 paso u horario.
# 


~~~sql
SELECT
    [sJOB].[name] AS [JobName] ,
    CASE [sJOB].[enabled]
      WHEN 1 THEN 'Yes'
      WHEN 0 THEN 'No'
    END AS [IsEnabled] ,
    [sJOB].[date_created] AS [JobCreatedOn] ,
    [sJOB].[date_modified] AS [JobLastModifiedOn] ,
    [sJSTP].[step_id] AS [StepNo] ,
    [sJSTP].[step_name] AS [StepName] ,
    [sDBP].[name] AS [JobOwner] ,
    [sCAT].[name] AS [JobCategory] ,
    [sJOB].[description] AS [JobDescription] ,
    CASE [sJSTP].[subsystem]
      WHEN 'ActiveScripting' THEN 'ActiveX Script'
      WHEN 'CmdExec' THEN 'Operating system (CmdExec)'
      WHEN 'PowerShell' THEN 'PowerShell'
      WHEN 'Distribution' THEN 'Replication Distributor'
      WHEN 'Merge' THEN 'Replication Merge'
      WHEN 'QueueReader' THEN 'Replication Queue Reader'
      WHEN 'Snapshot' THEN 'Replication Snapshot'
      WHEN 'LogReader' THEN 'Replication Transaction-Log Reader'
      WHEN 'ANALYSISCOMMAND' THEN 'SQL Server Analysis Services Command'
      WHEN 'ANALYSISQUERY' THEN 'SQL Server Analysis Services Query'
      WHEN 'SSIS' THEN 'SQL Server Integration Services Package'
      WHEN 'TSQL' THEN 'Transact-SQL script (T-SQL)'
      ELSE sJSTP.subsystem
    END AS [StepType] ,
    [sPROX].[name] AS [RunAs] ,
    [sJSTP].[database_name] AS [Database] ,
    REPLACE(REPLACE(REPLACE([sJSTP].[command], 
    CHAR(10) + CHAR(13), ' '), CHAR(13), ' '), 
    CHAR(10), ' ') AS [ExecutableCommand] ,
    CASE [sJSTP].[on_success_action]
      WHEN 1 THEN 'Quit the job reporting success'
      WHEN 2 THEN 'Quit the job reporting failure'
      WHEN 3 THEN 'Go to the next step'
      WHEN 4 THEN 'Go to Step: ' +
       QUOTENAME(CAST([sJSTP].[on_success_step_id]
       
       AS VARCHAR(3))) + ' ' + [sOSSTP].[step_name]
    END AS [OnSuccessAction] ,
    [sJSTP].[retry_attempts] AS [RetryAttempts] ,
    [sJSTP].[retry_interval] AS [RetryInterval (Minutes)] ,
    CASE [sJSTP].[on_fail_action]
      WHEN 1 THEN 'Quit the job reporting success'
      WHEN 2 THEN 'Quit the job reporting failure'
      WHEN 3 THEN 'Go to the next step'
      WHEN 4 THEN 'Go to Step: ' + QUOTENAME(CAST([sJSTP].
      [on_fail_step_id] AS VARCHAR(3))) + ' ' + [sOFSTP].
      [step_name]
    END AS [OnFailureAction],
    CASE
        WHEN [sSCH].[schedule_uid] IS NULL THEN 'No'
        ELSE 'Yes'
      END AS [IsScheduled],
    [sSCH].[name] AS [JobScheduleName],
    CASE 
        WHEN [sSCH].[freq_type] = 64 THEN 'Start automatically when SQL Server Agent starts'
        WHEN [sSCH].[freq_type] = 128 THEN 'Start whenever the CPUs become idle'
        WHEN [sSCH].[freq_type] IN (4,8,16,32) THEN 'Recurring'
        WHEN [sSCH].[freq_type] = 1 THEN 'One Time'
    END [ScheduleType], 
    CASE [sSCH].[freq_type]
        WHEN 1 THEN 'One Time'
        WHEN 4 THEN 'Daily'
        WHEN 8 THEN 'Weekly'
        WHEN 16 THEN 'Monthly'
        WHEN 32 THEN 'Monthly - Relative to Frequency Interval'
        WHEN 64 THEN 'Start automatically when SQL Server Agent starts'
        WHEN 128 THEN 'Start whenever the CPUs become idle'
  END [Occurrence], 
  CASE [sSCH].[freq_type]
        WHEN 4 THEN 'Occurs every ' + CAST([freq_interval] AS VARCHAR(3)) + ' day(s)'
        WHEN 8 THEN 'Occurs every ' + CAST([freq_recurrence_factor] AS VARCHAR(3)) + ' week(s) on '
                + CASE WHEN [sSCH].[freq_interval] & 1 = 1 THEN 'Sunday' ELSE '' END
                + CASE WHEN [sSCH].[freq_interval] & 2 = 2 THEN ', Monday' ELSE '' END
                + CASE WHEN [sSCH].[freq_interval] & 4 = 4 THEN ', Tuesday' ELSE '' END
                + CASE WHEN [sSCH].[freq_interval] & 8 = 8 THEN ', Wednesday' ELSE '' END
                + CASE WHEN [sSCH].[freq_interval] & 16 = 16 THEN ', Thursday' ELSE '' END
                + CASE WHEN [sSCH].[freq_interval] & 32 = 32 THEN ', Friday' ELSE '' END
                + CASE WHEN [sSCH].[freq_interval] & 64 = 64 THEN ', Saturday' ELSE '' END
        WHEN 16 THEN 'Occurs on Day ' + CAST([freq_interval] AS
         VARCHAR(3)) + ' of every ' + CAST([sSCH].
         [freq_recurrence_factor] AS VARCHAR(3)) + ' month(s)'

        WHEN 32 THEN 'Occurs on '
                 + CASE [sSCH].[freq_relative_interval]
                    WHEN 1 THEN 'First'
                    WHEN 2 THEN 'Second'
                    WHEN 4 THEN 'Third'
                    WHEN 8 THEN 'Fourth'
                    WHEN 16 THEN 'Last'
                   END
                 + ' ' 
                 + CASE [sSCH].[freq_interval]
                    WHEN 1 THEN 'Sunday'
                    WHEN 2 THEN 'Monday'
                    WHEN 3 THEN 'Tuesday'
                    WHEN 4 THEN 'Wednesday'
                    WHEN 5 THEN 'Thursday'
                    WHEN 6 THEN 'Friday'
                    WHEN 7 THEN 'Saturday'
                    WHEN 8 THEN 'Day'
                    WHEN 9 THEN 'Weekday'
                    WHEN 10 THEN 'Weekend day'
                   END
                 + ' of every ' + CAST([sSCH].[freq_recurrence_factor] AS VARCHAR(3)) + ' month(s)'
    END AS [Recurrence], 
    CASE [sSCH].[freq_subday_type]
        WHEN 1 THEN 'Occurs once at ' + STUFF(STUFF(RIGHT
        ('000000' + CAST([sSCH].[active_start_time] 
        AS VARCHAR(6)), 6), 3, 0, ':'), 6, 0, ':')
        WHEN 2 THEN 'Occurs every ' +
         CAST([sSCH].[freq_subday_interval] AS VARCHAR(3))
          + ' Second(s) between ' 
          + STUFF(STUFF(RIGHT('000000' 
          + CAST([sSCH].[active_start_time] 
          AS VARCHAR(6)), 6), 3, 0, ':'), 6, 0, ':')
          + ' & ' + STUFF(STUFF(RIGHT('000000' 
          + CAST([sSCH].[active_end_time] 
          AS VARCHAR(6)), 6), 3, 0, ':')
          , 6, 0, ':')
        WHEN 4 THEN 'Occurs every ' 
        + CAST([sSCH].[freq_subday_interval] 
        AS VARCHAR(3)) + ' Minute(s) between ' 
        + STUFF(STUFF(RIGHT('000000' 
        + CAST([sSCH].[active_start_time] 
        AS VARCHAR(6)), 6), 3, 0, ':'), 6, 0, ':')
        + ' & ' + STUFF(STUFF(RIGHT('000000' 
        + CAST([sSCH].[active_end_time] 
        AS VARCHAR(6)), 6), 3, 0, ':')
        , 6, 0, ':')
        WHEN 8 THEN 'Occurs every ' 
        + CAST([sSCH].[freq_subday_interval] 
        AS VARCHAR(3)) + ' Hour(s) between ' 
        + STUFF(STUFF(RIGHT('000000' 
        + CAST([sSCH].[active_start_time] 
        AS VARCHAR(6)), 6), 3, 0, ':'), 6, 0, ':')
        + ' & ' + STUFF(STUFF(RIGHT('000000' 
        + CAST([sSCH].[active_end_time] 
        AS VARCHAR(6)), 6), 3, 0, ':'), 6, 0, ':')
    END [Frequency], 
    STUFF(STUFF(CAST([sSCH].[active_start_date] AS VARCHAR(8)), 5, 0, '-'), 8, 0, '-') AS [ScheduleUsageStartDate], 
    STUFF(STUFF(CAST([sSCH].[active_end_date] AS VARCHAR(8)), 5, 0, '-'), 8, 0, '-') AS [ScheduleUsageEndDate], 
    [sSCH].[date_created] AS [ScheduleCreatedOn], 
    [sSCH].[date_modified] AS [ScheduleLastModifiedOn],
    CASE [sJOB].[delete_level]
        WHEN 0 THEN 'Never'
        WHEN 1 THEN 'On Success'
        WHEN 2 THEN 'On Failure'
        WHEN 3 THEN 'On Completion'
    END AS [JobDeletionCriterion]
FROM
    [msdb].[dbo].[sysjobsteps] AS [sJSTP]
    INNER JOIN [msdb].[dbo].[sysjobs] AS [sJOB] ON [sJSTP].[job_id] = [sJOB].[job_id]
    LEFT JOIN [msdb].[dbo].[sysjobsteps] 
    AS [sOSSTP] ON [sJSTP].[job_id] = [sOSSTP].[job_id] AND 
    [sJSTP].[on_success_step_id] = [sOSSTP].[step_id]
    LEFT JOIN [msdb].[dbo].[sysjobsteps] 
    AS [sOFSTP] ON [sJSTP].[job_id] = [sOFSTP].[job_id] 
    AND [sJSTP].[on_fail_step_id] = [sOFSTP].[step_id]
    LEFT JOIN [msdb].[dbo].[sysproxies] 
    AS [sPROX] ON [sJSTP].[proxy_id] = [sPROX].[proxy_id]
    LEFT JOIN [msdb].[dbo].[syscategories] 
    AS [sCAT] ON [sJOB].[category_id] = [sCAT].[category_id]
    LEFT JOIN [msdb].[sys].[database_principals] 
    AS [sDBP] ON [sJOB].[owner_sid] = [sDBP].[sid]
    LEFT JOIN [msdb].[dbo].[sysjobschedules] 
    AS [sJOBSCH] ON [sJOB].[job_id] = [sJOBSCH].[job_id]
    LEFT JOIN [msdb].[dbo].[sysschedules] 
    AS [sSCH] ON [sJOBSCH].[schedule_id] = [sSCH].[schedule_id]
ORDER BY
    [JobName] ,
    [StepNo]
~~~
# 


## Jobs del sistema sql server,  con nombre y base de datos que apuntan<a name="28.2.1">

#### En SQL Server, la información sobre los trabajos (jobs) y la base de datos a la que apuntan se puede obtener a través del catálogo del sistema de SQL Server. Puedes usar las vistas del catálogo del sistema para obtener esta información. Aquí tienes una consulta SQL que te ayudará a obtener los nombres de los trabajos y las bases de datos a las que apuntan en SQL Server:

~~~sql
/*
Creado por Alejandro Jimenez rosa.
Lunes 16 de Octubre 2023.
Listado de los jobs que tiene un servidor sus steps, y las 
bases de datos a las que apuntan.


*/


USE msdb; -- Asegúrate de estar en la base de datos 'msdb' que contiene información de trabajos.

SELECT distinct
    jobs.name AS JobName,
    jobsteps.step_name,
    jobsteps.database_name AS TargetDatabase
FROM msdb.dbo.sysjobs AS jobs
INNER JOIN msdb.dbo.sysjobsteps AS jobsteps ON jobs.job_id = jobsteps.job_id
order by jobs.name,jobsteps.step_name, jobsteps.database_name;
~~~

#### En esta consulta, estamos utilizando las vistas del catálogo del sistema msdb.dbo.sysjobs y msdb.dbo.sysjobsteps para obtener información sobre los trabajos y los pasos de los trabajos. La columna name en sysjobs contiene el nombre del trabajo, y la columna database_name en sysjobsteps contiene el nombre de la base de datos a la que apunta el trabajo.

#### Asegúrate de estar conectado a la base de datos 'msdb' antes de ejecutar esta consulta, ya que la información de trabajos se encuentra en esa base de datos en SQL Server.




# 

# Jobs del sistema sql server,  para entregar al personal de control M<a name="28.2.2"></a>
# 
## Trabajos con los Jobs de Sql server , realizados para el trabajo de control M, con esto se migraran los jobs a un proceso automatico en el cual se despararan los jobs desde una aplicacio.

~~~sql
/*
Author: Jose Alejandro Jimenez Rosa
Fecha: 2023 Junio  26.

Descripcion:
Query modificado a peticion de RAUDYS MANUEL MELIAN CRUZ
en una conversacion por Teams del dia Viernes 23 de Junio del 2023


cito:
Como habiamos conversado, necesitamos esto por columnas:

-Servidor
-Nombre de job
-Descripcion
-Cuenta de usuario con la que se ejecuta
-Si esta habilitado
-Si esta schedulado
-Ocurrencia (Daily, Weekly, etc)
-Recurrencia (Dias de ejecucion)
-Hora(s) de ejecucion



*/

use msdb
go


SELECT distinct
    @@SERVERNAME AS Servidor,
    [sJOB].[name] AS [JobName] ,
    --Replace( [sJOB].description,Char(10),'') description,
    description = REPLACE(REPLACE(REPLACE([sJOB].description,CHAR(9),''),CHAR(10),''),CHAR(13),''),

    [dbo].[fn_sysdac_get_username](sJOB.owner_sid) [JobOwner],

    CASE [sJOB].[enabled]
      WHEN 1 THEN 'Yes'
      WHEN 0 THEN 'No'
    END AS [IsEnabled] ,

     CASE
        WHEN [sSCH].[schedule_uid] IS NULL THEN 'No'
        ELSE 'Yes'
      END AS [IsScheduled],
    
    --CASE 
    --    WHEN [sSCH].[freq_type] = 64 THEN 'Start automatically when SQL Server Agent starts'
    --    WHEN [sSCH].[freq_type] = 128 THEN 'Start whenever the CPUs become idle'
    --    WHEN [sSCH].[freq_type] IN (4,8,16,32) THEN 'Recurring'
    --    WHEN [sSCH].[freq_type] = 1 THEN 'One Time'
    --END [ScheduleType], 




    CASE [sSCH].[freq_type]
        WHEN 1 THEN 'One Time'
        WHEN 4 THEN 'Daily'
        WHEN 8 THEN 'Weekly'
        WHEN 16 THEN 'Monthly'
        WHEN 32 THEN 'Monthly - Relative to Frequency Interval'
        WHEN 64 THEN 'Start automatically when SQL Server Agent starts'
        WHEN 128 THEN 'Start whenever the CPUs become idle'
  END [Occurrence], 

 -- 	'Start Date' = CASE active_start_date
    --	WHEN 0 THEN null
    --	ELSE
    --	substring(convert(varchar(15),active_start_date),1,4) + '/' + 
    --	substring(convert(varchar(15),active_start_date),5,2) + '/' + 
    --	substring(convert(varchar(15),active_start_date),7,2)
    --END,
    ----[sJSTP].last_run_date,


  CASE [sSCH].[freq_type]
        WHEN 4 THEN 'Occurs every ' + CAST([freq_interval] AS VARCHAR(3)) + ' day(s)'
        WHEN 8 THEN 'Occurs every ' + CAST([freq_recurrence_factor] AS VARCHAR(3)) + ' week(s) on '
                + CASE WHEN [sSCH].[freq_interval] & 1 = 1 THEN 'Sunday' ELSE '' END
                + CASE WHEN [sSCH].[freq_interval] & 2 = 2 THEN ', Monday' ELSE '' END
                + CASE WHEN [sSCH].[freq_interval] & 4 = 4 THEN ', Tuesday' ELSE '' END
                + CASE WHEN [sSCH].[freq_interval] & 8 = 8 THEN ', Wednesday' ELSE '' END
                + CASE WHEN [sSCH].[freq_interval] & 16 = 16 THEN ', Thursday' ELSE '' END
                + CASE WHEN [sSCH].[freq_interval] & 32 = 32 THEN ', Friday' ELSE '' END
                + CASE WHEN [sSCH].[freq_interval] & 64 = 64 THEN ', Saturday' ELSE '' END
        WHEN 16 THEN 'Occurs on Day ' + CAST([freq_interval] AS VARCHAR(3)) + ' of every ' + CAST([sSCH].[freq_recurrence_factor] AS VARCHAR(3)) + ' month(s)'
        WHEN 32 THEN 'Occurs on '
                 + CASE [sSCH].[freq_relative_interval]
                    WHEN 1 THEN 'First'
                    WHEN 2 THEN 'Second'
                    WHEN 4 THEN 'Third'
                    WHEN 8 THEN 'Fourth'
                    WHEN 16 THEN 'Last'
                   END
                 + ' ' 
                 + CASE [sSCH].[freq_interval]
                    WHEN 1 THEN 'Sunday'
                    WHEN 2 THEN 'Monday'
                    WHEN 3 THEN 'Tuesday'
                    WHEN 4 THEN 'Wednesday'
                    WHEN 5 THEN 'Thursday'
                    WHEN 6 THEN 'Friday'
                    WHEN 7 THEN 'Saturday'
                    WHEN 8 THEN 'Day'
                    WHEN 9 THEN 'Weekday'
                    WHEN 10 THEN 'Weekend day'
                   END
                 + ' of every ' + CAST([sSCH].[freq_recurrence_factor] AS VARCHAR(3)) + ' month(s)'
    END AS [Recurrence], 
     sSCH.active_start_time

     --sSCH.freq_subday_interval
 
    --[dbo].[fn_sysdac_get_username](sJOB.owner_sid) [JobOwner],
        --[sCAT].[name] AS [JobCategory] 
FROM
    [msdb].[dbo].[sysjobsteps] AS [sJSTP]
    INNER JOIN [msdb].[dbo].[sysjobs] AS [sJOB] ON [sJSTP].[job_id] = [sJOB].[job_id]
    LEFT JOIN [msdb].[dbo].[sysjobsteps] AS [sOSSTP] ON [sJSTP].[job_id] = [sOSSTP].[job_id] AND [sJSTP].[on_success_step_id] = [sOSSTP].[step_id]
    LEFT JOIN [msdb].[dbo].[sysjobsteps] AS [sOFSTP] ON [sJSTP].[job_id] = [sOFSTP].[job_id] AND [sJSTP].[on_fail_step_id] = [sOFSTP].[step_id]
    LEFT JOIN [msdb].[dbo].[sysproxies] AS [sPROX] ON [sJSTP].[proxy_id] = [sPROX].[proxy_id]
    LEFT JOIN [msdb].[dbo].[syscategories] AS [sCAT] ON [sJOB].[category_id] = [sCAT].[category_id]
    LEFT JOIN [msdb].[sys].[database_principals] AS [sDBP] ON [sJOB].[owner_sid] = [sDBP].[sid]
    LEFT JOIN [msdb].[dbo].[sysjobschedules] AS [sJOBSCH] ON [sJOB].[job_id] = [sJOBSCH].[job_id]
    LEFT JOIN [msdb].[dbo].[sysschedules] AS [sSCH] ON [sJOBSCH].[schedule_id] = [sSCH].[schedule_id]
ORDER BY
    [JobName] 
 

~~~



# Establecimiento de la opción de configuración del servidor Máximo de subprocesos de trabajo <a name="autogrowmaxime"></a>
###### Artículo
###### 21/03/2023
###### 15 colaboradores
## En este artículo
###### Limitaciones y restricciones
###### Recomendaciones
###### Permisos
###### Usar SQL Server Management Studio (SSMS)


#### En este artículo se describe cómo establecer la opción de configuración del servidor número máximo de subprocesos de trabajo en SQL Server mediante SQL Server Management Studio o Transact-SQL. La opción max worker threads configura el número de subprocesos de trabajo disponibles en SQL Server para procesar solicitudes de consulta, inicio de sesión, cierre de sesión y solicitudes de aplicación similares.

#### SQL Server utiliza los servicios de subprocesos nativos de los sistemas operativos para garantizar las condiciones siguientes:

 - Uno o más subprocesos admiten simultáneamente cada red que SQL Server admite.

 - Un subproceso controla los puntos de control de base de datos.

 - Un grupo de subprocesos controla todos los usuarios.

#### El valor predeterminado de máximo de subprocesos de trabajo es 0. Esto permite a SQL Server configurar automáticamente el número de subprocesos de trabajo en el inicio. El valor predeterminado es el más adecuado para la mayor parte de los sistemas. No obstante, dependiendo de la configuración del sistema, el uso de un valor concreto para máximo de subprocesos de trabajo en ocasiones puede mejorar el rendimiento.

# Limitaciones y restricciones
 - El número real de solicitudes de consulta puede superar el número establecido en número máximo de subprocesos de trabajo, en cuyo caso SQL Server agrupa los subprocesos de trabajo de manera que el siguiente subproceso de trabajo disponible pueda administrar la solicitud. Un subproceso de trabajo se asigna solo a las solicitudes activas y se libera una vez que se ha atendido la solicitud. Esto sucede incluso si la sesión de usuario o la conexión en la que se ha realizado la solicitud permanece abierta.

 - La opción de configuración del servidor Máximo de subprocesos de trabajo no limita todos los subprocesos que pueden generarse en el motor. Los subprocesos del sistema necesarios para tareas como Escritura diferida, Punto de control, Escritura de registro, Service Broker, Administrador de bloqueos u otras se generan fuera de este límite. Los grupos de disponibilidad usan algunos de los subprocesos de trabajo en el límite máximo de subprocesos de trabajo, pero también utilizan subprocesos del sistema (vea Uso de subprocesos por parte de los grupos de disponibilidad). Si se supera el número de subprocesos configurados, la siguiente consulta proporciona información sobre las tareas del sistema que han generado los subprocesos adicionales.

    SQL
~~~sql
SELECT s.session_id,
    r.command,
    r.STATUS,
    r.wait_type,
    r.scheduler_id,
    w.worker_address,
    w.is_preemptive,
    w.STATE,
    t.task_state,
    t.session_id,
    t.exec_context_id,
    t.request_id
FROM sys.dm_exec_sessions AS s
INNER JOIN sys.dm_exec_requests AS r
    ON s.session_id = r.session_id
INNER JOIN sys.dm_os_tasks AS t
    ON r.task_address = t.task_address
INNER JOIN sys.dm_os_workers AS w
    ON t.worker_address = w.worker_address
WHERE s.is_user_process = 0;
~~~

# Recomendaciones
 - Esta opción es avanzada y solo debe cambiarla un administrador de base de datos con experiencia o un profesional certificado de SQL Server. Si sospecha que hay un problema de rendimiento, probablemente no se deba a la disponibilidad de subprocesos de trabajo. Es más probable que la causa esté relacionada con las actividades que ocupan los subprocesos de trabajo y no los liberan. Entre los ejemplos se incluyen consultas de ejecución prolongada o cuellos de botella en el sistema (E/S, bloqueo, tiempos de espera de bloqueo temporal y esperas de red), que provocan consultas de espera prolongada. Lo mejor es buscar la causa principal de un problema de rendimiento antes de cambiar el valor de configuración de máximo de subprocesos de trabajo. Para obtener más información sobre cómo evaluar el rendimiento, vea Supervisión y optimización del rendimiento.

 - La agrupación de subprocesos permite optimizar el rendimiento cuando un gran número de clientes se conecta al servidor. Normalmente, se crea un subproceso del sistema operativo independiente para cada solicitud de la consulta. Sin embargo, cuando hay cientos de conexiones al servidor, el uso de un subproceso por solicitud de consulta puede consumir grandes cantidades de recursos del sistema. La opción de máximo de subprocesos de trabajo permite que SQL Server cree un grupo de subprocesos de trabajo para atender un gran número de solicitudes de consulta, lo que mejora el rendimiento.

 - n la tabla siguiente se muestra el número configurado automáticamente de número máximo de subprocesos de trabajo (cuando el valor se establece en 0) basado en diferentes combinaciones de CPU lógicas, arquitectura de equipo y versiones de SQL Server, mediante la fórmula: Número máximo predeterminado de trabajos + ((CPU lógicas - 4) * Trabajos por CPU).


<table>
<tr>
<td>Número de CPU lógicas</td>
<td>Equipo de 32 bits (hasta SQL Server 2014 (12.x))</td>
<td>Equipo de 64 bits (hasta SQL Server 2016 (13.x) SP1)</td>
<td>Equipo de 64 bits (a partir de SQL Server 2016 (13.x) SP2 y SQL Server 2017 (14.x))</td>
</tr>
<tr>
<td><=4</td>
<td>256</td>
<td>512</td>
<td>512</td>
</tr>
<tr>
<td>8</td>
<td>288</td>
<td>578</td>
<td>576</td>
</tr>
<tr>
<td>16</td>
<td>352</td>
<td>704</td>
<td>704</td>
</tr>
<tr>
<td>32</td>
<td>480</td>
<td>960</td>
<td>960</td>
</tr>
<tr>
<td>64</td>
<td>736</td>
<td>1472</td>
<td>1472</td>
</tr>
<tr>
<td>128</td>
<td>1248</td>
<td>2496</td>
<td>4480</td>
</tr>
<tr>
<td>256</td>
<td>2272</td>
<td>4544</td>
<td>8576</td>
</tr>


</table>


#### Hasta SQL Server 2016 (13.x) con Service Pack 1, los trabajos por CPU solo dependen de la arquitectura (32 bits o 64 bits):

<table>
<tr>
    <td>Número de CPU lógicas</td>
    <td>Equipo de 32 bits 1</td>
    <td>	Equipo de 64 bits</td>
</tr>

<tr>
    <td><=4</td>
    <td>256</td>
    <td>512</td>
</tr>

<tr>
    <td>>4</td>
    <td>256 + ((CPU lógicas - 4) * 8)</td>
    <td>512 2 + ((CPU lógicas - 4) * 16)</td>
</tr>


</table>

# 

#### A partir de SQL Server 2016 (13.x) SP2 y SQL Server 2017 (14.x), los Trabajos por CPU dependen de la arquitectura y el número de procesadores (entre 4 y 64, o superior a 64):

<table>
    <tr>
        <td>Número de CPU lógicas</td>
        <td>Equipo de 32 bits 1</td>
        <td>Equipo de 64 bits</td>
    </tr>
    <tr>
    <td><= 4</td>    
    <td>256</td>    
    <td>512</td>    
</tr>
    </tr>
    <tr>
    <td>> 4 y <= 64</td>    
    <td>256 + ((CPU lógicas - 4) * 8)</td>    
    <td>512 2 + ((CPU lógicas - 4) * 16)</td>    
</tr>
</tr>
    </tr>
    <tr>
    <td>> 64</td>    
    <td>256 + ((CPU lógicas - 4) * 32)</td>    
    <td>512 2 + ((CPU lógicas - 4) * 32)</td>    
</tr>



</table>


#### 1 A partir de SQL Server 2016 (13.x), SQL Server ya no se puede instalar en un sistema operativo de 32 bits. Se muestran los valores de equipo de 32 bits como ayuda para los clientes que ejecutan SQL Server 2014 (12.x) y versiones anteriores. Se recomienda 1024 como número máximo de subprocesos de trabajo para una instancia de SQL Server que se ejecuta en un equipo de 32 bits.

#### 2 A partir de SQL Server 2017 (14.x), el valor de trabajos máximos predeterminados se divide por 2 con menos de 2 GB de memoria.

     Sugerencia

    Para más información sobre el uso de más de 64 CPU lógicas,
     consulte Procedimientos recomendados para ejecutar SQL 
     Server en equipos que tienen más de 64 CPU.

- Si todos los subprocesos de trabajo están activos con consultas de ejecución prolongada, puede parecer que SQL Server no responde hasta que finaliza un subproceso de trabajo y vuelve a estar disponible. Aunque no se trata de un defecto, puede que a veces este comportamiento no sea deseable. Si un proceso parece no responder y no se pueden procesar nuevas consultas, conéctese a SQL Server mediante la conexión de administrador dedicada (DAC) y finalice el proceso. Para impedir este comportamiento, aumente el número máximo de subprocesos de trabajo.

# Permisos
#### De forma predeterminada, todos los usuarios tienen permisos de ejecución en sp_configure sin ningún parámetro o solo con el primero. Para ejecutar sp_configure con ambos parámetros y cambiar una opción de configuración, o para ejecutar la instrucción RECONFIGURE, un usuario debe tener el permiso ALTER SETTINGS en el servidor. Los roles fijos de servidor sysadmin y serveradmin tienen el permiso ALTER SETTINGS de forma implícita.

# Usar SQL Server Management Studio (SSMS)
  1  En el Explorador de objetos, haga clic con el botón derecho en un servidor y seleccione Propiedades.

  2 Seleccione el nodo Procesadores.

  3 En el cuadro Máximo de subprocesos de trabajo, escriba o seleccione un valor entre 128 y 65 535.

    Sugerencia

    Utilice la opción max worker threads para configurar el 
    número de subprocesos de trabajo disponibles para procesos 
    de SQL Server . El valor predeterminado de la opción max 
    worker threads es el óptimo para la mayor parte de los sistemas.

    No obstante, dependiendo de la configuración del sistema,
     el uso de un valor inferior para el máximo de subprocesos
      de trabajo puede mejorar el rendimiento a veces. Para más 
      información, consulte la sección Recomendaciones de este artículo.

# Uso de Transact-SQL
  1 Conéctese con el Motor de base de datos.

  2 En la barra Estándar, seleccione Nueva consulta.

  3 Copie y pegue el ejemplo siguiente en la ventana de consulta y seleccione Ejecutar. En este ejemplo se muestra cómo usar sp_configure para configurar la opción max worker threads en 900.

#### SQL

~~~sql
EXEC sp_configure 'show advanced options', 1;
GO

RECONFIGURE;
GO

EXEC sp_configure 'max worker threads', 900;
GO

RECONFIGURE;
GO
~~~

#### El cambio se aplicará inmediatamente después de ejecutar RECONFIGURE, sin necesidad de reiniciar Motor de base de datos.



# 


# Para aplicar cambios en la configuración de "autogrow max" en SQL Server 2012, es necesario reiniciar el servicio de SQL Server en lugar de reiniciar todo el servidor de Windows.

### Puedes seguir los pasos a continuación para reiniciar el servicio de SQL Server:

### Abre la ventana de servicios: Puedes hacerlo presionando las teclas "Windows + R", escribiendo "services.msc" y presionando Enter.

### Busca el servicio de SQL Server: En la lista de servicios, busca el servicio de SQL Server que corresponde a la instancia en la que deseas realizar el cambio.

### Detén el servicio: Haz clic derecho en el servicio de SQL Server y selecciona "Detener" en el menú contextual. Espera unos segundos para asegurarte de que el servicio se haya detenido por completo.

### Inicia el servicio: Haz clic derecho en el servicio de SQL Server nuevamente y selecciona "Iniciar" en el menú contextual.
# 
##### Después de reiniciar el servicio de SQL Server, la nueva configuración de "autogrow max" se aplicará y estará activa para las bases de datos. No es necesario reiniciar todo el servidor de Windows en este caso.

Recuerda que realizar cambios en la configuración de SQL Server puede tener impacto en la disponibilidad y el rendimiento del servidor, por lo que se recomienda realizar estos cambios en un momento de baja actividad o durante un mantenimiento planificado.


# Query para saber la max/memory que esta apliaca a un servidor Sql Server<a name="querymamemory"></a>
![Max Memory Best Practices](https://soundtrax.typepad.com/.a/6a00d834539b6d69e201a73e0cc9d8970d-pi)
#### La siguiente consulta devuelve información sobre los valores actualmente configurados y el valor actualmente en uso. Esta consulta devolverá resultados independientemente de si la opción "mostrar opciones avanzadas" de sp_configure está habilitada.


~~~sql
SELECT [name], [value], [value_in_use]
FROM sys.configurations
WHERE [name] = 'max server memory (MB)' OR [name] = 'min server memory (MB)';
~~~




# información sobre los estados de cifrado de las bases de datos<a name="cifrado"></a>

#### Este query fue diseñado para obtener información sobre los estados de cifrado de las bases de datos, con una fecha de extracción del 12 de julio de 2023.


~~~sql
SELECT D.name AS 'Database Name'
    ,c.name AS 'Cert Name'
    ,E.encryptor_type AS 'Type'
    ,case
        when E.encryption_state = 3 then 'Encrypted'
        when E.encryption_state = 2 then 'In Progress'
        else 'Not Encrypted'
    end as state,
    E.encryption_state
    , E.key_algorithm
    , E.key_length
FROM sys.dm_database_encryption_keys E
    right join sys.databases D on D.database_id = E.database_id
    left join sys.certificates c ON E.encryptor_thumbprint=c.thumbprint
where C.name is not null
~~~

# 

# Shrink DB<a name="shrinkfilebpd"></a> 

~~~sql
/*
Entregado por RAINIERO MARTE.
 Viernes 14 de julio del 2023.
 Este query es el mas eficiente que tengo a nivel 
 reducir el espacio en mdf
*/


SET NOCOUNT ON
DECLARE @ACTUAL_SIZE INT
DECLARE @FINAL_SIZE INT
DECLARE @FILE_NAME NVARCHAR(100)

SET @ACTUAL_SIZE = 155540
SET @FINAL_SIZE = 104000 --37705
SET @FILE_NAME = N'MCSRDB'


WHILE NOT @ACTUAL_SIZE < @FINAL_SIZE
     BEGIN
           DBCC SHRINKFILE (@FILE_NAME, @ACTUAL_SIZE);
           PRINT 'ACTUAL SIZE: ' + CONVERT(varchar(20),@ACTUAL_SIZE) + ' MB';
           SET @ACTUAL_SIZE = @ACTUAL_SIZE - 300
     END
SET NOCOUNT OFF
go
~~~


# cuanto ocupan mis archivos de base de datos y cuanto espacio puedo reducir<a name="espaciodbLibres"></a> 

~~~sql
select
       name as [Nombre]
       , size/128.0 as [Tamano en MB]
       ,Cast(fileproperty(name, 'SpaceUsed') as int) - size/128.0  AS [Espacio LIbre en MB]
from
       sys.database_files
where
       type >= 0; -- Filtra los archivos Mdf
~~~

# 




## Para obtener los datos en el mismo formato que te muestran en el sistema, y no perder el espacio utilizado por los índices, se puedes utilizar el siguiente script,<a name="espacidiscobpd"><a>


~~~sql
SELECT a3.name + '.' + a2.name AS [name], 
   a1.rows AS [rows], 
   (a1.reserved + ISNULL(a4.reserved, 0)) * 8 AS [Reserved KB], 
   a1.data * 8 AS [Data KB], 
   (CASE

        WHEN(a1.used + ISNULL(a4.used, 0)) > a1.data

        THEN(a1.used + ISNULL(a4.used, 0)) - a1.data

        ELSE 0
    END) * 8 AS [Index_size KB], 
   (CASE
        WHEN(a1.reserved + ISNULL(a4.reserved, 0)) > a1.used


        THEN(a1.reserved + ISNULL(a4.reserved, 0)) - a1.used
        ELSE 0
    END) * 8 AS [unused KB], 
   CONVERT(DECIMAL(18, 2), (((a1.reserved + ISNULL(a4.reserved, 0)) * 8) - ((CASE
    WHEN(a1.reserved + ISNULL(a4.reserved, 0)) > a1.used
    THEN(a1.reserved + ISNULL(a4.reserved, 0)) - a1.used
    ELSE 0
    END) * 8)) / 1024.0 / 1024.0) AS [Table_used_Space GB]
FROM
(
SELECT ps.object_id, 
       SUM(CASE
               WHEN(ps.index_id < 2)
               THEN row_count
               ELSE 0
           END) AS [rows], 
       SUM(ps.reserved_page_count) AS reserved, 
       SUM(CASE
               WHEN(ps.index_id < 2)
               THEN(ps.in_row_data_page_count + ps.lob_used_page_count + ps.row_overflow_used_page_count)
               ELSE(ps.lob_used_page_count + ps.row_overflow_used_page_count)
           END) AS data, 
       SUM(ps.used_page_count) AS used
FROM sys.dm_db_partition_stats ps
GROUP BY ps.object_id
) AS a1
LEFT OUTER JOIN
(
SELECT it.parent_id, 
       SUM(ps.reserved_page_count) AS reserved, 
       SUM(ps.used_page_count) AS used
FROM sys.dm_db_partition_stats ps
     INNER JOIN sys.internal_tables it ON(it.object_id = ps.object_id)
WHERE it.internal_type IN(202, 204)
GROUP BY it.parent_id
) AS a4 ON(a4.parent_id = a1.object_id)
INNER JOIN sys.all_objects a2 ON(a1.object_id = a2.object_id)
INNER JOIN sys.schemas a3 ON(a2.schema_id = a3.schema_id)
WHERE a2.type != N'S'
  AND a2.type != N'IT'

ORDER BY [Table_used_Space GB] DESC, [rows] desc ;
~~~

#

## **Título: Configuración para Habilitar Conexiones a Servidores de Internet en Agentes Foglight**<a name="foglight1"></a>

<img src="https://www.quest.com/images/patterns/ZigZag/6-column/foglight-evolve-monitor.jpg?format=jpg&name=large" alt="JuveR" width="800px">

### **Objetivo:**
#### Este documento describe los pasos necesarios para habilitar las conexiones a servidores de Internet Banking en los agentes Foglight, permitiendo una comunicación exitosa con recursos en línea. Estos pasos son útiles para resolver problemas de conectividad y deben seguirse con precaución.

**Pasos a Seguir:**

1. **Ubicación del Archivo de Configuración:**
   Navegue a la ubicación del archivo de configuración `java.security` en su sistema. El archivo se encuentra en la siguiente ruta:
   ~~~cmd
   D:\Quest\Foglight Agent Manager\jre\1.8.0.352\jre\lib\security
   ~~~ 

2. **Modificar el Archivo `java.security`:**
   - Localice el archivo `java.security` en la ubicación mencionada anteriormente.
   - Abra el archivo utilizando un editor de texto apropiado.

3. **Habilitar Protocolos de Seguridad Necesarios:**
   Busque la línea que contiene la configuración de protocolos de seguridad deshabilitados. Debería verse similar a lo siguiente:
   
   ~~~java
   jdk.tls.disabledAlgorithms=SSLv3, TLSv1, TLSv1.1, RC4, DES, MD5withRSA, \
       DH keySize < 1024, EC keySize < 224, 3DES_EDE_CBC, anon, NULL, \
       include jdk.disabled.namedCurves
   ~~~
   Elimine **TLSv1 y TLSv1.1** de la lista para permitir conexiones utilizando estos protocolos.

4. **Guardar los Cambios y Cerrar el Archivo:**
   Después de realizar la modificación, guarde los cambios en el archivo **java.security** y cierre el editor de texto.

5. **Reiniciar el Agente de Foglight:**
   Reinicie el servicio Foglight en los agentes donde realizó la modificación. Esto permitirá que los cambios surtan efecto y se establezcan las conexiones correctamente.

## **Importante:**
- Estos pasos deben seguirse con precaución y solo deben aplicarse si se enfrenta a problemas de conectividad con servidores de Internet Banking.
- Realice una copia de seguridad del archivo `java.security` antes de realizar cualquier modificación para evitar pérdida de datos o configuraciones incorrectas.
- Asegúrese de comprender las implicaciones de seguridad al habilitar protocolos previamente deshabilitados.

## **Conclusion:**
#### Siguiendo estos pasos, podrá habilitar conexiones a a los servidores de Internet BANKING en los agentes Foglight, mejorando la conectividad y asegurando una comunicación fluida con recursos en línea. Recuerde que estos cambios deben aplicarse con precaución y se recomienda mantener un registro de las modificaciones realizadas para futuras referencias. Ademas los mismos solo afectanran los servidores de INTERNET BANKING  en caso de los mismo no tener comunicacion.




# 

<!-- 
<--

# Defragmentación, al rescate (ONLINE=ON)<a name="desfragmentacionalrescate2"></a>
![](https://greyphillips.com/Guides/assets/img/Database_Maintenance.png)
#### Para evitar el deterioro del rendimiento en nuestro servidor, deberemos mantener nuestros índices en un estado de fragmentación óptimo. Lo podremos lograr sencillamente siguiendo estos pasos.

#### Primer paso: detectar fragmentación en los índices de tu base de datos. Para ello, nos basaremos en la vista de sistema sys.dm_db_index_physical_stats, que encapsularemos en la siguiente query:
# 


~~~sql
SELECT DB_NAME(database_id) AS DatabaseName, database_id, 
OBJECT_NAME(ips.object_id) AS TableName, ips.object_id,
i.name AS IndexName, i.index_id, p.rows,
ips.partition_number, index_type_desc, alloc_unit_type_desc, index_depth, index_level,
avg_fragmentation_in_percent, fragment_count, 
avg_fragment_size_in_pages, page_count,

avg_page_space_used_in_percent, record_count, 
ghost_record_count, version_ghost_record_count, 
min_record_size_in_bytes,
max_record_size_in_bytes, avg_record_size_in_bytes, 
forwarded_record_count
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL , NULL, 'LIMITED') ips
INNER JOIN sys.indexes i ON i.object_id = ips.object_id AND i.index_id = ips.index_id
INNER JOIN sys.partitions p ON p.object_id = i.object_id AND p.index_id = i.index_id
WHERE avg_fragmentation_in_percent > 10.0 AND ips.index_id > 0 AND page_count > 1000
ORDER BY avg_fragmentation_in_percent DESC
~~~
# 


#### Segundo paso: ejecutar un script para defragmentar los índices con problemas. El script determina si hay que hacer un Reorganize o un Rebuild para cada índice:

#### En esta versión modificada del script, se ha agregado la opción WITH (ONLINE = ON) en las instrucciones ALTER INDEX para que las operaciones se realicen en línea, lo que minimizará el bloqueo de las tablas y permitirá que las consultas y las inserciones continúen sin interrupciones. 

####  También se ha incluido una condición adicional para decidir si se realiza una reconstrucción en línea basada en el tamaño de la tabla y el nivel de fragmentación. Las reorganizaciones se seguirán realizando en línea. 

#### ***Debemos tener en cuenta que la disponibilidad de la opción ONLINE puede depender de la edición de SQL Server que estemos utilizando.***
#####   ***Este query solo funciona con Sql Server Interprise Edition.***
# 


~~~sql
-- Ensure a USE statement has been executed first.
-- Asegurarse de que se haya ejecutado una instrucción USE primero.
SET NOCOUNT ON;
DECLARE @objectid INT;
DECLARE @indexid INT;
DECLARE @partitioncount BIGINT;
DECLARE @schemaname NVARCHAR(130);
DECLARE @objectname NVARCHAR(130);
DECLARE @indexname NVARCHAR(130);
DECLARE @partitionnum BIGINT;
DECLARE @partitions BIGINT;
DECLARE @frag FLOAT;
DECLARE @command NVARCHAR(4000);

-- Condición para seleccionar tablas e índices de la función sys.dm_db_index_physical_stats
-- y convertir los IDs de objetos e índices en nombres.
SELECT
    object_id AS objectid,
    index_id AS indexid,
    partition_number AS partitionnum,
    avg_fragmentation_in_percent AS frag
INTO #work_to_do
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, 'LIMITED')
WHERE avg_fragmentation_in_percent > 10.0 AND index_id > 0 AND
page_count > 1000;

-- Declarar el cursor para la lista de particiones a procesar.
DECLARE partitions CURSOR FOR SELECT * FROM #work_to_do;

-- Abrir el cursor.
OPEN partitions;

-- Loop a través de las particiones.
WHILE (1=1)
BEGIN
    FETCH NEXT
    FROM partitions
    INTO @objectid, @indexid, @partitionnum, @frag;
    IF @@FETCH_STATUS < 0 BREAK;

    SELECT @objectname = QUOTENAME(o.name), @schemaname = QUOTENAME(s.name)
    FROM sys.objects AS o
    JOIN sys.schemas AS s ON s.schema_id = o.schema_id
    WHERE o.object_id = @objectid;

    SELECT @indexname = QUOTENAME(name)
    FROM sys.indexes
    WHERE  object_id = @objectid AND index_id = @indexid;

    SELECT @partitioncount = COUNT(*)
    FROM sys.partitions
    WHERE object_id = @objectid AND index_id = @indexid;

    -- 30 es un punto de decisión arbitrario para cambiar entre reorganización y reconstrucción.
    IF @frag < 30.0
        SET @command = N'ALTER INDEX ' + @indexname + N' ON ' + 
        @schemaname + N'.' + @objectname + N' REORGANIZE';
    ELSE IF @frag >= 30.0 AND @partitioncount <= 1
        SET @command = N'ALTER INDEX ' + @indexname + N' ON ' + 
        @schemaname + N'.' + @objectname + N' REBUILD WITH (ONLINE = ON)';
    ELSE IF @frag >= 30.0 AND @partitioncount > 1
        SET @command = N'ALTER INDEX ' + @indexname + N' ON ' + 
        @schemaname + N'.' + @objectname + N' REBUILD PARTITION=' + 
        CAST(@partitionnum AS NVARCHAR(10)) + N' WITH (ONLINE = ON)';

    BEGIN TRY
        EXEC (@command);
        PRINT N'Executed: ' + @command;
    END TRY
    BEGIN CATCH
        PRINT N'Error executing: ' + @command;
        -- Puedes registrar el error o realizar cualquier otra acción aquí si es necesario.
    END CATCH
END;

-- Cerrar y liberar el cursor.
CLOSE partitions;
DEALLOCATE partitions;

-- Eliminar la tabla temporal.
DROP TABLE #work_to_do;
GO

~~~
# 


## defragmentar con intervalos de 10 indices y excluye los que ya fueron leidos para mayor eficiencia


~~~sql
-- Asegurarse de que se haya ejecutado una instrucción USE primero.

SET NOCOUNT ON;
DECLARE @objectid INT;
DECLARE @indexid INT;
DECLARE @partitioncount BIGINT;
DECLARE @schemaname NVARCHAR(130);
DECLARE @objectname NVARCHAR(130);
DECLARE @indexname NVARCHAR(130);
DECLARE @partitionnum BIGINT;
DECLARE @partitions BIGINT;
DECLARE @frag FLOAT;
DECLARE @command NVARCHAR(4000);

-- Condición para seleccionar tablas e índices de la función sys.dm_db_index_physical_stats

-- y convertir los IDs de objetos e índices en nombres.

--create table filtrarIndices

--(

-- indice  int

--)

 

 

declare @datos table
(
id int
,indexs int
,partic int
,frag float
)
 

 

    BEGIN TRY
        DROP TABLE #work_to_do;
    END TRY
    BEGIN CATCH
        PRINT N'Error executing: '
        -- Puedes registrar el error o realizar cualquier otra acción aquí si es necesario.
    END CATCH

 

declare @guardar int;

DECLARE @TOTAL VARCHAR(50)
 

while exists (
SELECT  top 10
    object_id AS objectid,
    index_id AS indexid,
    partition_number AS partitionnum,
    avg_fragmentation_in_percent AS frag
--INTO #work_to_do
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, 'LIMITED')
WHERE avg_fragmentation_in_percent > 60.0 AND index_id > 0 AND
page_count > 1000
and  object_id  not in
(
select id from @datos
)
and  object_id  not in
(
select  indice from filtrarIndices
)

)
begin
SELECT top 10
    object_id AS objectid,
    index_id AS indexid,
    partition_number AS partitionnum,
    avg_fragmentation_in_percent AS frag
INTO #work_to_do
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, 'LIMITED')
WHERE avg_fragmentation_in_percent > 60.0 AND index_id > 0 AND
page_count > 1000
and  object_id  not in
(
    select id from @datos
)
and  object_id  not in
(
    select indice from filtrarIndices
)
;

-- Declarar el cursor para la lista de particiones a procesar.
DECLARE partitions CURSOR FOR SELECT * FROM #work_to_do;

-- Abrir el cursor.
OPEN partitions;

-- Loop a través de las particiones.
WHILE (1=1)
BEGIN
    FETCH NEXT
    FROM partitions
    INTO @objectid, @indexid, @partitionnum, @frag;
    IF @@FETCH_STATUS < 0 BREAK;
    SELECT @objectname = QUOTENAME(o.name), @schemaname = QUOTENAME(s.name)
    FROM sys.objects AS o
    JOIN sys.schemas AS s ON s.schema_id = o.schema_id
    WHERE o.object_id = @objectid;
 

    SELECT @indexname = QUOTENAME(name)

    FROM sys.indexes

    WHERE  object_id = @objectid AND index_id = @indexid;

    SELECT @partitioncount = COUNT(*)
    FROM sys.partitions
    WHERE object_id = @objectid AND index_id = @indexid;
 

    -- 30 es un punto de decisión arbitrario para cambiar entre reorganización y reconstrucción.

    IF @frag < 30.0
        SET @command = N'ALTER INDEX ' + @indexname + N' ON ' +
        @schemaname + N'.' + @objectname + N' REORGANIZE';
    ELSE IF @frag >= 30.0 AND @partitioncount <= 1
        SET @command = N'ALTER INDEX ' + @indexname + N' ON ' +
        @schemaname + N'.' + @objectname + N' REBUILD WITH (ONLINE = ON)';
    ELSE IF @frag >= 30.0 AND @partitioncount > 1
        SET @command = N'ALTER INDEX ' + @indexname + N' ON ' +
        @schemaname + N'.' + @objectname + N' REBUILD PARTITION=' +
        CAST(@partitionnum AS NVARCHAR(10)) + N' WITH (ONLINE = ON)';

    BEGIN TRY
              set @guardar = null;
        EXEC (@command);
        PRINT N'Executed: ' + @command;
    END TRY
    BEGIN CATCH
        PRINT N'Error executing: ' + @command;
              set @guardar = null;
              set @guardar = @objectid;
              --insert into filtrarIndices values @objectid;
        -- Puedes registrar el error o realizar cualquier otra acción aquí si es necesario.
    END CATCH
       if(@guardar is not null)
       begin
              insert into filtrarIndices values (@guardar);
    end

END;

 

-- Cerrar y liberar el cursor.

CLOSE partitions;
DEALLOCATE partitions;

 

insert into @datos

select * from  #work_to_do

-- Eliminar la tabla temporal.

DROP TABLE #work_to_do;

Set @TOTAL = (select cast( count(*) as varchar(50)) from @datos)

Print 'Defragmentados 10 registros---' + @TOTAL
end
GO
~~~


--> -->

# Para sacar una base de datos de modo restoring solo debemos ejecutar este código.<a name="sacarrestoring"></a>

~~~sql
RESTORE DATABASE nombre WITH RECOVERY;
~~~

# 
## Si estás buscando un script que lea los valores de `-ServerInstance`, `-Database` y `-Query` desde archivos de texto y luego ejecute las consultas utilizando Invoke-Sqlcmd. Aquí tienes un ejemplo de cómo podrías hacerlo en PowerShell:<a name="powershellsqlserver"></a>

1. Crea tres archivos de texto: uno para las instancias de servidor (`server_instances.txt`), otro para las bases de datos (`databases.txt`) y otro para las consultas (`queries.txt`).

2. En cada archivo, coloca un valor por línea correspondiente a las instancias de servidor, bases de datos y consultas respectivamente.

3. Luego, puedes usar el siguiente script en PowerShell para leer los valores de los archivos y ejecutar las consultas:

~~~Powershell
$serverInstances = Get-Content -Path "server_instances.txt"
$databases = Get-Content -Path "databases.txt"
$queries = Get-Content -Path "queries.txt"

for ($i = 0; $i -lt $serverInstances.Length; $i++) {
    $serverInstance = $serverInstances[$i]
    $database = $databases[$i]
    $query = $queries[$i]

    Write-Host "Executing query on ServerInstance: $serverInstance, Database: $database"
    
    Invoke-Sqlcmd -ServerInstance $serverInstance -Database $database -Query $query
}
~~~

#### Este script lee los valores de los archivos de texto línea por línea y ejecuta las consultas con los valores correspondientes de `-ServerInstance`, `-Database` y `-Query`. Asegúrate de que los archivos de texto tengan el mismo número de líneas y que las líneas correspondientes en los archivos contengan información coherente entre sí.

#### Recuerda que este script asume que las rutas a los archivos de texto son los mismos directorios desde donde se ejecuta el script. Si los archivos están en diferentes ubicaciones, asegúrate de ajustar las rutas en la función `Get-Content`.


# 


## Para obtener una lista de todas las tablas de todas las bases de datos en un servidor SQL Server, puedes utilizar la siguiente consulta:<a name="listadbytablasserver"></a>
# 
<div>
<p style = 'text-align:center;'>
<img src="https://allmastersolutions.com/wp-content/uploads/2017/01/2017-01-19-Ejecutar-consultas-SQL-Din%C3%A1micas.png?format=jpg&name=small" alt="JuveYell" width="700px">
</p>
</div>


# 
~~~sql
DECLARE @DatabaseName NVARCHAR(128)
DECLARE @SQL NVARCHAR(MAX)

-- Crear una tabla temporal para almacenar los resultados
CREATE TABLE #TableList (
    ServerName NVARCHAR(128),
    InstanceName NVARCHAR(128),
    DatabaseName NVARCHAR(128),
    SchemaName NVARCHAR(128),
    TableName NVARCHAR(128)
)

-- Cursor para recorrer todas las bases de datos
DECLARE db_cursor CURSOR FOR
SELECT name
FROM sys.databases
WHERE state_desc = 'ONLINE' AND database_id > 4

-- Recorrer las bases de datos y obtener las tablas
OPEN db_cursor
FETCH NEXT FROM db_cursor INTO @DatabaseName

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @SQL = 'USE [' + @DatabaseName + '];
                INSERT INTO #TableList (ServerName, InstanceName, DatabaseName, SchemaName, TableName)
                SELECT @@SERVERNAME, CAST(SERVERPROPERTY(''InstanceName'') AS NVARCHAR(128)), ''' + @DatabaseName + ''', s.name, t.name
                FROM [' + @DatabaseName + '].sys.tables t
                INNER JOIN [' + @DatabaseName + '].sys.schemas s ON t.schema_id = s.schema_id;'

    EXEC sp_executesql @SQL

    FETCH NEXT FROM db_cursor INTO @DatabaseName
END

-- Cerrar el cursor y eliminarlo
CLOSE db_cursor
DEALLOCATE db_cursor

-- Obtener los resultados
SELECT * FROM #TableList
ORDER BY ServerName, InstanceName, DatabaseName, TableName

-- Eliminar la tabla temporal
DROP TABLE #TableList

~~~
# 
### Esta consulta utiliza un cursor para recorrer todas las bases de datos en el servidor (excluyendo las bases de datos del sistema) y luego ejecuta una consulta dinámica en cada base de datos para obtener las tablas y sus nombres de esquema. Los resultados se almacenan en una tabla temporal `#TableList` y finalmente se muestran. Recuerda que el uso excesivo de cursores y consultas dinámicas puede afectar el rendimiento, por lo que debes considerar esta consulta con cuidado, especialmente en entornos de producción con muchas bases de datos y tablas.

# 

## Aquí tenemos  una consulta simple que lista todas las bases de datos en un servidor SQL Server:<a name="listabasedatos"></a>
![](https://4.bp.blogspot.com/-VetwnKIZI_g/U6WJWoQ4m3I/AAAAAAAAAXI/r2tB34lk6bU/s1600/db.jpg)
# 
~~~sql
DECLARE @ServerName NVARCHAR(128) = @@SERVERNAME
DECLARE @InstanceName NVARCHAR(128) = CAST(SERVERPROPERTY('InstanceName') AS NVARCHAR(128))

SELECT @ServerName AS ServerName, @InstanceName AS InstanceName, name AS DatabaseName
FROM sys.databases
WHERE state_desc = 'ONLINE' AND database_id > 4
ORDER BY name;

~~~
# 
#### Esta consulta selecciona el nombre de todas las bases de datos en el sistema que estén en estado en línea (`state_desc = 'ONLINE'`) y tengan un `database_id` mayor que 4. Los valores de `database_id` 1 a 4 corresponden a bases de datos del sistema, por lo que se excluyen de la lista.



# 

## Sacar servidores con sus bases de datos usando PowerShell<a name="powershellserverydbhtml"></a>
# 
#### Este código ejecutará la consulta proporcionada en cada uno de los servidores en el archivo server_instances.txt y mostrará los resultados. Cabe mencionar que este código solo muestra los resultados en la consola de PowerShell. Si deseas adaptarlo para generar archivos HTML como antes, puedes usar la estructura y el estilo que hemos discutido en las respuestas anteriores.
# 
~~~sql
#==========================================================================================================#
#Creado por Alejandro Jimenez Rosa                                                                         #
#Fecha inicio Agosto 18 2023                                                                               #
#Esto para resolver problemas de extraer todos los servidores de bases de datos que existen en el banco    #
#con su respectivas bases de datos.                                                                        #
#Esta tarea duraria mas o menos 20 dias dedicando 10 horas diarias si se realiza de forma manual.          #
#==========================================================================================================#

$serverInstances = Get-Content -Path "C:\PWtablas\server_instances.txt"

$databases = "master"

$queries = "DECLARE @ServerName NVARCHAR(128) = @@SERVERNAME DECLARE @InstanceName NVARCHAR(128) = CAST(SERVERPROPERTY('InstanceName') AS NVARCHAR(128))  SELECT @ServerName AS ServerName, @InstanceName AS InstanceName, name AS DatabaseName FROM sys.databases WHERE state_desc = 'ONLINE' AND database_id > 4 ORDER BY name;"

$htmlFilePath = "C:\PWtablas\html\ServidoresyBasedatosytablasHtml_$(Get-Date -Format 'yyyyMMdd_HHmmss').html"
$notFoundFilePath = "C:\PWtablas\html\ServidoresNoEncontrados_$(Get-Date -Format 'yyyyMMdd_HHmmss').html"

$blueColor = "#1E3D5C"
$whiteColor = "#FFFFFF"

$htmlHeader = @"
<!DOCTYPE html>
<html>
<head>
<style>
    body {
        font-family: Arial, sans-serif;
    }
    h2 {
        color: $whiteColor;
        background-color: $blueColor;
        padding: 10px;
    }
    table {
        border-collapse: collapse;
        width: 100%;
    }
    th {
        background-color: $blueColor;
        color: $whiteColor;
        border: 1px solid black;
        padding: 8px;
        text-align: left;
    }
    td {
        border: 1px solid black;
        padding: 8px;
        text-align: left;
    }
</style>
</head>
<body>
"@

$htmlFooter = @"
</body>
</html>
"@

$htmlResults = @()

for ($i = 0; $i -lt $serverInstances.Length; $i++) {
    $serverInstance = $serverInstances[$i]
    
    $result = Invoke-Sqlcmd -ServerInstance $serverInstance -Database $databases -Query $queries -ErrorAction SilentlyContinue
    if ($result) {
        $htmlResults += $result
    }
    else {
        Write-Host "Failed to execute query on ServerInstance: $serverInstance"
    }
}

# Remove duplicates from $htmlResults
$htmlResults = $htmlResults | Select-Object -Property ServerName, InstanceName, DatabaseName -Unique

# Find servers not read
$notFoundServers = Compare-Object $serverInstances $htmlResults.ServerName | Where-Object { $_.SideIndicator -eq "<=" } | Select-Object -ExpandProperty InputObject

$htmlContent = $htmlHeader
$htmlContent += "<h2>Bases de datos Por Servidor del Banco Popular Dominicano</h2>"
$htmlContent += "<table>"
$htmlContent += "<tr><th>Servidor</th><th>Instancia</th><th>Base de Datos</th></tr>"
$htmlContent += $htmlResults | ForEach-Object {
    "<tr><td>$($_.ServerName)</td><td>$($_.InstanceName)</td><td>$($_.DatabaseName)</td></tr>"
}
$htmlContent += "</table>"
$htmlContent += $htmlFooter

$notFoundContent = $htmlHeader
$notFoundContent += "<h2>Servidores no encontrados</h2>"
if ($notFoundServers.Count -gt 0) {
    $notFoundContent += "<ul>"
    foreach ($server in $notFoundServers) {
        $notFoundContent += "<li>$server</li>"
    }
    $notFoundContent += "</ul>"
} else {
    $notFoundContent += "<p>No se encontraron servidores no leídos.</p>"
}
$notFoundContent += $htmlFooter

$htmlContent | Set-Content -Path $htmlFilePath -Force
$notFoundContent | Set-Content -Path $notFoundFilePath -Force

Write-Host "Proceso finalizado. Archivos HTML generados:"
Write-Host $htmlFilePath
Write-Host $notFoundFilePath

~~~
# Sacar todos los Jobs de un sevidor Sql Server para migralos a otro<a name="migrarjobs"><a/>

##  Generar los scripts de los trabajos en tu servidor SQL Server. Recuerda siempre realizar pruebas en un entorno controlado antes de aplicar cambios en un entorno de producción.
# 
~~~sql
USE msdb;

DECLARE @Script NVARCHAR(MAX) = '';

SELECT @Script = @Script + 
    'EXEC msdb.dbo.sp_add_job ' +
    '@job_name=N''' + name + ''', ' +
    '@enabled=' + CASE WHEN enabled = 1 THEN '1' ELSE '0' END + ';' + CHAR(13) + CHAR(10) +
    -- Aquí puedes agregar más parámetros según tus necesidades
    -- ...
    'EXEC msdb.dbo.sp_add_jobstep ' +
    '@job_name=N''' + name + ''', ' +
    '@step_name=N''Step 1'', ' +
    -- Aquí puedes agregar más parámetros de paso según tus necesidades
    ' @subsystem=N''TSQL'', ' +
    '@command=N''' + REPLACE(command, '''', '''''') + ''';' + CHAR(13) + CHAR(10)
FROM dbo.sysjobs
JOIN dbo.sysjobsteps ON sysjobs.job_id = sysjobsteps.job_id;

-- Imprimir o guardar el script generado
PRINT @Script;
-- Para guardar en un archivo, usa la siguiente línea:
-- EXEC xp_cmdshell 'echo ' + @Script + ' > C:\Ruta\Archivo.sql'

~~~


## Esto es otro query, en al cual podremos sacar todos los jobs


~~~sql
USE msdb;
set nocount on;
SELECT
    'EXEC msdb.dbo.sp_add_job ' +
    '@job_name=N''' + name + ''', ' +
    '@enabled=' + CASE WHEN enabled = 1 THEN '1' ELSE '0' END + ';' + CHAR(13) + CHAR(10) +
    -- Aquí puedes agregar más parámetros según tus necesidades
    -- ...
    'EXEC msdb.dbo.sp_add_jobstep ' +
    '@job_name=N''' + name + ''', ' +
    '@step_name=N''Step 1'', ' +
    -- Aquí puedes agregar más parámetros de paso según tus necesidades
    ' @subsystem=N''TSQL'', ' +
    '@command=N''' + REPLACE(command, '''', '''''') + ''';' + CHAR(13) + CHAR(10)
FROM dbo.sysjobs
JOIN dbo.sysjobsteps ON sysjobs.job_id = sysjobsteps.job_id
--where name not like '%STOS%'
order by name
~~~


#### Recuerda que ejecutar consultas dinámicas y manipular objetos del sistema debe hacerse con precaución en un entorno de producción. Realiza pruebas en un entorno controlado antes de aplicar este tipo de scripts en un entorno de producción y asegúrate de comprender completamente el impacto que puedan tener en tu sistema.<a name="extraerjobssql"></a>
# 


---

### Cambiar Owner de Múltiples Jobs en SQL Server<a name="13.00"></a>



Este script permite listar los jobs actuales y su dueño (owner) en SQL Server, y cambiar el owner de múltiples jobs utilizando el procedimiento almacenado `sp_manage_jobs_by_login`.

#### Requisitos

Este script debe ejecutarse en el entorno de `msdb`, ya que esta base de datos contiene los detalles de los jobs de SQL Server.

#### Pasos para usar el script

1. **Listar los jobs y el owner actual**

   El siguiente script muestra los jobs que están habilitados en SQL Server junto con su owner (dueño) actual:

   ```sql
   SELECT s.name AS JobName, l.name AS JobOwner, enabled
   FROM msdb..sysjobs s
   LEFT JOIN master.sys.syslogins l ON s.owner_sid = l.sid
   WHERE enabled = 1
   ORDER BY l.name;
   ```

   Esto te permitirá visualizar cuáles jobs tienen un owner específico antes de proceder a realizar cambios.

2. **Cambiar el owner de los jobs**

   Utiliza el siguiente comando para cambiar el owner de los jobs. Debes reemplazar los valores de `@current_owner_login_name` y `@new_owner_login_name` con los usuarios correspondientes.

   ```sql
   USE msdb;
   GO
   EXEC dbo.sp_manage_jobs_by_login
      @action = N'REASSIGN',
      @current_owner_login_name = N'owner anterior',
      @new_owner_login_name = N'Nuevo owner';
   GO
   ```

#### Consideraciones

- Asegúrate de tener los permisos necesarios para ejecutar cambios sobre los jobs en SQL Server.
- Este script solo cambiará el owner de los jobs que tienen el `@current_owner_login_name` especificado.
- Si tienes que realizar estos cambios en un entorno productivo, se recomienda probar primero en un entorno de desarrollo o staging.

---










# 
# 

Aquí te presento una estructura de la documentación para solucionar problemas de jobs que no se pueden eliminar en SQL Server, incluyendo los ejemplos de código y comentarios. Puedes usar este formato para tu repositorio de GitHub:

---

# Solución de Problemas con Jobs en SQL Server que No Se Dejan Eliminar

## Descripción del Problema

A veces en SQL Server, los jobs que se configuran a través de planes de mantenimiento pueden fallar al intentar eliminarlos por medios convencionales, ya sea por corrupción en las entradas relacionadas en las tablas del sistema o por dependencias incorrectamente gestionadas en la base de datos `msdb`. Este documento proporciona algunos ejemplos prácticos para eliminar jobs problemáticos que no se pueden remover de manera convencional.

### Índice

1. [Consulta de subplanes asociados a un Job](#14.1)
2. [Eliminación de subplanes asociados a un Job](#14.2)
3. [Comando para eliminar un job específico](#14.3)
4. [Eliminación de registros en el log de mantenimiento](#14.4)
5. [Verificación de logs de mantenimiento](#14.5)

---

## 1. Consulta de subplanes asociados a un Job<a name="14.1"></a>

Este código permite verificar si un subplan de mantenimiento está asociado a un Job específico en la tabla `sysmaintplan_subplans`.

```sql
-- Consulta de subplanes asociados a un Job en particular
SELECT * 
FROM msdb.dbo.sysmaintplan_subplans 
WHERE job_id = '056064f0-19ff-4a21-a2ca-0ea72d7f7dc4';
```

### Explicación:

- `msdb.dbo.sysmaintplan_subplans`: Esta tabla contiene los subplanes de mantenimiento que están vinculados a los jobs.
- `job_id`: El identificador único (UUID) del Job problemático.

---

## 2. Eliminación de subplanes asociados a un Job<a name="14.2"></a>

Si deseas eliminar un subplan de mantenimiento asociado a un Job específico, puedes usar la siguiente instrucción:

```sql
-- Eliminar subplanes asociados a un Job
DELETE FROM msdb.dbo.sysmaintplan_subplans 
WHERE job_id = '056064f0-19ff-4a21-a2ca-0ea72d7f7dc4';
```

### Explicación:

- El comando `DELETE` eliminará las filas de la tabla `sysmaintplan_subplans` asociadas al `job_id` especificado, lo que puede desbloquear la eliminación del Job.

---

## 3. Comando para eliminar un Job específico<a name="14.3"></a>

Si el Job sigue sin poder eliminarse después de eliminar el subplan, puedes intentar con este procedimiento almacenado del sistema:

```sql
-- Eliminar un Job específico utilizando su nombre
EXEC msdb.dbo.sp_delete_job @job_name = 'STOS_Update Statistics';
```

### Explicación:

- `sp_delete_job`: Es un procedimiento almacenado que elimina un job con el nombre especificado.
- `@job_name`: El nombre del job que se desea eliminar. Asegúrate de proporcionar el nombre correcto.

---

## 4. Eliminación de registros en el log de mantenimiento<a name="14.4"></a>

Es posible que los registros en el log de mantenimiento también estén evitando la eliminación completa del Job. Usa este código para eliminar esos registros:

```sql
-- Eliminar registros en el log de mantenimiento asociados al subplan
DELETE FROM msdb.dbo.sysmaintplan_log 
WHERE subplan_id = 'FE31FD6B-516E-4F05-A4CF-126D2A7D1F3E';
```

### Explicación:

- `msdb.dbo.sysmaintplan_log`: Esta tabla contiene los logs de ejecución de subplanes de mantenimiento.
- `subplan_id`: El identificador del subplan cuyos registros se desean eliminar.

---

## 5. Verificación de logs de mantenimiento<a name="14.5"></a>

Finalmente, puedes verificar los logs relacionados con los subplanes de mantenimiento usando el siguiente código:

```sql
-- Consulta de los logs de mantenimiento
SELECT * 
FROM msdb.dbo.sysmaintplan_log;
```

### Explicación:

- Esta consulta te permitirá ver los registros almacenados en el log de los planes de mantenimiento para obtener más detalles sobre el subplan.

---

## Conclusión

Este documento proporciona instrucciones claras y directas para solucionar el problema de eliminar jobs problemáticos en SQL Server. Si bien estos pasos deben realizarse con precaución, pueden ser muy útiles para la administración de jobs y mantenimiento de bases de datos.

---



















# 
# 



## Determinar si un Nodo es primario o secundario en un AlwaysOn<a name="queestestenodoAO"></a>
#### En un grupo de disponibilidad de AlwaysOn en SQL Server, los roles de los servidores se denominan "nodo primario" y "nodo secundario". Puedes utilizar la siguiente consulta en el servidor SQL para determinar si un servidor específico es el nodo primario o el nodo secundario en un grupo de disponibilidad AlwaysOn:
# 
![](https://docs.vmware.com/es/vRealize-Operations/8.10/com.vmware.vcom.refarch.doc/images/GUID-8B25CDAE-3FC0-4F16-A271-838BFD3B7DDE-high.png)
~~~sql
SELECT
    ags.name AS [AvailabilityGroupName],
       arcs.replica_server_name,
    CASE
        WHEN adr.role_desc = 'PRIMARY' THEN 'Nodo Primario'
        WHEN adr.role_desc = 'SECONDARY' THEN 'Nodo Secundario'
        ELSE 'Desconocido'
    END AS [Role]
FROM sys.availability_groups AS ags
INNER JOIN sys.dm_hadr_availability_replica_states AS ar
    ON ags.group_id = ar.group_id
INNER JOIN sys.dm_hadr_availability_replica_cluster_states AS arcs
    ON ar.replica_id = arcs.replica_id
INNER JOIN sys.dm_hadr_availability_replica_states AS adr
    ON ar.replica_id = adr.replica_id
~~~

#### Esta consulta consulta las vistas del sistema relacionadas con AlwaysOn para obtener información sobre el estado y el rol de las réplicas en el grupo de disponibilidad. La columna "Role" mostrará si el servidor es el nodo primario o secundario.

# 
## como puedo saber si un servidor sql server alwaysOn hizo failover y cuando lo hizo<a name="failover"></a>
# 
![](https://www.manageengine.com/privileged-access-management/help/images/Failover-service.png)
#### Para saber si un servidor SQL Server Always On ha realizado un failover y cuándo lo hizo, puedes utilizar varias opciones, que incluyen el uso de consultas en SQL Server Management Studio (SSMS) y el monitoreo de eventos en el Visor de Eventos de Windows. Aquí hay un enfoque general para lograrlo:
#
### Consulta en SSMS:

#### Puedes utilizar consultas en SQL Server Management Studio para obtener información sobre el estado de la réplica y detectar si ha ocurrido un failover. Esto te proporcionará detalles sobre la última vez que ocurrió un failover. Ejecuta las siguientes consultas en la base de datos maestra del servidor Always On:

#  
~~~sql
SELECT
    ag.name AS 'AvailabilityGroupName',
       adc.is_primary_replica, adc.synchronization_health_desc,adc.database_state_desc,
    --ar.replica_server_name AS 'CurrentPrimaryReplica',
       ar.operational_state_desc,
    adc1.database_name AS 'DatabaseName',
    --adc1.synchronization_state_desc AS 'SyncState'
       adc.synchronization_state_desc
FROM sys.dm_hadr_database_replica_states AS adc
JOIN sys.availability_databases_cluster AS adc1 ON adc.group_id = adc.group_id
JOIN sys.availability_groups AS ag ON adc.group_id = ag.group_id
JOIN sys.dm_hadr_availability_replica_states AS ar ON adc.replica_id = ar.replica_id
WHERE adc.is_local = 1;
~~~


#### La columna role_desc te indicará si el servidor es el principal ("PRIMARY") o el secundario ("SECONDARY"), y la columna failure_state_desc te dará información sobre cualquier estado de falla.

### ***Visor de Eventos de Windows:***

#### También puedes verificar el Visor de Eventos de Windows para detectar eventos relacionados con los cambios de estado y los failovers de Always On. Los eventos relevantes se registrarán en el registro de aplicaciones.

### ***Abre el Visor de Eventos de Windows.***
 -  Navega a "Registros de Windows" > "Aplicación".
 - En la vista "Detalles", busca eventos con la fuente "SQLSERVERAGENT" y el ID de evento 208.
- Los eventos con ID 208 indican cambios de estado en grupos de disponibilidad, lo que incluye los eventos de failover. Estos eventos también contendrán información sobre la fecha y hora en que ocurrió el failover.

####  Es importante tener en cuenta que el acceso y la comprensión de estos registros pueden variar según la versión de SQL Server que estés utilizando y cómo esté configurado tu entorno. Si estás utilizando herramientas de monitorización de terceros, también podrías obtener información más detallada sobre los cambios de estado y los failovers.

#### Recuerda que la configuración exacta puede variar según tu entorno y la versión de SQL Server que estés utilizando. Siempre es recomendable consultar la documentación oficial de SQL Server para obtener instrucciones específicas para tu caso.

<!-- ======================== -->


## Para obtener información sobre los failovers en SQL Server, puedes consultar el log de errores de SQL Server o las vistas del sistema que contienen información sobre el clúster de conmutación por error. Aquí tienes un ejemplo de cómo puedes hacerlo mediante una consulta en T-SQL para revisar el log de errores y extraer información relevante sobre los failovers:<a name="failover2"></a>

#### 1. **Usando el Log de Errores de SQL Server**:

~~~sql
EXEC xp_readerrorlog 0, 1, N'Failover';
~~~

### Esta consulta ejecuta el procedimiento almacenado `xp_readerrorlog`, que lee el log de errores de SQL Server buscando la palabra clave "Failover". Esto te dará una lista de entradas en el log que contienen la palabra "Failover", las cuales generalmente incluyen eventos de conmutación por error.

#### 2. **Filtrando los Logs para Conmutaciones por Error**:

~~~sql
CREATE TABLE #ErrorLog (
    LogDate DATETIME,
    ProcessInfo NVARCHAR(50),
    Text NVARCHAR(MAX)
);

INSERT INTO #ErrorLog
EXEC xp_readerrorlog 0, 1, N'Failover';

SELECT LogDate, Text
FROM #ErrorLog
WHERE Text LIKE '%Failover%';

DROP TABLE #ErrorLog;
~~~

#### Este script crea una tabla temporal para almacenar las entradas del log de errores, inserta las entradas que contienen la palabra "Failover" y luego selecciona las columnas `LogDate` y `Text` que contienen la información relevante. Finalmente, elimina la tabla temporal.

### 3. **Usando las Vistas del Sistema**:

#### Para obtener información de failovers desde vistas del sistema, especialmente si estás usando Always On Availability Groups, puedes consultar la vista `sys.dm_hadr_availability_replica_cluster_nodes` y otras relacionadas:

~~~sql
SELECT 
    ags.name AS 'AGName',
    ar.replica_server_name AS 'ReplicaName',
    harn.node_name AS 'NodeName',
    far.failure_time AS 'FailoverTime',
    far.failure_count AS 'FailureCount',
    far.failure_type_desc AS 'FailureType'
FROM 
    sys.dm_hadr_availability_replica_cluster_nodes AS harn
JOIN 
    sys.availability_groups AS ags ON harn.group_id = ags.group_id
JOIN 
    sys.availability_replicas AS ar ON ags.group_id = ar.group_id
JOIN 
    sys.dm_hadr_failure_report AS far ON ar.replica_id = far.replica_id
ORDER BY 
    far.failure_time DESC;
~~~

#### Este script une varias vistas del sistema relacionadas con Always On Availability Groups para obtener detalles de failovers, incluyendo el tiempo de fallas (`failure_time`), el tipo de falla (`failure_type_desc`), y otras informaciones relacionadas.

#### Estos ejemplos te permiten obtener información sobre los failovers en SQL Server. Asegúrate de ajustar las consultas según tus necesidades específicas y el entorno de tu SQL Server.





# 
## Cambiar el "collation"  de todas las bases de datos en un servidor SQL Server<a name="collectionchange"></a>

![](https://www.mssqltips.com/images_newsletter/3519_NewsletterImage.png)
#### Si estás buscando cambiar el "collation" de todas las bases de datos en un servidor SQL Server, aquí tienes un script que puedes utilizar para estos fines.

#### Ten en cuenta que cambiar el "collation" de una base de datos es un proceso delicado y debe hacerse con precaución, ya que puede afectar la forma en que los datos se comparan y ordenan en las consultas. Asegúrate de realizar pruebas exhaustivas en un entorno de desarrollo antes de aplicar estos cambios en un entorno de producción.

# 
~~~sql
/*
Creado por Alejandro Jimenez Miercoles 20 de Agosto 2023
Este query cambia los Collettion de todas las bases de datos de un servidor.

Nota: el mismo debe ser probado antes de ejecutarlo.
Estado de pruebas. y confirmacion.
*/

DECLARE @DatabaseName NVARCHAR(128)
DECLARE @NewCollation NVARCHAR(128) = 'NewCollationName'  -- Cambia al nuevo "collation" que deseas aplicar

DECLARE db_cursor CURSOR FOR
SELECT name
FROM sys.databases
WHERE state_desc = 'ONLINE' AND name NOT IN ('master', 'tempdb', 'model', 'msdb') -- Filtra las bases de datos del sistema

OPEN db_cursor
FETCH NEXT FROM db_cursor INTO @DatabaseName

WHILE @@FETCH_STATUS = 0
BEGIN
    DECLARE @sql NVARCHAR(MAX)
    SET @sql = N'ALTER DATABASE [' + @DatabaseName + N'] COLLATE ' + @NewCollation + N';'

    EXEC sp_executesql @sql

    FETCH NEXT FROM db_cursor INTO @DatabaseName
END

CLOSE db_cursor
DEALLOCATE db_cursor

~~~
# 
#### En este script, @NewCollation es la variable que debes cambiar para especificar el nuevo ***"collation"*** que deseas aplicar a todas las bases de datos. El script utiliza un cursor para recorrer todas las bases de datos en el servidor ***(excluyendo las bases de datos del sistema)*** y ejecuta una declaración ***ALTER DATABASE*** para cambiar el "collation".

#### Recuerda que cambiar el "collation" de una base de datos puede tener implicaciones significativas, como cambios en la forma en que se comparan y ordenan los datos en las consultas. Asegúrate de comprender completamente los efectos de este cambio y realizar pruebas adecuadas antes de aplicarlo en un entorno de producción.

# 


## Para saber si SQL Server Replication está instalado en SQL Server 2019, puedes seguir estos pasos:<a name="saberreplicationserver"></a>

<div>
<p style = 'text-align:center;'>
<img src="https://www.striim.com/wp-content/uploads/2022/06/Data-replication.png?format=jpg&name=small" alt="JuveYell" width="750px">
</p>
</div>




1. **SQL Server Management Studio (SSMS):** Abre SQL Server Management Studio y conéctate a tu instancia de SQL Server 2019.

2. **Consulta del catálogo:** Ejecuta la siguiente consulta en una nueva ventana de consulta de SSMS:

   ```sql
   SELECT * FROM sys.objects WHERE type = 'S'
   ```

####   Esta consulta buscará objetos de tipo 'S' (que representan objetos de replicación) en la base de datos `Master` del servidor.

3. **Verificación de objetos de replicación:** Si obtienes resultados de la consulta que incluyen objetos de tipo 'S', entonces SQL Server Replication está instalado en tu instancia de SQL Server. Estos objetos de replicación son parte del sistema de replicación y su presencia indica que la característica está instalada.

#### Si no obtienes resultados o recibes un mensaje de error indicando que la tabla `sys.objects` no existe, es posible que no tengas permisos suficientes para consultar el catálogo o que la característica de replicación no esté instalada en tu instancia de SQL Server.

#### Recuerda que la replicación es una característica que se puede instalar o desinstalar durante la instalación de SQL Server o posteriormente a través del instalador de SQL Server. Si necesitas habilitar o deshabilitar la replicación, puedes hacerlo a través del instalador de SQL Server o de la configuración de características de SQL Server en el Panel de Control de Windows.



# 
#
## documentación para el comando `ALTER DATABASE ... SET HADR RESUME;`<a name="135"></a>

---

### Resumen del Comando `ALTER DATABASE ... SET HADR RESUME;`

**Comando:** 
```sql
ALTER DATABASE [Nombre_Base_Datos] SET HADR RESUME;
```

**Descripción:**  
Este comando reanuda la sincronización de una base de datos en un grupo de disponibilidad de SQL Server AlwaysOn (HADR - High Availability Disaster Recovery). Es particularmente útil cuando la sincronización de la base de datos ha sido suspendida por cualquier motivo (como un fallo temporal o una suspensión manual) y se requiere restablecer el flujo de datos entre las réplicas de alta disponibilidad.

**Sintaxis:**
```sql
ALTER DATABASE [Nombre_Base_Datos] SET HADR RESUME;
```

- **[Nombre_Base_Datos]:** Nombre de la base de datos que necesita reanudar la sincronización en el grupo de disponibilidad AlwaysOn.

**Ejemplo:**
```sql
ALTER DATABASE [RSA_CM_AA] SET HADR RESUME;
```

Este ejemplo reanuda la sincronización de la base de datos llamada `RSA_CM_AA` en el grupo de disponibilidad AlwaysOn.

**Uso común:**
1. Situaciones donde la sincronización fue suspendida manualmente o por problemas técnicos.
2. Permite restablecer la comunicación y la replicación de datos entre las réplicas sin interrumpir la disponibilidad de la base de datos primaria.

**Consideraciones importantes:**
- El usuario que ejecuta este comando necesita permisos elevados, generalmente de administrador, sobre la base de datos y el entorno de alta disponibilidad.
- La base de datos debe estar configurada previamente en un grupo de disponibilidad AlwaysOn para que el comando sea efectivo.

**Referencias:**
- Documentación oficial de [Microsoft SQL Server](https://learn.microsoft.com/en-us/sql) para más detalles sobre AlwaysOn y comandos HADR.

---




# 
## Listado de transacciones bloqueadas en un servidor DB<a  name="bloqueos2" ></a>
<div>
<p style = 'text-align:center;'>
<img src="https://www.datanumen.com/blogs/wp-content/uploads/2017/01/blocking-in-sql.jpg?format=jpg&name=small" alt="JuveYell" width="750px">
</p>
</div>





###  Para detectar bloqueos en un entorno Always On Availability Groups en SQL Server, puedes utilizar la siguiente consulta que se basa en vistas dinámicas relacionadas con bloqueos y Always On. Ten en cuenta que esta consulta debe ejecutarse en la instancia primaria del grupo de disponibilidad:

~~~sql

SELECT
    DB_NAME(tl.resource_database_id) AS DatabaseName,
    tl.request_session_id AS SessionID,
    wt.blocking_session_id AS BlockingSessionID,
    tl.resource_type AS ResourceType,
    tl.resource_associated_entity_id AS AssociatedEntityID,
    tl.request_mode AS LockMode,
    tl.request_status AS LockStatus,
    tl.request_owner_type AS LockOwnerType,
    CASE
        WHEN tl.resource_type = 'OBJECT' THEN OBJECT_NAME(tl.resource_associated_entity_id, tl.resource_database_id)
        ELSE 'N/A'
    END AS ResourceName,
    r.replica_server_name AS ReplicaServerName
FROM sys.dm_tran_locks AS tl
LEFT JOIN sys.dm_exec_requests AS wt ON tl.request_session_id = wt.session_id
INNER JOIN sys.dm_hadr_availability_replica_states AS r ON DB_NAME(tl.resource_database_id) = r.database_name
WHERE tl.request_status = 'WAIT' OR tl.request_status = 'GRANT'
ORDER BY tl.request_session_id;
~~~
# 

#### Esta consulta recuperará información sobre los bloqueos en la base de datos en el contexto de un entorno Always On Availability Groups. Proporcionará detalles sobre el nombre de la base de datos afectada, el identificador de sesión, el identificador de sesión de bloqueo (si está bloqueado), el tipo de recurso bloqueado, el modo de bloqueo, el estado del bloqueo y otros detalles relacionados con el bloqueo. Además, mostrará en qué réplica se encuentra la base de datos en el momento del bloqueo.

#### Asegúrate de ejecutar esta consulta en la instancia primaria del grupo de disponibilidad, ya que es la instancia primaria la que maneja las operaciones de escritura y, por lo tanto, donde es más probable que ocurran bloqueos significativos. Ten en cuenta que esta consulta solo mostrará bloqueos activos o en espera en el momento de la ejecución.

### Recuerda que la resolución de problemas de bloqueos en un entorno Always On Availability Groups puede ser complicada debido a la replicación y la distribución de datos entre réplicas. Es importante comprender bien cómo funciona Always On y contar con experiencia en la resolución de problemas en este tipo de entornos.


# 




## Ver los Log de Errores del Sql server<a name="errorlogsql"></a> 
<div>
<p style = 'text-align:center;'>
<img src="https://cf-images.us-east-1.prod.boltdns.net/v1/static/6057277730001/217b8d18-11ba-46d1-bc1f-120a43f9a6a9/a2dbc8fb-60d1-4c8e-8c45-3b79ff2efadc/1280x720/match/image.jpg?format=jpg&name=small" alt="JuveYell" width="750px">
</p>
</div>


#### Para consultar el registro de errores de SQL Server y obtener información sobre eventos y errores, puedes utilizar la siguiente consulta SQL. Esta consulta utiliza la función extendida `xp_readerrorlog` para leer el registro de errores:

```sql
EXEC xp_readerrorlog;
```

#### Al ejecutar esta consulta, obtendrás un conjunto de resultados que incluirá información sobre los eventos y errores registrados en el registro de errores de SQL Server. El conjunto de resultados contendrá columnas como `LogDate`, `ProcessInfo`, `Text`, entre otras, que proporcionan detalles sobre los eventos y errores.

#### Si deseas consultar registros de errores específicos o filtrar por fechas, puedes usar los parámetros opcionales de la función `xp_readerrorlog`. Por ejemplo:

```sql
-- Mostrar los últimos 50 registros de errores
EXEC xp_readerrorlog 0, 1, NULL, NULL, NULL, NULL, N'desc';

-- Filtrar registros de errores por fecha (en este caso, los últimos 7 días)
EXEC xp_readerrorlog 0, 1, NULL, NULL, '2023-09-18', '2023-09-25', NULL;

-- Filtrar registros de errores por texto específico
EXEC xp_readerrorlog 0, 1, NULL, N'Texto de error a buscar', NULL, NULL, NULL;
```

#### Ajusta los parámetros según tus necesidades para obtener la información específica que estás buscando en el registro de errores de SQL Server.


## Cerrar todas la conexion a mi base de datos<a name="cerrarconexionessql"></a>   
<div>
<p style = 'text-align:center;'>
<img src="https://bigprofitdata.com/wp-content/uploads/2020/07/Miniatura_image-1024x540.png?format=jpg&name=small" alt="JuveYell" width="750px">
</p>
</div>





#### Como cerrar todas la conexiones a mi base de datos SQL Server: Cerrar conexiones sql en toda mi base de datos SQL Server

~~~sql
USE master
GO
 
SET NOCOUNT ON
 
DECLARE @DBName VARCHAR(50)
DECLARE @spidstr VARCHAR(8000)
DECLARE @ConnKilled SMALLINT
 
SET @ConnKilled = 0
SET @spidstr = ''
SET @DBName = 'AQUI TU BASE DE DATOS'
 
IF Db_id(@DBName) < 4
BEGIN
    PRINT 'Connections to system databases cannot be killed'
 
    RETURN
END
 
SELECT @spidstr = COALESCE(@spidstr, ',') + 'kill ' + CONVERT(VARCHAR, spid) + '; '
FROM master..sysprocesses
WHERE dbid = Db_id(@DBName)
 
IF Len(@spidstr) > 0
BEGIN
    EXEC (@spidstr)
 
    SELECT @ConnKilled = Count(1)
    FROM master..sysprocesses
    WHERE dbid = Db_id(@DBName)
END
~~~
# 


<div>
<p style = 'text-align:center;'>
<img src="https://bigprofitdata.com/wp-content/uploads/2020/07/Miniatura_image-1024x540.png?format=jpg&name=small" alt="JuveYell" width="750px">
</p>
</div>





# Script de Microsoft para detecar problemas SDP<a name="45sdp"></a>
###  SCRIPT DE MICROSOFT PARA DETECTAR problemas SDP, PARA DETETAR PROBLEMAS EN DB


~~~sql

/*******************************************************************
perf stats


********************************************************************/
USE tempdb
GO
SET NOCOUNT ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET NUMERIC_ROUNDABORT OFF
GO

go
IF OBJECT_ID ('sp_perf_stats','P') IS NOT NULL
   DROP PROCEDURE sp_perf_stats
GO
CREATE PROCEDURE sp_perf_stats @appname sysname='PSSDIAG', @runtime datetime, @prevruntime datetime, @IsLite bit=0 
AS 
 SET NOCOUNT ON
  DECLARE @msg varchar(100)
  DECLARE @querystarttime datetime
  DECLARE @queryduration int
  DECLARE @qrydurationwarnthreshold int
  DECLARE @servermajorversion int
  DECLARE @cpu_time_start bigint, @elapsed_time_start bigint
  DECLARE @sql nvarchar(max)
  DECLARE @cte nvarchar(max)
  DECLARE @rowcount bigint

  SELECT @cpu_time_start = cpu_time, @elapsed_time_start = total_elapsed_time FROM sys.dm_exec_sessions WHERE session_id = @@SPID

  IF OBJECT_ID ('tempdb.dbo.#tmp_requests') IS NOT NULL DROP TABLE #tmp_requests
  IF OBJECT_ID ('tempdb.dbo.#tmp_requests2') IS NOT NULL DROP TABLE #tmp_requests2
  
  IF @runtime IS NULL 
  BEGIN 
    SET @runtime = GETDATE()
    SET @msg = 'Start time: ' + CONVERT (varchar(30), @runtime, 126)
    RAISERROR (@msg, 0, 1) WITH NOWAIT
  END

RAISERROR (' ', 0, 1) WITH NOWAIT
RAISERROR ('-- sys.dm_tran_session_transactions (DTC ONLY) --', 0, 1) WITH NOWAIT
select @runtime, * from sys.dm_tran_session_transactions where is_local = 0
RAISERROR (' ', 0, 1) WITH NOWAIT



RAISERROR (' ', 0, 1) WITH NOWAIT
RAISERROR ('-- sys.dm_tran_active_transactions (DTC ONLY) --', 0, 1) WITH NOWAIT
select @runtime, * from sys.dm_tran_active_transactions where transaction_type = 4
RAISERROR (' ', 0, 1) WITH NOWAIT

  SET @qrydurationwarnthreshold = 500
  
  -- SERVERPROPERTY ('ProductVersion') returns e.g. "9.00.2198.00" --> 9
  SET @servermajorversion = REPLACE (LEFT (CONVERT (varchar, SERVERPROPERTY ('ProductVersion')), 2), '.', '')

  RAISERROR (@msg, 0, 1) WITH NOWAIT

  SET @querystarttime = GETDATE()

  SELECT  blocking_session_id into #blockingSessions FROM sys.dm_exec_requests WHERE blocking_session_id != 0
  create index ix_blockingSessions_1 on #blockingSessions (blocking_session_id)

  select * into #dm_exec_sessions_raw from sys.dm_exec_sessions

  create index ix_dm_exec_sessions on #dm_exec_sessions_raw (session_id)

  create index ix_dm_exec_sessions_is_user_process on #dm_exec_sessions_raw (is_user_process)

  select * into #requests_raw from   sys.dm_exec_requests
  
  create index ix_requests_raw_session_id on #requests_raw (session_id)
  create index ix_requests_raw_request_id on #requests_raw (request_id)
  create index ix_requests_raw_status on #requests_raw (status)
  create index ix_requests_raw_wait_type on #requests_raw (wait_type)
  
  select * into #dm_os_tasks from   sys.dm_os_tasks
  create index ix_dm_os_tasks_session_id on #dm_os_tasks (session_id)
  create index ix_dm_os_tasks_request_id on #dm_os_tasks (request_id)

  select * into #dm_exec_connections from   sys.dm_exec_connections
  create index ix_dm_exec_connections_session_id on #dm_exec_connections (session_id)

  select * into #dm_tran_active_transactions from   sys.dm_tran_active_transactions 
  create index ix_dm_tran_active_transactions_transaction_id on #dm_tran_active_transactions(transaction_id)

  select * into #dm_tran_session_transactions from  sys.dm_tran_session_transactions

  create index  ix_dm_tran_session_transactions_session_id on #dm_tran_session_transactions (session_id)

  select * into #dm_os_waiting_tasks  from  sys.dm_os_waiting_tasks
  create index ix_dm_os_waiting_tasks_waiting_task_address on #dm_os_waiting_tasks(waiting_task_address)

  select * into #sysprocesses from master.dbo.sysprocesses 
  create index ix_sysprocesses_spid on #sysprocesses (spid)


  SELECT
    sess.session_id, req.request_id, tasks.exec_context_id AS 'ecid', tasks.task_address, req.blocking_session_id, LEFT (tasks.task_state, 15) AS 'task_state', 
    tasks.scheduler_id, LEFT (ISNULL (req.wait_type, ''), 50) AS 'wait_type', LEFT (ISNULL (req.wait_resource, ''), 40) AS 'wait_resource', 
    LEFT (req.last_wait_type, 50) AS 'last_wait_type', 
    /* sysprocesses is the only way to get open_tran count for sessions w/o an active request (SQLBUD #487091) */
    CASE 
      WHEN req.open_transaction_count IS NOT NULL THEN req.open_transaction_count 
      ELSE (SELECT open_tran FROM #sysprocesses sysproc WHERE sess.session_id = sysproc.spid) 
    END AS open_trans, 
    LEFT (CASE COALESCE(req.transaction_isolation_level, sess.transaction_isolation_level)
      WHEN 0 THEN '0-Read Committed' 
      WHEN 1 THEN '1-Read Uncommitted (NOLOCK)' 
      WHEN 2 THEN '2-Read Committed' 
      WHEN 3 THEN '3-Repeatable Read' 
      WHEN 4 THEN '4-Serializable' 
      WHEN 5 THEN '5-Snapshot' 
      ELSE CONVERT (varchar(30), req.transaction_isolation_level) + '-UNKNOWN' 
    END, 30) AS transaction_isolation_level, 
    sess.is_user_process, req.cpu_time AS 'request_cpu_time', 
    req.logical_reads request_logical_reads,
    req.reads request_reads,
     req.writes request_writes,
    sess.memory_usage, sess.cpu_time AS 'session_cpu_time', sess.reads AS 'session_reads', sess.writes AS 'session_writes', sess.logical_reads AS 'session_logical_reads', 
    sess.total_scheduled_time, sess.total_elapsed_time, sess.last_request_start_time, sess.last_request_end_time, sess.row_count AS session_row_count, 
    sess.prev_error, req.open_resultset_count AS open_resultsets, req.total_elapsed_time AS request_total_elapsed_time, 
    CONVERT (decimal(5,2), req.percent_complete) AS percent_complete, req.estimated_completion_time AS est_completion_time, req.transaction_id, 
    req.start_time AS request_start_time, LEFT (req.status, 15) AS request_status, req.command, req.plan_handle, req.sql_handle, req.statement_start_offset, 
    req.statement_end_offset, req.database_id, req.[user_id], req.executing_managed_code, tasks.pending_io_count, sess.login_time, 
    LEFT (sess.[host_name], 20) AS [host_name], LEFT (ISNULL (sess.program_name, ''), 50) AS program_name, ISNULL (sess.host_process_id, 0) AS 'host_process_id', 
    ISNULL (sess.client_version, 0) AS 'client_version', LEFT (ISNULL (sess.client_interface_name, ''), 30) AS 'client_interface_name', 
    LEFT (ISNULL (sess.login_name, ''), 30) AS 'login_name', LEFT (ISNULL (sess.nt_domain, ''), 30) AS 'nt_domain', LEFT (ISNULL (sess.nt_user_name, ''), 20) AS 'nt_user_name', 
    ISNULL (conn.net_packet_size, 0) AS 'net_packet_size', LEFT (ISNULL (conn.client_net_address, ''), 20) AS 'client_net_address', conn.most_recent_sql_handle, 
    LEFT (sess.status, 15) AS 'session_status',
    /* sys.dm_os_workers and sys.dm_os_threads removed due to perf impact, no predicate pushdown (SQLBU #488971) */
    --  workers.is_preemptive,
    --  workers.is_sick, 
    --  workers.exception_num AS last_worker_exception, 
    --  convert (varchar (20), master.dbo.fn_varbintohexstr (workers.exception_address)) AS last_exception_address
    --  threads.os_thread_id 
    sess.group_id, req.query_hash, req.query_plan_hash  
  INTO #tmp_requests
  FROM #dm_exec_sessions_raw sess 
  /* Join hints are required here to work around bad QO join order/type decisions (ultimately by-design, caused by the lack of accurate DMV card estimates) */
  LEFT OUTER  JOIN #requests_raw  req  ON sess.session_id = req.session_id
  LEFT OUTER  JOIN #dm_os_tasks tasks ON tasks.session_id = sess.session_id AND tasks.request_id = req.request_id 
  /* The following two DMVs removed due to perf impact, no predicate pushdown (SQLBU #488971) */
  --  LEFT OUTER MERGE JOIN sys.dm_os_workers workers ON tasks.worker_address = workers.worker_address
  --  LEFT OUTER MERGE JOIN sys.dm_os_threads threads ON workers.thread_address = threads.thread_address
  LEFT OUTER JOIN #dm_exec_connections conn on conn.session_id = sess.session_id
  WHERE 
    /* Get execution state for all active queries... */
    (req.session_id IS NOT NULL AND (sess.is_user_process = 1 OR req.status COLLATE Latin1_General_BIN NOT IN ('background', 'sleeping')))
    /* ... and also any head blockers, even though they may not be running a query at the moment. */
    OR (sess.session_id IN (SELECT blocking_session_id FROM #blockingSessions))
  /* redundant due to the use of join hints, but added here to suppress warning message */
  OPTION (MAX_GRANT_PERCENT = 3, MAXDOP 1)

  create index ix_temp_request_session_id on #tmp_requests(session_id) 
  create index ix_temp_request_transaction_id on #tmp_requests(transaction_id) 
  create index ix_temp_request_task_address on #tmp_requests(task_address)  


  SET @rowcount = @@ROWCOUNT
  SET @queryduration = DATEDIFF (ms, @querystarttime, GETDATE())
  IF @queryduration > @qrydurationwarnthreshold
    PRINT 'DebugPrint: perfstats qry0 - ' + CONVERT (varchar, @queryduration) + 'ms, rowcount=' + CONVERT(varchar, @rowcount) + CHAR(13) + CHAR(10)

  IF NOT EXISTS (SELECT * FROM #tmp_requests WHERE session_id <> @@SPID AND ISNULL (host_name, '') != @appname) BEGIN
    PRINT 'No active queries'
  END
  ELSE BEGIN
    -- There are active queries (other than this one). 
    -- This query could be collapsed into the query above.  It is broken out here to avoid an excessively 
    -- large memory grant due to poor cardinality estimates (see previous bugs -- ultimate cause is the 
    -- lack of good stats for many DMVs). 
    SET @querystarttime = GETDATE()
    SELECT 
      IDENTITY (int,1,1) AS tmprownum, 
      r.session_id, r.request_id, r.ecid, r.blocking_session_id, ISNULL (waits.blocking_exec_context_id, 0) AS blocking_ecid, 
      r.task_state, waits.wait_type, ISNULL (waits.wait_duration_ms, 0) AS wait_duration_ms, r.wait_resource, 
      LEFT (ISNULL (waits.resource_description, ''), 140) AS resource_description, r.last_wait_type, r.open_trans, 
      r.transaction_isolation_level, r.is_user_process, r.request_cpu_time, r.request_logical_reads, r.request_reads, 
      r.request_writes, r.memory_usage, r.session_cpu_time, r.session_reads, r.session_writes, r.session_logical_reads, 
      r.total_scheduled_time, r.total_elapsed_time, r.last_request_start_time, r.last_request_end_time, r.session_row_count, 
      r.prev_error, r.open_resultsets, r.request_total_elapsed_time, r.percent_complete, r.est_completion_time, 
      -- r.tran_name, r.transaction_begin_time, r.tran_type, r.tran_state, 
      LEFT (COALESCE (reqtrans.name, sesstrans.name, ''), 24) AS tran_name, 
      COALESCE (reqtrans.transaction_begin_time, sesstrans.transaction_begin_time) AS transaction_begin_time, 
      LEFT (CASE COALESCE (reqtrans.transaction_type, sesstrans.transaction_type)
        WHEN 1 THEN '1-Read/write'
        WHEN 2 THEN '2-Read only'
        WHEN 3 THEN '3-System'
        WHEN 4 THEN '4-Distributed'
        ELSE CONVERT (varchar(30), COALESCE (reqtrans.transaction_type, sesstrans.transaction_type)) + '-UNKNOWN' 
      END, 15) AS tran_type, 
      LEFT (CASE COALESCE (reqtrans.transaction_state, sesstrans.transaction_state)
        WHEN 0 THEN '0-Initializing'
        WHEN 1 THEN '1-Initialized'
        WHEN 2 THEN '2-Active'
        WHEN 3 THEN '3-Ended'
        WHEN 4 THEN '4-Preparing'
        WHEN 5 THEN '5-Prepared'
        WHEN 6 THEN '6-Committed'
        WHEN 7 THEN '7-Rolling back'
        WHEN 8 THEN '8-Rolled back'
        ELSE CONVERT (varchar(30), COALESCE (reqtrans.transaction_state, sesstrans.transaction_state)) + '-UNKNOWN'
      END, 15) AS tran_state, 
      r.request_start_time, r.request_status, r.command, r.plan_handle, r.[sql_handle], r.statement_start_offset, 
      r.statement_end_offset, r.database_id, r.[user_id], r.executing_managed_code, r.pending_io_count, r.login_time, 
      r.[host_name], r.[program_name], r.host_process_id, r.client_version, r.client_interface_name, r.login_name, r.nt_domain, 
      r.nt_user_name, r.net_packet_size, r.client_net_address, r.most_recent_sql_handle, r.session_status, r.scheduler_id,
      -- r.is_preemptive, r.is_sick, r.last_worker_exception, r.last_exception_address, 
      -- r.os_thread_id
      r.group_id, r.query_hash, r.query_plan_hash
    INTO #tmp_requests2
    FROM #tmp_requests r
    /* Join hints are required here to work around bad QO join order/type decisions (ultimately by-design, caused by the lack of accurate DMV card estimates) */
    LEFT OUTER MERGE JOIN #dm_tran_active_transactions reqtrans ON r.transaction_id = reqtrans.transaction_id
    
    LEFT OUTER MERGE JOIN #dm_tran_session_transactions sessions_transactions on sessions_transactions.session_id = r.session_id
    
    LEFT OUTER MERGE JOIN #dm_tran_active_transactions sesstrans ON sesstrans.transaction_id = sessions_transactions.transaction_id
    
    LEFT OUTER MERGE JOIN #dm_os_waiting_tasks waits ON waits.waiting_task_address = r.task_address 
    ORDER BY r.session_id, blocking_ecid
    /* redundant due to the use of join hints, but added here to suppress warning message */
    OPTION (MAX_GRANT_PERCENT = 3, MAXDOP 1)

    SET @rowcount = @@ROWCOUNT
    SET @queryduration = DATEDIFF (ms, @querystarttime, GETDATE())
    IF @queryduration > @qrydurationwarnthreshold
      PRINT 'DebugPrint: perfstats qry0a - ' + CONVERT (varchar, @queryduration) + 'ms, rowcount=' + CONVERT(varchar, @rowcount) + CHAR(13) + CHAR(10)

    /* This index typically takes <10ms to create, and drops the head blocker summary query cost from ~250ms CPU down to ~20ms. */
    CREATE NONCLUSTERED INDEX idx1 ON #tmp_requests2 (blocking_session_id, session_id, wait_type, wait_duration_ms)

    /* Output Resultset #1: summary of all active requests (and head blockers) 
    ** Dynamic (but explicitly parameterized) SQL used here to allow for (optional) direct-to-database data collection 
    ** without unnecessary code duplication. */
    RAISERROR ('-- requests --', 0, 1) WITH NOWAIT
    SET @querystarttime = GETDATE()

    SELECT TOP 10000 CONVERT (varchar(30), @runtime, 126) AS 'runtime', 
      session_id, request_id, ecid, blocking_session_id, blocking_ecid, task_state, 
      wait_type, wait_duration_ms, wait_resource, resource_description, last_wait_type, 
      open_trans, transaction_isolation_level, is_user_process, 
      request_cpu_time, request_logical_reads, request_reads, request_writes, memory_usage, 
      session_cpu_time, session_reads, session_writes, session_logical_reads, total_scheduled_time, 
      total_elapsed_time, CONVERT (varchar(30), last_request_start_time, 126) AS 'last_request_start_time', 
      CONVERT (varchar(30), last_request_end_time, 126) AS 'last_request_end_time', session_row_count, 
      prev_error, open_resultsets, request_total_elapsed_time, percent_complete, 
      est_completion_time, tran_name, 
      CONVERT (varchar(30), transaction_begin_time, 126) AS 'transaction_begin_time', tran_type, 
      tran_state, CONVERT (varchar, request_start_time, 126) AS request_start_time, request_status, 
      command, statement_start_offset, statement_end_offset, database_id, [user_id], 
      executing_managed_code, pending_io_count, CONVERT (varchar(30), login_time, 126) AS 'login_time', 
      [host_name], [program_name], host_process_id, client_version, client_interface_name, login_name, 
      nt_domain, nt_user_name, net_packet_size, client_net_address, session_status, 
      scheduler_id,
      -- is_preemptive, is_sick, last_worker_exception, last_exception_address
      -- os_thread_id
      group_id, query_hash, query_plan_hash, plan_handle      
    FROM #tmp_requests2 r
    WHERE ISNULL ([host_name], '''') != @appname AND r.session_id != @@SPID 
      /* One EC can have multiple waits in sys.dm_os_waiting_tasks (e.g. parent thread waiting on multiple children, for example 
      ** for parallel create index; or mem grant waits for RES_SEM_FOR_QRY_COMPILE).  This will result in the same EC being listed 
      ** multiple times in the request table, which is counterintuitive for most people.  Instead of showing all wait relationships, 
      ** for each EC we will report the wait relationship that has the longest wait time.  (If there are multiple relationships with 
      ** the same wait time, blocker spid/ecid is used to choose one of them.)  If it were not for , we would do this 
      ** exclusion in the previous query to avoid storing data that will ultimately be filtered out. */
      AND NOT EXISTS 
        (SELECT * FROM #tmp_requests2 r2 
         WHERE r.session_id = r2.session_id AND r.request_id = r2.request_id AND r.ecid = r2.ecid AND r.wait_type = r2.wait_type 
           AND (r2.wait_duration_ms > r.wait_duration_ms OR (r2.wait_duration_ms = r.wait_duration_ms AND r2.tmprownum > r.tmprownum)))
    OPTION (MAX_GRANT_PERCENT = 3, MAXDOP 1)

    RAISERROR (' ', 0, 1) WITH NOWAIT
    
    SET @rowcount = @@ROWCOUNT
    SET @queryduration = DATEDIFF (ms, @querystarttime, GETDATE())
    IF @queryduration > @qrydurationwarnthreshold
      PRINT 'DebugPrint: perfstats qry1 - ' + CONVERT (varchar, @queryduration) + 'ms, rowcount=' + CONVERT(varchar, @rowcount) + CHAR(13) + CHAR(10)

    /* Resultset #2: Head blocker summary 
    ** Intra-query blocking relationships (parallel query waits) aren't "true" blocking problems that we should report on here. */
    IF NOT EXISTS (SELECT * FROM #tmp_requests2 WHERE blocking_session_id != 0 AND wait_type NOT IN ('WAITFOR', 'EXCHANGE', 'CXPACKET') AND wait_duration_ms > 0) 
    BEGIN 
      PRINT ''
      PRINT '-- No blocking detected --'
      PRINT ''
    END
    ELSE BEGIN
      PRINT ''
      PRINT '-----------------------'
      PRINT '-- BLOCKING DETECTED --'
      PRINT ''
      RAISERROR ('-- headblockersummary --', 0, 1) WITH NOWAIT;
      /* We need stats like the number of spids blocked, max waittime, etc, for each head blocker.  Use a recursive CTE to 
      ** walk the blocking hierarchy. Again, explicitly parameterized dynamic SQL used to allow optional collection direct  
      ** to a database. */
      SET @querystarttime = GETDATE();
      
      WITH BlockingHierarchy (head_blocker_session_id, session_id, blocking_session_id, wait_type, wait_duration_ms, 
        wait_resource, statement_start_offset, statement_end_offset, plan_handle, sql_handle, most_recent_sql_handle, [Level]) 
      AS (
        SELECT head.session_id AS head_blocker_session_id, head.session_id AS session_id, head.blocking_session_id, 
          head.wait_type, head.wait_duration_ms, head.wait_resource, head.statement_start_offset, head.statement_end_offset, 
          head.plan_handle, head.sql_handle, head.most_recent_sql_handle, 0 AS [Level]
        FROM #tmp_requests2 head
        WHERE (head.blocking_session_id IS NULL OR head.blocking_session_id = 0) 
          AND head.session_id IN (SELECT DISTINCT blocking_session_id FROM #tmp_requests2 WHERE blocking_session_id != 0) 
        UNION ALL 
        SELECT h.head_blocker_session_id, blocked.session_id, blocked.blocking_session_id, blocked.wait_type, 
          blocked.wait_duration_ms, blocked.wait_resource, h.statement_start_offset, h.statement_end_offset, 
          h.plan_handle, h.sql_handle, h.most_recent_sql_handle, [Level] + 1
        FROM #tmp_requests2 blocked
        INNER JOIN BlockingHierarchy AS h ON h.session_id = blocked.blocking_session_id and h.session_id!=blocked.session_id --avoid infinite recursion for latch type of blocknig
        WHERE h.wait_type COLLATE Latin1_General_BIN NOT IN ('EXCHANGE', 'CXPACKET') or h.wait_type is null
      )
      SELECT CONVERT (varchar(30), @runtime, 126) AS 'runtime', 
        head_blocker_session_id, COUNT(*) AS 'blocked_task_count', SUM (ISNULL (wait_duration_ms, 0)) AS 'tot_wait_duration_ms', 
        LEFT (CASE 
          WHEN wait_type LIKE 'LCK%' COLLATE Latin1_General_BIN AND wait_resource LIKE '%\[COMPILE\]%' ESCAPE '\' COLLATE Latin1_General_BIN 
            THEN 'COMPILE (' + ISNULL (wait_resource, '') + ')' 
          WHEN wait_type LIKE 'LCK%' COLLATE Latin1_General_BIN THEN 'LOCK BLOCKING' 
          WHEN wait_type LIKE 'PAGELATCH%' COLLATE Latin1_General_BIN THEN 'PAGELATCH_* WAITS' 
          WHEN wait_type LIKE 'PAGEIOLATCH%' COLLATE Latin1_General_BIN THEN 'PAGEIOLATCH_* WAITS' 
          ELSE wait_type
        END, 40) AS 'blocking_resource_wait_type', AVG (ISNULL (wait_duration_ms, 0)) AS 'avg_wait_duration_ms', MAX(wait_duration_ms) AS 'max_wait_duration_ms', 
        MAX ([Level]) AS 'max_blocking_chain_depth', 
        MAX (ISNULL (CONVERT (nvarchar(60), CASE 
          WHEN sql.objectid IS NULL THEN NULL 
          ELSE REPLACE (REPLACE (SUBSTRING (sql.[text], CHARINDEX ('CREATE ', CONVERT (nvarchar(512), SUBSTRING (sql.[text], 1, 1000)) COLLATE Latin1_General_BIN), 50) COLLATE Latin1_General_BIN, CHAR(10), ' '), CHAR(13), ' ')
        END), '')) AS 'head_blocker_proc_name', 
        MAX (ISNULL (sql.objectid, 0)) AS 'head_blocker_proc_objid', MAX (ISNULL (CONVERT (nvarchar(1000), REPLACE (REPLACE (SUBSTRING (sql.[text], ISNULL (statement_start_offset, 0)/2 + 1, 
          CASE WHEN ISNULL (statement_end_offset, 8192) <= 0 THEN 8192 
          ELSE ISNULL (statement_end_offset, 8192)/2 - ISNULL (statement_start_offset, 0)/2 END + 1) COLLATE Latin1_General_BIN, 
        CHAR(13), ' '), CHAR(10), ' ')), '')) AS 'stmt_text', 
        CONVERT (varbinary (64), MAX (ISNULL (plan_handle, 0x))) AS 'head_blocker_plan_handle'
      FROM BlockingHierarchy
      OUTER APPLY sys.dm_exec_sql_text (ISNULL ([sql_handle], most_recent_sql_handle)) AS sql
      WHERE blocking_session_id != 0 AND [Level] > 0
      GROUP BY head_blocker_session_id, 
        LEFT (CASE 
          WHEN wait_type LIKE 'LCK%' COLLATE Latin1_General_BIN AND wait_resource LIKE '%\[COMPILE\]%' ESCAPE '\' COLLATE Latin1_General_BIN 
            THEN 'COMPILE (' + ISNULL (wait_resource, '') + ')' 
          WHEN wait_type LIKE 'LCK%' COLLATE Latin1_General_BIN THEN 'LOCK BLOCKING' 
          WHEN wait_type LIKE 'PAGELATCH%' COLLATE Latin1_General_BIN THEN 'PAGELATCH_* WAITS' 
          WHEN wait_type LIKE 'PAGEIOLATCH%' COLLATE Latin1_General_BIN THEN 'PAGEIOLATCH_* WAITS' 
          ELSE wait_type
        END, 40) 
      ORDER BY SUM (wait_duration_ms) DESC
      OPTION (MAX_GRANT_PERCENT = 3, MAXDOP 1)

      RAISERROR (' ', 0, 1) WITH NOWAIT

      
      SET @rowcount = @@ROWCOUNT
      SET @queryduration = DATEDIFF (ms, @querystarttime, GETDATE())
      IF @queryduration > @qrydurationwarnthreshold
        PRINT 'DebugPrint: perfstats qry2 - ' + CONVERT (varchar, @queryduration) + 'ms, rowcount=' + CONVERT(varchar, @rowcount) + CHAR(13) + CHAR(10)
    END

    /* Resultset #3: inputbuffers and query stats for "expensive" queries, head blockers, and "first-tier" blocked spids */
    PRINT ''
    RAISERROR ('-- notableactivequeries --', 0, 1) WITH NOWAIT
    SET @querystarttime = GETDATE()

    SELECT DISTINCT TOP 500 
      CONVERT (varchar(30), @runtime, 126) AS 'runtime', r.session_id AS session_id, r.request_id AS request_id, stat.execution_count AS 'plan_total_exec_count', 
      stat.total_worker_time/1000 AS 'plan_total_cpu_ms', stat.total_elapsed_time/1000 AS 'plan_total_duration_ms', stat.total_physical_reads AS 'plan_total_physical_reads', 
      stat.total_logical_writes AS 'plan_total_logical_writes', stat.total_logical_reads AS 'plan_total_logical_reads', 
      LEFT (CASE 
        WHEN pa.value=32767 THEN 'ResourceDb'
        ELSE ISNULL (DB_NAME (CONVERT (sysname, pa.value)), CONVERT (sysname, pa.value))
      END, 40) AS 'dbname', 
      sql.objectid AS 'objectid', 
      CONVERT (nvarchar(60), CASE 
        WHEN sql.objectid IS NULL THEN NULL 
        ELSE REPLACE (REPLACE (SUBSTRING (sql.[text] COLLATE Latin1_General_BIN, CHARINDEX ('CREATE ', SUBSTRING (sql.[text] COLLATE Latin1_General_BIN, 1, 1000)), 50), CHAR(10), ' '), CHAR(13), ' ')
      END) AS procname, 
      CONVERT (nvarchar(300), REPLACE (REPLACE (CONVERT (nvarchar(300), SUBSTRING (sql.[text], ISNULL (r.statement_start_offset, 0)/2 + 1, 
          CASE WHEN ISNULL (r.statement_end_offset, 8192) <= 0 THEN 8192 
          ELSE ISNULL (r.statement_end_offset, 8192)/2 - ISNULL (r.statement_start_offset, 0)/2 END + 1)) COLLATE Latin1_General_BIN, 
        CHAR(13), ' '), CHAR(10), ' ')) AS 'stmt_text', 
      CONVERT (varbinary (64), (r.plan_handle)) AS 'plan_handle',
      group_id
    FROM #tmp_requests2 r
    LEFT OUTER JOIN sys.dm_exec_query_stats stat ON r.plan_handle = stat.plan_handle AND stat.statement_start_offset = r.statement_start_offset
    OUTER APPLY sys.dm_exec_plan_attributes (r.plan_handle) pa
    OUTER APPLY sys.dm_exec_sql_text (ISNULL (r.[sql_handle], r.most_recent_sql_handle)) AS sql
    WHERE (pa.attribute = 'dbid' COLLATE Latin1_General_BIN OR pa.attribute IS NULL) AND ISNULL (host_name, '') != @appname AND r.session_id != @@SPID 
      AND ( 
        /* We do not want to pull inputbuffers for everyone. The conditions below determine which ones we will fetch. */
        (r.session_id IN (SELECT blocking_session_id FROM #tmp_requests2 WHERE blocking_session_id != 0)) -- head blockers
        OR (r.blocking_session_id IN (SELECT blocking_session_id FROM #tmp_requests2 WHERE blocking_session_id != 0)) -- "first-tier" blocked requests
        OR (LTRIM (r.wait_type) <> '''' OR r.wait_duration_ms > 500) -- waiting for some resource
        OR (r.open_trans > 5) -- possible orphaned transaction
        OR (r.request_total_elapsed_time > 25000) -- long-running query
        OR (r.request_logical_reads > 1000000 OR r.request_cpu_time > 3000) -- expensive (CPU) query
        OR (r.request_reads + r.request_writes > 5000 OR r.pending_io_count > 400) -- expensive (I/O) query
        OR (r.memory_usage > 25600) -- expensive (memory > 200MB) query
        -- OR (r.is_sick > 0) -- spinloop
      )
    ORDER BY stat.total_worker_time/1000 DESC
    OPTION (MAX_GRANT_PERCENT = 3, MAXDOP 1)

    RAISERROR (' ', 0, 1) WITH NOWAIT

    SET @rowcount = @@ROWCOUNT
    SET @queryduration = DATEDIFF (ms, @querystarttime, GETDATE())
    IF @rowcount >= 500 PRINT 'WARNING: notableactivequeries output artificially limited to 500 rows'
    IF @queryduration > @qrydurationwarnthreshold
      PRINT 'DebugPrint: perfstats qry3 - ' + CONVERT (varchar, @queryduration) + 'ms, rowcount=' + CONVERT(varchar, @rowcount) + CHAR(13) + CHAR(10)

    IF '%runmode%' = 'REALTIME' BEGIN 
      -- In near-realtime/direct-to-database mode, we have to maintain tbl_BLOCKING_CHAINS on-the-fly
      -- 1) Insert new blocking chains
      RAISERROR ('', 0, 1) WITH NOWAIT
      INSERT INTO tbl_BLOCKING_CHAINS (first_rownum, last_rownum, num_snapshots, blocking_start, blocking_end, head_blocker_session_id, 
        blocking_wait_type, max_blocked_task_count, max_total_wait_duration_ms, avg_wait_duration_ms, max_wait_duration_ms, 
        max_blocking_chain_depth, head_blocker_session_id_orig)
      SELECT rownum, NULL, 1, runtime, NULL, 
        CASE WHEN blocking_resource_wait_type LIKE 'COMPILE%' THEN 'COMPILE BLOCKING' ELSE head_blocker_session_id END AS head_blocker_session_id, 
        blocking_resource_wait_type, blocked_task_count, tot_wait_duration_ms, avg_wait_duration_ms, max_wait_duration_ms, 
        max_blocking_chain_depth, head_blocker_session_id
      FROM tbl_HEADBLOCKERSUMMARY b1 
      WHERE b1.runtime = @runtime AND NOT EXISTS (
        SELECT * FROM tbl_BLOCKING_CHAINS b2  
        WHERE b2.blocking_end IS NULL  -- end-of-blocking has not been detected yet
          AND b2.head_blocker_session_id = CASE WHEN blocking_resource_wait_type LIKE 'COMPILE%' THEN 'COMPILE BLOCKING' ELSE head_blocker_session_id END -- same head blocker
          AND b2.blocking_wait_type = b1.blocking_resource_wait_type -- same type of blocking
      )
      OPTION (MAX_GRANT_PERCENT = 3, MAXDOP 1)

      PRINT 'Inserted ' + CONVERT (varchar, @@ROWCOUNT) + ' new blocking chains...'

      -- 2) Update statistics for in-progress blocking incidents
      UPDATE tbl_BLOCKING_CHAINS 
      SET last_rownum = b2.rownum, num_snapshots = b1.num_snapshots + 1, 
        max_blocked_task_count = CASE WHEN b1.max_blocked_task_count > b2.blocked_task_count THEN b1.max_blocked_task_count ELSE b2.blocked_task_count END, 
        max_total_wait_duration_ms = CASE WHEN b1.max_total_wait_duration_ms > b2.tot_wait_duration_ms THEN b1.max_total_wait_duration_ms ELSE b2.tot_wait_duration_ms END, 
        avg_wait_duration_ms = (b1.num_snapshots-1) * b1.avg_wait_duration_ms + b2.avg_wait_duration_ms / b1.num_snapshots, 
        max_wait_duration_ms = CASE WHEN b1.max_wait_duration_ms > b2.max_wait_duration_ms THEN b1.max_wait_duration_ms ELSE b2.max_wait_duration_ms END, 
        max_blocking_chain_depth = CASE WHEN b1.max_blocking_chain_depth > b2.max_blocking_chain_depth THEN b1.max_blocking_chain_depth ELSE b2.max_blocking_chain_depth END
      FROM tbl_BLOCKING_CHAINS b1 
      INNER JOIN tbl_HEADBLOCKERSUMMARY b2 ON b1.blocking_end IS NULL -- end-of-blocking has not been detected yet
          AND b2.head_blocker_session_id = b1.head_blocker_session_id -- same head blocker
          AND b1.blocking_wait_type = b2.blocking_resource_wait_type -- same type of blocking
          AND b2.runtime = @runtime
      PRINT 'Updated ' + CONVERT (varchar, @@ROWCOUNT) + ' in-progress blocking chains...'

      -- 3) "Close out" blocking chains that were just resolved
      UPDATE tbl_BLOCKING_CHAINS 
      SET blocking_end = @runtime
      FROM tbl_BLOCKING_CHAINS b1
      WHERE blocking_end IS NULL AND NOT EXISTS (
        SELECT * FROM tbl_HEADBLOCKERSUMMARY b2 WHERE b2.runtime = @runtime 
          AND b2.head_blocker_session_id = b1.head_blocker_session_id -- same head blocker
          AND b1.blocking_wait_type = b2.blocking_resource_wait_type -- same type of blocking
      )
      PRINT + CONVERT (varchar, @@ROWCOUNT) + ' blocking chains have ended.'
    END
  END

  
  SET @rowcount = @@ROWCOUNT
  SET @queryduration = DATEDIFF (ms, @querystarttime, GETDATE())
  IF @queryduration > @qrydurationwarnthreshold
    PRINT 'DebugPrint: perfstats qry4 - ' + CONVERT (varchar, @queryduration) + 'ms, rowcount=' + CONVERT(varchar, @rowcount) + CHAR(13) + CHAR(10)

  -- Raise a diagnostic message if we use much more CPU than normal (a typical execution uses <300ms)
  DECLARE @cpu_time bigint, @elapsed_time bigint
  SELECT @cpu_time = cpu_time - @cpu_time_start, @elapsed_time = total_elapsed_time - @elapsed_time_start FROM sys.dm_exec_sessions WHERE session_id = @@SPID
  IF (@elapsed_time > 2000 OR @cpu_time > 750)
    PRINT 'DebugPrint: perfstats tot - ' + CONVERT (varchar, @elapsed_time) + 'ms elapsed, ' + CONVERT (varchar, @cpu_time) + 'ms cpu' + CHAR(13) + CHAR(10)  

  RAISERROR ('', 0, 1) WITH NOWAIT

  print '-- debug info finishing sp_perf_stats --'
  print ''


GO


IF OBJECT_ID ('sp_perf_stats_infrequent','P') IS NOT NULL
   DROP PROCEDURE sp_perf_stats_infrequent
GO
CREATE PROCEDURE sp_perf_stats_infrequent @runtime datetime, @prevruntime datetime, @prevmsticks bigint, @lastmsticks bigint output, @firstrun tinyint = 0, @IsLite bit = 0
 AS 
 
  SET NOCOUNT ON
  print '-- debug info starting sp_perf_stats_infrequent --'
  print ''
  DECLARE @queryduration int
  DECLARE @querystarttime datetime
  DECLARE @qrydurationwarnthreshold int
  DECLARE @cpu_time_start bigint, @elapsed_time_start bigint
  DECLARE @servermajorversion int
  DECLARE @msg varchar(100)
  DECLARE @sql nvarchar(max)
  DECLARE @rowcount bigint
  DECLARE @msticks bigint
  DECLARE @mstickstime datetime
  DECLARE @procname varchar(50) = OBJECT_NAME(@@PROCID)

  IF @runtime IS NULL 
  BEGIN 
    SET @runtime = GETDATE()
    SET @msg = 'Start time: ' + CONVERT (varchar(30), @runtime, 126)
    RAISERROR (@msg, 0, 1) WITH NOWAIT
  END
  SET @qrydurationwarnthreshold = 750

  SELECT @cpu_time_start = cpu_time, @elapsed_time_start = total_elapsed_time FROM sys.dm_exec_sessions WHERE session_id = @@SPID

  /* SERVERPROPERTY ('ProductVersion') returns e.g. "9.00.2198.00" --> 9 */
  SET @servermajorversion = REPLACE (LEFT (CONVERT (varchar, SERVERPROPERTY ('ProductVersion')), 2), '.', '')


  /* Resultset #1: Server global wait stats */
  PRINT ''
  RAISERROR ('-- dm_os_wait_stats --', 0, 1) WITH NOWAIT;
  SET @querystarttime = GETDATE()

  SELECT /*qry1*/ CONVERT (varchar(30), @runtime, 126) AS 'runtime', waiting_tasks_count, wait_time_ms, max_wait_time_ms, signal_wait_time_ms, wait_type
  FROM sys.dm_os_wait_stats 
  WHERE waiting_tasks_count > 0 OR wait_time_ms > 0 OR signal_wait_time_ms > 0
  ORDER BY wait_time_ms DESC

  RAISERROR (' ', 0, 1) WITH NOWAIT;
  SET @queryduration = DATEDIFF (ms, @querystarttime, GETDATE())
  IF @queryduration > @qrydurationwarnthreshold
    PRINT 'DebugPrint: perfstats2 qry1 - ' + CONVERT (varchar, @queryduration) + 'ms' + CHAR(13) + CHAR(10)


  /* Resultset #2: Spinlock stats
  ** No DMV for this -- we will synthesize the [runtime] column during data load. */
  --PRINT ''
  --RAISERROR ('-- DBCC SQLPERF (SPINLOCKSTATS) --', 0, 1) WITH NOWAIT;
  --DBCC SQLPERF (SPINLOCKSTATS)


  /* Resultset #2a: dm_os_spinlock_stats */
  PRINT ''
  RAISERROR ('--  dm_os_spinlock_stats --', 0, 1) WITH NOWAIT;
  SET @querystarttime = GETDATE()

  SELECT /*qry2a*/ CONVERT (varchar(30), @runtime, 126) AS 'runtime', collisions, spins, spins_per_collision, sleep_time, backoffs, name 
  FROM sys.dm_os_spinlock_stats
  WHERE spins > 0

  RAISERROR (' ', 0, 1) WITH NOWAIT;
  SET @queryduration = DATEDIFF (ms, @querystarttime, GETDATE())
  IF @queryduration > @qrydurationwarnthreshold
    PRINT 'DebugPrint: perfstats2 qry2a - ' + CONVERT (varchar, @queryduration) + 'ms' + CHAR(13) + CHAR(10)

    
  /* Resultset #3: basic perf-related SQL perfmon counters */
  PRINT ''
  RAISERROR ('-- sysperfinfo_raw (general perf subset) --', 0, 1) WITH NOWAIT;
  SET @querystarttime = GETDATE()
 
  /* Force binary collation to speed up string comparisons (query uses 10-20ms CPU w/binary collation, 200-300ms otherwise) */
  
  SELECT /*qry3*/ 
    CONVERT (varchar(30), @runtime, 126) AS 'runtime', cntr_value,
    SUBSTRING ([object_name], CHARINDEX (':', [object_name]) + 1, 30) AS [object_name], 
    LEFT (counter_name, 40) AS 'counter_name', LEFT (instance_name, 50) AS 'instance_name'
  FROM sys.dm_os_performance_counters 
  WHERE 
       ([object_name] LIKE '%:Memory Manager%' COLLATE Latin1_General_BIN     AND counter_name COLLATE Latin1_General_BIN IN ('Connection Memory (KB)', 'Granted Workspace Memory (KB)', 'Lock Memory (KB)', 'Memory Grants Outstanding', 'Memory Grants Pending', 'Optimizer Memory (KB)', 'SQL Cache Memory (KB)'))
    OR ([object_name] LIKE '%:Buffer Manager%' COLLATE Latin1_General_BIN     AND counter_name COLLATE Latin1_General_BIN IN ('Buffer cache hit ratio', 'Buffer cache hit ratio base', 'Page lookups/sec', 'Page life expectancy', 'Lazy writes/sec', 'Page reads/sec', 'Page writes/sec', 'Checkpoint pages/sec', 'Free pages', 'Total pages', 'Target pages', 'Stolen pages'))
    OR ([object_name] LIKE '%:General Statistics%' COLLATE Latin1_General_BIN AND counter_name COLLATE Latin1_General_BIN IN ('User Connections', 'Transactions', 'Processes blocked'))
    OR ([object_name] LIKE '%:Access Methods%' COLLATE Latin1_General_BIN     AND counter_name COLLATE Latin1_General_BIN IN ('Index Searches/sec', 'Pages Allocated/sec', 'Table Lock Escalations/sec'))
    OR ([object_name] LIKE '%:SQL Statistics%' COLLATE Latin1_General_BIN     AND counter_name COLLATE Latin1_General_BIN IN ('Batch Requests/sec', 'Forced Parameterizations/sec', 'SQL Compilations/sec', 'SQL Re-Compilations/sec', 'SQL Attention rate'))
    OR ([object_name] LIKE '%:Transactions%' COLLATE Latin1_General_BIN       AND counter_name COLLATE Latin1_General_BIN IN ('Transactions', 'Snapshot Transactions', 'Longest Transaction Running Time', 'Free Space in tempdb (KB)', 'Version Generation rate (KB/s)'))
    OR ([object_name] LIKE '%:CLR%' COLLATE Latin1_General_BIN                AND counter_name COLLATE Latin1_General_BIN IN ('CLR Execution'))
    OR ([object_name] LIKE '%:Wait Statistics%' COLLATE Latin1_General_BIN    AND instance_name COLLATE Latin1_General_BIN IN ('Waits in progress', 'Average wait time (ms)'))
    OR ([object_name] LIKE '%:Exec Statistics%' COLLATE Latin1_General_BIN    AND instance_name COLLATE Latin1_General_BIN IN ('Average execution time (ms)', 'Execs in progress', 'Cumulative execution time (ms) per second'))
    OR ([object_name] LIKE '%:Plan Cache%' COLLATE Latin1_General_BIN             AND instance_name = '_Total' COLLATE Latin1_General_BIN AND counter_name COLLATE Latin1_General_BIN IN ('Cache Hit Ratio', 'Cache Hit Ratio Base', 'Cache Pages', 'Cache Object Counts'))
    OR ([object_name] LIKE '%:Locks%' COLLATE Latin1_General_BIN                  AND instance_name = '_Total' COLLATE Latin1_General_BIN AND counter_name COLLATE Latin1_General_BIN IN ('Lock Requests/sec', 'Number of Deadlocks/sec', 'Lock Timeouts (timeout > 0)/sec'))
    OR ([object_name] LIKE '%:Databases%' COLLATE Latin1_General_BIN              AND instance_name = '_Total' COLLATE Latin1_General_BIN AND counter_name COLLATE Latin1_General_BIN IN ('Data File(s) Size (KB)', 'Log File(s) Size (KB)', 'Log File(s) Used Size (KB)', 'Active Transactions', 'Transactions/sec', 'Bulk Copy Throughput/sec', 'Backup/Restore Throughput/sec', 'DBCC Logical Scan Bytes/sec', 'Log Flush Wait Time', 'Log Growths', 'Log Shrinks'))
    OR ([object_name] LIKE '%:Cursor Manager by Type%' COLLATE Latin1_General_BIN AND instance_name = '_Total' COLLATE Latin1_General_BIN AND counter_name COLLATE Latin1_General_BIN IN ('Cached Cursor Counts', 'Cursor Requests/sec', 'Cursor memory usage'))
    OR ([object_name] LIKE '%:Catalog Metadata%' COLLATE Latin1_General_BIN       AND instance_name = '_Total' COLLATE Latin1_General_BIN AND counter_name COLLATE Latin1_General_BIN IN ('Cache Hit Ratio', 'Cache Hit Ratio Base', 'Cache Entries Count'))
  OPTION (MAX_GRANT_PERCENT = 3, MAXDOP 1)

  RAISERROR (' ', 0, 1) WITH NOWAIT;

  SET @queryduration = DATEDIFF (ms, @querystarttime, GETDATE())
  IF @queryduration > @qrydurationwarnthreshold
    PRINT 'DebugPrint: perfstats2 qry3 - ' + CONVERT (varchar, @queryduration) + 'ms' + CHAR(13) + CHAR(10)


  /* Resultset #4: SQL processor utilization */
  PRINT ''
  RAISERROR ('-- Recent SQL Processor Utilization (Health Records) --', 0, 1) WITH NOWAIT;
  SELECT @querystarttime = GETDATE(), @msticks = ms_ticks from sys.dm_os_sys_info
  SET @mstickstime = @querystarttime
  
  SELECT  /*qry4*/
      CONVERT (varchar(30), @runtime, 126) AS 'runtime', 
      record.value('(Record/@id)[1]', 'int') AS 'record_id',
      CONVERT (varchar, DATEADD (ms, -1 * (@msticks - [timestamp]),@mstickstime), 126) AS 'EventTime', [timestamp], 
      record.value('(Record/SchedulerMonitorEvent/SystemHealth/SystemIdle)[1]', 'int') AS 'system_idle_cpu',
      record.value('(Record/SchedulerMonitorEvent/SystemHealth/ProcessUtilization)[1]', 'int') AS 'sql_cpu_utilization' 
    FROM (
      SELECT timestamp, CONVERT (xml, record) AS 'record' 
      FROM sys.dm_os_ring_buffers 
      WHERE [timestamp] > @prevmsticks
        AND ring_buffer_type = 'RING_BUFFER_SCHEDULER_MONITOR'
        and record LIKE '%<SystemHealth>%') AS t
    ORDER BY record.value('(Record/@id)[1]', 'int') 
    OPTION (MAX_GRANT_PERCENT = 3, MAXDOP 1)

   RAISERROR (' ', 0, 1) WITH NOWAIT;
  SET @queryduration = DATEDIFF (ms, @querystarttime, GETDATE())
  IF @queryduration > @qrydurationwarnthreshold
    PRINT 'DebugPrint: perfstats2 qry4 - ' + CONVERT (varchar, @queryduration) + 'ms' + CHAR(13) + CHAR(10)


  /* Resultset #5: sys.dm_os_sys_info 
  ** used to determine the # of CPUs SQL is able to use at the moment */
  PRINT ''
  RAISERROR ('-- sys.dm_os_sys_info --', 0, 1) WITH NOWAIT;
  SELECT /*qry5*/ CONVERT (varchar(30), @runtime, 126) AS 'runtime', * FROM sys.dm_os_sys_info


  /* Resultset #6: sys.dm_os_latch_stats */
  PRINT ''
  RAISERROR ('-- sys.dm_os_latch_stats --', 0, 1) WITH NOWAIT;
  SELECT /*qry6*/ CONVERT (varchar(30), @runtime, 126) AS 'runtime', waiting_requests_count, wait_time_ms, max_wait_time_ms, latch_class
    FROM sys.dm_os_latch_stats 
    WHERE waiting_requests_count > 0 OR wait_time_ms > 0 OR max_wait_time_ms > 0
    ORDER BY wait_time_ms DESC
    OPTION (MAX_GRANT_PERCENT = 3, MAXDOP 1)

  /* Resultset #7: File Stats Full
  ** To conserve space, output full dbname and filenames on 1st execution only. */
  PRINT ''
  RAISERROR ('-- File Stats (full) --', 0, 1) WITH NOWAIT;
  SET @sql = 'SELECT /*' + @procname + ':7 */ CONVERT (varchar(30), @runtime, 126) AS runtime, 
    fs.DbId, fs.FileId, 
    fs.IoStallMS / (fs.NumberReads + fs.NumberWrites + 1) AS AvgIOTimeMS, fs.[TimeStamp], fs.NumberReads, fs.BytesRead, 
    fs.IoStallReadMS, fs.NumberWrites, fs.BytesWritten, fs.IoStallWriteMS, fs.IoStallMS, fs.BytesOnDisk, 
    f.type, LEFT (f.type_desc, 10) AS type_desc, f.data_space_id, f.state, LEFT (f.state_desc, 15) AS state_desc, 
    f.[size], f.max_size, f.growth, f.is_sparse, f.is_percent_growth'

  IF @firstrun = 0 
    SET @sql = @sql + ', NULL AS [database], NULL AS [file]'
  ELSE
    SET @sql = @sql + ', d.name AS [database], f.physical_name AS [file]'
  SET @sql = @sql + 'FROM ::fn_virtualfilestats (null, null) fs
  INNER JOIN master.dbo.sysdatabases d ON d.dbid = fs.DbId
  INNER JOIN sys.master_files f ON fs.DbId = f.database_id AND fs.FileId = f.[file_id]
  ORDER BY AvgIOTimeMS DESC
  OPTION (MAX_GRANT_PERCENT = 3, MAXDOP 1)
  '

  
  SET @querystarttime = GETDATE()

  EXEC sp_executesql @sql, N'@runtime datetime', @runtime = @runtime

  RAISERROR (' ', 0, 1) WITH NOWAIT;
  SET @queryduration = DATEDIFF (ms, @querystarttime, GETDATE())
  IF @queryduration > @qrydurationwarnthreshold
    PRINT 'DebugPrint: perfstats2 qry7 - ' + CONVERT (varchar, @queryduration) + 'ms' + CHAR(13) + CHAR(10)

 
  /* Resultset #8: dm_exec_query_resource_semaphores 
  ** no reason to list columns since no long character columns */
  PRINT ''
  RAISERROR ('-- dm_exec_query_resource_semaphores --', 0, 1) WITH NOWAIT;
  SELECT /*qry8*/ CONVERT (varchar(30), @runtime, 126) AS 'runtime', * from sys.dm_exec_query_resource_semaphores


  /* Resultset #9: dm_exec_query_memory_grants 
  ** Query sometimes causes follow message:
  ** Warning: The join order has been enforced because a local join hint is used.*/
  PRINT ''
  RAISERROR ('-- dm_exec_query_memory_grants --', 0, 1) WITH NOWAIT;
  SELECT /*qry9*/ CONVERT (varchar(30), @runtime, 126) AS 'runtime', session_id, request_id, scheduler_id, dop, request_time, grant_time, requested_memory_kb, 
        granted_memory_kb, required_memory_kb, used_memory_kb, max_used_memory_kb, query_cost, timeout_sec, resource_semaphore_id, queue_id, wait_order, is_next_candidate, 
        wait_time_ms, group_id, pool_id, is_small ideal_memory_kb, plan_handle, [sql_handle],
        convert(smallint, substring(plan_handle,4,1) + substring(plan_handle,3,1)) as [database_id],
        case when substring(plan_handle,1,1) = 0x05 then convert(int, substring(plan_handle,8,1) + substring(plan_handle,7,1) + substring(plan_handle,6,1) + substring(plan_handle,5,1))
            else NULL end as [object_id],
        case when substring(plan_handle,1,1) = 0x05 then 
            '[' + DB_NAME(convert(smallint, substring(plan_handle,4,1) + substring(plan_handle,3,1)))
            + '].[' + object_schema_name(convert(int, substring(plan_handle,8,1) + substring(plan_handle,7,1) + substring(plan_handle,6,1) + substring(plan_handle,5,1)),convert(smallint, substring(plan_handle,4,1) + substring(plan_handle,3,1)))
            + '].['+ object_name(convert(int, substring(plan_handle,8,1) + substring(plan_handle,7,1) + substring(plan_handle,6,1) + substring(plan_handle,5,1)),convert(smallint, substring(plan_handle,4,1) + substring(plan_handle,3,1))) + ']' 
            else 'ad-hoc query, see notableactivequeries for text' end as 'full_object_name'
    FROM sys.dm_exec_query_memory_grants
    OPTION (MAX_GRANT_PERCENT = 3, MAXDOP 1)

  /* Resultset #10: dm_os_memory_brokers */
  PRINT ''
  RAISERROR ('-- dm_os_memory_brokers --', 0, 1) WITH NOWAIT;
  SELECT /*qry10*/ CONVERT (varchar(30), @runtime, 126) AS 'runtime', pool_id, allocations_kb, allocations_kb_per_sec, predicted_allocations_kb, target_allocations_kb, future_allocations_kb, overall_limit_kb, last_notification, memory_broker_type 
  FROM sys.dm_os_memory_brokers

  /* Resultset #11: dm_os_schedulers 
  ** no reason to list columns since no long character columns */
  PRINT ''
  RAISERROR ('-- dm_os_schedulers --', 0, 1) WITH NOWAIT;
  SELECT /*qry11*/ CONVERT (varchar(30), @runtime, 126) as 'runtime', * 
  FROM sys.dm_os_schedulers


  /* Resultset #12: dm_os_nodes */
  PRINT ''
  RAISERROR ('-- sys.dm_os_nodes --', 0, 1) WITH NOWAIT;
  SELECT /*qry12*/ CONVERT (varchar(30), @runtime, 126) as 'runtime', node_id, memory_object_address, memory_clerk_address, io_completion_worker_address, memory_node_id, cpu_affinity_mask, online_scheduler_count, idle_scheduler_count, active_worker_count, avg_load_balance, timer_task_affinity_mask, permanent_task_affinity_mask, resource_monitor_state,/* online_scheduler_mask,*/ /*processor_group,*/ node_state_desc 
  FROM sys.dm_os_nodes


  /* Resultset #13: dm_os_memory_nodes 
  ** no reason to list columns since no long character columns */
  PRINT ''
  RAISERROR ('-- sys.dm_os_memory_nodes --', 0, 1) WITH NOWAIT;
  SELECT /*qry13*/ CONVERT (varchar(30), @runtime, 126) as 'runtime',* 
  FROM sys.dm_os_memory_nodes


  /* Resultset #14: Lock summary */
  PRINT ''
  RAISERROR ('-- Lock summary --', 0, 1) WITH NOWAIT;
  SET @querystarttime = GETDATE()

  select /*qry14*/ CONVERT (varchar(30), @runtime, 126) as 'runtime', * from 
    (SELECT  count (*) as 'LockCount', Resource_database_id, LEFT(resource_type,15) as 'resource_type', LEFT(request_mode,20) as 'request_mode', request_status 
     FROM sys.dm_tran_locks 
     GROUP BY  Resource_database_id, resource_type, request_mode, request_status ) t

   RAISERROR (' ', 0, 1) WITH NOWAIT;
  SET @queryduration = DATEDIFF (ms, @querystarttime, GETDATE())
  IF @queryduration > @qrydurationwarnthreshold
    PRINT 'DebugPrint: perfstats2 qry14 - ' + CONVERT (varchar, @queryduration) + 'ms' + CHAR(13) + CHAR(10)


  /* Resultset #15: Thread Statistics */
  PRINT ''
  RAISERROR ('-- Thread Statistics --', 0, 1) WITH NOWAIT
  SET @querystarttime = GETDATE()

  SELECT /*qry15*/ CONVERT (varchar(30), @runtime, 126) as 'runtime', th.os_thread_id, ta.scheduler_id, ta.session_id, ta.request_id, req.command, usermode_time, kernel_time, req.cpu_time as 'req_cpu_time',  req.logical_reads,req.total_elapsed_time,
      REPLACE (REPLACE (SUBSTRING (sql.[text], CHARINDEX ('CREATE ', CONVERT (nvarchar(512), SUBSTRING (sql.[text], 1, 1000)) COLLATE Latin1_General_BIN), 50) COLLATE Latin1_General_BIN, CHAR(10), ' '), CHAR(13), ' ') as 'QueryText'
  FROM sys.dm_os_threads th join sys.dm_os_tasks ta on th.worker_address = ta.worker_address
    LEFT OUTER JOIN sys.dm_exec_requests req on ta.session_id = req.session_id 
      AND ta.request_id = req.request_id
    OUTER APPLY sys.dm_exec_sql_text (req.sql_handle) sql
  OPTION (MAX_GRANT_PERCENT = 3, MAXDOP 1)

      RAISERROR (' ', 0, 1) WITH NOWAIT;
  SET @queryduration = DATEDIFF (ms, @querystarttime, GETDATE())
  IF @queryduration > @qrydurationwarnthreshold
    PRINT 'DebugPrint: perfstats2 qry15 - ' + CONVERT (varchar, @queryduration) + 'ms' + CHAR(13) + CHAR(10)


  /* Resultset #16: dm_db_file_space_usage 
  ** must be run from tempdb */
  PRINT ''
  RAISERROR ('-- dm_db_file_space_usage --', 0, 1) WITH NOWAIT;
  SET @querystarttime = GETDATE()

  SELECT /*qry16*/ CONVERT (varchar(30), @runtime, 126) AS 'runtime', * FROM sys.dm_db_file_space_usage

  RAISERROR (' ', 0, 1) WITH NOWAIT;
  SET @queryduration = DATEDIFF (ms, @querystarttime, GETDATE())
  IF @queryduration > @qrydurationwarnthreshold
    PRINT 'DebugPrint: perfstats2 qry16 - ' + CONVERT (varchar, @queryduration) + 'ms' + CHAR(13) + CHAR(10)


  /* Resultset #17: dm_exec_cursors(0) */
  PRINT ''
  RAISERROR ('-- dm_exec_cursors(0) --', 0, 1) WITH NOWAIT;
  SET @querystarttime = GETDATE()

  SELECT /*qry17*/ CONVERT (varchar(30), @runtime, 126) AS 'runtime', COUNT(*) AS 'count', SUM(CONVERT(INT,is_open)) AS 'open count', MIN(creation_time) AS 'oldest create',[properties]
  FROM sys.dm_exec_cursors(0)
  GROUP BY [properties]

    RAISERROR (' ', 0, 1) WITH NOWAIT;
  SET @queryduration = DATEDIFF (ms, @querystarttime, GETDATE())
  IF @queryduration > @qrydurationwarnthreshold
    PRINT 'DebugPrint: perfstats2 qry17 - ' + CONVERT (varchar, @queryduration) + 'ms' + CHAR(13) + CHAR(10)


  /* Resultset #18:  dm_os_ring_buffers for connectivity
  ** return all rows on first run and then after only new rows in later runs */
  PRINT ''
  RAISERROR ('-- dm_os_ring_buffers --', 0, 1) WITH NOWAIT;
  SET @querystarttime = GETDATE()

  SET @sql = '
    SELECT /*' + @procname + ':18*/  
        CONVERT (varchar(30), @runtime, 126) AS runtime, 
        CONVERT (varchar(23), DATEADD (ms, -1 * (@msticks - [timestamp]), @mstickstime), 126) AS EventTime, 
        [record] 
      FROM sys.dm_os_ring_buffers 
      WHERE [timestamp] > @prevmsticks 
        AND ring_buffer_type in (''RING_BUFFER_CONNECTIVITY'',''RING_BUFFER_SECURITY_ERROR'')
      ORDER BY [timestamp]'

  EXEC sp_executesql @sql, N'@runtime datetime, @prevmsticks bigint, @msticks bigint, @mstickstime datetime', @runtime = @runtime, @prevmsticks = @prevmsticks, @msticks = @msticks, @mstickstime = @mstickstime


  RAISERROR (' ', 0, 1) WITH NOWAIT;
  SET @queryduration = DATEDIFF (ms, @querystarttime, GETDATE())
  --SET @lastmsticks = @msticks		
  IF @queryduration > @qrydurationwarnthreshold
    PRINT 'DebugPrint: perfstats2 qry18 - ' + CONVERT (varchar, @queryduration) + 'ms' + CHAR(13) + CHAR(10)


  /* Resultset #19: Plan Cache Stats */
  PRINT ''
  RAISERROR ('-- Plan Cache Stats --', 0, 1) WITH NOWAIT;
  SET @querystarttime = GETDATE()

  SELECT /*qry19*/ CONVERT (varchar(30), @runtime, 126) AS 'runtime',*  from 
    (SELECT  objtype, sum(cast(size_in_bytes as bigint) /cast(1024.00 as decimal(38,2)) /1024.00) 'Cache_Size_MB' , count_big (*) 'Entry_Count', isnull(db_name(cast (value as int)),'mssqlsystemresource') 'db name'
      FROM  sys.dm_exec_cached_plans AS p CROSS APPLY sys.dm_exec_plan_attributes ( plan_handle ) as t 
      WHERE attribute='dbid'
      GROUP BY  isnull(db_name(cast (value as int)),'mssqlsystemresource'), objtype )  t
  ORDER BY Entry_Count desc
  OPTION (MAX_GRANT_PERCENT = 3, MAXDOP 1)


    RAISERROR (' ', 0, 1) WITH NOWAIT;
  SET @queryduration = DATEDIFF (ms, @querystarttime, GETDATE())
  IF @queryduration > @qrydurationwarnthreshold
    PRINT 'DebugPrint: perfstats2 qry19 - ' + CONVERT (varchar, @queryduration) + 'ms' + CHAR(13) + CHAR(10)


  /* Resultset #20: System Requests */
  PRINT ''
  RAISERROR ('-- System Requests --', 0, 1) WITH NOWAIT
  SET @querystarttime = GETDATE()
  
  SELECT /*qry20*/ CONVERT (varchar(30), @runtime, 126) AS 'runtime', tr.os_thread_id, req.* 
  FROM sys.dm_exec_requests req 
      JOIN sys.dm_os_workers wrk  on req.task_address = wrk.task_address and req.connection_id is null
      JOIN sys.dm_os_threads tr on tr.worker_address=wrk.worker_address
   OPTION (MAX_GRANT_PERCENT = 3, MAXDOP 1)

      RAISERROR (' ', 0, 1) WITH NOWAIT;
  SET @rowcount = @@ROWCOUNT
  SET @queryduration = DATEDIFF (ms, @querystarttime, GETDATE())
  IF @queryduration > @qrydurationwarnthreshold
    PRINT 'DebugPrint: perfstats2 qry20 - ' + CONVERT (varchar, @queryduration) + 'ms, rowcount=' + CONVERT(varchar, @rowcount) + CHAR(13) + CHAR(10)


  /* Resultset #21: sys.dm_os_process_memory */
  print ''
  RAISERROR ('-- sys.dm_os_process_memory --', 0, 1) WITH NOWAIT
  SET @querystarttime = GETDATE()

  select /*qry21*/ CONVERT (varchar(30), @runtime, 126) AS 'runtime',* from sys.dm_os_process_memory

  RAISERROR (' ', 0, 1) WITH NOWAIT;
  SET @queryduration = DATEDIFF (ms, @querystarttime, GETDATE())
  IF @queryduration > @qrydurationwarnthreshold
    PRINT 'DebugPrint: perfstats2 qry21 - ' + CONVERT (varchar, @queryduration) + 'ms' + CHAR(13) + CHAR(10)

  /* Resultset #22: sys.dm_os_sys_memory */
  print ''
  RAISERROR ('-- sys.dm_os_sys_memory --', 0, 1) WITH NOWAIT
  SET @querystarttime = GETDATE()

  select /*qry22*/ CONVERT (varchar(30), @runtime, 126) AS 'runtime',* from sys.dm_os_sys_memory

  RAISERROR (' ', 0, 1) WITH NOWAIT;
  SET @queryduration = DATEDIFF (ms, @querystarttime, GETDATE())
  IF @queryduration > @qrydurationwarnthreshold
    PRINT 'DebugPrint: perfstats2 qry22 - ' + CONVERT (varchar, @queryduration) + 'ms' + CHAR(13) + CHAR(10)

  /* Resultset #23:  dm_os_ring_buffers for security cache
  ** return all rows on first run and then after only new rows in later runs */
    IF (CONVERT(smallint,SERVERPROPERTY ('ProductMajorVersion')) < 15)
        PRINT '' -- we do not capture this information for versions lower than SQL 2019
    ELSE
        BEGIN
            PRINT ''
            RAISERROR ('-- dm_os_ring_buffers_sec_cache --', 0, 1) WITH NOWAIT;
            SET @querystarttime = GETDATE()

            SET @sql = '
                SELECT /*' + @procname + ':23*/  
                    CONVERT (varchar(30), @runtime, 126) AS runtime, 
                    CONVERT (varchar(23), DATEADD (ms, -1 * (@msticks - [timestamp]), @mstickstime), 126) AS EventTime, 
                    [record] 
                  FROM sys.dm_os_ring_buffers 
                  WHERE [timestamp] > @prevmsticks 
                    AND ring_buffer_type in (''RING_BUFFER_SECURITY_CACHE'')
                  ORDER BY [timestamp]'

            EXEC sp_executesql @sql, N'@runtime datetime, @prevmsticks bigint, @msticks bigint, @mstickstime datetime', @runtime = @runtime, @prevmsticks = @prevmsticks, @msticks = @msticks, @mstickstime = @mstickstime


            RAISERROR (' ', 0, 1) WITH NOWAIT;
            SET @queryduration = DATEDIFF (ms, @querystarttime, GETDATE())
            IF @queryduration > @qrydurationwarnthreshold
                PRINT 'DebugPrint: perfstats2 qry23 - ' + CONVERT (varchar, @queryduration) + 'ms' + CHAR(13) + CHAR(10)
        END
    SET @lastmsticks = @msticks	-- Note that this is used by multiple ring buffer queries in this proc so be careful where you position this

  /* Raise a diagnostic message if we use more CPU than normal (a typical execution uses <200ms) */
  DECLARE @cpu_time bigint, @elapsed_time bigint
  SELECT @cpu_time = cpu_time - @cpu_time_start, @elapsed_time = total_elapsed_time - @elapsed_time_start FROM sys.dm_exec_sessions WHERE session_id = @@SPID
  IF (@elapsed_time > 3000 OR @cpu_time > 1000) BEGIN
    PRINT ''
    PRINT 'DebugPrint: perfstats2 tot - ' + CONVERT (varchar, @elapsed_time) + 'ms elapsed, ' + CONVERT (varchar, @cpu_time) + 'ms cpu' + CHAR(13) + CHAR(10)  
  END

  RAISERROR ('', 0, 1) WITH NOWAIT;
  print '-- debug info finishing sp_perf_stats_infrequent --'
  print ''

GO
IF OBJECT_ID ('sp_mem_stats_grants','P') IS NOT NULL
   DROP PROCEDURE sp_mem_stats_grants
GO

CREATE PROCEDURE sp_mem_stats_grants @runtime datetime , @lastruntime datetime =null
as
print '-- query execution memory --'
SELECT    CONVERT (varchar(30), @runtime, 121) as runtime, 
        r.session_id
         , r.blocking_session_id
         , r.cpu_time
         , r.total_elapsed_time
         , r.reads
         , r.writes
         , r.logical_reads
         , r.row_count
         , wait_time
         , wait_type
         , r.command
         , ltrim(rtrim(replace(replace (substring (q.text, 1, 1000), char(10), ' '), char(13), ' '))) [text]
         --, REPLACE (REPLACE (SUBSTRING (q.[text] COLLATE Latin1_General_BIN, CHARINDEX (''CREATE '', SUBSTRING (q.[text] COLLATE Latin1_General_BIN, 1, 1000)), 50), CHAR(10), '' ''), CHAR(13), '' '')
         --, q.TEXT  --Full SQL Text
         , s.login_time
         , d.name
         , s.login_name
         , s.host_name
         , s.nt_domain
         , s.nt_user_name
         , s.status
         , c.client_net_address
         , s.program_name
         , s.client_interface_name
--         , s.total_elapsed_time
         , s.last_request_start_time
         , s.last_request_end_time
         , c.connect_time
         , c.last_read
         , c.last_write
         , mg.dop --Degree of parallelism 
         , mg.request_time  --Date and time when this query requested the memory grant.
         , mg.grant_time --NULL means memory has not been granted
         , mg.requested_memory_kb
          / 1024 requested_memory_mb --Total requested amount of memory in megabytes
         , mg.granted_memory_kb
          / 1024 AS granted_memory_mb --Total amount of memory actually granted in megabytes. NULL if not granted
         , mg.required_memory_kb
          / 1024 AS required_memory_mb--Minimum memory required to run this query in megabytes. 
         , max_used_memory_kb
          / 1024 AS max_used_memory_mb
         , mg.query_cost --Estimated query cost.
         , mg.timeout_sec --Time-out in seconds before this query gives up the memory grant request.
         , mg.resource_semaphore_id --Nonunique ID of the resource semaphore on which this query is waiting.
         , mg.wait_time_ms --Wait time in milliseconds. NULL if the memory is already granted.
         , CASE mg.is_next_candidate --Is this process the next candidate for a memory grant
           WHEN 1 THEN 'Yes'
           WHEN 0 THEN 'No'
           ELSE 'Memory has been granted'
         END AS 'Next Candidate for Memory Grant'
         , rs.target_memory_kb
          / 1024 AS server_target_memory_mb --Grant usage target in megabytes.
         , rs.max_target_memory_kb
          / 1024 AS server_max_target_memory_mb --Maximum potential target in megabytes. NULL for the small-query resource semaphore.
         , rs.total_memory_kb
          / 1024 AS server_total_memory_mb --Memory held by the resource semaphore in megabytes. 
         , rs.available_memory_kb
          / 1024 AS server_available_memory_mb --Memory available for a new grant in megabytes.
         , rs.granted_memory_kb
          / 1024 AS server_granted_memory_mb  --Total granted memory in megabytes.
         , rs.used_memory_kb
          / 1024 AS server_used_memory_mb --Physically used part of granted memory in megabytes.
         , rs.grantee_count --Number of active queries that have their grants satisfied.
         , rs.waiter_count --Number of queries waiting for grants to be satisfied.
         , rs.timeout_error_count --Total number of time-out errors since server startup. NULL for the small-query resource semaphore.
         , rs.forced_grant_count --Total number of forced minimum-memory grants since server startup. NULL for the small-query resource semaphore.
FROM     sys.dm_exec_requests r
         JOIN sys.dm_exec_connections c
           ON r.connection_id = c.connection_id
         JOIN sys.dm_exec_sessions s
           ON c.session_id = s.session_id
         JOIN sys.databases d
           ON r.database_id = d.database_id
         JOIN sys.dm_exec_query_memory_grants mg
           ON s.session_id = mg.session_id
         INNER JOIN sys.dm_exec_query_resource_semaphores rs
           ON mg.resource_semaphore_id = rs.resource_semaphore_id
         CROSS APPLY sys.dm_exec_sql_text (r.sql_handle ) AS q
ORDER BY wait_time DESC
OPTION (MAX_GRANT_PERCENT = 3, MAXDOP 1)

RAISERROR ('', 0, 1) WITH NOWAIT


go

go

IF OBJECT_ID ('sp_perf_stats_reallyinfrequent','P') IS NOT NULL
   DROP PROCEDURE sp_perf_stats_reallyinfrequent
GO
CREATE PROCEDURE sp_perf_stats_reallyinfrequent @runtime datetime, @firstrun int = 0, @IsLite bit=0
 AS 
 set quoted_identifier on
  print '-- debug info starting sp_perf_stats_reallyinfrequent  --'
  print ''

DECLARE @qrydurationwarnthreshold int = 750
DECLARE @queryduration int
DECLARE @querystarttime datetime


exec sp_mem_stats_grants @runtime

RAISERROR (' ', 0, 1) WITH NOWAIT;
SET @queryduration = DATEDIFF (ms, @querystarttime, GETDATE())
IF @queryduration > @qrydurationwarnthreshold
  PRINT 'DebugPrint: perfstats3 qry1 - ' + CONVERT (varchar, @queryduration) + 'ms' + CHAR(13) + CHAR(10)

RAISERROR ('', 0, 1) WITH NOWAIT

  print '-- debug info finishing sp_perf_stats_reallyinfrequent  --'
  print ''

go
IF OBJECT_ID ('sp_perf_stats10','P') IS NOT NULL
   DROP PROCEDURE sp_perf_stats10
GO
go
CREATE PROCEDURE sp_perf_stats10 @appname sysname='PSSDIAG', @runtime datetime, @prevruntime datetime, @IsLite bit =0 
AS 
begin
    exec sp_perf_stats @appname, @runtime, @prevruntime, @IsLite
end

go
IF OBJECT_ID ('sp_perf_stats11','P') IS NOT NULL
   DROP PROCEDURE sp_perf_stats11
GO
go
CREATE PROCEDURE sp_perf_stats11 @appname sysname='PSSDIAG', @runtime datetime, @prevruntime datetime , @IsLite bit =0 
AS 
begin
    exec sp_perf_stats10 @appname, @runtime, @prevruntime, @IsLite
end

go

IF OBJECT_ID ('sp_perf_stats12','P') IS NOT NULL
   DROP PROCEDURE sp_perf_stats12
GO
go
CREATE PROCEDURE sp_perf_stats12 @appname sysname='PSSDIAG', @runtime datetime, @prevruntime datetime , @IsLite bit =0 
AS 
begin
    exec sp_perf_stats11 @appname, @runtime, @prevruntime, @IsLite
end

go

IF OBJECT_ID ('sp_perf_stats13','P') IS NOT NULL
   DROP PROCEDURE sp_perf_stats13
GO
go
CREATE PROCEDURE sp_perf_stats13 @appname sysname='PSSDIAG', @runtime datetime, @prevruntime datetime , @IsLite bit =0 
AS 
begin
    exec sp_perf_stats12 @appname, @runtime, @prevruntime, @IsLite
end
go
IF OBJECT_ID ('sp_perf_stats14','P') IS NOT NULL
   DROP PROCEDURE sp_perf_stats14
GO
go
CREATE PROCEDURE sp_perf_stats14 @appname sysname='PSSDIAG', @runtime datetime, @prevruntime datetime , @IsLite bit =0 
AS 
BEGIN
    exec sp_perf_stats13 @appname, @runtime, @prevruntime, @IsLite
END
go
IF OBJECT_ID ('sp_perf_stats15','P') IS NOT NULL
   DROP PROCEDURE sp_perf_stats15
GO
GO
CREATE PROCEDURE sp_perf_stats15 @appname sysname='PSSDIAG', @runtime datetime, @prevruntime datetime , @IsLite bit =0 
AS 
BEGIN
    exec sp_perf_stats14 @appname, @runtime, @prevruntime, @IsLite
END
GO
IF OBJECT_ID ('sp_perf_stats16','P') IS NOT NULL
   DROP PROCEDURE sp_perf_stats16
GO
GO
CREATE PROCEDURE sp_perf_stats16 @appname sysname='PSSDIAG', @runtime datetime, @prevruntime datetime , @IsLite bit =0 
AS 
BEGIN
    exec sp_perf_stats15 @appname, @runtime, @prevruntime, @IsLite
END
GO




IF OBJECT_ID ('sp_perf_stats_infrequent10','P') IS NOT NULL
   DROP PROCEDURE sp_perf_stats_infrequent10
GO
CREATE PROCEDURE sp_perf_stats_infrequent10 @runtime datetime, @prevruntime datetime, @prevmsticks bigint, @lastmsticks bigint output, @firstrun tinyint = 0, @IsLite bit =0 
AS 
begin
    exec sp_perf_stats_infrequent @runtime, @prevruntime, @prevmsticks, @lastmsticks output, @firstrun, @IsLite
end
go

IF OBJECT_ID ('sp_perf_stats_infrequent11','P') IS NOT NULL
   DROP PROCEDURE sp_perf_stats_infrequent11
GO
CREATE PROCEDURE sp_perf_stats_infrequent11 @runtime datetime, @prevruntime datetime, @prevmsticks bigint, @lastmsticks bigint output, @firstrun tinyint = 0, @IsLite bit =0 
AS 
begin
    exec sp_perf_stats_infrequent10 @runtime, @prevruntime, @prevmsticks, @lastmsticks output, @firstrun, @IsLite
end

go

IF OBJECT_ID ('sp_perf_stats_infrequent12','P') IS NOT NULL
   DROP PROCEDURE sp_perf_stats_infrequent12
GO
CREATE PROCEDURE sp_perf_stats_infrequent12 @runtime datetime, @prevruntime datetime, @prevmsticks bigint, @lastmsticks bigint output, @firstrun tinyint = 0, @IsLite bit =0 
AS 
begin
    exec sp_perf_stats_infrequent11 @runtime, @prevruntime, @prevmsticks, @lastmsticks output, @firstrun, @IsLite
end
go

IF OBJECT_ID ('sp_perf_stats_infrequent13','P') IS NOT NULL
   DROP PROCEDURE sp_perf_stats_infrequent13
GO
CREATE PROCEDURE sp_perf_stats_infrequent13 @runtime datetime, @prevruntime datetime, @prevmsticks bigint, @lastmsticks bigint output, @firstrun tinyint = 0, @IsLite bit =0 
AS 
begin
    exec sp_perf_stats_infrequent12 @runtime, @prevruntime, @prevmsticks, @lastmsticks output, @firstrun, @IsLite
end

go
IF OBJECT_ID ('sp_perf_stats_infrequent14','P') IS NOT NULL
   DROP PROCEDURE sp_perf_stats_infrequent14
GO
CREATE PROCEDURE sp_perf_stats_infrequent14 @runtime datetime, @prevruntime datetime, @prevmsticks bigint, @lastmsticks bigint output, @firstrun tinyint = 0, @IsLite bit =0 
AS 
BEGIN
    exec sp_perf_stats_infrequent13 @runtime, @prevruntime, @prevmsticks, @lastmsticks output, @firstrun, @IsLite
END

GO
IF OBJECT_ID ('sp_perf_stats_infrequent15','P') IS NOT NULL
   DROP PROCEDURE sp_perf_stats_infrequent15
GO
CREATE PROCEDURE sp_perf_stats_infrequent15 @runtime datetime, @prevruntime datetime, @prevmsticks bigint, @lastmsticks bigint output, @firstrun tinyint = 0, @IsLite bit =0 
AS 
BEGIN
    exec sp_perf_stats_infrequent14 @runtime, @prevruntime, @prevmsticks, @lastmsticks output, @firstrun, @IsLite
END
GO
GO
IF OBJECT_ID ('sp_perf_stats_infrequent16','P') IS NOT NULL
   DROP PROCEDURE sp_perf_stats_infrequent16
GO
CREATE PROCEDURE sp_perf_stats_infrequent16 @runtime datetime, @prevruntime datetime, @prevmsticks bigint, @lastmsticks bigint output, @firstrun tinyint = 0, @IsLite bit =0 
AS 
BEGIN
    exec sp_perf_stats_infrequent15 @runtime, @prevruntime, @prevmsticks, @lastmsticks output, @firstrun, @IsLite
END
GO




IF OBJECT_ID ('sp_perf_stats_reallyinfrequent10','P') IS NOT NULL
   DROP PROCEDURE sp_perf_stats_reallyinfrequent10
GO
CREATE PROCEDURE sp_perf_stats_reallyinfrequent10 @runtime datetime, @firstrun int = 0 , @IsLite bit =0 
AS 
begin
    exec sp_perf_stats_reallyinfrequent @runtime, @firstrun , @IsLite
end

go


IF OBJECT_ID ('sp_perf_stats_reallyinfrequent11','P') IS NOT NULL
   DROP PROCEDURE sp_perf_stats_reallyinfrequent11
GO
CREATE PROCEDURE sp_perf_stats_reallyinfrequent11 @runtime datetime, @firstrun int = 0 , @IsLite bit =0 
AS 
begin
    exec sp_perf_stats_reallyinfrequent10 @runtime, @firstrun , @IsLite
end

go


IF OBJECT_ID ('sp_perf_stats_reallyinfrequent12','P') IS NOT NULL
   DROP PROCEDURE sp_perf_stats_reallyinfrequent12
GO
CREATE PROCEDURE sp_perf_stats_reallyinfrequent12 @runtime datetime, @firstrun int = 0 , @IsLite bit =0 
AS 
begin
    exec sp_perf_stats_reallyinfrequent11 @runtime, @firstrun , @IsLite
end

go

IF OBJECT_ID ('sp_perf_stats_reallyinfrequent13','P') IS NOT NULL
   DROP PROCEDURE sp_perf_stats_reallyinfrequent13
GO
CREATE PROCEDURE sp_perf_stats_reallyinfrequent13 @runtime datetime, @firstrun int = 0 , @IsLite bit =0 
AS 
begin
    exec sp_perf_stats_reallyinfrequent12 @runtime, @firstrun , @IsLite
end


go

IF OBJECT_ID ('sp_perf_stats_reallyinfrequent14','P') IS NOT NULL
   DROP PROCEDURE sp_perf_stats_reallyinfrequent14
GO
CREATE PROCEDURE sp_perf_stats_reallyinfrequent14 @runtime datetime, @firstrun int = 0 , @IsLite bit =0 
AS 
begin
    exec sp_perf_stats_reallyinfrequent13 @runtime, @firstrun , @IsLite
END
GO

IF OBJECT_ID ('sp_perf_stats_reallyinfrequent15','P') IS NOT NULL
   DROP PROCEDURE sp_perf_stats_reallyinfrequent15
GO
CREATE PROCEDURE sp_perf_stats_reallyinfrequent15 @runtime datetime, @firstrun int = 0 , @IsLite bit =0 
AS 
BEGIN
    exec sp_perf_stats_reallyinfrequent14 @runtime, @firstrun , @IsLite
end
GO


IF OBJECT_ID ('sp_perf_stats_reallyinfrequent16','P') IS NOT NULL
   DROP PROCEDURE sp_perf_stats_reallyinfrequent16
GO
CREATE PROCEDURE sp_perf_stats_reallyinfrequent16 @runtime datetime, @firstrun int = 0 , @IsLite bit =0 
AS 
BEGIN
    exec sp_perf_stats_reallyinfrequent15 @runtime, @firstrun , @IsLite
end
GO





IF OBJECT_ID ('sp_Run_PerfStats','P') IS NOT NULL
   DROP PROCEDURE sp_Run_PerfStats
GO
create procedure sp_Run_PerfStats @IsLite bit = 0
as
  -- Main loop
  
PRINT 'Starting SQL Server Perf Stats Script...'
SET LANGUAGE us_english
PRINT '-- Script Source --'
SELECT 'SQL Server Perf Stats Script' AS script_name, '$Revision: 16 $ ($Change: ? $)' AS revision
PRINT ''
PRINT '-- Script and Environment Details --'
PRINT 'Name                     Value'
PRINT '------------------------ ---------------------------------------------------'
PRINT 'SQL Server Name          ' + @@SERVERNAME
PRINT 'Machine Name             ' + CONVERT (varchar, SERVERPROPERTY ('MachineName'))
PRINT 'SQL Version (SP)         ' + CONVERT (varchar, SERVERPROPERTY ('ProductVersion')) + ' (' + CONVERT (varchar, SERVERPROPERTY ('ProductLevel')) + ')'
PRINT 'Edition                  ' + CONVERT (varchar, SERVERPROPERTY ('Edition'))
PRINT 'Script Name              SQL Server Perf Stats Script'
PRINT 'Script File Name         $File: SQL_Server_Perf_Stats.sql $'
PRINT 'Revision                 $Revision: 16 $ ($Change: ? $)'
PRINT 'Last Modified            $Date: 2015/10/15  $'
PRINT 'Script Begin Time        ' + CONVERT (varchar(30), GETDATE(), 126) 
PRINT 'Current Database         ' + DB_NAME()
PRINT '@@SPID                   ' + LTRIM(STR(@@SPID))
PRINT ''

DECLARE @firstrun tinyint = 1
DECLARE @msg varchar(100)
DECLARE @runtime datetime
DECLARE @prevruntime datetime
DECLARE @previnfreqruntime datetime
DECLARE @prevreallyinfreqruntime datetime
DECLARE @lastmsticks bigint = 0
DECLARE @prevmsticks bigint = 0

SELECT @prevruntime = sqlserver_start_time from sys.dm_os_sys_info
print 'Start SQLServer time: ' + convert(varchar(23), @prevruntime, 126)
sET @prevruntime = DATEADD(SECOND, -300, @prevruntime)
SET @previnfreqruntime = @prevruntime
SET @prevreallyinfreqruntime = @prevruntime

DECLARE @servermajorversion nvarchar(2)
SET @servermajorversion = REPLACE (LEFT (CONVERT (varchar, SERVERPROPERTY ('ProductVersion')), 2), '.', '')
declare @sp_perf_stats_ver sysname, @sp_perf_stats_reallyinfrequent_ver sysname, @sp_perf_stats_infrequent_ver sysname
set @sp_perf_stats_ver = 'sp_perf_stats' + @servermajorversion
set @sp_perf_stats_infrequent_ver = 'sp_perf_stats_infrequent' -- + @servermajorversion
set @sp_perf_stats_reallyinfrequent_ver = 'sp_perf_stats_reallyinfrequent' + @servermajorversion


  WHILE (1=1)
  BEGIN
    SET @runtime = GETDATE()
    SET @msg = 'Start time: ' + CONVERT (varchar(30), @runtime, 126)

    PRINT ''
    RAISERROR (@msg, 0, 1) WITH NOWAIT
  
    -- Collect sp_perf_stats every 10 seconds
    --EXEC dbo.sp_perf_stats @appname = 'pssdiag', @runtime = @runtime, @prevruntime = @prevruntime
    exec @sp_perf_stats_ver 'pssdiag', @runtime = @runtime, @prevruntime = @prevruntime, @IsLite=@IsLite

        
    -- Collect sp_perf_stats_infrequent approximately every minute
    if DATEDIFF(SECOND, @previnfreqruntime,GETDATE()) > 59
    BEGIN
      EXEC @sp_perf_stats_infrequent_ver  @runtime = @runtime, @prevruntime = @previnfreqruntime, @prevmsticks = @prevmsticks, @lastmsticks = @lastmsticks output, @firstrun = @firstrun,  @IsLite=@IsLite
      SET @prevmsticks = @lastmsticks
      SET @previnfreqruntime = @runtime
    END

    -- Collect sp_perf_stats_reallyinfrequent approximately every 5 minutes		
    if DATEDIFF(SECOND, @prevreallyinfreqruntime,GETDATE()) > 299
    BEGIN
      EXEC @sp_perf_stats_reallyinfrequent_ver  @runtime = @runtime, @firstrun = @firstrun,  @IsLite=@IsLite
      SET @firstrun = 0
      SET @prevreallyinfreqruntime = @runtime
    END
      
    SET @prevruntime = @runtime
    WAITFOR DELAY '0:0:10'
  END

GO


exec sp_Run_PerfStats

~~~
# 

# 


# Scripts para Restaurar db/s en Diferentes tipos de Ambientes.<a name="46"></a>

<div>
<p style = 'text-align:center;'>
<img src="https://learn.microsoft.com/es-es/sql/relational-databases/backup-restore/media/bnrr-rmsimple2-diffdbbu.png?view=sql-server-ver16?format=jpg&name=small" alt="JuveYell" width="750px">
</p>
</div>



## Scripts para Ambientes Standalone:
### scripts_backup_bd_standalone
#### Propósito: Realiza una copia de seguridad completa de la base de datos master.
#### Ubicación de respaldo: U:\MSSQL\BACKUP\master.bak
#### Scripts_Restore_bd_Standalone
#### Propósito: Restaura la base de datos bpd_convertidor desde un archivo de respaldo.
#### Ubicación del respaldo: U:\MSSQL\BACKUP\bpd_convertidor.BAK
#### Detalles de la restauración: Restaura los archivos de datos (mdf), log (ldf), e índices (ndf) en ubicaciones específicas.
# 
# STANDALONE_STOS_ADMIN_DB_creation
#### Propósito: Crea la base de datos STOS_ADMIN.
#### Ubicaciones de archivos:
#### Datos: E:\MSSQL\DATA\STOS_ADMIN.mdf
#### Índices: I:\MSSQL\INDEX\STOS_ADMIN_Index.ndf
#### Registro: L:\MSSQL\LOG\STOS_ADMIN_log.ldf
#### Configuración adicional:
#### Establece el modelo de recuperación en SIMPLE.
#### Cambia el propietario de la base de datos a _SQLDBOwner.
#### Scripts para Ambientes de Availability Group (AlwaysOn):
# 
# AG_STOS_ADMIN_DB_creation
#### Propósito: Crea la base de datos STOS_ADMIN para entornos de Availability Group.
#### Ubicaciones de archivos y configuración: Similar al script STANDALONE_STOS_ADMIN_DB_creation pero con recuperación establecida como FULL.
#
# AG_STOS_ADMIN_BackupDB_PrimaryReplica
#### Propósito: Realiza copias de seguridad de la base de datos STOS_ADMIN (copias completas y de registros de transacciones) en la réplica primaria.
#### Ubicaciones de respaldo: U:\MSSQL\BACKUP\STOS_ADMIN.bak y U:\MSSQL\BACKUP\STOS_ADMIN.trn
#### AG_STOS_ADMIN_RestoreDB_SecondariesReplicas
#### Propósito: Restaura la base de datos STOS_ADMIN en réplicas secundarias.
#### Detalles de restauración: Restaura el respaldo completo y los registros de transacciones en las ubicaciones correspondientes en las réplicas secundarias.
#### Estos scripts son herramientas poderosas para respaldar, restaurar y crear bases de datos en entornos Standalone y de Availability Group, ayudando a mantener la integridad de los datos y a administrar los entornos de base de datos de manera efectiva. Recuerda ajustar las rutas de archivos y los nombres de bases de datos según sea necesario para tu entorno específico.

#

# Scripts para Ambientes Standalone:
#### 1. Creación de base de datos STOS_ADMIN (Standalone):


#### Para ambientes availability group (Alwayson)

 
Scripts para Ambientes Standalone:
#### 1. Creación de base de datos STOS_ADMIN (Standalone):

~~~sql
CREATE DATABASE [STOS_ADMIN]
 ON  PRIMARY 
( NAME = N'STOS_ADMIN', FILENAME = N'E:\MSSQL\DATA\STOS_ADMIN.mdf' , SIZE = 153600KB , FILEGROWTH = 51200KB ), 
 FILEGROUP [INDEXES] 
( NAME = N'STOS_ADMIN_Index', FILENAME = N'I:\MSSQL\INDEX\STOS_ADMIN_Index.ndf' , SIZE = 153600KB , FILEGROWTH = 51200KB )
 LOG ON 
( NAME = N'STOS_ADMIN_log', FILENAME = N'L:\MSSQL\LOG\STOS_ADMIN_log.ldf' , SIZE = 51200KB , FILEGROWTH = 51200KB )
GO
ALTER DATABASE [STOS_ADMIN] SET RECOVERY SIMPLE WITH NO_WAIT
GO

-- Cambio de propietario de la base de datos:
USE [STOS_ADMIN]
GO
EXEC dbo.sp_changedbowner @loginame = N'_SQLDBOwner', @map = false	
GO

~~~


#### 2. Script de Backup de Sql StandAlone
~~~sql
BACKUP DATABASE [master] TO  DISK = N'U:\MSSQL\BACKUP\master.bak' WITH NOFORMAT, INIT,  NAME = N'master-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 5
GO
~~~




#### 3. Script de Respaldo para Standalone:

~~~sql
-- Respaldo de base de datos 'master':
BACKUP DATABASE [master] TO  DISK = N'U:\MSSQL\BACKUP\master.bak' WITH NOFORMAT, INIT,  NAME = N'master-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 5
GO

-- Restaurar base de datos 'bpd_convertidor':
RESTORE DATABASE [bpd_convertidor] 
FROM  DISK = N'U:\MSSQL\BACKUP\bpd_convertidor.BAK' 
WITH  FILE = 1,  
MOVE N'bpd_convertidor' TO N'E:\MSSQL\Data\bpd_convertidor.mdf',  
MOVE N'bpd_convertidor_Log' TO N'L:\MSSQL\Log\bpd_convertidor_log.ldf',  
MOVE N'bpd_convertidor_Index' TO N'I:\MSSQL\Index\bpd_convertidor_index.ndf',  
NOUNLOAD,  STATS = 10
GO

~~~

# Scripts para Ambientes de Availability Group (AlwaysOn):
#### 1. Creación de base de datos STOS_ADMIN (AlwaysOn):
~~~sql
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

-- Cambio de propietario de la base de datos:
USE [STOS_ADMIN]
GO
EXEC dbo.sp_changedbowner @loginame = N'_SQLDBOwner', @map = false	
GO

~~~

#### 2. Respaldo y Restauración para Availability Group:
## Respaldo en la réplica primaria:

~~~sql
USE master
GO

-- Respaldo de base de datos STOS_ADMIN (primaria):
BACKUP DATABASE [STOS_ADMIN]
TO DISK = N'U:\MSSQL\BACKUP\STOS_ADMIN.bak' 
WITH INIT,  
NAME = N'STOS_ADMIN-Full Database Backup', 
SKIP, NOREWIND, NOUNLOAD,  STATS = 1
GO

-- Respaldo de registros de transacciones STOS_ADMIN (primaria):
BACKUP LOG [STOS_ADMIN]
TO DISK = 'U:\MSSQL\BACKUP\STOS_ADMIN.trn' 
WITH INIT;
GO

~~~

#### 3. Restauración en las réplicas secundarias:

~~~sql
USE master
GO

-- Restaurar base de datos STOS_ADMIN en secundarias:
RESTORE DATABASE [STOS_ADMIN]
FROM  DISK = N'U:\MSSQL\BACKUP\STOS_ADMIN.BAK' 
WITH  FILE = 1,  
MOVE N'STOS_ADMIN' TO N'E:\MSSQL\DATA\STOS_ADMIN.mdf',  
MOVE N'STOS_ADMIN' TO N'L:\MSSQL\LOG\STOS_ADMIN.ldf',
MOVE N'STOS_ADMIN' TO N'I:\MSSQL\INDEX\STOS_ADMIN.ndf',
NOUNLOAD,  STATS = 1,
NORECOVERY;	
GO

-- Restaurar registros de transacciones en secundarias:
RESTORE LOG [STOS_ADMIN]
FROM Disk = 'U:\MSSQL\BACKUP\STOS_ADMIN.trn'
WITH NORECOVERY;
GO

~~~

#### Estos scripts están ordenados según su uso y su secuencia lógica para cada tipo de ambiente, permitiendo realizar las operaciones de creación de bases de datos, respaldo y restauración de manera adecuada.

# 


 ## Como puedo saber que puerto utilizan mis consultas BPD<a name="puetos"></a>
# 

 

#### Codigo que muestra el puerto que esta utilizando una session determinada

#### esto seria util en caso de querer saber el puesto que esta utiliando el sql server

#### para nuestro caso es el por defecto 1433

 
~~~sql
SELECT local_tcp_port

FROM   sys.dm_exec_connections

WHERE  session_id = @@SPID
~~~
 
# 

# Obtener la Versión de SQL Server - Métodos Rápidos<a name="25dup"></a>

<div>
<p style = 'text-align:center;'>
<img src="https://i.ytimg.com/vi/Efpm8uciluw/maxresdefault.jpg?format=jpg&name=small" alt="JuveYell" width="750px">
</p>
</div>



#### En el rol de un Administrador de Bases de Datos (DBA), es crucial conocer la versión exacta de SQL Server instalada. Aquí te presento cuatro métodos sencillos para obtener esta información.

## Método 1: Consulta SQL
#### Conéctate a la instancia de SQL Server y ejecuta la siguiente consulta SQL:

~~~sql
SELECT @@version;
~~~

#### Este comando proporcionará detalles sobre la versión de SQL Server, como se muestra a continuación:


    Microsoft SQL Server 2008 (SP1) - 10.0.2531.0 (X64) Mar 29 2009 10:11:52 Copyright (c) 1988-2008 Microsoft Corporation Express Edition (64-bit) on Windows NT 6.1 <X64> (Build 7600: )

## Método 2: Consulta ServerProperty
#### Conéctate a la instancia de SQL Server y ejecuta la siguiente consulta:

~~~sql

SELECT SERVERPROPERTY('productversion') AS 'Versión', SERVERPROPERTY('productlevel') AS 'Nivel', SERVERPROPERTY('edition') AS 'Edición';
~~~

#### Esta consulta devuelve información detallada sobre la versión, nivel y edición de SQL Server, como se muestra a continuación:


Versión          | Nivel  | Edición
-----------------|--------|-----------------
10.0.1600.22     | RTM    | Enterprise Edition

## Método 3: SQL Server Management Studio
#### Conéctate al servidor mediante SQL Server Management Studio. El Explorador de Objetos mostrará la información de versión junto con el nombre de usuario utilizado para la conexión.

## Método 4: Archivo de Registro de Errores
#### Busca la instancia en las primeras líneas del archivo de registro de errores. Por defecto, el archivo se encuentra en la ruta:

    C:\Program Files\Microsoft SQL Server\MSSQL.n\MSSQL\LOG\ERRORLOG
#### Las entradas en el archivo de registro proporcionan información sobre la versión, nivel, edición y sistema operativo, como se muestra a continuación:


    2011-03-27 22:31:33.50 Server Microsoft SQL Server 2008 (SP1) - 10.0.2531.0 (X64) Mar 29 2009 10:11:52 Copyright (c) 1988-2008 Microsoft Corporation Express Edition (64-bit) on Windows NT 6.1 <X64> (Build 7600: )
#### Estos métodos te permitirán obtener rápidamente la información necesaria sobre la versión de SQL Server, facilitando tu tarea como DBA.




## 46 [Tamanio de las bases de datos de un servidor]<a name="46"></a>


#### Puedes utilizar la siguiente consulta en SQL Server para obtener el nombre del servidor, el nombre de la base de datos y su tamaño en gigabytes (GB):

~~~sql
SELECT 
    @@SERVERNAME AS 'Nombre del Servidor',
    DB_NAME() AS 'Nombre de la Base de Datos',
    CONVERT(DECIMAL(10, 2), ROUND(SUM(size) * 8.0 / 1024, 2)) AS 'Tamaño de la Base de Datos (GB)'
FROM 
    sys.master_files
WHERE 
    database_id = DB_ID();
~~~    
#### Esta consulta utiliza la vista del sistema sys.master_files para obtener información sobre los archivos de la base de datos y calcula el tamaño total de la base de datos en gigabytes. La función ROUND se utiliza para redondear el resultado a dos decimales.

# 

## Query de listado de Tablas con su Tamano y su cantidad de registros<a name="listadotablas"></a>

<div>
<p style = 'text-align:center;'>
<img src="https://desarrolloweb.com/media/696/campos-tablas.jpg?format=jpg&name=small" alt="JuveYell" width="750px">
</p>
</div>

#### En el query proporcionado para SQL Server, la columna size_bytes representa el tamaño total de la tabla en bytes. La unidad de medida en este caso es bytes. Si deseas expresar el tamaño en kilobytes (KB), megabytes (MB), gigabytes (GB) u otra unidad más conveniente, puedes realizar la conversión correspondiente.

#### Aquí tienes algunas conversiones comunes:

###### KB: size_bytes / 1024
###### MB: size_bytes / (1024 * 1024)
###### GB: size_bytes / (1024 * 1024 * 1024)
#### Puedes ajustar el resultado según la unidad de medida que prefieras. Por ejemplo, si deseas obtener el tamaño en megabytes, la consulta podría modificarse así:

~~~sql
SELECT 
    t.name AS table_name,
    p.rows AS cantidad_registros,
    SUM(a.total_pages) * 8 / (1024 * 1024) AS size_mb
FROM 
    sys.tables t
INNER JOIN      
    sys.indexes i ON t.object_id = i.object_id
INNER JOIN 
    sys.partitions p ON i.object_id = p.object_id AND i.index_id = p.index_id
INNER JOIN 
    sys.allocation_units a ON p.partition_id = a.container_id
WHERE 
    t.is_ms_shipped = 0
GROUP BY 
    t.name, p.rows
ORDER BY 
    table_name;

~~~

#### Esta modificación divide el tamaño total en bytes por (1024 * 1024) para obtener el tamaño en megabytes. Puedes ajustar la división según la unidad de medida que prefieras utilizar.


# 


# Script de Monitoreo y Optimización del Rendimiento de SQL Server<a name="500"></a>

## DESCARGO DE RESPONSABILIDAD
El código de muestra se proporciona con fines ilustrativos y no está destinado a ser utilizado en un entorno de producción. Este código de muestra y cualquier información relacionada se proporcionan "tal cual" sin garantía de ningún tipo, ya sea expresa o implícita, incluidas, entre otras, las garantías implícitas de comerciabilidad y/o aptitud para un propósito particular. Le otorgamos un derecho no exclusivo y libre de regalías para usar y modificar el código de muestra y para reproducir y distribuir la forma de código objeto del código de muestra, siempre que:

1. Usted acepta no usar nuestro nombre, logotipo o marcas comerciales para comercializar su producto de software en el que se incrusta el código de muestra.
2. Incluye un aviso de derechos de autor válido en su producto de software en el que se incrusta el código de muestra.
3. Usted indemniza, libera de responsabilidad y defiende a nosotros y a nuestros proveedores de cualquier reclamo o demanda, incluidos honorarios de abogados, que surjan o resulten del uso o distribución del código de muestra.

## Propósito
Este script SQL proporciona un conjunto completo de consultas para monitorear y optimizar el rendimiento de una base de datos de SQL Server. Incluye varias secciones como información del servidor, procesos de bloqueo, estadísticas de espera, estadísticas de latch, información de memoria, utilización de archivos de base de datos de E/S, consultas más costosas, índices faltantes y declaraciones de creación de índices.

## Cómo Usar
1. Ejecute cada sección del script secuencialmente en una ventana de consulta de SQL Server Management Studio (SSMS).
2. Revise la salida de cada sección para comprender el rendimiento del servidor e identificar áreas de optimización.
3. Personalice el script según sea necesario para su entorno de base de datos específico.
4. Asegúrese de que se otorguen los permisos adecuados para ejecutar estas consultas.

## Componentes
- **Información del Servidor**: Proporciona información básica sobre la instancia de SQL Server, como el nombre del servidor, la versión del producto, la edición, etc.
- **Procesos de Bloqueo**: Identifica cualquier proceso que esté bloqueando actualmente o que esté siendo bloqueado por otros procesos.
- **Información de Esperas**: Analiza las estadísticas de espera para identificar las fuentes más significativas de espera dentro de la base de datos.
- **Latches**: Proporciona estadísticas de latch para comprender la contención de recursos de latch.
- **Tareas en Espera**: Enumera las tareas que están esperando recursos o están bloqueadas actualmente.
- **Información de Memoria**: Muestra información sobre el uso y los límites de memoria.
- **Utilización y Latencia de Archivos de Base de Datos de E/S**: Analiza el rendimiento de E/S para archivos de base de datos.
- **Top 10 de Consultas Más Costosas**: Identifica las principales consultas que consumen recursos de CPU y disco.
- **Índices Faltantes**: Sugiere mejoras potenciales de índice según las estadísticas de ejecución de consultas.
- **Declaración de Creación de Índices Faltantes**: Genera declaraciones CREATE INDEX para los índices faltantes sugeridos.

## Descargo de Responsabilidad
Este script está destinado únicamente con fines educativos y debe usarse con precaución en un entorno de producción. Siempre revise y pruebe los scripts a fondo antes de aplicarlos a un sistema de producción.

~~~sql
/*DISCLAIMER. Sample Code is provided for the purpose of illustration only and is not intended to be used in a production environment. 
THIS SAMPLE CODE AND ANY RELATED INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, 
INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE. 
We grant you a nonexclusive, royalty-free right to use and modify the Sample Code and to reproduce and distribute the object code form of the Sample Code, provided that. You agree: 
(i) to not use Our name, logo, or trademarks to market Your software product in which the Sample Code is embedded; 
(ii) to include a valid copyright notice on Your software product in which the Sample Code is embedded; and 
(iii) to indemnify, hold harmless, and defend Us and Our suppliers from and against any claims or lawsuits, including attorneys' fees, that arise or result from the use or distribution of the Sample Code.*/
--------------------------------------------------------------------------------------------------------------------------
SELECT @@SERVERNAME
GO
SELECT SERVERPROPERTY('productversion'), SERVERPROPERTY ('productlevel'), SERVERPROPERTY ('edition')
GO

--------------------------------------------------------------------------------------------------------------------------

SELECT session_id ,status ,command, blocking_session_id
    ,wait_type ,wait_time ,wait_resource 
    ,transaction_id, estimated_completion_time
FROM sys.dm_exec_requests 
WHERE (status = N'suspended' OR status = N'running')
AND session_id <> @@SPID;
GO

----------------------------------------------------Blocking Processes----------------------------------------------------

--Parte 1
SELECT
             WaitingTime = s.waittime, s.spid, BlockingSPID = s.blocked, DatabaseName = DB_NAME(s.dbid),
             s.program_name, s.loginame, s.hostname, s.cmd, ObjectName = OBJECT_NAME(objectid,s.dbid), Definition = CAST(text AS VARCHAR(MAX))
 INTO        #Processes
 FROM      sys.sysprocesses s
 CROSS APPLY sys.dm_exec_sql_text (sql_handle)
 WHERE
            s.spid > 50
go            

--select * from #Processes
--Parte2

WITH Blocking(SPID, BlockingSPID, "WaitingTime (secs)", BlockingStatement, LoginName, HostName, Command, RowNo, LevelRow)
 AS
 (
      SELECT
       s.spid, s.BlockingSPID, s.WaitingTime/1000, s.Definition, s.loginame, s.hostname, s.cmd,
       ROW_NUMBER() OVER(ORDER BY s.spid),
       0 AS LevelRow
     FROM
       #Processes s
       JOIN #Processes s1 ON s.spid = s1.BlockingSPID
     WHERE
       s.BlockingSPID = 0
     UNION ALL
     SELECT
       r.spid,  r.BlockingSPID, r.WaitingTime/1000, r.Definition, r.loginame, r.hostname, r.cmd,
       d.RowNo,
       d.LevelRow + 1
     FROM
       #Processes r
      JOIN Blocking d ON r.BlockingSPID = d.SPID
     WHERE
       r.BlockingSPID > 0
 )
 SELECT * FROM Blocking
 ORDER BY RowNo, LevelRow
 go

--Parte 3
 drop table #Processes
 go
 --------------------------------------------------------Waits Info--------------------------------------------------

WITH [Waits] AS
    (SELECT
        [wait_type],
        [wait_time_ms] / 1000.0 AS [WaitS],
        ([wait_time_ms] - [signal_wait_time_ms]) / 1000.0 AS [ResourceS],
        [signal_wait_time_ms] / 1000.0 AS [SignalS],
        [waiting_tasks_count] AS [WaitCount],
        100.0 * [wait_time_ms] / SUM ([wait_time_ms]) OVER() AS [Percentage],
        ROW_NUMBER() OVER(ORDER BY [wait_time_ms] DESC) AS [RowNum]
    FROM sys.dm_os_wait_stats
    WHERE [wait_type] NOT IN (
        N'BROKER_EVENTHANDLER',             N'BROKER_RECEIVE_WAITFOR',
        N'BROKER_TASK_STOP',                N'BROKER_TO_FLUSH',
        N'BROKER_TRANSMITTER',              N'CHECKPOINT_QUEUE',
        N'CHKPT',                           N'CLR_AUTO_EVENT',
        N'CLR_MANUAL_EVENT',                N'CLR_SEMAPHORE',
        N'DBMIRROR_DBM_EVENT',              N'DBMIRROR_EVENTS_QUEUE',
        N'DBMIRROR_WORKER_QUEUE',           N'DBMIRRORING_CMD',
        N'DIRTY_PAGE_POLL',                 N'DISPATCHER_QUEUE_SEMAPHORE',
        N'EXECSYNC',                        N'FSAGENT',
        N'FT_IFTS_SCHEDULER_IDLE_WAIT',     N'FT_IFTSHC_MUTEX',
        N'HADR_CLUSAPI_CALL',               N'HADR_FILESTREAM_IOMGR_IOCOMPLETION',
        N'HADR_LOGCAPTURE_WAIT',            N'HADR_NOTIFICATION_DEQUEUE',
        N'HADR_TIMER_TASK',                 N'HADR_WORK_QUEUE',
        N'KSOURCE_WAKEUP',                  N'LAZYWRITER_SLEEP',
        N'LOGMGR_QUEUE',                    N'ONDEMAND_TASK_QUEUE',
        N'PWAIT_ALL_COMPONENTS_INITIALIZED',
        N'QDS_PERSIST_TASK_MAIN_LOOP_SLEEP',
        N'QDS_CLEANUP_STALE_QUERIES_TASK_MAIN_LOOP_SLEEP',
        N'REQUEST_FOR_DEADLOCK_SEARCH',     N'RESOURCE_QUEUE',
        N'SERVER_IDLE_CHECK',               N'SLEEP_BPOOL_FLUSH',
        N'SLEEP_DBSTARTUP',                 N'SLEEP_DCOMSTARTUP',
        N'SLEEP_MASTERDBREADY',             N'SLEEP_MASTERMDREADY',
        N'SLEEP_MASTERUPGRADED',            N'SLEEP_MSDBSTARTUP',
        N'SLEEP_SYSTEMTASK',                N'SLEEP_TASK',
        N'SLEEP_TEMPDBSTARTUP',             N'SNI_HTTP_ACCEPT',
        N'SP_SERVER_DIAGNOSTICS_SLEEP',     N'SQLTRACE_BUFFER_FLUSH',
        N'SQLTRACE_INCREMENTAL_FLUSH_SLEEP',
        N'SQLTRACE_WAIT_ENTRIES',           N'WAIT_FOR_RESULTS',
        N'WAITFOR',                         N'WAITFOR_TASKSHUTDOWN',
        N'WAIT_XTP_HOST_WAIT',              N'WAIT_XTP_OFFLINE_CKPT_NEW_LOG',
        N'WAIT_XTP_CKPT_CLOSE',             N'XE_DISPATCHER_JOIN',
        N'XE_DISPATCHER_WAIT',              N'XE_TIMER_EVENT')
    AND [waiting_tasks_count] > 0
 )
SELECT
    TOP 5
    MAX ([W1].[wait_type]) AS [WaitType],
    CAST (MAX ([W1].[WaitS]) AS DECIMAL (16,2)) AS [Wait_S],
    CAST (MAX ([W1].[ResourceS]) AS DECIMAL (16,2)) AS [Resource_S],
    CAST (MAX ([W1].[SignalS]) AS DECIMAL (16,2)) AS [Signal_S],
    MAX ([W1].[WaitCount]) AS [WaitCount],
    CAST (MAX ([W1].[Percentage]) AS DECIMAL (5,2)) AS [Percentage],
    CAST ((MAX ([W1].[WaitS]) / MAX ([W1].[WaitCount])) AS DECIMAL (16,4)) AS [AvgWait_S],
    CAST ((MAX ([W1].[ResourceS]) / MAX ([W1].[WaitCount])) AS DECIMAL (16,4)) AS [AvgRes_S],
    CAST ((MAX ([W1].[SignalS]) / MAX ([W1].[WaitCount])) AS DECIMAL (16,4)) AS [AvgSig_S]
FROM [Waits] AS [W1]
INNER JOIN [Waits] AS [W2]
    ON [W2].[RowNum] <= [W1].[RowNum]
GROUP BY [W1].[RowNum]
HAVING SUM ([W2].[Percentage]) - MAX ([W1].[Percentage]) < 95; -- percentage threshold
GO

-------------------------------------------------------------Latches-----------------------------------------------------

WITH [Latches] AS
    (SELECT
        [latch_class],
        [wait_time_ms] / 1000.0 AS [WaitS],
        [waiting_requests_count] AS [WaitCount],
        100.0 * [wait_time_ms] / SUM ([wait_time_ms]) OVER() AS [Percentage],
        ROW_NUMBER() OVER(ORDER BY [wait_time_ms] DESC) AS [RowNum]
    FROM sys.dm_os_latch_stats
    WHERE [latch_class] NOT IN (
        N'BUFFER')
    AND [wait_time_ms] > 0
)
SELECT
    MAX ([W1].[latch_class]) AS [LatchClass],
    CAST (MAX ([W1].[WaitS]) AS DECIMAL(14, 2)) AS [Wait_S],
    MAX ([W1].[WaitCount]) AS [WaitCount],
    CAST (MAX ([W1].[Percentage]) AS DECIMAL(14, 2)) AS [Percentage],
    CAST ((MAX ([W1].[WaitS]) / MAX ([W1].[WaitCount])) AS DECIMAL (14, 4)) AS [AvgWait_S]
FROM [Latches] AS [W1]
INNER JOIN [Latches] AS [W2]
    ON [W2].[RowNum] <= [W1].[RowNum]
GROUP BY [W1].[RowNum]
HAVING SUM ([W2].[Percentage]) - MAX ([W1].[Percentage]) < 95; -- percentage threshold
GO

-------------------------------------------------------------Waiting Tasks-------------------------------------------------

SELECT 'Waiting_tasks' AS [Information], owt.session_id,
     owt.wait_duration_ms,
     owt.wait_type,
     owt.blocking_session_id,
     owt.resource_description,
     es.program_name,
     est.text,
     est.dbid,
     eqp.query_plan,
     er.database_id,
     es.cpu_time,
     es.memory_usage
 FROM sys.dm_os_waiting_tasks owt
 INNER JOIN sys.dm_exec_sessions es ON owt.session_id = es.session_id
 INNER JOIN sys.dm_exec_requests er ON es.session_id = er.session_id
 OUTER APPLY sys.dm_exec_sql_text (er.sql_handle) est
 OUTER APPLY sys.dm_exec_query_plan (er.plan_handle) eqp
 WHERE es.is_user_process = 1
 AND owt.wait_duration_ms > 0;
 GO
 
--------------------------------------------------------Memory Info--------------------------------------------------
 SELECT
(physical_memory_in_use_kb/1024)/1024 AS 'Physical Memory in Use (GB)',
(total_virtual_address_space_kb/1024)/1024 AS 'Total Virtual Address Space (GB)',
(virtual_address_space_committed_kb/1024)/1024 AS 'Total Virtual Address Space Committed (GB)',
(virtual_address_space_available_kb/1024)/1024 AS 'Total Virtual Address Space Available (GB)'
FROM sys.dm_os_process_memory
GO

SELECT 
(physical_memory_kb/1024)/1024 AS 'Physical Memory (GB)', 
(committed_kb/1024)/1024 AS 'Committed Memory (GB)' 
FROM sys.dm_os_sys_info 
GO

SELECT 
counter_name AS 'Performance Counter', 
cntr_value AS 'Counter Value' 
FROM sys.dm_os_performance_counters
WHERE counter_name in  ('Lock Memory (KB)', 'Target Server Memory (KB)', 'Total Server Memory (KB)', 'Buffer Cache Hit Ratio', 'Page life expectancy', 'DatabASe Pages')
GROUP BY counter_name,cntr_value
GO

SELECT memory_limit_mb, process_memory_limit_mb
FROM sys.dm_os_job_object

-------------------------------------------------I/O Database File Utilization And Latency-----------------------------------

SELECT TOP 5 DB_NAME(a.database_id) AS [Database Name] , b.type_desc, b.physical_name, CAST(( io_stall_read_ms + io_stall_write_ms ) / ( 1.0 + num_of_reads + num_of_writes) AS NUMERIC(10,1)) AS [avg_io_stall_ms]
FROM sys.dm_io_virtual_file_stats(NULL, NULL) a
INNER JOIN sys.master_files b 
ON a.database_id = b.database_id and a.file_id = b.file_id
ORDER BY avg_io_stall_ms DESC ;
GO

SELECT DB_NAME(f.database_id) AS database_name, f.name AS logical_file_name, f.type_desc, 
    CAST (CASE 
        -- Handle UNC paths (e.g. '\\fileserver\readonlydbs\dept_dw.ndf')
        WHEN LEFT (LTRIM (f.physical_name), 2) = '\\' 
            THEN LEFT (LTRIM (f.physical_name),CHARINDEX('\',LTRIM(f.physical_name),CHARINDEX('\',LTRIM(f.physical_name), 3) + 1) - 1)
            -- Handle local paths (e.g. 'C:\Program Files\...\master.mdf') 
            WHEN CHARINDEX('\', LTRIM(f.physical_name), 3) > 0 
            THEN UPPER(LEFT(LTRIM(f.physical_name), CHARINDEX ('\', LTRIM(f.physical_name), 3) - 1))
        ELSE f.physical_name
    END AS NVARCHAR(255)) AS logical_disk,
    fs.size_on_disk_bytes/1024/1024 AS size_on_disk_Mbytes,
    fs.num_of_reads, fs.num_of_writes,
    fs.num_of_bytes_read/1024/1024 AS num_of_Mbytes_read,
    fs.num_of_bytes_written/1024/1024 AS num_of_Mbytes_written,
    (fs.io_stall_read_ms / (1.0 + fs.num_of_reads)) AS avg_read_latency_ms,
    (fs.io_stall_write_ms / (1.0 + fs.num_of_writes)) AS avg_write_latency_ms
FROM sys.dm_io_virtual_file_stats (default, default) AS fs
INNER JOIN sys.master_files AS f ON fs.database_id = f.database_id AND fs.[file_id] = f.[file_id]
ORDER BY 2 DESC
GO

-------------------------------------------------Top 10 most expensive queries-----------------------------------------------

SELECT TOP 10 
        (SELECT db_name(dbid) FROM sys.dm_exec_sql_text(qs.plan_handle)) DBName, 
        (SELECT object_name(objectid, dbid) FROM sys.dm_exec_sql_text(qs.plan_handle)) 		AS SPName, 
        (SELECT SUBSTRING(text, statement_start_offset/2 + 1, (CASE WHEN 			statement_end_offset = -1 THEN LEN(CONVERT(nvarchar(max), text)) * 2 ELSE 		statement_end_offset END - statement_start_offset)/2) FROM 			sys.dm_exec_sql_text(sql_handle)) AS query_text,
        creation_time,
        last_execution_time,
        execution_count,
        total_worker_time / 1000 AS CPU_ms,
        total_worker_time / execution_count / 1000 AS Avg_CPU_ms,
        total_logical_reads AS page_reads,
        total_logical_reads / execution_count AS Avg_page_reads,
        total_elapsed_time / 1000 AS CPU_ms,
        total_worker_time / execution_count / 1000 AS Avg_CPU_ms,
        (SELECT query_plan FROM sys.dm_exec_query_plan(qs.plan_handle)) QueryPlan
FROM sys.dm_exec_query_stats qs
ORDER BY total_worker_time DESC
go

------------------------------------------------------Missing Indexes--------------------------------------------------------

SELECT TOP 5 priority = avg_total_user_cost * avg_user_impact * (user_seeks + user_scans) , 
d.statement , d.equality_columns , d.inequality_columns , d.included_columns , 
s.avg_total_user_cost , s.avg_user_impact , s.user_seeks, s.user_scans 
FROM sys.dm_db_missing_index_group_stats s 
JOIN sys.dm_db_missing_index_groups g 
ON s.group_handle = g.index_group_handle 
JOIN sys.dm_db_missing_index_details d 
ON g.index_handle = d.index_handle 
ORDER BY priority DESC
go

---------------------------------------------Missing Indexes Creation Statement----------------------------------------------


;WITH I AS ( 
SELECT --user_seeks * avg_total_user_cost * (avg_user_impact * 0.01) AS [index_advantage], 
        avg_total_user_cost * avg_user_impact * (user_seeks + user_scans) AS [Priority],
migs.last_user_seek, 
mid.[statement] AS [Database.Schema.Table], 
mid.equality_columns, mid.inequality_columns, 
mid.included_columns,migs.unique_compiles, migs.user_seeks, 
migs.avg_total_user_cost, migs.avg_user_impact 
FROM sys.dm_db_missing_index_group_stats AS migs WITH (NOLOCK) 
INNER JOIN sys.dm_db_missing_index_groups AS mig WITH (NOLOCK) 
ON migs.group_handle = mig.index_group_handle 
INNER JOIN sys.dm_db_missing_index_details AS mid WITH (NOLOCK) 
ON mig.index_handle = mid.index_handle 
--WHERE mid.database_id = db_id('driveatv') --DB_ID() 
      --AND user_seeks * avg_total_user_cost * (avg_user_impact * 0.01) > 90 -- Set this to Whatever 
    
) 
SELECT top 5 'CREATE INDEX IX_' 
            + SUBSTRING([Database.Schema.Table], 
                              CHARINDEX('].[',[Database.Schema.Table], 
                              CHARINDEX('].[',[Database.Schema.Table])+4)+3, 
                              LEN([Database.Schema.Table]) -   
                              (CHARINDEX('].[',[Database.Schema.Table], 
                              CHARINDEX('].[',[Database.Schema.Table])+4)+3)) 
            + '_' + LEFT(REPLACE(REPLACE(REPLACE(REPLACE( 
            ISNULL(equality_columns,inequality_columns), 
            '[',''),']',''),' ',''),',',''),20) 
            + ' ON ' 
            + [Database.Schema.Table] 
            + '(' 
            + ISNULL(equality_columns,'') 
            + CASE WHEN equality_columns IS NOT NULL AND 
                              inequality_columns IS NOT NULL 
                  THEN ',' 
                  ELSE '' 
              END 
      + ISNULL(inequality_columns,'') 
                 + ')' 
                 + CASE WHEN included_columns IS NOT NULL 
                  THEN ' INCLUDE(' + included_columns + ')' + ' WITH (ONLINE = ON)'
                  ELSE ' WITH (ONLINE = ON)'
              END CreateStatement
FROM I
order by Priority DESC
go
~~~


# 


### Documentación del Query para la Captura de Logs en Grupos de Disponibilidad Always On<a name="501"></a>

#### Objetivo:
El objetivo de este conjunto de consultas y scripts es capturar información relevante para el análisis de latencia en el movimiento de datos entre nodos primarios y secundarios en Grupos de Disponibilidad Always On en Microsoft SQL Server. La documentación proporcionada está diseñada para permitir una fácil ejecución y recopilación de datos para su posterior análisis y diagnóstico.

#### Pasos para la Captura de Logs:

1. **Captura de Información de Estado del Grupo de Disponibilidad Always On:**
   - **Propósito:** Esta consulta recopila información esencial sobre el estado de los nodos, réplicas y bases de datos en el Grupo de Disponibilidad.
   - **Ejecución:** Se debe ejecutar en ambos nodos primarios y secundarios y guardar los resultados como `primary.xml` y `secondary.xml` respectivamente.

```sql
SELECT
    AGNode.group_name,
    AGNode.replica_server_name,
    AGNode.node_name,
    ReplicaState.role,
    ReplicaState.role_desc,
    ReplicaState.is_local,
    DatabaseState.database_id,
    DB_NAME(DatabaseState.database_id) AS database_name,
    DatabaseState.group_database_id,
    DatabaseState.is_commit_participant,
    DatabaseState.is_primary_replica,
    DatabaseState.synchronization_state_desc,
    DatabaseState.synchronization_health_desc,
    ClusterState.group_id,
    ReplicaState.replica_id
FROM
    sys.dm_hadr_availability_replica_cluster_nodes AS AGNode
JOIN
    sys.dm_hadr_availability_replica_cluster_states AS ClusterState ON AGNode.replica_server_name = ClusterState.replica_server_name
JOIN
    sys.dm_hadr_availability_replica_states AS ReplicaState ON ReplicaState.replica_id = ClusterState.replica_id
JOIN
    sys.dm_hadr_database_replica_states AS DatabaseState ON ReplicaState.replica_id = DatabaseState.replica_id
FOR XML RAW, ROOT('AGInfoRoot')
```

2. **Captura de Eventos de Movimiento de Datos:**
   - **Propósito:** Establece una sesión de eventos para capturar actividades relacionadas con el movimiento de datos entre nodos primarios y secundarios.
   - **Ejecución:** Se debe ejecutar en ambos nodos primarios y secundarios durante un período de 5 a 10 minutos y luego detenerlo.

```sql
CREATE EVENT SESSION [AlwaysOn_Data_Movement_Tracing] ON SERVER
ADD EVENT sqlserver.hadr_apply_log_block,
    ADD EVENT sqlserver.hadr_capture_filestream_wait,
    ADD EVENT sqlserver.hadr_capture_log_block,
    ADD EVENT sqlserver.hadr_capture_vlfheader,
    ADD EVENT sqlserver.hadr_db_commit_mgr_harden,
    ADD EVENT sqlserver.hadr_log_block_compression,
    ADD EVENT sqlserver.hadr_log_block_decompression,
    ADD EVENT sqlserver.hadr_log_block_group_commit ,
    ADD EVENT sqlserver.hadr_log_block_send_complete,
    ADD EVENT sqlserver.hadr_lsn_send_complete,
    ADD EVENT sqlserver.hadr_receive_harden_lsn_message,
    ADD EVENT sqlserver.hadr_send_harden_lsn_message,
    ADD EVENT sqlserver.hadr_transport_flow_control_action,
    ADD EVENT sqlserver.hadr_transport_receive_log_block_message,
    ADD EVENT sqlserver.log_block_pushed_to_logpool,
    ADD EVENT sqlserver.log_flush_complete ,
    ADD EVENT sqlserver.recovery_unit_harden_log_timestamps
ADD TARGET package0.event_file(SET filename=N'c:\temp\AlwaysOn_Data_Movement_Tracing.xel',max_file_size=(500),max_rollover_files=(4))
WITH (MAX_MEMORY=4096 KB,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,MAX_DISPATCH_LATENCY=30 SECONDS,MAX_EVENT_SIZE=0 KB,
MEMORY_PARTITION_MODE=NONE,TRACK_CAUSALITY=OFF,STARTUP_STATE=ON)
GO

-- Comienza la sesión de eventos
ALTER EVENT SESSION [AlwaysOn_Data_Movement_Tracing] ON SERVER STATE=START;
```

3. **Procesamiento de Datos y Generación de Informes:**
   - **Propósito:** Prepara los archivos de registro capturados y los archivos XML de estado del Grupo de Disponibilidad para su análisis posterior.
   - **Pasos:**
     - Mueva los archivos `AlwaysOn_Data_Movement_Tracing.xel` y `primary.xml` del nodo primario a una carpeta designada.
     - Mueva el archivo `AlwaysOn_Data_Movement_Tracing.xel` del nodo secundario y `secondary.xml` a otra carpeta designada.
     - Utilice una herramienta específica para procesar estos archivos y generar informes sobre la latencia en el movimiento de datos.

#### Notas Adicionales:
- Asegúrese de ajustar las rutas de archivo según sea necesario para reflejar la ubicación de los archivos en su entorno.
- Para detener la sesión de eventos, utilice el script proporcionado en la sección comentada.


## Documentation of SQL Scripts for Backup and Restore with TDE<a name="tde1"></a>

Below are the documented SQL scripts for performing backup and restore operations on multiple databases with Transparent Data Encryption (TDE). Each script includes comments explaining the steps and the sequence in which they should be executed.

#### 1. PYEENG Database

~~~sql
-- Step 1: Full Database Backup
BACKUP DATABASE [PYEENG]
TO DISK = N'U:\MSSQL\BACKUP\PYEENG.bak'
WITH INIT,
NAME = N'PYEENG-Full Database Backup',
SKIP, NOREWIND, NOUNLOAD,  STATS = 1
GO

-- Step 2: Transaction Log Backup
BACKUP LOG [PYEENG]
TO DISK = 'U:\MSSQL\BACKUP\PYEENG.trn'
WITH INIT;
GO

-- Step 3: Add Database to Availability Group on Primary Replica
ALTER AVAILABILITY GROUP [IBANKING] ADD DATABASE [PYEENG]
GO

-- Step 4: Restore Full Database Backup on Secondary Replica
RESTORE DATABASE [PYEENG]
FROM  DISK = N'U:\MSSQL\BACKUP\PYEENG.BAK'
WITH  FILE = 1,
MOVE N'PYEENG' TO N'G:\MSSQL\DATA\PYEENG.mdf',
MOVE N'PYEENG_log' TO N'N:\MSSQL\LOG\PYEENG_log.ldf',
MOVE N'PYEENG_index' TO N'K:\MSSQL\INDEX\PYEENG_Index.ndf',
NOUNLOAD,  STATS = 10, REPLACE,
NORECOVERY;       
GO

-- Step 5: Restore Transaction Log Backup on Secondary Replica
RESTORE LOG [PYEENG]
FROM Disk = 'U:\MSSQL\BACKUP\PYEENG.trn'
WITH NORECOVERY;
GO

-- Step 6: Set HADR Availability Group on Secondary Replica
ALTER DATABASE [PYEENG] SET HADR AVAILABILITY GROUP = [IBANKING];
GO
~~~

#### 2. SII_Omega_TRX Database

~~~sql
-- Step 1: Full Database Backup
BACKUP DATABASE [SII_Omega_TRX]
TO DISK = N'U:\MSSQL\BACKUP\SII_Omega_TRX.bak'
WITH INIT,
NAME = N'SII_Omega_TRX-Full Database Backup',
SKIP, NOREWIND, NOUNLOAD,  STATS = 1
GO

-- Step 2: Transaction Log Backup
BACKUP LOG [SII_Omega_TRX]
TO DISK = 'U:\MSSQL\BACKUP\SII_Omega_TRX.trn'
WITH INIT;
GO

-- Step 3: Add Database to Availability Group on Primary Replica
ALTER AVAILABILITY GROUP [IBANKING] ADD DATABASE [SII_Omega_TRX]
GO

-- Step 4: Restore Full Database Backup on Secondary Replica
RESTORE DATABASE [SII_Omega_TRX]
FROM  DISK = N'U:\MSSQL\BACKUP\SII_Omega_TRX.BAK'
WITH  FILE = 1,
MOVE N'SII_Omega_TRX' TO N'G:\MSSQL\DATA\SII_Omega_TRX.mdf',
MOVE N'SII_Omega_TRX_log' TO N'L:\MSSQL\LOG\SII_Omega_TRX_log.ldf',
MOVE N'SII_Omega_TRX_index' TO N'I:\MSSQL\INDEX\SII_Omega_TRX_Index.ndf',
NOUNLOAD,  STATS = 10, REPLACE,
NORECOVERY;       
GO

-- Step 5: Restore Transaction Log Backup on Secondary Replica
RESTORE LOG [SII_Omega_TRX]
FROM Disk = 'U:\MSSQL\BACKUP\SII_Omega_TRX.trn'
WITH NORECOVERY;
GO

-- Step 6: Set HADR Availability Group on Secondary Replica
ALTER DATABASE [SII_Omega_TRX] SET HADR AVAILABILITY GROUP = [IBANKING];
GO
~~~

#### 3. TSCENG Database

~~~sql
-- Step 1: Full Database Backup
BACKUP DATABASE [TSCENG]
TO DISK = N'U:\MSSQL\BACKUP\TSCENG.bak'
WITH INIT,
NAME = N'TSCENG-Full Database Backup',
SKIP, NOREWIND, NOUNLOAD,  STATS = 1
GO

-- Step 2: Transaction Log Backup
BACKUP LOG [TSCENG]
TO DISK = 'U:\MSSQL\BACKUP\TSCENG.trn'
WITH INIT;
GO

-- Step 3: Add Database to Availability Group on Primary Replica
ALTER AVAILABILITY GROUP [IBANKING] ADD DATABASE [TSCENG]
GO

-- Step 4: Restore Full Database Backup on Secondary Replica
RESTORE DATABASE [TSCENG]
FROM  DISK = N'U:\MSSQL\BACKUP\TSCENG.BAK'
WITH  FILE = 1,
MOVE N'TSCENG_Data' TO N'G:\MSSQL\DATA\TSCENG.mdf',
MOVE N'TSCENG_log' TO N'M:\MSSQL\LOG\TSCENG_log.ldf',
MOVE N'TSCENG_index' TO N'K:\MSSQL\INDEX\TSCENG_Index.ndf',
NOUNLOAD,  STATS = 10, REPLACE,
NORECOVERY;       
GO

-- Step 5: Restore Transaction Log Backup on Secondary Replica
RESTORE LOG [TSCENG]
FROM Disk = 'U:\MSSQL\BACKUP\TSCENG.trn'
WITH NORECOVERY;
GO

-- Step 6: Set HADR Availability Group on Secondary Replica
ALTER DATABASE [TSCENG] SET HADR AVAILABILITY GROUP = [IBANKING];
GO
~~~

#### 4. AUTMOD Database

~~~sql
-- Step 1: Full Database Backup
BACKUP DATABASE [AUTMOD]
TO DISK = N'U:\MSSQL\BACKUP\AUTMOD.bak'
WITH INIT,
NAME = N'AUTMOD-Full Database Backup',
SKIP, NOREWIND, NOUNLOAD,  STATS = 1
GO

-- Step 2: Transaction Log Backup
BACKUP LOG [AUTMOD]
TO DISK = 'U:\MSSQL\BACKUP\AUTMOD.trn'
WITH INIT;
GO

-- Step 3: Add Database to Availability Group on Primary Replica
ALTER AVAILABILITY GROUP [IBANKING] ADD DATABASE [AUTMOD]
GO

-- Step 4: Restore Full Database Backup on Secondary Replica
RESTORE DATABASE [AUTMOD]
FROM  DISK = N'U:\MSSQL\BACKUP\AUTMOD.BAK'
WITH  FILE = 1,
MOVE N'AUTMOD' TO N'F:\MSSQL\DATA\AUTMOD.mdf',
MOVE N'AUTMOD_log' TO N'N:\MSSQL\LOG\AUTMOD_log.ldf',
MOVE N'AUTMOD_index' TO N'K:\MSSQL\INDEX\AUTMOD_Index.ndf',
NOUNLOAD,  STATS = 10, REPLACE,
NORECOVERY;       
GO

-- Step 5: Restore Transaction Log Backup on Secondary Replica
RESTORE LOG [AUTMOD]
FROM Disk = 'U:\MSSQL\BACKUP\AUTMOD.trn'
WITH NORECOVERY;
GO

-- Step 6: Set HADR Availability Group on Secondary Replica
ALTER DATABASE [AUTMOD] SET HADR AVAILABILITY GROUP = [IBANKING];
GO
~~~

#### 5. BPD_SecureContainer Database

~~~sql
-- Step 1: Full Database Backup
BACKUP DATABASE [BPD_SecureContainer]
TO DISK = N'U:\MSSQL\BACKUP\BPD_SecureContainer.bak'
WITH INIT,
NAME = N'BPD_SecureContainer-Full Database Backup',
SKIP, NOREWIND, NOUNLOAD,  STATS = 1
GO

-- Step 2: Transaction Log Backup
BACKUP LOG [BPD_SecureContainer]
TO DISK = 'U:\MSSQL\BACKUP\BPD_SecureContainer.trn'
WITH INIT;
GO

-- Step 3: Add Database to Availability Group on Primary Replica
ALTER AVAILABILITY GROUP [IBANKING] ADD DATABASE [BPD_SecureContainer]
GO

-- Step 4: Restore Full Database Backup on Secondary Replica
RESTORE DATABASE [BPD_SecureContainer]
FROM  DISK = N'U:\MSSQL\BACKUP\BPD_SecureContainer.BAK'
WITH  FILE = 1,
MOVE N'BPD_SecureContainer' TO N'D:\MSSQL\DATA\BPD_SecureContainer.mdf',
MOVE N'BPD_SecureContainer_log' TO N'L:\MSSQL\LOG\BPD_SecureContainer_log.ldf',
NOUNLOAD,  STATS = 10, REPLACE,
NORECOVERY;       
GO

-- Step 5: Restore Transaction Log Backup on Secondary Replica
RESTORE LOG [BPD_SecureContainer]
FROM Disk = 'U:\MSSQL\BACKUP\BPD_SecureContainer.trn'
WITH NORECOVERY;
GO

-- Step 6: Set HADR Availability Group on Secondary Replica
ALTER DATABASE [BPD_SecureContainer] SET HADR AVAILABILITY GROUP = [IBANKING];
GO
~~~

#### 6. PAYENG Database

~~~sql
-- Step 1: Full Database Backup


BACKUP DATABASE [PAYENG]
TO DISK = N'U:\MSSQL\BACKUP\PAYENG.bak'
WITH INIT,
NAME = N'PAYENG-Full Database Backup',
SKIP, NOREWIND, NOUNLOAD,  STATS = 1
GO

-- Step 2: Transaction Log Backup
BACKUP LOG [PAYENG]
TO DISK = 'U:\MSSQL\BACKUP\PAYENG.trn'
WITH INIT;
GO

-- Step 3: Add Database to Availability Group on Primary Replica
ALTER AVAILABILITY GROUP [IBANKING] ADD DATABASE [PAYENG]
GO

-- Step 4: Restore Full Database Backup on Secondary Replica
RESTORE DATABASE [PAYENG]
FROM  DISK = N'U:\MSSQL\BACKUP\PAYENG.BAK'
WITH  FILE = 1,
MOVE N'PAYENG' TO N'F:\MSSQL\DATA\PAYENG.mdf',
MOVE N'PAYENG_log' TO N'M:\MSSQL\LOG\PAYENG_log.ldf',
MOVE N'PAYENG_index' TO N'I:\MSSQL\INDEX\PAYENG_Index.ndf',
NOUNLOAD,  STATS = 10, REPLACE,
NORECOVERY;       
GO

-- Step 5: Restore Transaction Log Backup on Secondary Replica
RESTORE LOG [PAYENG]
FROM Disk = 'U:\MSSQL\BACKUP\PAYENG.trn'
WITH NORECOVERY;
GO

-- Step 6: Set HADR Availability Group on Secondary Replica
ALTER DATABASE [PAYENG] SET HADR AVAILABILITY GROUP = [IBANKING];
GO
~~~

### Summary

For each database, the sequence of steps is as follows:
1. **Full Database Backup**: Creates a full backup of the database.
2. **Transaction Log Backup**: Creates a transaction log backup to capture all the transactions that occurred after the full backup.
3. **Add Database to Availability Group**: Adds the database to the Availability Group on the primary replica.
4. **Restore Full Database Backup on Secondary Replica**: Restores the full backup on the secondary replica.
5. **Restore Transaction Log Backup on Secondary Replica**: Restores the transaction log backup on the secondary replica.
6. **Set HADR Availability Group on Secondary Replica**: Configures the secondary replica to be part of the Availability Group.

This sequence ensures that the databases are properly backed up, restored, and configured for high availability.
#


## Como saber Cuales DB tienen TDE en un Servidor<a name="49"></a>
Para determinar si una base de datos tiene Transparent Data Encryption (TDE) habilitado en SQL Server, puedes ejecutar la siguiente consulta en la base de datos:

```sql
SELECT name, is_encrypted 
FROM sys.databases
WHERE name = 'NombreDeTuBaseDeDatos';
```

Este query devuelve dos columnas:

- `name`: El nombre de la base de datos.
- `is_encrypted`: Indicador de si la base de datos está encriptada. Si el valor es `1`, la base de datos tiene TDE habilitado; si el valor es `0`, TDE no está habilitado.

Si deseas obtener el estado de todas las bases de datos en la instancia, simplemente ejecuta:

```sql
SELECT name, is_encrypted 
FROM sys.databases;
```

Esta consulta te mostrará el estado de TDE para cada base de datos en la instancia de SQL Server.







# 

## Jobs Que se estan Ejecutando en un Servidor SQL Server<a name="jobactivos2"></a>

Aqui podaras ver un script SQL que se utiliza para listar los jobs actualmente en ejecución en SQL Server. La consulta utiliza el procedimiento almacenado `sp_help_job` de la base de datos `msdb` con el parámetro `@execution_status=1`, que filtra los jobs que están en estado de ejecución.

## Requisitos

- SQL Server 2005 o superior
- Permisos adecuados para acceder a la base de datos `msdb` y ejecutar procedimientos almacenados

## Uso

### Descripción del Comando

El comando que se ejecuta es:

```sql
exec msdb.dbo.sp_help_job @execution_status=1
```

### Parámetros

- `@execution_status=1`: Este parámetro filtra los resultados para mostrar solo los jobs que están actualmente en ejecución.

### Salida

La salida del comando proporciona información sobre los jobs que están en ejecución. Los campos más relevantes que se incluyen en la salida son:

- `job_id`: Identificador único del job.
- `originating_server`: Nombre del servidor de origen.
- `name`: Nombre del job.
- `enabled`: Estado del job (si está habilitado o no).
- `description`: Descripción del job.
- `start_step_id`: Paso inicial del job.
- `category`: Categoría del job.
- `owner`: Propietario del job.
- `notify_level_eventlog`: Nivel de notificación en el registro de eventos.
- `notify_level_email`: Nivel de notificación por correo electrónico.
- `notify_level_netsend`: Nivel de notificación por red.
- `notify_level_page`: Nivel de notificación por buscapersonas.
- `delete_level`: Nivel de eliminación.
- `date_created`: Fecha de creación del job.
- `date_modified`: Fecha de última modificación del job.
- `version_number`: Número de versión del job.

### Ejecución del Comando

Para ejecutar el comando, sigue estos pasos:

1. Abre SQL Server Management Studio (SSMS).
2. Conéctate a la instancia de SQL Server donde deseas verificar los jobs en ejecución.
3. Abre una nueva consulta.
4. Copia y pega el siguiente comando en la ventana de la consulta:

    ```sql
    exec msdb.dbo.sp_help_job @execution_status=1
    ```

5. Ejecuta la consulta presionando `F5` o haciendo clic en el botón "Ejecutar" en la barra de herramientas.

## Ejemplo de Uso

A continuación se muestra un ejemplo de cómo se vería la salida del comando:

```plaintext
+--------------------------------------+-------------------+-------------------+---------+---------------------------+---------------+
| job_id                               | originating_server| name              | enabled | description               | start_step_id |
+--------------------------------------+-------------------+-------------------+---------+---------------------------+---------------+
| 1F27BA43-88F7-4E02- | SERVER01          | Backup Database   | 1       | Daily backup of database  | 1             |
| 2D47D3B6-C9EC- | SERVER01          | Index Rebuild     | 1       | Weekly index rebuild      | 1             |
+--------------------------------------+-------------------+-------------------+---------+---------------------------+---------------+
```

## Contribuciones

Las contribuciones son bienvenidas. Si encuentras algún error o tienes sugerencias para mejorar este script, por favor abre un issue o envía un pull request.

## Licencia

Este proyecto está bajo la licencia MIT. Para más detalles, consulta el archivo [LICENSE](./LICENSE).

---

¡Espero que esta documentación sea útil para tu repositorio de GitHub! Si necesitas más detalles o alguna otra sección específica, no dudes en decírmelo.

# 


## Agregar Archivos de `tempdb` en SQL Server<a name="tempdb2"></a>

Esta guía describe cómo agregar archivos adicionales al `tempdb` en un servidor SQL Server y verificar su correcta configuración. Este procedimiento se puede utilizar en futuras implementaciones para optimizar el rendimiento de `tempdb`.

## 1. Introducción

El propósito de esta guía es proporcionar un paso a paso para agregar archivos al `tempdb` en SQL Server y verificar que se hayan agregado y utilizado correctamente. Esta configuración puede ayudar a mejorar la gestión y el rendimiento del `tempdb`.

## 2. Prerrequisitos

Antes de iniciar, asegúrese de:

- Tener acceso administrativo al servidor SQL Server.
- Tener suficiente espacio en disco en la ubicación donde se crearán los nuevos archivos `tempdb`.

## 3. Pasos para Configurar `tempdb`

### 3.1. Abrir SQL Server Management Studio (SSMS)

Inicie sesión en el servidor SQL Server usando SQL Server Management Studio (SSMS).

### 3.2. Ejecutar el Código para Agregar Archivos a `tempdb`

Ejecute el siguiente script para agregar nuevos archivos a `tempdb`:

```sql
USE master;

GO

ALTER DATABASE tempdb
ADD FILE (NAME = tempdev8, FILENAME = 'S:\MSSQL\TEMPDB\tempdb8.ndf', SIZE = 100MB, FILEGROWTH = 500MB);

ALTER DATABASE tempdb
ADD FILE (NAME = tempdev9, FILENAME = 'S:\MSSQL\TEMPDB\tempdb9.ndf', SIZE = 100MB, FILEGROWTH = 500MB);

ALTER DATABASE tempdb
ADD FILE (NAME = tempdev10, FILENAME = 'S:\MSSQL\TEMPDB\tempdb10.ndf', SIZE = 100MB, FILEGROWTH = 500MB);

ALTER DATABASE tempdb
ADD FILE (NAME = tempdev11, FILENAME = 'S:\MSSQL\TEMPDB\tempdb11.ndf', SIZE = 100MB, FILEGROWTH = 500MB);

GO
```

### 3.3. Verificar que los Archivos se hayan Agregado Correctamente

Ejecute el siguiente comando para verificar que los archivos se hayan agregado correctamente:

```sql
USE tempdb;

GO

EXEC sp_helpfile;

GO
```

## 4. Verificación de la Configuración

### 4.1. Confirmar el Uso de los Nuevos Archivos

Para confirmar que los nuevos archivos de `tempdb` se están utilizando correctamente:

- Asegúrese de que no haya errores en los registros de SQL Server.
- Monitoree el rendimiento de la base de datos para verificar mejoras.

### 4.2. Capturas de Pantalla

Tome capturas de pantalla del resultado de `sp_helpfile` como evidencia de la configuración exitosa.

## 5. Reporte de Finalización

### 5.1. Notificación al Equipo Responsable

Una vez completada la configuración, notifique a los siguientes equipos y roles:

- Control de Cambios
- Gerentes de Producción
- Control de Incidentes

Proporcione las capturas de pantalla del resultado de `sp_helpfile` como evidencia.

## 6. Referencias

Consulte la documentación oficial de SQL Server para obtener más detalles sobre la gestión de `tempdb` y las mejores prácticas:

- [Documentación de SQL Server](https://docs.microsoft.com/en-us/sql/sql-server/)

## 7. Historial de Cambios

Registre cualquier cambio realizado en este procedimiento en esta sección.

| Fecha       | Cambio Realizado                    | Autor            |
|-------------|-------------------------------------|------------------|
| YYYY-MM-DD  | Creación del documento              | Nombre del Autor |
| YYYY-MM-DD  | Actualización de los archivos       | Nombre del Autor |

---

Esta guía debe almacenarse en el repositorio de GitHub correspondiente y mantenerse actualizada con cualquier cambio en los procedimientos o configuraciones.

# 



## Monitoreo de TempDB.<a name="tempdb1"></a>

Para asegurar que los archivos de `tempdb` en un servidor SQL Server fueron creados correctamente y para monitorear su comportamiento, puedes seguir estos pasos:

1. **Verificar la configuración y existencia de `tempdb`:**
   Utiliza la siguiente consulta para revisar los archivos y su configuración:

   ```sql
   USE tempdb;
   GO
   EXEC sp_helpfile;
   ```

   Esta consulta te mostrará información sobre los archivos de `tempdb`, incluyendo su nombre, tamaño, crecimiento, y ubicación.

2. **Revisar el tamaño y crecimiento de `tempdb`:**
   Puedes verificar el tamaño actual y el crecimiento de `tempdb` usando la siguiente consulta:

   ```sql
   SELECT 
       name AS [FileName], 
       size*8/1024 AS [SizeMB], 
       max_size, 
       growth*8/1024 AS [GrowthMB], 
       physical_name AS [FilePath]
   FROM sys.master_files
   WHERE database_id = DB_ID('tempdb');
   ```

   Esta consulta te dará una visión general del tamaño de cada archivo y su configuración de crecimiento.

3. **Monitorear el uso de espacio en `tempdb`:**
   Para monitorear el uso de espacio en `tempdb`, puedes utilizar la siguiente consulta:

   ```sql
   SELECT 
       SUM(unallocated_extent_page_count) AS [unallocated_extent_page_count],
       SUM(version_store_reserved_page_count) AS [version_store_reserved_page_count],
       SUM(user_object_reserved_page_count) AS [user_object_reserved_page_count],
       SUM(internal_object_reserved_page_count) AS [internal_object_reserved_page_count],
       SUM(mixed_extent_page_count) AS [mixed_extent_page_count]
   FROM sys.dm_db_file_space_usage;
   ```

   Esto te proporcionará detalles sobre el uso de espacio por diferentes tipos de objetos en `tempdb`.

4. **Monitorear la actividad de `tempdb`:**
   Puedes utilizar la siguiente consulta para monitorear la actividad de `tempdb` y ver qué sesiones están utilizando más recursos:

   ```sql
   SELECT 
       t1.session_id, 
       t1.request_id, 
       t1.task_alloc AS [Task Allocated (MB)], 
       t1.task_dealloc AS [Task Deallocated (MB)], 
       t2.text AS [SQL Text]
   FROM 
   ( 
       SELECT 
           session_id, 
           request_id, 
           SUM(internal_objects_alloc_page_count)*8/1024 AS task_alloc,
           SUM(internal_objects_dealloc_page_count)*8/1024 AS task_dealloc
       FROM sys.dm_db_task_space_usage
       GROUP BY session_id, request_id
   ) t1
   JOIN sys.dm_exec_requests t3 ON t1.session_id = t3.session_id AND t1.request_id = t3.request_id
   CROSS APPLY sys.dm_exec_sql_text(t3.sql_handle) t2
   ORDER BY task_alloc DESC;
   ```

   Esta consulta te ayudará a identificar qué sesiones y consultas están consumiendo más recursos en `tempdb`.

5. **Monitorear el rendimiento de `tempdb`:**
   Puedes revisar los contadores de rendimiento de SQL Server relacionados con `tempdb` en el monitor de rendimiento de Windows. Los contadores clave incluyen:

   - `SQLServer:Databases` -> `Transactions/sec`
   - `SQLServer:Databases` -> `Log Flushes/sec`
   - `SQLServer:Databases` -> `Log Bytes Flushed/sec`
   - `SQLServer:Databases` -> `Data File(s) Size (KB)`

6. **Monitorear bloqueos y esperas en `tempdb`:**
   Usa la siguiente consulta para identificar bloqueos y esperas relacionados con `tempdb`:

   ```sql
   SELECT 
       wait_type, 
       wait_time_ms, 
       wait_resource
   FROM sys.dm_os_waiting_tasks
   WHERE resource_description LIKE '2:%'; -- 2 es el database_id para tempdb
   ```

Estos pasos te ayudarán a asegurarte de que `tempdb` esté configurado correctamente y a monitorear su comportamiento y rendimiento en tiempo real.
# 


## Query de extraccion de Base de datos y Tablas en Sql Server.<a name="600"></a>

Este script obtiene información detallada sobre todas las bases de datos y sus tablas en una instancia de SQL Server. Incluye el nombre del servidor, la versión de SQL Server, la versión del sistema operativo y el nivel de service pack en un formato legible.
<div>
<p style = 'text-align:center;'>
<img src="https://gdm-catalog-fmapi-prod.imgix.net/ProductScreenshot/619d96d5-048c-485f-9070-1ef4713c56de.png?auto=format&q=50?format=jpg&name=small" alt="JuveYell" width="750px">
</p>
</div>
## Resumen del Script

El script realiza los siguientes pasos:
1. Obtiene el nombre del servidor, la edición de SQL Server, la versión, el nivel de parche y el nivel de service pack.
2. Extrae la versión del sistema operativo de la instancia de SQL Server.
3. Itera sobre todas las bases de datos en el servidor (excluyendo bases de datos del sistema) y obtiene los nombres de todas las tablas.
4. Almacena la información obtenida en una tabla temporal.
5. Muestra la información de la tabla temporal.
6. Limpia la tabla temporal.

## Script

~~~sql
-- Obtener información del servidor
DECLARE @ServerName NVARCHAR(255);
DECLARE @SQLEdition NVARCHAR(255);
DECLARE @SQLVersion NVARCHAR(255);
DECLARE @SQLPatch NVARCHAR(255);
DECLARE @SQLServicePack NVARCHAR(255);
DECLARE @OSVersion NVARCHAR(255);

SET @ServerName = @@SERVERNAME;
SET @SQLEdition = CAST(SERVERPROPERTY('Edition') AS NVARCHAR);
SET @SQLVersion = CAST(SERVERPROPERTY('ProductVersion') AS NVARCHAR);
SET @SQLPatch = CAST(SERVERPROPERTY('ProductLevel') AS NVARCHAR);
SET @SQLServicePack = ISNULL(CAST(SERVERPROPERTY('ProductUpdateLevel') AS NVARCHAR), 'N/A');

-- Obtener la versión del sistema operativo desde @@VERSION
SELECT @OSVersion = SUBSTRING(@@VERSION, CHARINDEX('Windows', @@VERSION), LEN(@@VERSION) - CHARINDEX('Windows', @@VERSION) + 1);

-- Formatear la versión de SQL Server y el sistema operativo en un formato legible
DECLARE @ReadableSQLVersion NVARCHAR(255);
SET @ReadableSQLVersion = @SQLEdition + ' - ' + @SQLVersion + ' - ' + @SQLPatch + ' - Service Pack ' + @SQLServicePack;

DECLARE @ReadableOSVersion NVARCHAR(255);
SET @ReadableOSVersion = @OSVersion;

-- Crear una tabla temporal para almacenar la información
IF OBJECT_ID('tempdb..#DatabasesAndTables') IS NOT NULL
    DROP TABLE #DatabasesAndTables;

CREATE TABLE #DatabasesAndTables (
    ServerName NVARCHAR(255),
    ReadableSQLVersion NVARCHAR(255),
    ReadableOSVersion NVARCHAR(255),
    DatabaseName NVARCHAR(255),
    TableName NVARCHAR(255)
);

-- Declarar un cursor para iterar sobre todas las bases de datos del servidor
DECLARE @DatabaseName NVARCHAR(255);
DECLARE db_cursor CURSOR FOR
SELECT name
FROM sys.databases
WHERE state_desc = 'ONLINE' AND name NOT IN ('master', 'tempdb', 'model', 'msdb');

OPEN db_cursor;
FETCH NEXT FROM db_cursor INTO @DatabaseName;

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Construir una consulta dinámica para obtener todas las tablas de la base de datos actual
    DECLARE @SQL NVARCHAR(MAX);
    SET @SQL = 'INSERT INTO #DatabasesAndTables (ServerName, ReadableSQLVersion, ReadableOSVersion, DatabaseName, TableName)
                SELECT ''' + @ServerName + ''', ''' + @ReadableSQLVersion + ''', ''' + @ReadableOSVersion + ''', ''' + @DatabaseName + ''', TABLE_NAME
                FROM ' + QUOTENAME(@DatabaseName) + '.INFORMATION_SCHEMA.TABLES
                WHERE TABLE_TYPE = ''BASE TABLE''';

    -- Ejecutar la consulta dinámica
    EXEC sp_executesql @SQL;

    FETCH NEXT FROM db_cursor INTO @DatabaseName;
END;

CLOSE db_cursor;
DEALLOCATE db_cursor;

-- Seleccionar los resultados de la tabla temporal
SELECT * FROM #DatabasesAndTables;

-- Limpiar la tabla temporal
DROP TABLE #DatabasesAndTables;

~~~

## Prerrequisitos
    - Permisos: Asegúrate de tener los permisos necesarios para ejecutar el script y acceder a las vistas sys.databases y INFORMATION_SCHEMA.TABLES.
    - Versión de SQL Server: El script es compatible con SQL Server 2008 y versiones posteriores.

## Notas
    - El script excluye las bases de datos del sistema (master, tempdb, model, y msdb) de los resultados.
    - La función @@VERSION se utiliza para extraer la versión del sistema operativo.
## Ejemplo de Salida

| ServerName | ReadableSQLVersion                                     | ReadableOSVersion            | DatabaseName | TableName |
|------------|--------------------------------------------------------|------------------------------|--------------|-----------|
| SERVER1    | Standard Edition - 15.0.2000.5 - RTM - Service Pack 1  | Windows Server 2016 Datacenter | MyDatabase   | Customers |
| SERVER1    | Standard Edition - 15.0.2000.5 - RTM - Service Pack 1  | Windows Server 2016 Datacenter | MyDatabase   | Orders    |
| SERVER1    | Standard Edition - 15.0.2000.5 - RTM - Service Pack 1  | Windows Server 2016 Datacenter | MyOtherDB    | Products  |


# 


## Documentación para la Restauración de Bases de Datos ABT<a name="601"></a>

#### Introducción
Este documento detalla el procedimiento a seguir para traer en línea las bases de datos asociadas con los servidores de oficina y sucursales (CNP y SUC) de la institución, conocidos como ABT, después de que el personal de seguridad asigne los permisos de control total (full control) para los discos correspondientes.

#### Contexto
En los servidores ABT, tanto en oficinas como en sucursales, se ha identificado la necesidad de traer en línea las bases de datos luego de que se realicen ciertos cambios de permisos a nivel de los discos donde estas residen. Este procedimiento es común cuando se presentan problemas de acceso a las bases de datos debido a cambios en la configuración de permisos.

#### Procedimiento

1. **Asignación de Permisos:**
   - El personal de seguridad deberá asignar permisos de control total (full control) sobre los discos que contienen las bases de datos mencionadas. Este paso es crucial para garantizar que los servicios de SQL Server puedan acceder correctamente a los archivos de las bases de datos.

2. **Ejecución del Script SQL:**
   - Una vez asignados los permisos, el personal encargado de las bases de datos deberá ejecutar el siguiente script para traer en línea las bases de datos que se encontraban offline:
   
     ~~~sql
     ALTER DATABASE [ABT41] SET ONLINE;
     ALTER DATABASE [ABT41ROM] SET ONLINE;
     ALTER DATABASE [ABT41SIG] SET ONLINE;
     ~~~

3. **Verificación:**
   - Después de ejecutar el script, se debe verificar que las bases de datos estén en línea y operativas. Esto se puede hacer revisando el estado de las bases de datos desde el SQL Server Management Studio (SSMS) o utilizando la siguiente consulta:
   
     ~~~sql
     SELECT name, state_desc 
     FROM sys.databases 
     WHERE name IN ('ABT41', 'ABT41ROM', 'ABT41SIG');
     ~~~

#### Consideraciones Finales
- Este procedimiento debe ser realizado por personal autorizado y capacitado para manejar tanto los permisos de seguridad a nivel de discos como la administración de bases de datos en SQL Server.
- Es importante documentar cualquier incidente relacionado con las bases de datos ABT para mejorar futuros procesos de resolución.

#### Conclusión
El procedimiento descrito en este documento permite restaurar el acceso a las bases de datos en los servidores ABT después de la asignación de permisos correspondientes. Esto asegura que el personal pueda resolver problemas similares en el futuro de manera eficiente y efectiva.

---

Este  procedimiento debe ser revisado y actualizado según sea necesario para reflejar cambios en la infraestructura o procedimientos relacionados con la administración de bases de datos en la institución.

--- 
# ELIMINAR NUMERO ENGANCHADO EN DAKOTA/CAFÉ GCS-SYSTEMS<a name="700"></a>
<div>
<p style = 'text-align:center;'>
<img src="https://gcscertification.com/wp-content/uploads/2024/10/logogcs-1024x500.png?auto=format&q=50?format=jpg&name=small" alt="JuveYell" width="750px">
</p>
</div>

## 1.- EN LA BASE DE DATOS DE SQLSERVER

## Eliminar registro de la base de datos `[SII.Omega.GCS]`  

El error que estás viendo se debe a un conflicto entre dos intercalaciones (collations) diferentes en las columnas que estás comparando o usando en las consultas. Este problema es común cuando las bases de datos o las tablas utilizan diferentes configuraciones de intercalación.

Para resolver este problema, puedes forzar a que las comparaciones se hagan usando la misma intercalación (`collation`). A continuación, te muestro cómo ajustar tu consulta para forzar la intercalación en las comparaciones.

### Solución:
Puedes usar la cláusula `COLLATE` en las columnas afectadas para asegurarte de que ambas columnas tengan la misma intercalación en la comparación.

### Ejemplo Modificado:

Si sabes que las columnas están usando diferentes collation (por ejemplo, `Modern_Spanish_CI_AS` y `SQL_Latin1_General_CP1_CI_AS`), puedes forzar una de las intercalaciones en las comparaciones. Aquí te dejo un ejemplo para una de las consultas.

~~~sql
USE [SII.Omega.GCS]
GO

DECLARE @phoneNumber VARCHAR(max)

-- Aquí insertas todos los números como antes

-- Forzar intercalación en la comparación para evitar conflictos de collation
SELECT * 
FROM [SII.Omega.GCS].dbo.MobilesAccounts 
WHERE mobileID IN (
    SELECT ID 
    FROM [SII.Omega.GCS].dbo.CustomersMobiles 
    WHERE phoneNumber COLLATE SQL_Latin1_General_CP1_CI_AS 
    IN (SELECT PhoneNumber FROM #PhoneNumbers)
)

SELECT * 
FROM [SII.Omega.GCS].dbo.MobilesSecurityCodes 
WHERE mobileID IN (
    SELECT ID 
    FROM [SII.Omega.GCS].dbo.CustomersMobiles 
    WHERE phoneNumber COLLATE SQL_Latin1_General_CP1_CI_AS 
    IN (SELECT PhoneNumber FROM #PhoneNumbers)
)

SELECT * 
FROM [SII.Omega.GCS].dbo.MobilesLogs 
WHERE mobileID IN (
    SELECT ID 
    FROM [SII.Omega.GCS].dbo.CustomersMobiles 
    WHERE phoneNumber COLLATE SQL_Latin1_General_CP1_CI_AS 
    IN (SELECT PhoneNumber FROM #PhoneNumbers)
)

SELECT * 
FROM [SII.Omega.GCS].dbo.CustomersMobiles 
WHERE phoneNumber COLLATE SQL_Latin1_General_CP1_CI_AS 
IN (SELECT PhoneNumber FROM #PhoneNumbers)
~~~


## Esto ser hizo para solucionar el `Error` de Collate que presento el query
### Detalles del Ajuste:
1. **Uso de `COLLATE`:** En las comparaciones de la columna `phoneNumber`, se fuerza la intercalación a `SQL_Latin1_General_CP1_CI_AS`. Si prefieres usar otra intercalación, puedes reemplazarla por la que desees.
2. **Compatibilidad:** Asegúrate de que la intercalación elegida sea compatible con la intercalación de las columnas en la base de datos o tablas que estás utilizando.

Este ajuste debería eliminar el error de conflicto de collation. Si el conflicto ocurre en otra columna o parte de la consulta, aplica la misma lógica de `COLLATE` en esa columna.

## 3.- En el servidor de VCASH
#### Este es un comando curl que realiza una operación de desvinculación mediante una solicitud HTTP DELETE. No es posible convertir este comando directamente en una consulta SELECT porque es una operación en un servicio externo. Sin embargo, podrías intentar verificar la existencia del recurso o realizar un GET si el servicio ofrece un endpoint para consultar la información antes de eliminarla.


--- 

---











# 

---


# Documentación de Inserción de Usuarios en SQL Server para GCS `[SII.Omega.GCS]`<a name="1601"></a>

<div>
<p style = 'text-align:center;'>
<img src="https://gcs-international.com/wp-content/uploads/2017/05/GCS-International-Logo.png?auto=format&q=50?format=jpg&name=small" alt="JuveYell" width="750px">
</p>
</div>


a la creación de usuarios en la base de datos `[SII.Omega.GCS]`. Los scripts aquí presentados permiten duplicar un usuario existente como un nuevo registro en la tabla `PartnersUsers`, ajustando los valores necesarios para el nuevo usuario.

---

## Tabla de Contenidos
1. [Documentación de Inserción de Usuarios en SQL Server para GCS SII_OMGGA_GCS](#1801)
2. [Requerimientos](#1802)
3. [Scripts](#1803)
   - [Insertar usando Variables](#1831)
   - [Insertar usando `INSERT ... SELECT` con Usuario Modelo](#1832)
4. [Instrucciones de Uso](#1804)

---

## Descripción

Este código permite crear usuarios en la base de datos `GCS SII_OMGGA_GCS` de manera eficiente:
- **Primera Opción**: Insertar un nuevo usuario especificando valores personalizados mediante variables.
- **Segunda Opción**: Duplicar un usuario existente como registro, basándose en un usuario modelo y personalizando solo algunos campos (como el nombre de usuario, nombre, apellido y correo electrónico).

---



## Requerimientos<a name="1602"></a>

- **SQL Server**: Base de datos `GCS SII_OMGGA_GCS` donde existe la tabla `PartnersUsers`.
- **Permisos**: Permisos de escritura para ejecutar comandos `INSERT` en la base de datos.

---

## Scripts<a name="1603"></a>

### Insertar usando Variables<a name="1831"></a>

Este script permite la creación de un nuevo usuario en la tabla `PartnersUsers` especificando valores personalizados para cada campo.

```sql
DECLARE @PartnerID INT = 213;
DECLARE @AgencyID INT = 616;
DECLARE @TerminalID INT = 172;
DECLARE @ShiftID INT = 201;
DECLARE @UserName NVARCHAR(50) = 'joguzman';
DECLARE @FirstName NVARCHAR(50) = 'Joaquin';
DECLARE @LastName NVARCHAR(50) = 'Guzman';
DECLARE @Email NVARCHAR(100) = 'jeabreu@gcs-systems.com';
DECLARE @SOP_UpdUser INT = 3;
DECLARE @id_Ent INT = 309;
DECLARE @titleID INT = 1;
DECLARE @identificationType INT = 1;
DECLARE @identificationNumber NVARCHAR(20) = '00117167619';
DECLARE @userRoleId INT = 35;
DECLARE @creationDate DATE = '2024-10-25';
DECLARE @enabled BIT = 1;
DECLARE @SYS_Attr INT = 0;
DECLARE @SYS_Order INT = 0;
DECLARE @SOP_LockUpd BIT = 0;
DECLARE @SOP_LockDel BIT = 0;
DECLARE @SOP_InsStamp BIGINT = 20130418200238077;
DECLARE @SOP_InsUser INT = 3;
DECLARE @SOP_UpdStamp BIGINT = 20130418200238077;

INSERT INTO dbo.PartnersUsers (
    PartnerID,
    AgencyID,
    TerminalID,
    ShiftID,
    UserName,
    FirstName,
    LastName,
    Email,
    SOP_UpdUser,
    id_Ent,
    titleID,
    identificationType,
    identificationNumber,
    userRoleId,
    creationDate,
    enabled,
    SYS_Attr,
    SYS_Order,
    SOP_LockUpd,
    SOP_LockDel,
    SOP_InsStamp,
    SOP_InsUser,
    SOP_UpdStamp
)
VALUES (
    @PartnerID,
    @AgencyID,
    @TerminalID,
    @ShiftID,
    @UserName,
    @FirstName,
    @LastName,
    @Email,
    @SOP_UpdUser,
    @id_Ent,
    @titleID,
    @identificationType,
    @identificationNumber,
    @userRoleId,
    @creationDate,
    @enabled,
    @SYS_Attr,
    @SYS_Order,
    @SOP_LockUpd,
    @SOP_LockDel,
    @SOP_InsStamp,
    @SOP_InsUser,
    @SOP_UpdStamp
);
```

### Insertar usando `INSERT ... SELECT` con Usuario Modelo<a name="1632"></a>

Este script permite duplicar un usuario existente en la base de datos `GCS SII_OMGGA_GCS` copiando sus datos y personalizando campos específicos, como el nombre de usuario, nombre, apellido y correo electrónico.

```sql
DECLARE @NewUserName NVARCHAR(50) = 'joguzman';
DECLARE @NewFirstName NVARCHAR(50) = 'Joaquin';
DECLARE @NewLastName NVARCHAR(50) = 'Guzman';
DECLARE @NewEmail NVARCHAR(100) = 'jeabreu@gcs-systems.com';
DECLARE @ModelUserName NVARCHAR(50) = 'modelUser';  -- Especifica aquí el UserName del usuario modelo

INSERT INTO dbo.PartnersUsers (
    PartnerID,
    AgencyID,
    TerminalID,
    ShiftID,
    UserName,
    FirstName,
    LastName,
    Email,
    SOP_UpdUser,
    id_Ent,
    titleID,
    identificationType,
    identificationNumber,
    userRoleId,
    creationDate,
    enabled,
    SYS_Attr,
    SYS_Order,
    SOP_LockUpd,
    SOP_LockDel,
    SOP_InsStamp,
    SOP_InsUser,
    SOP_UpdStamp
)
SELECT 
    PartnerID,
    AgencyID,
    TerminalID,
    ShiftID,
    @NewUserName AS UserName,
    @NewFirstName AS FirstName,
    @NewLastName AS LastName,
    @NewEmail AS Email,
    SOP_UpdUser,
    id_Ent,
    titleID,
    identificationType,
    identificationNumber,
    userRoleId,
    creationDate,
    enabled,
    SYS_Attr,
    SYS_Order,
    SOP_LockUpd,
    SOP_LockDel,
    SOP_InsStamp,
    SOP_InsUser,
    SOP_UpdStamp
FROM dbo.PartnersUsers
WHERE UserName = @ModelUserName;
```

---





## Instrucciones de Uso<a name="1604"></a>




1. Selecciona el script adecuado según el método de inserción que prefieras.
2. Modifica los valores necesarios:
   - En el primer script, ajusta las variables para los valores que deseas.
   - En el segundo script, especifica el nombre de usuario del usuario modelo y los nuevos valores.
3. Ejecuta el script en SQL Server Management Studio o en tu entorno de SQL preferido.


1. [Documentación de Inserción de Usuarios en SQL Server para GCS SII_OMGGA_GCS](#1801)

---

### Notas

Este documento está diseñado para integrarse en un repositorio de GitHub y proporcionar una referencia clara para la creación de registros en la tabla `PartnersUsers` en `GCS SII-OMGGA-GCS` 10.226.196.30. Ajusta el código según tus necesidades específicas.
---



# 
# Consulta de Estadísticas de Ejecución de Queries en SQL Server con Detalles de Rendimiento y Uso de Recursos<a name="602"></a>

<div>
<p style = 'text-align:center;'>
<img src="https://previews.123rf.com/images/r4yhan/r4yhan1908/r4yhan190800073/128376160-ilustraci%C3%B3n-relacionada-con-el-an%C3%A1lisis-de-datos-vector-logo-de-investigaci%C3%B3n-informaci%C3%B3n.jpg" alt="JuveYell" width="700px">
</p>
</div>


Para obtener los logs de las consultas ejecutadas en SQL Server, puedes utilizar las vistas de catálogo del sistema, como `sys.dm_exec_query_stats`, junto con otras vistas que te permitan ver el texto de la consulta y detalles adicionales como el plan de ejecución y la sesión en la que se ejecutó.

Aquí te muestro un ejemplo de cómo puedes extraer información sobre las consultas que se han ejecutado en el servidor SQL:

~~~sql
SELECT 
    qs.sql_handle,
    qs.execution_count,
    qs.total_worker_time AS CPU_Time,
    qs.total_physical_reads AS Physical_Reads,
    qs.total_logical_reads AS Logical_Reads,
    qs.total_logical_writes AS Logical_Writes,
    qs.total_elapsed_time AS Duration,
    SUBSTRING(st.text, (qs.statement_start_offset/2) + 1, 
              ((CASE qs.statement_end_offset 
                  WHEN -1 THEN DATALENGTH(st.text)
                  ELSE qs.statement_end_offset 
              END - qs.statement_start_offset)/2) + 1) AS query_text,
    DB_NAME(dbid) AS DatabaseName,
    OBJECT_NAME(st.objectid, dbid) AS ObjectName,
    qs.creation_time
FROM 
    sys.dm_exec_query_stats qs
CROSS APPLY 
    sys.dm_exec_sql_text(qs.sql_handle) st
ORDER BY 
    qs.total_worker_time DESC;  -- Ordenar por el tiempo total de CPU utilizado
~~~

### Explicación de la consulta:

- **`sys.dm_exec_query_stats`**: Esta vista devuelve estadísticas agregadas de las consultas que se han ejecutado en el servidor SQL.
- **`sys.dm_exec_sql_text(qs.sql_handle)`**: Esta función devuelve el texto de la consulta SQL asociado con un `sql_handle`.
- **`execution_count`**: Número de veces que se ha ejecutado la consulta.
- **`total_worker_time`**: Tiempo total de CPU utilizado por la consulta.
- **`total_physical_reads`**: Número total de lecturas físicas (desde el disco).
- **`total_logical_reads`**: Número total de lecturas lógicas (desde la memoria).
- **`total_logical_writes`**: Número total de escrituras lógicas.
- **`total_elapsed_time`**: Tiempo total de duración de la consulta.
- **`query_text`**: El texto de la consulta ejecutada.
- **`DatabaseName`**: Nombre de la base de datos en la que se ejecutó la consulta.
- **`ObjectName`**: Nombre del objeto (por ejemplo, procedimiento almacenado) al que pertenece la consulta.
- **`creation_time`**: Hora en la que se creó la entrada de estadísticas.

Este query te da una visión general de las consultas que han consumido más recursos en tu servidor. Ten en cuenta que `sys.dm_exec_query_stats` solo mantiene las estadísticas de las consultas que aún están en caché. Si una consulta ya no está en caché, no aparecerá en los resultados.

Si necesitas logs más detallados o históricos, deberías considerar la habilitación de `SQL Server Audit` o el uso de `Extended Events`. También puedes habilitar la traza de SQL Server, aunque esta última opción está obsoleta en versiones más recientes.

---





## 1.- EN LA BASE DE DATOS DE SQLSERVER

## Eliminar registro de la base de datos `[SII.Omega.GCS]`  

El error que estás viendo se debe a un conflicto entre dos intercalaciones (collations) diferentes en las columnas que estás comparando o usando en las consultas. Este problema es común cuando las bases de datos o las tablas utilizan diferentes configuraciones de intercalación.

Para resolver este problema, puedes forzar a que las comparaciones se hagan usando la misma intercalación (`collation`). A continuación, te muestro cómo ajustar tu consulta para forzar la intercalación en las comparaciones.

### Solución:
Puedes usar la cláusula `COLLATE` en las columnas afectadas para asegurarte de que ambas columnas tengan la misma intercalación en la comparación.

### Ejemplo Modificado:

Si sabes que las columnas están usando diferentes collation (por ejemplo, `Modern_Spanish_CI_AS` y `SQL_Latin1_General_CP1_CI_AS`), puedes forzar una de las intercalaciones en las comparaciones. Aquí te dejo un ejemplo para una de las consultas.

~~~sql
USE [SII.Omega.GCS]
GO

DECLARE @phoneNumber VARCHAR(max)

-- Aquí insertas todos los números como antes

-- Forzar intercalación en la comparación para evitar conflictos de collation
SELECT * 
FROM [SII.Omega.GCS].dbo.MobilesAccounts 
WHERE mobileID IN (
    SELECT ID 
    FROM [SII.Omega.GCS].dbo.CustomersMobiles 
    WHERE phoneNumber COLLATE SQL_Latin1_General_CP1_CI_AS 
    IN (SELECT PhoneNumber FROM #PhoneNumbers)
)

SELECT * 
FROM [SII.Omega.GCS].dbo.MobilesSecurityCodes 
WHERE mobileID IN (
    SELECT ID 
    FROM [SII.Omega.GCS].dbo.CustomersMobiles 
    WHERE phoneNumber COLLATE SQL_Latin1_General_CP1_CI_AS 
    IN (SELECT PhoneNumber FROM #PhoneNumbers)
)

SELECT * 
FROM [SII.Omega.GCS].dbo.MobilesLogs 
WHERE mobileID IN (
    SELECT ID 
    FROM [SII.Omega.GCS].dbo.CustomersMobiles 
    WHERE phoneNumber COLLATE SQL_Latin1_General_CP1_CI_AS 
    IN (SELECT PhoneNumber FROM #PhoneNumbers)
)

SELECT * 
FROM [SII.Omega.GCS].dbo.CustomersMobiles 
WHERE phoneNumber COLLATE SQL_Latin1_General_CP1_CI_AS 
IN (SELECT PhoneNumber FROM #PhoneNumbers)
~~~


## Esto ser hizo para solucionar el `Error` de Collate que presento el query
### Detalles del Ajuste:
1. **Uso de `COLLATE`:** En las comparaciones de la columna `phoneNumber`, se fuerza la intercalación a `SQL_Latin1_General_CP1_CI_AS`. Si prefieres usar otra intercalación, puedes reemplazarla por la que desees.
2. **Compatibilidad:** Asegúrate de que la intercalación elegida sea compatible con la intercalación de las columnas en la base de datos o tablas que estás utilizando.

Este ajuste debería eliminar el error de conflicto de collation. Si el conflicto ocurre en otra columna o parte de la consulta, aplica la misma lógica de `COLLATE` en esa columna.

## 3.- En el servidor de VCASH
#### Este es un comando curl que realiza una operación de desvinculación mediante una solicitud HTTP DELETE. No es posible convertir este comando directamente en una consulta SELECT porque es una operación en un servicio externo. Sin embargo, podrías intentar verificar la existencia del recurso o realizar un GET si el servicio ofrece un endpoint para consultar la información antes de eliminarla.


--- 




# **"Cómo Localizar y Revisar Archivos de Auditoría (.sqlaudit) en SQL Server"**<a name="603"></a>
<div>
<p style = 'text-align:center;'>
<img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQLNTZk49IjJKvo4QJY8oFvtclV2b3PNOPlFA&s" alt="JuveYell" width="700px">
</p>
</div>

El archivo `YourAuditFilePath\YourAuditName*.sqlaudit` es un ejemplo genérico. Para encontrar la ubicación real de tus archivos de auditoría (`.sqlaudit`), sigue estos pasos:

### **1. Consultar la configuración de la auditoría en SQL Server**

Ejecuta la siguiente consulta en SQL Server para obtener la ubicación del archivo de auditoría:

```sql
SELECT 
    audit_name,
    audit_file_path,
    audit_guid,
    status_desc,
    queue_delay,
    on_failure,
    max_size,
    max_rollover_files
FROM 
    sys.server_file_audits;
```

- **audit_name**: El nombre de la auditoría configurada.
- **audit_file_path**: La ruta del sistema de archivos donde se almacenan los archivos de auditoría.

### **2. Localizar el archivo en el sistema operativo**

Una vez que obtengas la ruta (`audit_file_path`), sigue estos pasos:

- **En Windows**:
  1. Abre el Explorador de Archivos.
  2. Copia y pega la ruta obtenida de la consulta en la barra de direcciones del Explorador.
  3. Presiona `Enter`.

  Aquí deberías encontrar uno o varios archivos con la extensión `.sqlaudit` que corresponden a los eventos auditados.

### **3. Revisar el archivo de auditoría**

Puedes abrir el archivo `.sqlaudit` con SQL Server Management Studio (SSMS) para revisar su contenido, o usar la función `sys.fn_get_audit_file` para consultar los datos desde SQL Server:

```sql
SELECT 
    event_time,
    server_principal_name,
    database_name,
    schema_name,
    object_name,
    statement
FROM 
    sys.fn_get_audit_file('C:\Ruta\AuditFolder\YourAuditName*.sqlaudit', NULL, NULL);
```

Asegúrate de reemplazar `'C:\Ruta\AuditFolder\YourAuditName*.sqlaudit'` con la ruta y nombre correctos obtenidos en los pasos anteriores.

Este proceso te permitirá encontrar y revisar los archivos de auditoría en SQL Server.

--- 

## Auto-fix para Usuarios Huérfanos en SQL Server<a name="604"></a>

```sql
-- Script: Auto-fix SQL Server Login/User Mismatch
-- Database: myDB

-- Description:
-- This script is used to automatically link an existing SQL Server login 
-- with a database user that has become orphaned, i.e., a database user 
-- that is not mapped to a login. The 'Auto_Fix' option of the 
-- sp_change_users_login stored procedure attempts to fix the mismatch 
-- between a login and a user by finding a login with the same name and 
-- associating it with the specified user.

-- Usage:
-- This script is executed in the context of the 'myDB' database. 
-- Replace 'myDB' with the name of your database and 'myUser' with the 
-- database username you wish to fix. Ensure that the login name in 
-- the server matches the username in the database.

USE myDB
EXEC sp_change_users_login 'Auto_Fix', 'myUser'
```

### Additional Notes:
- **sp_change_users_login** is a deprecated stored procedure, so consider using `ALTER USER` or other methods in future developments.
- This script is typically used in environments where users might become orphaned after a database restoration or migration.
- **'Auto_Fix'** will automatically associate the database user with a login of the same name. If the login does not exist, it won't create a new one.

### Example:
```sql
-- Assuming you have a database 'SalesDB' and a user 'john_doe' that is orphaned:
USE SalesDB
EXEC sp_change_users_login 'Auto_Fix', 'john_doe'
```

You can include this documentation in a `README.md` file in your GitHub repository, along with the SQL script file for better organization and understanding for others who might view or use your code.



---
# 

Aquí tienes una propuesta para una documentación en GitHub para el script SQL que permite copiar permisos y roles de un usuario existente a un nuevo usuario en SQL Server. Esta documentación incluye un índice, descripción del script, y pasos detallados para su ejecución.

---

# Clonación de Permisos y Roles de un Usuario en SQL Server<a name="605"></a>

Este repositorio contiene un script de SQL Server que permite clonar los permisos y roles de un usuario existente (`@ExistingUser`) a un nuevo usuario (`@NewUser`). Es útil cuando se necesita crear un usuario con la misma configuración de permisos en una base de datos.

## Tabla de Contenidos

### 1. Descripción

Este script está diseñado para clonar permisos y roles de un usuario existente a un nuevo usuario en una base de datos de SQL Server. El script sigue estos pasos:

- Define variables de entrada para el usuario existente y el nuevo usuario.
- Crea un nuevo `Login` y `User` para el nuevo usuario.
- Copia permisos de nivel de base de datos, objetos, esquemas y roles del usuario existente al nuevo usuario.

### 2. Requisitos

Para utilizar este script, necesitas:
- Permisos de administrador en SQL Server para crear y asignar permisos a usuarios.
- Conexión a la base de datos donde se van a clonar los permisos.

### 3. Uso del Script

1. **Establecer valores de usuario**: Define el nombre del usuario existente (`@ExistingUser`) y el nuevo usuario (`@NewUser`) en las variables al inicio del script.
2. **Ejecutar el script**: Ejecuta el script completo para clonar los permisos y roles.
3. **Verificar**: Comprueba que el nuevo usuario tiene los permisos y roles clonados correctamente desde el usuario existente.

### 4. Código

```sql
-- Variables
DECLARE @ExistingUser NVARCHAR(50) = 'UsuarioExistente'
DECLARE @NewUser NVARCHAR(50) = 'NuevoUsuario'
DECLARE @Password NVARCHAR(50) = 'ContraseñaSegura'

-- Crear nuevo usuario
CREATE LOGIN [@NewUser] WITH PASSWORD = @Password;
CREATE USER [@NewUser] FOR LOGIN [@NewUser];

-- Asignar permisos del usuario existente al nuevo usuario
DECLARE @SQL NVARCHAR(MAX) = '';

-- Permisos a nivel de base de datos
SELECT @SQL = @SQL + 'USE ' + QUOTENAME(DB_NAME()) + ';
GRANT ' + dp.permission_name + ' ON ' +
    CASE dp.class
        WHEN 0 THEN 'DATABASE::' + QUOTENAME(DB_NAME())
        WHEN 1 THEN 'OBJECT::' + QUOTENAME(OBJECT_SCHEMA_NAME(dp.major_id)) + '.' + QUOTENAME(OBJECT_NAME(dp.major_id))
        WHEN 3 THEN 'SCHEMA::' + QUOTENAME(OBJECT_SCHEMA_NAME(dp.major_id))
        WHEN 4 THEN 'APPLICATION ROLE::' + QUOTENAME(OBJECT_NAME(dp.major_id))
        ELSE 'UNKNOWN'
    END + ' TO ' + QUOTENAME(@NewUser) + ';
'
FROM sys.database_permissions dp
JOIN sys.database_principals dp2 ON dp.grantee_principal_id = dp2.principal_id
WHERE dp2.name = @ExistingUser;

-- Ejecutar el script de permisos
EXEC sp_executesql @SQL;

-- Roles de base de datos
DECLARE @Role NVARCHAR(128);
DECLARE RoleCursor CURSOR FOR
SELECT dp.name
FROM sys.database_principals dp
JOIN sys.database_role_members drm ON dp.principal_id = drm.role_principal_id
JOIN sys.database_principals dp2 ON drm.member_principal_id = dp2.principal_id
WHERE dp2.name = @ExistingUser;

OPEN RoleCursor;
FETCH NEXT FROM RoleCursor INTO @Role;

WHILE @@FETCH_STATUS = 0
BEGIN
    EXEC sp_addrolemember @Role, @NewUser;
    FETCH NEXT FROM RoleCursor INTO @Role;
END

CLOSE RoleCursor;
DEALLOCATE RoleCursor;
```

### 5. Explicación del Código

1. **Definición de Variables**:
   - `@ExistingUser`: Nombre del usuario existente cuyos permisos y roles se copiarán.
   - `@NewUser`: Nombre del nuevo usuario que recibirá los permisos.
   - `@Password`: Contraseña para el nuevo usuario.

2. **Creación del Nuevo Usuario**:
   - Crea un `Login` y un `User` en la base de datos para el nuevo usuario.

3. **Clonación de Permisos**:
   - Se genera un script dinámico para copiar todos los permisos (base de datos, objetos, esquemas) del usuario existente al nuevo usuario.

4. **Asignación de Roles**:
   - Utiliza un cursor para asignar al nuevo usuario los roles que tenía el usuario existente.

---







# 
# 


# Configuraciones Post-Instalación de SQL Server
<div>
<p style = 'text-align:center;'>
<img src="https://i.ytimg.com/vi/fyyGKLtZIvk/hq720.jpg?sqp=-oaymwEhCK4FEIIDSFryq4qpAxMIARUAAAAAGAElAADIQj0AgKJD&rs=AOn4CLD9NcEAkiG5SKjC7wCmMCnKH1PTLA" alt="JuveYell" width="700px">
</p>
</div>

Este repositorio contiene una serie de scripts SQL diseñados para realizar configuraciones post-instalación en servidores SQL Server. Las configuraciones incluyen la actualización de políticas de crecimiento y tamaños iniciales en las bases de datos del sistema, la configuración de TempDB, ajustes de parámetros de configuración de la instancia, renombramiento del servidor, y la creación de bases de datos administrativas.

---

## 1. Actualizar Políticas de Crecimiento y Tamaños de las Bases de Datos del Sistema<a name="17.1"></a>

Este script actualiza las políticas de crecimiento y los tamaños iniciales en las bases de datos del sistema: `master`, `model` y `msdb`. Es aplicable a servidores recién instalados o que requieren remediación en sus configuraciones.

**Autores:** Charles Díaz Falette, Departamento de Soporte de Bases de Datos  
**Compilado:** 1 de Febrero de 2018  
**Modificado por:** Carlos Manuel Lesta, 16 de Septiembre de 2022

### Script

```sql
/*
    Tipo: Configuraciones post-instalación.
    Acción: Actualiza políticas de crecimiento y tamaños iniciales en bases de datos del sistema.
    Escenario: Servidores recién instalados y servidores que requieren remediación en sus configuraciones.
    Bases de datos: Master, model, msdb.
    Autores: Charles Díaz Falette, Depto. Soporte Bases De Datos.
    Compilado: 1/Febrero/2018.
    Modificado: Carlos Manuel Lesta, 16/Septiembre/2022.
*/

-- Modifica tamaño y política de crecimiento de los archivos de la base de datos master.
-- Tamaño: Datafile: 2000MB | Logfile: 1000MB
-- Crecimiento: Datafile: 1000MB | Logfile: 1000MB

USE [master]
GO

ALTER DATABASE [master] MODIFY FILE (NAME = N'master', SIZE = 2048000KB, FILEGROWTH = 1024000KB)
GO

ALTER DATABASE [master] MODIFY FILE (NAME = N'mastlog', SIZE = 1024000KB, FILEGROWTH = 1024000KB)
GO

-- Modifica tamaño y política de crecimiento de los archivos de la base de datos model.
-- Tamaño: Datafile: 2000MB | Logfile: 1000MB
-- Crecimiento: Datafile: 1000MB | Logfile: 1000MB

USE [master]
GO

ALTER DATABASE [model] MODIFY FILE (NAME = N'modeldev', SIZE = 2048000KB, FILEGROWTH = 1024000KB)
GO

ALTER DATABASE [model] MODIFY FILE (NAME = N'modellog', SIZE = 1024000KB, FILEGROWTH = 1024000KB)
GO

-- Modifica modelo de recuperación a Full

USE [master]
GO

ALTER DATABASE [model] SET RECOVERY FULL WITH NO_WAIT
GO

-- Modifica tamaño y política de crecimiento de los archivos de la base de datos msdb.
-- Tamaño: Datafile: 2000MB | Logfile: 1000MB
-- Crecimiento: Datafile: 1000MB | Logfile: 1000MB

USE [master]
GO

ALTER DATABASE [msdb] MODIFY FILE (NAME = N'MSDBData', SIZE = 2048000KB, FILEGROWTH = 1024000KB)
GO

ALTER DATABASE [msdb] MODIFY FILE (NAME = N'MSDBLog', SIZE = 1024000KB, FILEGROWTH = 1024000KB)
GO
```

---

## 2. Adicionar Nuevos Archivos de TempDB<a name="17.1"></a>

Este script adiciona nuevos archivos a TempDB según los requerimientos del servidor, basándose en el número de cores de CPU. Aplica para servidores recién instalados y aquellos que requieren remediación en sus configuraciones.

**Autores:** Charles Díaz Falette, Departamento de Soporte de Bases de Datos  
**Compilado:** 21 de Septiembre de 2020  
**Modificado por:** 1 de Octubre de 2020

### Paso 1: Validar Archivos<a name="17.21"></a>

Este paso verifica la configuración actual de TempDB.

```sql
-- Paso 1: validar archivos

USE master
GO

SP_HELPDB TempDB
GO
```

### Paso 2: Crear Nuevos Archivos para TempDB (4 Cores)<a name="17.22"></a>

Aplica para instalaciones convencionales de 4 cores.

```sql
-- Paso 2: Crea nuevos archivos para TempDB. Aplica para instalaciones convencionales de 4 cores.

USE [master]
GO

ALTER DATABASE [tempdb] ADD FILE (NAME = N'tempdev2', FILENAME = N'T:\MSSQL\TempDB\tempdb2.ndf', SIZE = 2048000KB, FILEGROWTH = 512000KB)
GO

ALTER DATABASE [tempdb] ADD FILE (NAME = N'tempdev3', FILENAME = N'T:\MSSQL\TempDB\tempdb3.ndf', SIZE = 2048000KB, FILEGROWTH = 512000KB)
GO

ALTER DATABASE [tempdb] ADD FILE (NAME = N'tempdev4', FILENAME = N'T:\MSSQL\TempDB\tempdb4.ndf', SIZE = 2048000KB, FILEGROWTH = 512000KB)
GO
```

### Paso 3: Crear Nuevos Archivos para TempDB (8, 12, y 16 Cores)<a name="17.23"></a>

Estos pasos agregan archivos adicionales para instalaciones con más cores, utilizando diferentes discos según el número de cores.

#### Para 8 Cores (Drive S)

```sql
-- Paso 3: Crea nuevos archivos para TempDB. Aplica para instalaciones de 8 cores.
-- Se emplea un disco adicional para TempDB con el drive S.

/*
ALTER DATABASE [tempdb] ADD FILE (NAME = N'tempdev5', FILENAME = N'S:\MSSQL\TempDB\tempdb5.ndf', SIZE = 2048000KB, FILEGROWTH = 512000KB)
GO
ALTER DATABASE [tempdb] ADD FILE (NAME = N'tempdev6', FILENAME = N'S:\MSSQL\TempDB\tempdb6.ndf', SIZE = 2048000KB, FILEGROWTH = 512000KB)
GO
ALTER DATABASE [tempdb] ADD FILE (NAME = N'tempdev7', FILENAME = N'S:\MSSQL\TempDB\tempdb7.ndf', SIZE = 2048000KB, FILEGROWTH = 512000KB)
GO
ALTER DATABASE [tempdb] ADD FILE (NAME = N'tempdev8', FILENAME = N'S:\MSSQL\TempDB\tempdb8.ndf', SIZE = 2048000KB, FILEGROWTH = 512000KB)
GO
*/
```

#### Para 12 Cores (Drive X)

```sql
-- Paso 3: Crea nuevos archivos para TempDB. Aplica para instalaciones de 12 cores.
-- Se emplea un disco adicional para TempDB con el drive X.

/*
ALTER DATABASE [tempdb] ADD FILE (NAME = N'tempdev9', FILENAME = N'X:\MSSQL\TempDB\tempdb9.ndf', SIZE = 2048000KB, FILEGROWTH = 512000KB)
GO
ALTER DATABASE [tempdb] ADD FILE (NAME = N'tempdev10', FILENAME = N'X:\MSSQL\TempDB\tempdb10.ndf', SIZE = 2048000KB, FILEGROWTH = 512000KB)
GO
ALTER DATABASE [tempdb] ADD FILE (NAME = N'tempdev11', FILENAME = N'X:\MSSQL\TempDB\tempdb11.ndf', SIZE = 2048000KB, FILEGROWTH = 512000KB)
GO
ALTER DATABASE [tempdb] ADD FILE (NAME = N'tempdev12', FILENAME = N'X:\MSSQL\TempDB\tempdb12.ndf', SIZE = 2048000KB, FILEGROWTH = 512000KB)
GO
*/
```

#### Para 16 Cores o más (Drive Y)

```sql
-- Paso 3: Crea nuevos archivos para TempDB. Aplica para instalaciones de 16 cores o más.
-- Se emplea un disco adicional para TempDB con el drive Y.

/*
ALTER DATABASE [tempdb] ADD FILE (NAME = N'tempdev13', FILENAME = N'Y:\MSSQL\TempDB\tempdb13.ndf', SIZE = 2048000KB, FILEGROWTH = 512000KB)
GO
ALTER DATABASE [tempdb] ADD FILE (NAME = N'tempdev14', FILENAME = N'Y:\MSSQL\TempDB\tempdb14.ndf', SIZE = 2048000KB, FILEGROWTH = 512000KB)
GO
ALTER DATABASE [tempdb] ADD FILE (NAME = N'tempdev15', FILENAME = N'Y:\MSSQL\TempDB\tempdb15.ndf', SIZE = 2048000KB, FILEGROWTH = 512000KB)
GO
ALTER DATABASE [tempdb] ADD FILE (NAME = N'tempdev16', FILENAME = N'Y:\MSSQL\TempDB\tempdb16.ndf', SIZE = 2048000KB, FILEGROWTH = 512000KB)
GO
*/
```

### Paso 4: Modificar Nombres y Tamaños de Archivos<a name="17.24"></a>

Este paso renombra los archivos lógicos y modifica las rutas físicas de los archivos recién creados. Requiere reiniciar el servicio de SQL Server para aplicar los cambios. Después del reinicio, los archivos anteriores deben ser eliminados.

```sql
-- Paso 3: Modificar nombres de archivos en el script.
-- El ejemplo muestra cambio de nombre del archivo lógico "temp2" a "tempdev2" y así sucesivamente.

USE [master]
GO

ALTER DATABASE [tempdb] MODIFY FILE (NAME=N'temp2', NEWNAME=N'tempdev2')
GO
ALTER DATABASE [tempdb] MODIFY FILE (NAME=N'temp3', NEWNAME=N'tempdev3')
GO
ALTER DATABASE [tempdb] MODIFY FILE (NAME=N'temp4', NEWNAME=N'tempdev4')
GO

-- Paso 3: Modificar nombres de archivos físicos.
-- NOTA: este cambio NO RENOMBRA archivos físicos de la TempDB. Sólo modifica el catálogo para la creación de nuevos archivos.
-- Este cambio requiere reinicio del servicio de SQL Server para ser aplicado.
-- Los archivos anteriores deben ser eliminados posterior al reinicio del servicio.

USE [master]
GO

ALTER DATABASE tempdb MODIFY FILE
(NAME = tempdev2, FILENAME = 'T:\MSSQL\TempDB\tempdb2.ndf')
GO
ALTER DATABASE tempdb MODIFY FILE
(NAME = tempdev3, FILENAME = 'T:\MSSQL\TempDB\tempdb3.ndf')
GO
ALTER DATABASE tempdb MODIFY FILE
(NAME = tempdev4, FILENAME = 'T:\MSSQL\TempDB\tempdb4.ndf')
GO

-- Paso 4: Modificar tamaños de archivos.
-- Modifica tamaños iniciales y políticas de crecimiento para archivos existentes:
-- Tamaño: Datafile: 4000MB | Logfile: 2000MB
-- Crecimiento: Datafile: 1000MB | Logfile: 1000MB

USE [master]
GO

ALTER DATABASE [tempdb] MODIFY FILE (NAME = N'tempdev2', SIZE = 4096000KB, FILEGROWTH = 1024000KB)
GO
ALTER DATABASE [tempdb] MODIFY FILE (NAME = N'tempdev3', SIZE = 4096000KB, FILEGROWTH = 1024000KB)
GO
ALTER DATABASE [tempdb] MODIFY FILE (NAME = N'tempdev4', SIZE = 4096000KB, FILEGROWTH = 1024000KB)
GO
ALTER DATABASE [tempdb] MODIFY FILE (NAME = N'tempdev', SIZE = 4096000KB, FILEGROWTH = 1024000KB)
GO
ALTER DATABASE [tempdb] MODIFY FILE (NAME = N'templog', SIZE = 2048000KB, FILEGROWTH = 1024000KB)
GO
```

---

## 3. Cálculo del MAXDOP<a name="17.3"></a>

Este script calcula el valor óptimo para el parámetro `MAXDOP` en SQL Server (versiones > 2016). Está basado en Microsoft KB# 2806535 y el calculador MaxDOP de MSDN. Se recomienda ejecutar este script en modo SQLCMD.

**Autor:** Carlos Robles  
**Fuente:** DBA Mastery  
**Licencia:** MIT

### Script

```sql
/*
-- +----------------------------------------------------------------------------+
-- |                                                        DBA Mastery                                      |
-- |                        dbamastery@outlook.com                              |
-- |                      http://www.dbamastery.com                             |
-- |----------------------------------------------------------------------------|
-- |                                                                            |
-- |----------------------------------------------------------------------------|
-- | DATABASE : SQL Server                                                      |
-- | FILE     : maxdop_calculator.sql                                        |
-- | CLASS    : Performance tuning                                              |
-- | PURPOSE  :  Calculates the optimal value for MAXDOP (> SQL 2016 )                  |
-- |                                                                                                                                                          |
-- | NOTE     : As with any code, ensure to test this script in a development   |
-- |            environment before attempting to run it in production.          |
-- |                                                                            |
-- |            Based on Microsoft KB# 2806535: https://goo.gl/4FD9BH and       |
-- |            MSDN MaxDOP calculator: https://goo.gl/hzyxY1                   |
-- +----------------------------------------------------------------------------+

AUTHOR: CARLOS ROBLES

Copyright (c) 2019 DBA Mastery

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

SET NOEXEC OFF;

:SETVAR IsSqlCmdEnabled "True"

:OUT STDOUT

GO

IF ('$(IsSqlCmdEnabled)' = '$' + '(IsSqlCmdEnabled)')
BEGIN
    -- Disabling script execution in case SQLCMD mode is not enabled in SSMS
    PRINT N'SQLCMD mode must be enabled to successfully execute this script.';
    PRINT N'For instructions on how to use SQLCMD mode in SSMS, please visit this post from my blog:';
    PRINT N'http://www.dbamastery.com/tips/SQLCMD-mode-SSMS'
    SET NOEXEC ON;
END;
ELSE
BEGIN
    SET NOCOUNT ON;
    USE MASTER;

    -- Dropping temp table in case it exists
    IF EXISTS (SELECT * FROM tempdb.dbo.sysobjects o WHERE o.XTYPE IN ('U') AND o.id = OBJECT_ID(N'tempdb..#MaxDOPDB')) 
        DROP TABLE #MaxDOPDB;

    DECLARE
        @SQLVersion INT,
        @NumaNodes INT,
        @NumCPUs INT,
        @MaxDop SQL_VARIANT,
        @RecommendedMaxDop INT;

    -- Getting SQL Server version
    SELECT @SQLVersion = SUBSTRING(CONVERT(VARCHAR, SERVERPROPERTY('ProductVersion')), 1, 2);

    -- Getting number of NUMA nodes
    SELECT @NumaNodes = COUNT(DISTINCT memory_node_id) 
    FROM sys.dm_os_memory_clerks 
    WHERE memory_node_id != 64;

    -- Getting number of CPUs (cores)
    SELECT @NumCPUs = COUNT(scheduler_id) 
    FROM sys.dm_os_schedulers 
    WHERE status = 'VISIBLE ONLINE';

    -- Getting current MAXDOP at instance level
    SELECT @MaxDop = value_in_use 
    FROM sys.configurations 
    WHERE name = 'max degree of parallelism';

    -- MAXDOP calculation (Instance level)
    -- If SQL Server has single NUMA node
    IF @NumaNodes = 1
        IF @NumCPUs < 8
            -- If number of logical processors is less than 8, MAXDOP equals number of logical processors
            SET @RecommendedMaxDop = @NumCPUs;
        ELSE
            -- Keep MAXDOP at 8
            SET @RecommendedMaxDop = 8;
    ELSE
        -- If SQL Server has multiple NUMA nodes
        IF (@NumCPUs / @NumaNodes) < 8
            -- IF number of logical processors per NUMA node is less than 8, MAXDOP equals or below logical processors per NUMA node
            SET @RecommendedMaxDop = (@NumCPUs / @NumaNodes);
        ELSE
            -- If greater than 8 logical processors per NUMA node - Keep MAXDOP at 8
            SET @RecommendedMaxDop = 8;

    -- If SQL Server is > 2016
    IF CONVERT(INT, @SQLVersion) > 12
    BEGIN
        -- Getting current MAXDOP at database level

        -- Creating temp table
        CREATE TABLE #MaxDOPDB
        (
            DBName sysname, 
            configuration_id int, 
            name nvarchar(120), 
            value_for_primary sql_variant, 
            value_for_secondary sql_variant
        );

        INSERT INTO #MaxDOPDB
        EXEC sp_msforeachdb 'USE [?]; SELECT DB_NAME(), configuration_id, name, value, value_for_secondary FROM sys.database_scoped_configurations WHERE name =''MAXDOP''';

        -- Displaying database MAXDOP configuration
        PRINT '------------------------------------------------------------------------';
        PRINT 'MAXDOP at Database level:';
        PRINT '------------------------------------------------------------------------';
        SELECT 
            CONVERT(VARCHAR(30), dbname) AS DatabaseName, 
            CONVERT(VARCHAR(10), name) AS ConfigurationName, 
            CONVERT(INT, value_for_primary) AS "MAXDOP Configured Value" 
        FROM #MaxDOPDB
        WHERE dbname NOT IN ('master', 'msdb', 'tempdb', 'model');

        PRINT '';

        -- Displaying current and recommended MAXDOP
        PRINT '--------------------------------------------------------------';
        PRINT 'MAXDOP at Instance level:';
        PRINT '--------------------------------------------------------------';
        PRINT 'MAXDOP configured value: ' + CHAR(9) + CAST(@MaxDop AS CHAR);
        PRINT 'MAXDOP recommended value: ' + CHAR(9) + CAST(@RecommendedMaxDop AS CHAR);
        PRINT '--------------------------------------------------------------';
        PRINT '';

        IF (@MaxDop <> @RecommendedMaxDop)
        BEGIN
            PRINT 'In case you want to change MAXDOP to the recommended value, please use this script:';
            PRINT '';
            PRINT 'EXEC sp_configure ''max degree of parallelism'', ' + CAST(@RecommendedMaxDop AS CHAR);
            PRINT 'GO';
            PRINT 'RECONFIGURE WITH OVERRIDE;';
        END
    END;
    ELSE
    BEGIN
        -- Displaying current and recommended MAXDOP
        PRINT '--------------------------------------------------------------';
        PRINT 'MAXDOP at Instance level:';
        PRINT '--------------------------------------------------------------';
        PRINT 'MAXDOP configured value: ' + CHAR(9) + CAST(@MaxDop AS CHAR);
        PRINT 'MAXDOP recommended value: ' + CHAR(9) + CAST(@RecommendedMaxDop AS CHAR);
        PRINT '--------------------------------------------------------------';
        PRINT '';

        IF (@MaxDop <> @RecommendedMaxDop)
        BEGIN
            PRINT 'In case you want to change MAXDOP to the recommended value, please use this script:';
            PRINT '';
            PRINT 'EXEC sp_configure ''max degree of parallelism'', ' + CAST(@RecommendedMaxDop AS CHAR);
            PRINT 'GO';
            PRINT 'RECONFIGURE WITH OVERRIDE;';
        END
    END;
END;

SET NOEXEC OFF;
```

**Nota:** Este script debe ejecutarse en modo SQLCMD en SQL Server Management Studio (SSMS) para que las variables y comandos de SQLCMD funcionen correctamente.

---

## 4. Ajustar Valores de Parámetros de Configuración de la Instancia<a name=17.4""></a>

Este script ajusta diversos parámetros de configuración de la instancia de SQL Server, tales como la memoria mínima y máxima, MAXDOP, fill factor, compresión de backups, costo del umbral para paralelismo, y configuraciones de conexiones remotas.

**Autores:** Ricardo Ledesma, Charles Díaz Falette, Departamento de Soporte de Bases de Datos  
**Compilado:** 15 de Septiembre de 2016  
**Modificado por:** 1 de Octubre de 2020

### Scripts

#### Ajuste de Memoria Mínima y Máxima

Configura los valores mínimos y máximos de memoria para la instancia de SQL Server.

```sql
--------------------------------------------------------------------------------
-- Set Minimun and Maximun memory values [Depending of total RAM installed].
--------------------------------------------------------------------------------

-- Siempre dejar al menos un mínimo de 4GB disponibles para el S.O.
-- Todo servidor de bases de datos debe tener al menos 8GB RAM asignados.
-- Todo escenario está sujeto a análisis.

USE master
GO

-- Sets minimun memory value.
EXEC sys.sp_configure N'show advanced options', N'1'
GO
EXEC sys.sp_configure N'min server memory (MB)', N'2048'
GO
RECONFIGURE WITH OVERRIDE
GO

-- Sets maximun memory value.
EXEC sys.sp_configure N'show advanced options', N'1'
GO
EXEC sys.sp_configure N'max server memory (MB)', N'55705'
GO
RECONFIGURE WITH OVERRIDE
GO
```

#### Set Max Degree of Parallelism

Configura el valor de `MAXDOP`. Se recomienda ejecutar previamente el script de cálculo de MAXDOP para determinar el valor óptimo.

```sql
--------------------------------------------------------------------------------
-- Set Max Degree of Parallelism.
--------------------------------------------------------------------------------

-- Ejecutar antes el script "03 - Cálculo del MAXDOP.sql" para determinar el valor del MAX DOP.

USE master
GO

EXEC sys.sp_configure N'show advanced options', N'1'
GO
EXEC sys.sp_configure N'max degree of parallelism', N'6'
GO
RECONFIGURE WITH OVERRIDE
GO
```

#### Set Fill Factor

Establece el valor de `fill factor` al 75%.

```sql
--------------------------------------------------------------------------------
-- Set fill factor value in (75%).
--------------------------------------------------------------------------------

USE master
GO

EXEC sys.sp_configure N'show advanced options', N'1'
GO
EXEC sys.sp_configure N'fill factor (%)', N'75'
GO
RECONFIGURE WITH OVERRIDE
GO
```

#### Enable Backup Compression

Habilita la compresión de backups por defecto.

```sql
--------------------------------------------------------------------------------
-- Enable backup compression
--------------------------------------------------------------------------------

USE master
GO

EXEC sys.sp_configure N'show advanced options', N'1'
GO
EXEC sys.sp_configure N'backup compression default', N'1'
GO
RECONFIGURE WITH OVERRIDE
GO
```

#### Set Cost Threshold for Parallelism

Configura el umbral de costo para paralelismo a 50.

```sql
--------------------------------------------------------------------------------
-- Set Cost Threshold for Parallelism in 50
--------------------------------------------------------------------------------

USE master
GO

EXEC sys.sp_configure N'show advanced options', N'1'
GO
EXEC sys.sp_configure N'cost threshold for parallelism', N'50'
GO
RECONFIGURE WITH OVERRIDE
GO
```

#### Enable Remote DAC

Habilita las conexiones administrativas remotas (DAC).

```sql
--------------------------------------------------------------------------------
-- Enable Remote DAC
--------------------------------------------------------------------------------

USE master
GO

sp_configure 'remote admin connections', 1;
GO 
RECONFIGURE;
GO
```

#### Enable Allow Remote Connections

Permite las conexiones remotas al servidor SQL.

```sql
--------------------------------------------------------------------------------
-- Enable Allow Remote Connections
--------------------------------------------------------------------------------

USE master
GO

EXEC sys.sp_configure N'show advanced options', N'1'
GO
EXEC sys.sp_configure N'remote access', N'1'
GO
RECONFIGURE WITH OVERRIDE
GO
```

---

## 5. Actualizar Valor del Parámetro Server Name<a name="17.5"></a>

Este script actualiza el valor del parámetro `Server Name` en casos donde el servidor fue creado con un nombre inicial y necesita ser renombrado. Requiere reiniciar el servicio principal de SQL Server para aplicar los cambios.

**Autores:** Charles Díaz Falette, Departamento de Soporte de Bases de Datos  
**Modificado por:** 1 de Octubre de 2020

### Script

```sql
/*
    Tipo: Configuraciones post-instalación.
    Acción: Actualiza valor del parámetro Server Name.
    Escenario: Servidores para migraciones que han sido creados con un nombre y luego tendrán que ser renombrados.
    Bases de datos: No tiene efecto en bases de datos.
    Autores: Charles Díaz Falette, Depto. Soporte Bases De Datos.
    Modificado: 1/Octubre/2020
*/

-- Verifica el valor actual del parámetro Server Name en Serverproperty('Servername')
SELECT @@SERVERNAME

-- Remueve el actual nombre de servidor [Server Name].
-- Requiere reinicio del servicio principal de SQL Server para aplicar el cambio.
EXEC Sp_dropserver 'NAP01VDBSDPN'
GO

-- Agrega un nuevo valor para nombre de servidor [Server Name].
-- Requiere reinicio del servicio principal de SQL Server para aplicar el cambio.
EXEC Sp_addserver 'NAP01VDBSDP', 'local'
GO
```

**Instrucciones:**
1. Verifica el nombre actual del servidor ejecutando `SELECT @@SERVERNAME`.
2. Remueve el nombre actual del servidor con `Sp_dropserver`.
3. Agrega el nuevo nombre del servidor con `Sp_addserver`.
4. Reinicia el servicio de SQL Server para aplicar los cambios.
5. Verifica nuevamente el nombre del servidor después del reinicio.

---

## 6. Crear Bases de Datos Administrativas STOS_ADMIN y STOS_PTO<a name="17.6"></a>

Este script crea las bases de datos administrativas `STOS_ADMIN` y `STOS_PTO` con configuraciones específicas de crecimiento y almacenamiento. Cada base de datos incluye un archivo primario, un grupo de archivos para índices y un archivo de log.

**Autores:** Charles Díaz Falette, Departamento de Soporte de Bases De Datos  
**Compilado:**  
**Modificado por:** 19 de Agosto de 2022

### Script

```sql
/*
    Tipo: Configuraciones post-instalación.
    Acción: Crea base de datos administrativa STOS_ADMIN.
    Escenario: Todos los servidores.
    Bases de datos: STOS_ADMIN | STOS_PTO
    Autores: Charles Díaz Falette, Depto. Soporte Bases De Datos.
    Modificado: 19/Agosto/2022
*/

-- Crea base de datos [STOS_ADMIN con crecimiento a 1000MB y archivos de 5GB cada uno.

USE [master]
GO

CREATE DATABASE [STOS_ADMIN]
ON  PRIMARY
(
    NAME = N'STOS_ADMIN', 
    FILENAME = N'E:\MSSQL\Data\STOS_ADMIN.mdf', 
    SIZE = 5120000KB, 
    MAXSIZE = UNLIMITED, 
    FILEGROWTH = 1024000KB
),
FILEGROUP [INDEXES]
(
    NAME = N'STOS_ADMIN_Index', 
    FILENAME = N'I:\MSSQL\Index\STOS_ADMIN_Index.ndf', 
    SIZE = 5120000KB, 
    MAXSIZE = UNLIMITED, 
    FILEGROWTH = 1024000KB
)
LOG ON
(
    NAME = N'STOS_ADMIN_log', 
    FILENAME = N'L:\MSSQL\Log\STOS_ADMIN_log.ldf', 
    SIZE = 5120000KB, 
    MAXSIZE = 2048GB, 
    FILEGROWTH = 1024000KB
)
GO

ALTER DATABASE [STOS_ADMIN] SET RECOVERY FULL
GO

ALTER DATABASE [STOS_ADMIN] SET MULTI_USER
GO

ALTER DATABASE [STOS_ADMIN] SET PAGE_VERIFY CHECKSUM
GO

-- Crea base de datos [STOS_PTO con crecimiento a 1000MB y archivos de 5GB cada uno.

USE [master]
GO

CREATE DATABASE [STOS_PTO]
ON  PRIMARY
(
    NAME = N'STOS_PTO', 
    FILENAME = N'E:\MSSQL\Data\STOS_PTO.mdf', 
    SIZE = 5120000KB, 
    MAXSIZE = UNLIMITED, 
    FILEGROWTH = 1024000KB
),
FILEGROUP [INDEXES]
(
    NAME = N'STOS_PTO_Index', 
    FILENAME = N'I:\MSSQL\Index\STOS_PTO_Index.ndf', 
    SIZE = 5120000KB, 
    MAXSIZE = UNLIMITED, 
    FILEGROWTH = 1024000KB
)
LOG ON
(
    NAME = N'STOS_PTO_log', 
    FILENAME = N'L:\MSSQL\Log\STOS_PTO_log.ldf', 
    SIZE = 5120000KB, 
    MAXSIZE = 2048GB, 
    FILEGROWTH = 1024000KB
)
GO

ALTER DATABASE [STOS_PTO] SET RECOVERY FULL
GO

ALTER DATABASE [STOS_PTO] SET MULTI_USER
GO

ALTER DATABASE [STOS_PTO] SET PAGE_VERIFY CHECKSUM
GO
```

**Descripción de Componentes:**

- **PRIMARY:** Archivo principal de datos (`.mdf`).
- **FILEGROUP [INDEXES]:** Grupo de archivos para índices (`.ndf`).
- **LOG ON:** Archivo de log (`.ldf`).

**Configuraciones Comunes:**

- **Tamaño Inicial:** 5 GB (`5120000KB`).
- **Crecimiento:** 1 GB (`1024000KB`).
- **Máximo Tamaño:** Ilimitado para datos, 2 TB (`2048GB`) para logs.
- **Recuperación:** Full.
- **Modo de Usuario:** Multi-user.
- **Verificación de Página:** Checksum.

---

## 7. Licencia

Los scripts incluidos en este repositorio están licenciados bajo la licencia [MIT](https://opensource.org/licenses/MIT). Esto permite el uso, copia, modificación, fusión, publicación, distribución, sublicenciamiento y/o venta de copias del software, siempre que se incluya el aviso de copyright y la
permisión de licencia en todas las copias o partes sustanciales del software.

---

**Nota Final:** Antes de ejecutar cualquier script en un entorno de producción, se recomienda probarlos en un entorno de desarrollo o pruebas para asegurar que cumplen con los requisitos y no causan efectos adversos en las configuraciones existentes.

---

Aquí tienes el archivo `README.md` con la descripción adicional que especifica que este código se usa para crear usuarios en `GCS SII_OMGGA_GCS`, permitiendo duplicar un usuario como registro en la base de datos.








---




# 

# No existe nada debajo de esta linea



<!-- 

<div>
<p style = 'text-align:center;'>
<img src="https://gcs-international.com/wp-content/uploads/2017/05/GCS-International-Logo.png?auto=format&q=50?format=jpg&name=small" alt="JuveYell" width="750px">
</p>
</div> 

-->



# 