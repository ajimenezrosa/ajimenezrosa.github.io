# Estado de Availability Groups y Servidores StandAlone - PowerShell

Este script en PowerShell permite consultar múltiples instancias de SQL Server listadas en un archivo, identificar si son instancias **StandAlone** o pertenecen a un **Availability Group (AG)**, y registrar esta información en una tabla central de auditoría para monitoreo y gestión.

## 📌 Autor

**Alejandro Jiménez Rosa**

## 🧾 Requisitos

- PowerShell 5.1+
- Módulo `SqlServer` (para `Invoke-Sqlcmd`)
- Permisos para conectarse a las instancias SQL Server remotas
- Base de datos central `SqlMonitors` y tabla `EstadoAvailabilityGroup`
- Archivo de texto plano con la lista de servidores (`servidores.txt`)

## 📂 Estructura del archivo `servidores.txt`

Cada línea debe contener el nombre o instancia de SQL Server. Ejemplo:

```
SRV1\SQLDEV
SRV2
SRV3\INSTANCE2022
```

## 🗃️ Script de creación de tabla recomendada

```sql
CREATE TABLE EstadoAvailabilityGroup (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Servidor NVARCHAR(255),
    TipoInstancia NVARCHAR(50),
    EstadoAG NVARCHAR(50),
    NombreAG NVARCHAR(255),
    FechaRegistro DATETIME DEFAULT GETDATE()
);
```

## 🚀 Uso

1. Asegúrate de tener el archivo `servidores.txt` en la ruta:  
   `E:\Powershell\servidores.txt`

2. Ajusta en el script los siguientes valores si es necesario:
   - `$servidorCentral`: nombre del servidor central donde se guardará la información.
   - `$baseCentral`: nombre de la base de datos.
   - `$tablaCentral`: nombre de la tabla de destino.

3. Ejecuta el script con PowerShell con privilegios suficientes:

```powershell
powershell -ExecutionPolicy Bypass -File E:\Powershell\EstadoAvailabilityGroup.ps1
```

---

## 🧠 ¿Qué hace el script?

- Si el servidor no forma parte de un AG, lo clasifica como `StandAlone`.
- Si pertenece a un AG, registra el nombre del grupo y el rol (Primario/Secundario).
- Los errores se capturan y notifican sin detener la ejecución.

---

## 📜 Código completo del script

```powershell
# =====================================
# CONFIGURACIÓN
# =====================================

$rutaArchivoServidores = "E:\Powershell\servidores.txt"
$servidorCentral = "SPYHUNTER\MSSQLSERVER2022"
$baseCentral = "SqlMonitors"
$tablaCentral = "EstadoAvailabilityGroup"

# =====================================
# FUNCIÓN PARA INSERTAR RESULTADO
# =====================================

function Insertar-EstadoAG {
    param (
        [string]$servidorOrigen,
        [string]$tipoInstancia,
        [string]$estadoAG,
        [string]$nombreAG
    )

    $conexion = New-Object System.Data.SqlClient.SqlConnection
    $conexion.ConnectionString = "Server=$servidorCentral;Database=$baseCentral;Integrated Security=True;"
    $conexion.Open()

    $cmd = $conexion.CreateCommand()
    $cmd.CommandText = @"
    INSERT INTO $tablaCentral (Servidor, TipoInstancia, EstadoAG, NombreAG)
    VALUES (@Servidor, @TipoInstancia, @EstadoAG, @NombreAG)
"@

    $cmd.Parameters.Add("@Servidor", [System.Data.SqlDbType]::NVarChar, 255).Value = $servidorOrigen
    $cmd.Parameters.Add("@TipoInstancia", [System.Data.SqlDbType]::NVarChar, 50).Value = $tipoInstancia
    $cmd.Parameters.Add("@EstadoAG", [System.Data.SqlDbType]::NVarChar, 50).Value = $estadoAG
    $cmd.Parameters.Add("@NombreAG", [System.Data.SqlDbType]::NVarChar, 255).Value = $nombreAG

    $cmd.ExecuteNonQuery()
    $conexion.Close()
}

# =====================================
# CARGAR SERVIDORES Y PROCESAR
# =====================================

if (-Not (Test-Path $rutaArchivoServidores)) {
    Write-Error "No se encontró el archivo de servidores: $rutaArchivoServidores"
    exit
}

$servidores = Get-Content -Path $rutaArchivoServidores | Where-Object { $_.Trim() -ne "" }

foreach ($servidor in $servidores) {
    try {
        Write-Host "`nConsultando $servidor..." -ForegroundColor Cyan

        $queryAG = @"
        SELECT 
            ag.name AS NombreAG,
            ars.role_desc AS Rol,
            ars.replica_server_name AS Replica
        FROM 
            sys.dm_hadr_availability_replica_states ars
        INNER JOIN 
            sys.availability_replicas ar ON ars.replica_id = ar.replica_id
        INNER JOIN 
            sys.availability_groups ag ON ar.group_id = ag.group_id
"@

        $resultado = Invoke-Sqlcmd -ServerInstance $servidor -Query $queryAG -ErrorAction Stop

        if ($resultado.Count -eq 0) {
            # Si no hay resultado, se asume que es una instancia StandAlone
            Insertar-EstadoAG -servidorOrigen $servidor `
                              -tipoInstancia "StandAlone" `
                              -estadoAG "N/A" `
                              -nombreAG "N/A"
            Write-Host "$servidor es StandAlone." -ForegroundColor Yellow
        } else {
            foreach ($fila in $resultado) {
                Insertar-EstadoAG -servidorOrigen $servidor `
                                  -tipoInstancia "AvailabilityGroup" `
                                  -estadoAG $fila.Rol `
                                  -nombreAG $fila.NombreAG
                Write-Host "$servidor pertenece al AG '$($fila.NombreAG)' como $($fila.Rol)." -ForegroundColor Green
            }
        }

    } catch {
        Write-Warning ("No se pudo procesar el servidor '" + $servidor + "'. Error: " + $_.Exception.Message)
    }
}
```