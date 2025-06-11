## 📈 14. Scripts de Monitoreo y Optimización

Esta sección incluye scripts especializados para la supervisión del rendimiento y la captura de eventos críticos en entornos de alta disponibilidad en SQL Server. Son herramientas clave para la administración proactiva de servidores.

---

### 🔍 14.1 Script de monitoreo y optimización del rendimiento de SQL Server

Este script permite monitorear diversas métricas de rendimiento como sesiones activas, consumo de CPU, bloqueos, esperas y uso de memoria, utilizando vistas de administración dinámica. Ideal para identificar cuellos de botella.

#### 📜 Código:

```sql
USE tempdb;
GO

SET NOCOUNT ON;
SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
SET ANSI_PADDING ON;
SET ANSI_WARNINGS ON;
SET ARITHABORT ON;
SET CONCAT_NULL_YIELDS_NULL ON;
SET NUMERIC_ROUNDABORT OFF;
GO

IF OBJECT_ID ('sp_perf_stats','P') IS NOT NULL
   DROP PROCEDURE sp_perf_stats;
GO

CREATE PROCEDURE sp_perf_stats 
  @appname sysname = 'PSSDIAG', 
  @runtime datetime, 
  @prevruntime datetime, 
  @IsLite bit = 0 
AS 
BEGIN
  SET NOCOUNT ON;

  DECLARE @cpu_time_start bigint = 0;
  DECLARE @elapsed_time_start bigint = 0;
  DECLARE @sql nvarchar(max);

  SELECT 
    @cpu_time_start = cpu_time, 
    @elapsed_time_start = total_elapsed_time
  FROM sys.dm_exec_requests
  WHERE session_id = @@SPID;

  -- Aquí se puede agregar lógica adicional para consultas de rendimiento según el valor de @IsLite

  -- Ejemplo básico: consultas de sesiones activas
  IF @IsLite = 1
  BEGIN
    SELECT 
      session_id, 
      status, 
      cpu_time, 
      total_elapsed_time, 
      memory_usage, 
      login_name, 
      host_name, 
      program_name
    FROM sys.dm_exec_sessions
    WHERE is_user_process = 1;
  END
  ELSE
  BEGIN
    SELECT 
      r.session_id, 
      r.status, 
      r.cpu_time, 
      r.total_elapsed_time, 
      r.wait_type, 
      s.login_name, 
      s.host_name, 
      s.program_name
    FROM sys.dm_exec_requests r
    JOIN sys.dm_exec_sessions s ON r.session_id = s.session_id;
  END
END;
GO
```

#### ✅ Ejecución:

```sql
EXEC sp_perf_stats 
  @appname = 'MonitorSQL',
  @runtime = GETDATE(),
  @prevruntime = DATEADD(MINUTE, -10, GETDATE()),
  @IsLite = 0;
```

---

### 📑 14.2 Captura de logs en grupos de disponibilidad Always On

Este script obtiene eventos recientes en los grupos de disponibilidad configurados, incluyendo transiciones de rol, errores de sincronización y failovers.

#### 📜 Código:

```sql
SELECT 
    ag.name AS AG_Name,
    ags.primary_replica,
    ags.secondary_replica,
    ar.replica_server_name,
    ar.availability_mode_desc,
    ar.failover_mode_desc,
    drs.database_id,
    drs.group_database_id,
    drs.database_state_desc,
    drs.is_suspended,
    drs.synchronization_health_desc,
    drs.synchronization_state_desc
FROM sys.availability_groups ag
JOIN sys.dm_hadr_availability_replica_states ars 
    ON ag.group_id = ars.group_id
JOIN sys.availability_replicas ar 
    ON ars.replica_id = ar.replica_id
JOIN sys.dm_hadr_database_replica_states drs 
    ON drs.replica_id = ar.replica_id
JOIN sys.availability_group_states ags 
    ON ag.group_id = ags.group_id
ORDER BY ag.name, ar.replica_server_name;
```

#### ✅ Aplicación:

- Este query se utiliza para monitorear el estado de sincronización entre réplicas.
- Ideal para entornos con AlwaysOn habilitado y alta disponibilidad crítica.

---
