# Auditoría de Availability Groups en SQL Server usando PowerShell

**Autor**: José Alejandro Jiménez Rosa  
**Fecha**: Mayo 2025  
**Uso**: Monitoreo y registro del estado de instancias SQL Server en AG (Availability Groups) o StandAlone.

---

## 📋 Descripción

Este script en PowerShell tiene como propósito consultar una lista de servidores SQL Server, identificar si pertenecen a un grupo de disponibilidad (Availability Group) o son instancias independientes (StandAlone), y registrar esta información en una tabla central en una base de datos SQL.

---

## 🗃️ Estructura de la Tabla SQL

Antes de ejecutar el script, asegúrate de crear la tabla en la base de datos `SqlMonitors` del servidor central (`CO01VSQLADMIN`):

```sql
CREATE TABLE EstadoAvailabilityGroup (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Servidor NVARCHAR(255),
    TipoInstancia NVARCHAR(50), -- StandAlone o AvailabilityGroup
    EstadoAG NVARCHAR(50),       -- Nodo Primario, Nodo Secundario, etc.
    NombreAG NVARCHAR(255),      -- Nombre del Availability Group
    FechaRegistro DATETIME DEFAULT GETDATE()
);
```

---

## ⚙️ Configuración del Script

- **Ruta de archivo de servidores**: `U:\WinServerSqlColector\servers.txt`  
  Este archivo debe contener una lista de instancias SQL Server, una por línea.

- **Servidor Central**: `CO01VSQLADMIN`  
- **Base de Datos Central**: `SqlMonitors`  
- **Tabla de destino**: `EstadoAvailabilityGroup`

---

## 📌 Funcionalidad del Script

1. **Carga de servidores**:  
   Lee la lista de servidores desde un archivo de texto.

2. **Conexión y Consulta**:  
   Se conecta a cada servidor e intenta identificar:
   - Si pertenece a un Availability Group.
   - Su rol en el AG (Primario, Secundario, etc.).
   - Su estado de sincronización.
   - O si es una instancia StandAlone.

3. **Inserción en base central**:  
   Se insertan los resultados en la tabla `EstadoAvailabilityGroup`.

4. **Manejo de errores**:  
   Se capturan errores de conexión o ejecución y se registran en consola.

---

## 🧠 Lógica SQL utilizada

La consulta utilizada en cada servidor busca en las vistas del sistema relacionadas a HADR:

- `sys.availability_groups`
- `sys.dm_hadr_availability_group_states`
- `sys.dm_hadr_availability_replica_states`
- `sys.dm_hadr_availability_replica_cluster_states`

---

## ▶️ Ejecución

Este script debe ejecutarse en un entorno que tenga acceso PowerShell y al módulo `SqlServer` con `Invoke-Sqlcmd`.  
Se recomienda programar su ejecución de forma periódica mediante un Job o una tarea del programador de tareas.

---

## ✅ Resultado Esperado

Una tabla poblada como la siguiente:

| Servidor             | TipoInstancia     | EstadoAG        | NombreAG         | FechaRegistro        |
|----------------------|-------------------|------------------|------------------|-----------------------|
| SQLPROD01            | AvailabilityGroup | Nodo Primario   | AG_Producción    | 2025-05-22 12:00:00   |
| SQLTEST01            | StandAlone        | N/A              | N/A              | 2025-05-22 12:00:00   |

---

## 🛠 Requisitos

- PowerShell 5.1+
- Módulo `SqlServer` (para usar `Invoke-Sqlcmd`)
- Permisos de lectura en las vistas del sistema SQL
- Acceso de escritura en la base de datos central

---

## 📄 Licencia

MIT License

---
