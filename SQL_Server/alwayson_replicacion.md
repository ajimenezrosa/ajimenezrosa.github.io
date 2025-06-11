## 🔁 13. AlwaysOn y Replicación

Esta sección agrupa consultas y procedimientos relacionados con la alta disponibilidad en SQL Server a través de AlwaysOn Availability Groups y la funcionalidad de replicación. Permite monitorear el estado de los nodos, configurar aspectos del sistema, y verificar la instalación de características críticas.

---

### 🧭 13.1 [Determinar si un nodo es primario o secundario en un AlwaysOn](#queestestenodoAO)

Consulta que permite identificar si el nodo actual es el principal (Primary) o un secundario (Secondary) dentro de un grupo de disponibilidad AlwaysOn.

---

### ⚠️ 13.2 [Verificar si un servidor SQL Server AlwaysOn hizo failover](#failover)

Verifica si ha ocurrido un evento de failover automático o manual en el grupo de disponibilidad.

#### 🔎 13.2.1 [Información detallada sobre failover de servidores](#failover2)

Script más específico que extrae la fecha, motivo y nodo afectado en eventos de failover recientes.

---

### 🈷️ 13.3 [Cambiar el *collation* de todas las bases de datos en un servidor SQL Server](#collectionchange)

Instrucción y procedimiento para modificar la configuración regional (*collation*) de todas las bases de datos activas en una instancia de SQL Server, útil en procesos de estandarización o migración.

---

### 🔄 13.4 [Verificar si SQL Server Replication está instalado en SQL Server 2019](#saberreplicationserver)

Consulta para validar si el componente de replicación está instalado y habilitado en la instancia de SQL Server 2019.

---

### 🧱 13.5 [ALTER DATABASE ... SET HADR RESUME](#135)

Comando utilizado para reanudar manualmente una base de datos suspendida en un grupo de disponibilidad AlwaysOn, especialmente después de interrupciones de red o mantenimiento.

---
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



