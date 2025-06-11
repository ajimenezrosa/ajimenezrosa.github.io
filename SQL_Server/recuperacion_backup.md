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



~~~Sql
/*
Joser Alejandro Jimenez Rosa 
Modificado para que me meustre el tiempo que tardo la db en restaurarse
Query que muestra las restauraciones de las bases de datos de un servidor
sql server 
fecha: 2016-07-22
*/
SELECT 
    rs.destination_database_name, 
    rs.restore_date, 
    bs.backup_start_date, 
    bs.backup_finish_date, 
    bs.database_name AS source_database_name, 
    bmf.physical_device_name AS backup_file_used_for_restore,
    DATEDIFF(MINUTE, bs.backup_finish_date, rs.restore_date)/60 AS restore_duration_minutes
FROM 
    msdb..restorehistory rs
INNER JOIN 
    msdb..backupset bs ON rs.backup_set_id = bs.backup_set_id
INNER JOIN 
    msdb..backupmediafamily bmf ON bs.media_set_id = bmf.media_set_id 
ORDER BY 
    rs.restore_date DESC;
~~~
 
~~~sql
/*
Joser Alejandro Jimenez Rosa 
Query que muestra las restauraciones de las bases de datos de un servidor
sql server 
fecha: 2016-07-22
*/

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
#### Ultima Modificacion: ***Jose Alejandro Jimenez Rosa*** 
#### ***Fecha: 2025-02-01***
<img src="https://soportesql.files.wordpress.com/2014/04/fa932-log.png?format=jpg&name=large" alt="JuveR" width="800px">

Este documento detalla los procedimientos para limpiar y reducir el log de transacciones en SQL Server tanto en entornos **Stand-Alone** como en **Grupos de Disponibilidad (AlwaysOn Availability Groups)**.

## 1. Reducción del Log de Transacciones en un Entorno Stand-Alone

### **Pasos:**
1. **Realizar un backup del log de transacciones** (obligatorio antes de la reducción):

   ```sql
   BACKUP LOG [NombreBaseDatos] TO DISK = 'C:\Backup\NombreBaseDatosLog.bak';
   ```

2. **Obtener el nombre lógico de los archivos de log**:

   ```sql
   sp_helpdb [NombreBaseDatos];
   ```

3. **Cambiar el modelo de recuperación a SIMPLE**:

   ```sql
   ALTER DATABASE [NombreBaseDatos] SET RECOVERY SIMPLE;
   GO
   ```

4. **Reducir el log de transacciones a 1 MB**:

   ```sql
   DBCC SHRINKFILE (NombreBaseDatos_Log, 1);
   GO
   ```

5. **Restaurar el modelo de recuperación a COMPLETO**:

   ```sql
   ALTER DATABASE [NombreBaseDatos] SET RECOVERY FULL;
   GO
   ```

## 2. Reducción del Log de Transacciones en un Entorno AlwaysOn Availability Groups

En un entorno de alta disponibilidad con Grupos de Disponibilidad, **no es posible cambiar el modelo de recuperación a SIMPLE**. Para reducir el tamaño del log de transacciones sin comprometer la alta disponibilidad, sigue los siguientes pasos:

### **Pasos:**
1. **Realizar un backup del log de transacciones**:

   ```sql
   BACKUP LOG [NombreBaseDatos] TO DISK = 'C:\Backup\NombreBaseDatosLog.bak';
   ```

2. **Reducir el tamaño del log de transacciones**:

   ```sql
   DBCC SHRINKFILE (NombreBaseDatos_Log, 1);
   ```

## 3. Monitoreo y Mantenimiento del Tamaño del Log
Para evitar el crecimiento excesivo del log de transacciones, es recomendable:

- **Realizar backups frecuentes** del log de transacciones.
- **Configurar alertas** para monitorear el tamaño del log y tomar acciones preventivas.
- **Monitorear el rendimiento del servidor** y ajustar la configuración según sea necesario.

## 4. Notas Adicionales

- Es importante realizar **backups completos** de la base de datos regularmente para asegurar la integridad de los datos.
- En entornos AlwaysOn, el backup del log debe realizarse desde la réplica primaria.

Este documento proporciona un procedimiento detallado y preciso para gestionar el tamaño del log de transacciones en diferentes entornos de SQL Server.

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
#### Propósito: Restaura la base de datos convertidor desde un archivo de respaldo.
#### Ubicación del respaldo: U:\MSSQL\BACKUP\convertidor.BAK
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

-- Restaurar base de datos 'onvertidor':
RESTORE DATABASE [convertidor] 
FROM  DISK = N'U:\MSSQL\BACKUP\convertidor.BAK' 
WITH  FILE = 1,  
MOVE N'convertidor' TO N'E:\MSSQL\Data\convertidor.mdf',  
MOVE N'convertidor_Log' TO N'L:\MSSQL\Log\convertidor_log.ldf',  
MOVE N'convertidor_Index' TO N'I:\MSSQL\Index\convertidor_index.ndf',  
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


 ## Como puedo saber que puerto utilizan mis consultas<a name="puetos"></a>
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