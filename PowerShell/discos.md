# Auditoría de Bases de Datos SQL Server con PowerShell

Este proyecto contiene un script en PowerShell que permite auditar múltiples servidores SQL Server extrayendo el nombre y tamaño de todas las bases de datos, tanto en megabytes (MB) como en gigabytes (GB). La información se almacena en una base de datos central para fines de monitoreo y auditoría.

---

## 📌 Funcionalidades
# Auditoría de Tamaño de Bases de Datos en Múltiples Servidores SQL Server

**Autor**: Alejandro Jiménez Rosa  
**Fecha**: Mayo 2025

Este script en PowerShell permite conectarse a una lista de servidores SQL Server, consultar el tamaño de cada base de datos en MB y GB, y registrar esta información en una base de datos central para auditoría y monitoreo.

---

## 📂 Requisitos

- Tener PowerShell con el módulo `SqlServer` instalado.
- Permisos para conectarse a los servidores SQL definidos.
- Archivo `servidores.txt` con una lista de instancias SQL (una por línea).
- Base de datos central donde se almacenarán los resultados.

---

## 🗂 Estructura esperada del archivo `servidores.txt`

```text
SQLSERVER1
SQLSERVER2\INSTANCIA
192.168.1.100\SQL2022
```

---

## 🧱 Script para crear la tabla en la base de datos central

Asegúrate de ejecutar este script en la base de datos central (`SqlMonitors`) para crear la tabla donde se almacenarán los resultados.

```sql
CREATE TABLE dbo.AuditoriaBasesDeDatos (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    FechaRegistro DATETIME DEFAULT GETDATE(),
    Servidor NVARCHAR(255),
    BaseDeDatos NVARCHAR(255),
    TamanoMB DECIMAL(18, 2),
    TamanoGB DECIMAL(18, 2)
);
```

---

## 💻 Script PowerShell: Auditoría de tamaños

```powershell
# =====================================
# CONFIGURACIÓN
# =====================================

# Ruta del archivo con la lista de servidores
$rutaArchivoServidores = "E:\Powershell\servidores.txt"

# Servidor y base de datos central donde se guardarán los resultados
$servidorCentral = "SPYHUNTER\MSSQLSERVER2022"
$baseCentral = "SqlMonitors"
$tablaCentral = "AuditoriaBasesDeDatos"

# =====================================
# CARGAR SERVIDORES DESDE ARCHIVO
# =====================================

if (-Not (Test-Path $rutaArchivoServidores)) {
    Write-Error "No se encontró el archivo de servidores: $rutaArchivoServidores"
    exit
}

$servidores = Get-Content -Path $rutaArchivoServidores | Where-Object { $_.Trim() -ne "" }

# =====================================
# FUNCIÓN PARA INSERTAR DATOS EN BD CENTRAL
# =====================================

function Insertar-EnTabla {
    param (
        [string]$servidorDestino,
        [string]$baseDestino,
        [string]$tablaDestino,
        [string]$servidorOrigen,
        [string]$nombreBD,
        [decimal]$tamanoMB,
        [decimal]$tamanoGB
    )

    $conexion = New-Object System.Data.SqlClient.SqlConnection
    $conexion.ConnectionString = "Server=$servidorDestino;Database=$baseDestino;Integrated Security=True;"
    $conexion.Open()

    $cmd = $conexion.CreateCommand()
    $cmd.CommandText = @"
    INSERT INTO $tablaDestino (Servidor, BaseDeDatos, TamanoMB, TamanoGB)
    VALUES (@Servidor, @BaseDeDatos, @TamanoMB, @TamanoGB)
"@

    $cmd.Parameters.Add("@Servidor", [System.Data.SqlDbType]::NVarChar, 255).Value = $servidorOrigen
    $cmd.Parameters.Add("@BaseDeDatos", [System.Data.SqlDbType]::NVarChar, 255).Value = $nombreBD
    $cmd.Parameters.Add("@TamanoMB", [System.Data.SqlDbType]::Decimal).Value = $tamanoMB
    $cmd.Parameters.Add("@TamanoGB", [System.Data.SqlDbType]::Decimal).Value = $tamanoGB

    $cmd.ExecuteNonQuery()
    $conexion.Close()
}

# =====================================
# PROCESAR CADA SERVIDOR
# =====================================

foreach ($servidor in $servidores) {
    try {
        Write-Host "`nConectando a $servidor..." -ForegroundColor Cyan

        $query = @"
        SELECT 
            DB_NAME(database_id) AS BaseDeDatos,
            SUM(size) * 8 / 1024.0 AS TamanoMB
        FROM 
            sys.master_files
        WHERE 
            type_desc = 'ROWS'
        GROUP BY 
            database_id
"@

        $datos = Invoke-Sqlcmd -ServerInstance $servidor -Query $query -ErrorAction Stop

        foreach ($fila in $datos) {
            $tamanoMB = [math]::Round($fila.TamanoMB, 2)
            $tamanoGB = [math]::Round($tamanoMB / 1024, 2)

            Insertar-EnTabla -servidorDestino $servidorCentral `
                             -baseDestino $baseCentral `
                             -tablaDestino $tablaCentral `
                             -servidorOrigen $servidor `
                             -nombreBD $fila.BaseDeDatos `
                             -tamanoMB $tamanoMB `
                             -tamanoGB $tamanoGB
        }

        Write-Host "Datos insertados para $servidor." -ForegroundColor Green
    } catch {
        Write-Warning "Error al procesar ${servidor}: $_"
    }
}
```

---

## ✅ Resultados

Cada ejecución del script insertará un conjunto de registros en la tabla `AuditoriaBasesDeDatos`, permitiendo llevar un historial de crecimiento y uso de espacio por base de datos en cada servidor monitoreado.

---

## 📝 Notas adicionales

- Puedes automatizar este script en un **Job de Windows Task Scheduler** o un **Job de SQL Server Agent**.
- Asegúrate de que el equipo desde donde se ejecuta el script tenga acceso de red y permisos a cada instancia SQL Server.
- Si se desea agregar campos como `Fecha`, `Instancia`, `Usuario`, se puede modificar la función `Insertar-EnTabla` fácilmente.

---

```bash
# Comando para instalar módulo si no lo tienes:
Install-Module -Name SqlServer -Scope CurrentUser -Force
```

---

- Lee una lista de servidores desde un archivo `servidores.txt`.
- Se conecta a cada instancia SQL usando `Invoke-Sqlcmd`.
- Extrae el nombre de cada base de datos y su tamaño.
- Calcula el tamaño en MB y GB.
- Inserta los datos en una tabla de auditoría en una base de datos central.
- Muestra mensajes y advertencias si algún servidor no está accesible.

---

## 🧰 Requisitos

- PowerShell 5.1 o superior
- Módulo `SqlServer` instalado:

```powershell
Install-Module -Name SqlServer -Scope CurrentUser -Force
