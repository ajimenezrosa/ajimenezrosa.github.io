## ⏱️ 12. Administración de Jobs

Esta sección está dedicada a la administración de SQL Server Agent Jobs. Incluye consultas para listar, analizar, migrar y eliminar jobs, además de revisar el uso de recursos del sistema relacionados con su ejecución.

---

### 📋 12.1 [Listar jobs de SQL Server](#listajob28)

Consulta básica para listar todos los jobs configurados en la instancia de SQL Server, incluyendo su estado y última ejecución.

---

### 📅 12.2 [Jobs con sus días de ejecución por steps](#listajob282)

Reporte detallado que muestra los jobs junto a la información de sus pasos y días de ejecución.

#### 🧩 12.2.1 [Jobs del sistema SQL Server, con nombre y base de datos](#28.2.1)

Lista los jobs creados por el sistema junto al nombre asociado y la base de datos a la que pertenecen.

#### 📦 12.2.2 [Jobs del sistema SQL Server para control M](#28.2.2)

Consulta especializada para identificar los jobs gestionados por Control-M en entornos integrados.

---

### 🟢 12.3 [Jobs ejecutándose en un servidor SQL Server](#jobactivos2)

Consulta para monitorear los jobs que están activos actualmente en ejecución.

---

### ⚙️ 12.4 [Configurar `max worker threads`](#autogrowmaxime)

Revisión y ajuste de la configuración de hilos máximos de trabajo para optimizar la concurrencia de ejecución de jobs.

---

### 💾 12.5 [Query para saber el `max memory` de un servidor SQL](#querymamemory)

Script que devuelve la configuración de memoria máxima (`max server memory`) del servidor.

---

### 🔧 12.6 [Shrink DB](#shrinkfilebpd)

Instrucción para reducir el tamaño de archivos de base de datos, especialmente después de una limpieza o migración de datos.

---

### 📊 12.7 [Ver espacio libre en archivos MDF y LDF](#espaciodbLibres)

Consulta para visualizar el espacio libre disponible en los archivos principales de datos y logs de transacciones.

---

### 💽 12.8 [Espacio en discos que ocupan mis tablas](#espacidiscobpd)

Consulta que evalúa cuánto espacio está ocupando cada tabla en el sistema, útil para gestión de almacenamiento.

---

### 🔁 12.9 [Migrar jobs de un servidor SQL Server a otro](#migrarjobs)

Script que permite exportar los jobs desde un servidor origen y reimportarlos en un destino, ideal para entornos de migración o staging.

---

### 👤 12.10 [Cambiar Owner de Múltiples Jobs en SQL Server](#13.00)

Instrucción para modificar el propietario de múltiples jobs simultáneamente, por ejemplo, al deshabilitar una cuenta de servicio.

---

## 🧹 12.11 Solución de Problemas con Jobs en SQL Server que No Se Dejan Eliminar

Esta sub-sección reúne soluciones específicas a problemas comunes con jobs atascados o que generan errores al intentar ser eliminados.

#### 🧷 12.11.1 [Consulta de subplanes asociados a un Job](#14.1)

Permite identificar los subplanes de mantenimiento (subplans) que están vinculados a un job en particular.

#### ❌ 12.11.2 [Eliminación de subplanes asociados a un Job](#14.2)

Pasos para eliminar correctamente los subplanes relacionados antes de intentar eliminar el job.

#### 🧼 12.11.3 [Comando para eliminar un job específico](#14.3)

Script T-SQL directo para eliminar un job específico, útil cuando no puede eliminarse desde la GUI.

#### 🧾 12.11.4 [Eliminación de registros en el log de mantenimiento](#14.4)

Consulta para limpiar entradas obsoletas del historial de mantenimiento, que pueden impedir operaciones sobre jobs.

#### 🕵️ 12.11.5 [Verificación de logs de mantenimiento](#14.5)

Visualiza los logs de mantenimiento asociados a un job para análisis de errores o bloqueos.

#### 📆 12.11.6 [Query para Listar Jobs en Ejecución en SQL Server con Fecha de Inicio](#14.6)

Script que muestra los jobs en ejecución junto a su hora de inicio, para auditoría en tiempo real.

#### 📌 12.11.7 [Script para Listar los Jobs en Ejecución en SQL Server](#14.7)

Versión simplificada del script anterior, útil para monitoreo rápido desde consola o panel de administración.

---

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


# 

# Query para saber la max/memory que esta apliaca a un servidor Sql Server<a name="querymamemory"></a>
![Max Memory Best Practices](https://soundtrax.typepad.com/.a/6a00d834539b6d69e201a73e0cc9d8970d-pi)
#### La siguiente consulta devuelve información sobre los valores actualmente configurados y el valor actualmente en uso. Esta consulta devolverá resultados independientemente de si la opción "mostrar opciones avanzadas" de sp_configure está habilitada.


~~~sql
SELECT [name], [value], [value_in_use]
FROM sys.configurations
WHERE [name] = 'max server memory (MB)' OR [name] = 'min server memory (MB)';
~~~



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

# 

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
- Estos pasos deben seguirse con precaución y solo deben aplicarse si se enfrenta a problemas de conectividad con servidores de .
- Realice una copia de seguridad del archivo `java.security` antes de realizar cualquier modificación para evitar pérdida de datos o configuraciones incorrectas.
- Asegúrese de comprender las implicaciones de seguridad al habilitar protocolos previamente deshabilitados.

## **Conclusion:**
#### Siguiendo estos pasos, podrá habilitar conexiones a a los servidores de Internet BANKING en los agentes Foglight, mejorando la conectividad y asegurando una comunicación fluida con recursos en línea. Recuerde que estos cambios deben aplicarse con precaución y se recomienda mantener un registro de las modificaciones realizadas para futuras referencias. Ademas los mismos solo afectanran los servidores de INTERNET BANKING  en caso de los mismo no tener comunicacion.

# 

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

### **Query para Listar Jobs en Ejecución en SQL Server con Fecha de Inicio**<a name="14.6"></a>

#### **Descripción**
Este script permite listar los jobs que están actualmente en ejecución en SQL Server Agent. Muestra información clave como el nombre del job, el paso que está ejecutándose, y la fecha de inicio del job. Es una herramienta útil para el monitoreo y diagnóstico en tiempo real de la actividad del SQL Server Agent.

---

#### **Código**

```sql
-- List running jobs in SQL Server with Job Start Time

-- This script lists all SQL Agent jobs that are currently running.

SELECT ja.job_id,
       j.name AS job_name,
       ja.start_execution_date,
       ISNULL(ja.last_executed_step_id, 0) + 1 AS current_executed_step_id,
       js.step_name
FROM msdb.dbo.sysjobactivity ja
    LEFT JOIN msdb.dbo.sysjobhistory jh
        ON ja.job_history_id = jh.instance_id
    JOIN msdb.dbo.sysjobs j
        ON ja.job_id = j.job_id
    JOIN msdb.dbo.sysjobsteps js
        ON ja.job_id = js.job_id
           AND ISNULL(ja.last_executed_step_id, 0) + 1 = js.step_id
WHERE ja.session_id =
(
    SELECT TOP (1)
           session_id
    FROM msdb.dbo.syssessions
    ORDER BY agent_start_date DESC
)
      AND ja.start_execution_date IS NOT NULL
      AND ja.stop_execution_date IS NULL;
```

---

#### **Columnas del Resultado**

1. **`job_id`**: Identificador único del job en SQL Server.
2. **`job_name`**: Nombre del job configurado en SQL Server Agent.
3. **`start_execution_date`**: Fecha y hora en que el job comenzó a ejecutarse.
4. **`current_executed_step_id`**: Identificador del paso del job que actualmente está en ejecución.
5. **`step_name`**: Nombre del paso del job que está ejecutándose.

---

#### **Uso Práctico**
- **Monitoreo en tiempo real**: Ver qué jobs están ejecutándose actualmente.
- **Diagnóstico de problemas**: Identificar jobs que están tardando más de lo esperado.
- **Auditoría y control**: Validar que los jobs programados están funcionando correctamente.

---

#### **Nota**
Para ejecutar este query, asegúrese de usar la base de datos `msdb` y contar con permisos de administrador o acceso a las tablas de sistema del SQL Server Agent. Es una consulta de solo lectura, diseñada para propósitos de monitoreo y diagnóstico.

# 

# Script para Listar los Jobs en Ejecución en SQL Server<a name="14.7"></a>

Este script está diseñado para listar los trabajos (jobs) del SQL Server Agent que se encuentran en ejecución, junto con detalles importantes como el nombre del trabajo, la fecha de inicio de la ejecución, el paso actual que se está ejecutando y el nombre de dicho paso.

---

## **Propósito del Script**

El propósito principal de este script es ayudar a los administradores de bases de datos (DBA) a identificar rápidamente los trabajos que se encuentran en ejecución en un momento dado. Esto es especialmente útil en escenarios de monitoreo y solución de problemas, tales como:

1. Verificar si algún job está en ejecución antes de realizar tareas de mantenimiento en el servidor.
2. Diagnosticar problemas relacionados con la duración de trabajos en ejecución.
3. Supervisar el progreso de trabajos largos o críticos.

---

## **Descripción del Código**

- **Consulta Principal:**
    - El script consulta las tablas del sistema de SQL Server en la base de datos `msdb`.
    - Utiliza las tablas `sysjobactivity`, `sysjobhistory`, `sysjobs`, y `sysjobsteps` para obtener información detallada sobre los trabajos.
- **Claves del Script:**
    - Filtra los trabajos que están en ejecución (`start_execution_date IS NOT NULL` y `stop_execution_date IS NULL`).
    - Obtiene el último `session_id` del SQL Server Agent para garantizar que está consultando la sesión actual.
    - Devuelve el ID y el nombre del trabajo, la fecha de inicio de la ejecución, el paso actual en ejecución y su nombre.

---

## **Código**

```sql
-- List running jobs in SQL Server with Job Start Time
-- This script lists all SQL Agent jobs that are currently running.

SELECT ja.job_id,
       j.name AS job_name,
       ja.start_execution_date,
       ISNULL(ja.last_executed_step_id, 0) + 1 AS current_executed_step_id,
       js.step_name
FROM msdb.dbo.sysjobactivity ja
    LEFT JOIN msdb.dbo.sysjobhistory jh
        ON ja.job_history_id = jh.instance_id
    JOIN msdb.dbo.sysjobs j
        ON ja.job_id = j.job_id
    JOIN msdb.dbo.sysjobsteps js
        ON ja.job_id = js.job_id
           AND ISNULL(ja.last_executed_step_id, 0) + 1 = js.step_id
WHERE ja.session_id =
(
    SELECT TOP (1)
           session_id
    FROM msdb.dbo.syssessions
    ORDER BY agent_start_date DESC
)
      AND ja.start_execution_date IS NOT NULL
      AND ja.stop_execution_date IS NULL;
```

---

## **Cómo Utilizar este Script**

1. **Abrir SQL Server Management Studio (SSMS):**
   - Conéctese al servidor donde desea ejecutar el script.
2. **Seleccionar la Base de Datos:**
   - Asegúrese de estar conectado a la base de datos `msdb`.
3. **Ejecutar el Script:**
   - Pegue el script en una nueva ventana de consulta y ejecútelo.
4. **Interpretar los Resultados:**
   - El resultado mostrará todos los trabajos que están en ejecución en ese momento, con los detalles mencionados.

---

## **Nota Importante**

- Este script solo es válido si el SQL Server Agent está habilitado y en ejecución.
- Para poder ejecutarlo, el usuario debe tener permisos para acceder a la base de datos `msdb` y consultar las tablas del sistema mencionadas.

---

## **Casos de Uso**

- **Monitoreo:** Determinar qué trabajos están en ejecución durante un periodo de alta actividad.
- **Auditoría:** Verificar qué pasos de los trabajos están tardando más de lo esperado.
- **Soporte:** Identificar rápidamente si un job crítico sigue en progreso.


================
# 
