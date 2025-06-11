## 🕵️‍♂️ 15. Auditoría y Verificación de Ambientes

Esta sección incluye scripts y documentación para tareas de auditoría, control de ambientes y solución de problemas relacionados con la disponibilidad y permisos de bases de datos. Es útil para detectar inconsistencias, validar configuraciones y responder ante incidentes.

---

### 🧾 15.1 [Query de extracción de bases de datos y tablas en SQL Server](#600)

Script que permite obtener un inventario completo de bases de datos y sus tablas dentro de una instancia de SQL Server. Es útil para auditorías de estructura, generación de documentación técnica y control de cambios.

---

### 🛠️ 15.2 [Documentación para la solución de problemas de bases de datos ABT *fuera de línea / problemas de permisos*](#601)

Guía y consultas para diagnosticar bases de datos que aparecen como "fuera de línea" o presentan errores relacionados con permisos. Incluye recomendaciones de verificación de archivos `.mdf` y `.ldf`, así como revisión de usuarios y roles.

---

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

**Procedimiento para traer en línea las bases de datos ABT en servidores de oficina y sucursales**

**Fecha Creacion    :** 14 de octubre de 2024
**Fecha Modificacion:** 14 de Febrero de 2025

---

### **Introducción**
Este documento detalla el procedimiento a seguir para traer en línea las bases de datos asociadas con los servidores de oficina y sucursales (CNP y SUC) de la institución, conocidos como ABT, después de que el personal de seguridad asigne los permisos de control total (*Full Control*) para los discos correspondientes.

### **Contexto**
En los servidores ABT, tanto en oficinas como en sucursales, se ha identificado la necesidad de traer en línea las bases de datos luego de que se realicen ciertos cambios de permisos a nivel de los discos donde estas residen. Este procedimiento es común cuando se presentan problemas de acceso a las bases de datos debido a cambios en la configuración de permisos.

### **Procedimiento**

#### **1. Asignación de Permisos**
- El personal de seguridad deberá asignar permisos de control total (*Full Control*) sobre los discos que contienen las bases de datos mencionadas.
- Los discos a los que se deben asignar los permisos son: **"B", "E", "T", "L", "U"**.
- La cuenta a la que se le deben otorgar permisos es la cuenta con la cual se ejecuta el servicio de SQL Server. Esta cuenta debe tener acceso completo a los discos correspondientes para que el motor de bases de datos pueda operar correctamente.

#### **2. Ejecución del Script SQL**
Una vez asignados los permisos, el personal encargado de las bases de datos deberá ejecutar el siguiente script para traer en línea las bases de datos que se encontraban offline:

```sql
ALTER DATABASE [ABT41] SET ONLINE;
ALTER DATABASE [ABT41ROM] SET ONLINE;
ALTER DATABASE [ABT41SIG] SET ONLINE;
```

#### **3. Verificación**
Después de ejecutar el script, se debe verificar que las bases de datos estén en línea y operativas. Esto se puede hacer revisando el estado de las bases de datos desde el SQL Server Management Studio (SSMS) o utilizando la siguiente consulta:

```sql
SELECT name, state_desc 
FROM sys.databases 
WHERE name IN ('ABT41', 'ABT41ROM', 'ABT41SIG');
```

### **Consideraciones Finales**
- Este procedimiento debe ser realizado por personal autorizado y capacitado para manejar tanto los permisos de seguridad a nivel de discos como la administración de bases de datos en SQL Server.
- Es importante documentar cualquier incidente relacionado con las bases de datos ABT para mejorar futuros procesos de resolución.

---

### **Notificación de Acciones Realizadas**

Espero que este correo les encuentre bien. El motivo del mismo es informarles que, para la solución del problema con el servidor **CNP38400**, se procedió, de parte del equipo de infraestructura, a otorgar permisos *Full Control* a la cuenta **FSRV\_SSDS-CNP38400** en los discos **"B", "E", "T", "L", "U"**.

Esta acción ha sido realizada para asegurar el acceso necesario de parte del SQL Server para realizar las operaciones requeridas para su correcto funcionamiento.

Posteriormente, se procedió a colocar las bases de datos **ABT41, ABT41ROM y ABT41SIG** en modo *Online*.

Quedo a su disposición para cualquier consulta adicional.

---

### **Conclusión**
El procedimiento descrito en este documento permite restaurar el acceso a las bases de datos en los servidores ABT después de la asignación de permisos correspondientes. Esto asegura que el personal pueda resolver problemas similares en el futuro de manera eficiente y efectiva.

Este procedimiento debe ser revisado y actualizado según sea necesario para reflejar cambios en la infraestructura o procedimientos relacionados con la administración de bases de datos en la institución.





--- 


