## 🧭 Documentación relacionada con la herramienta Foglight

Esta sección incluye procedimientos técnicos específicos para la administración de la herramienta de monitoreo **Foglight**, enfocándose en la configuración de conectividad externa y renovación de certificados del servidor de gestión.

---

### 🌐 [Configuración para Habilitar Conexiones a Servidores de Internet en Agentes Foglight](#foglight1)

Guía para configurar los agentes de Foglight de modo que puedan establecer conexiones con servidores externos a través de Internet. Este procedimiento es útil cuando se requieren integraciones con servicios en la nube o repositorios remotos.

---

### 🔐 [Renovación del Certificado Autofirmado en el Servidor de Gestión de Foglight](#foglight2)

Procedimiento paso a paso para renovar o reemplazar el certificado autofirmado que utiliza el servidor de gestión de Foglight para conexiones seguras HTTPS. Es esencial para mantener la confianza del navegador y evitar advertencias de seguridad.

---

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

# Renovación del Certificado Autofirmado en el Servidor de Gestión de Foglight<a name="foglight2"></a>

## Pasos para Renovar el Certificado Autofirmado

### 1. Conectarse al Servidor de Gestión de Foglight
Asegúrese de tener privilegios de administrador antes de continuar.

### 2. Navegar al Directorio de Instalación de Foglight
Reemplace `$FOGLIGHT_HOME` con la ruta de instalación actual de Foglight:
```sh
cd $FOGLIGHT_HOME  # Ejemplo: cd D:\Quest\Foglight
```

### 3. Eliminar el Alias del Certificado Expirado
Ejecute el siguiente comando para eliminar el alias `tomcat` expirado:
```sh
jre\bin\keytool -keystore config\tomcat.keystore -storepass nitrogen -delete -alias tomcat
```

### 4. Generar un Nuevo Certificado Autofirmado
Ejecute el siguiente comando para crear un nuevo alias `tomcat` con una nueva clave:
```sh
jre\bin\keytool -keystore config\tomcat.keystore -storepass nitrogen -genkeypair -alias tomcat -validity 3650 -keyalg RSA -keysize 2048 -dname "CN=quest.com, OU=FVE Support, O=Quest, L=Toronto, ST=Ontario, C=CA"
```
> Presione **Enter** dos veces para aceptar los valores predeterminados cuando se le solicite.

### 5. Repetir el Proceso para Cada FMS
Si tiene múltiples servidores de gestión de Foglight, repita los pasos anteriores para cada uno.

### 6. Reiniciar el Servidor de Gestión de Foglight (FMS)
Reinicie los servidores en el siguiente orden:
```sh
# Detener primero el servidor en espera
stop standby

# Detener el servidor principal
stop primary

# Iniciar primero el servidor principal
start primary

# Iniciar el servidor en espera
start standby
```

### 7. Validar la Conexión
Asegúrese de que **FglAM** (Foglight Agent Manager) pueda conectarse correctamente y que todos los agentes reanuden la monitorización.

---
Este proceso garantiza que su Servidor de Gestión de Foglight tenga un certificado autofirmado renovado, evitando problemas de autenticación relacionados con certificados expirados.




# 

<!-- 


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

