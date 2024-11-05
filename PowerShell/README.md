

## Alejandro Jimenez Rosa

<table>
<thead>
<tr>
  <th>Inicio de  </th>
  <th> manual de  PowerShel AJ</th>
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

# PowerShells
<img src="https://nerdcaster.com/wp-content/uploads/2019/08/PowerShell.jpeg?format=jpg&name=large" alt="JuveR" width="800px">

# Administracion


- 1 [Script que extrae datos de para documentacion de servidores sql BPD](#1)
- 2 [Sacar servidores con sus bases de datos usando PowerShell](#2)
- 3 [PowerShell que extrae los Sistema Operativa y version de sql del servidor](#2.2)
- 3 [Tamanos de carpetas y archivos a partir de una ruta usando Powershell](#3)

- 4 [Leer todos los programas instalados en una PC](#4)
- 5 [Generador de Informe de Cores y Discos de Servidores en PowerShell](#5)
- [Script de Reporte de Trabajos SQL](#6)
# 

- [ Enable Failover Clustering Feature using PowerShell](#7)

- [Powershell para leer los discos , memorias y si el servidor esta conectado y si es un AO y cual es su role en el (Primario , Secundario)](#20241031)

# 
--- 

## A continuación, te proporciono un código en PowerShell que extrae la información del servidor y la formatea en una tabla HTML con títulos en fondo azul:<a name="1"></a>
<img src="https://www.ionos.es/digitalguide/fileadmin/DigitalGuide/Teaser/was-ist-ein-server-t.jpg?format=jpg&name=large" alt="JuveR" width="800px">

~~~sql
# Crear una tabla HTML horizontal
$html = @"
<html>
<head>
<style>
th {
    background-color: blue;
    color: white;
}
td {
    padding: 8px;
}
</style>
</head>
<body>
<table border="1">
    <tr>
        <th>Server Name</th>
        <td>$($serverInfo.Name)</td>
    </tr>
    <tr>
        <th>IP Address</th>
        <td>$([System.Net.Dns]::GetHostAddresses($serverInfo.Name)[0].IPAddressToString)</td>
    </tr>
    <tr>
        <th>O.S.</th>
        <td>$($osInfo.Caption)</td>
    </tr>
    <tr>
        <th>O.S. Edition</th>
        <td>$($osInfo.CSDVersion)</td>
    </tr>
    <tr>
        <th>O.S. Version</th>
        <td>$($osInfo.Version)</td>
    </tr>
    <tr>
        <th>O.S. Build</th>
        <td>$($osInfo.BuildNumber)</td>
    </tr>
    <tr>
        <th>O.S. Architecture</th>
        <td>$($osInfo.OSArchitecture)</td>
    </tr>
    <tr>
        <th>Type</th>
        <td>$($serverInfo.Manufacturer)</td>
    </tr>
    <tr>
        <th>Clustered</th>
        <td>$($serverInfo.PartOfDomain)</td>
    </tr>
    <tr>
        <th>RAM (GB)</th>
        <td>$($serverInfo.TotalPhysicalMemory / 1GB)</td>
    </tr>
    <tr>
        <th>Processor Model</th>
        <td>$($cpuInfo.Name)</td>
    </tr>
    <tr>
        <th>Installed Processors (# Sockets)</th>
        <td>$($cpuInfo.NumberOfCores)</td>
    </tr>
    <tr>
        <th>Cores</th>
        <td>$($cpuInfo.NumberOfLogicalProcessors)</td>
    </tr>
    <tr>
        <th>Role</th>
        <td>$($serverInfo.DomainRole)</td>
    </tr>
    <tr>
        <th>SQL Version</th>
        <td>$($sqlInfo.InstallDate)</td>
    </tr>
    <tr>
        <th>SQL Edition</th>
        <td>$($sqlInfo.Version)</td>
    </tr>
    <tr>
        <th>SQL Architecture</th>
        <td>$($sqlInfo.Caption)</td>
    </tr>
    <tr>
        <th>Service Pack Level</th>
        <td>$($sqlInfo.ServicePackLevel)</td>
    </tr>
    <tr>
        <th>Current SQL Build</th>
        <td>$($sqlInfo.Version) ($sqlInfo.InstallLocation)</td>
    </tr>
    <tr>
        <th>Instance Name</th>
        <td>$($sqlInfo.Name)</td>
    </tr>
    <tr>
        <th>Perform Volume Maintenance Task Policy</th>
        <td>TODO</td>
    </tr>
</table>
</body>
</html>
"@

$html | Out-File -FilePath "C:\Pws\logs\ServerInfo.html"

Invoke-Item "ServerInfo.html"

~~~

#### Este script de PowerShell obtiene información del servidor y la formatea en una tabla HTML con los títulos en fondo azul. Asegúrate de modificar el contenido de la celda "Perform Volume Maintenance Task Policy" según tus necesidades, ya que no proporcionaste detalles sobre cómo obtener ese valor específico.

#### El script guarda el resultado en un archivo HTML llamado "ServerInfo.html" y lo abre en el navegador predeterminado. Asegúrate de ejecutar el script en un entorno donde tengas permisos para acceder a la información del servidor y crear archivos.

# 




### Sacar servidores con sus bases de datos usando PowerShell<a name="2"></a>
<img src="https://jsequeiros.com/archivos/img/sqlserver2012/base-datos-sql-server-sistema.png?format=jpg&name=large" alt="JuveR" width="800px">

# 


#### Este código ejecutará la consulta proporcionada en cada uno de los servidores en el archivo server_instances.txt y mostrará los resultados. Cabe mencionar que este código solo muestra los resultados en la consola de PowerShell. Si deseas adaptarlo para generar archivos HTML como antes, puedes usar la estructura y el estilo que hemos discutido en las respuestas anteriores.

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

# 

# PowerShell que extrae los Sistema Operativa y version de sql del servidor<a name="2.2"></a>

~~~~sql
# Script para obtener información de servidores SQL y sus sistemas operativos

# Definir la ruta del archivo de servidores y la carpeta de salida
$serverFilePath = "C:\PWtablas\server_instances.txt"
$outputDirectory = "C:\PWtablas\html"

# Crear la carpeta de salida si no existe
if (-Not (Test-Path -Path $outputDirectory)) {
    New-Item -ItemType Directory -Path $outputDirectory
}

# Leer servidores e instancias desde un archivo
$servers = Get-Content -Path $serverFilePath

# Crear una lista para almacenar los resultados
$results = @()

foreach ($server in $servers) {
    try {
        # Crear la conexión al servidor SQL
        $connectionString = "Server=$server;Integrated Security=True;"
        $connection = New-Object System.Data.SqlClient.SqlConnection
        $connection.ConnectionString = $connectionString
        $connection.Open()

        # Obtener información del servidor SQL
        $serverName = $connection.DataSource
        $instanceName = if ($server -match '\\') { $server.Split('\')[1] } else { "Default" }
        $versionInfo = $connection.ServerVersion

        # Obtener la versión de SQL Server en términos de año
        $sqlVersionYear = switch -Regex ($versionInfo) {
            "^8\." { "SQL Server 2000" }
            "^9\." { "SQL Server 2005" }
            "^10\.0" { "SQL Server 2008" }
            "^10\.5" { "SQL Server 2008 R2" }
            "^11\." { "SQL Server 2012" }
            "^12\." { "SQL Server 2014" }
            "^13\." { "SQL Server 2016" }
            "^14\." { "SQL Server 2017" }
            "^15\." { "SQL Server 2019" }
            "^16\." { "SQL Server 2022" }
            default { "Versión Desconocida" }
        }

        # Obtener información del sistema operativo del servidor
        $osInfo = Invoke-Command -ComputerName $server.Split('\')[0] -ScriptBlock {
            Get-WmiObject -Class Win32_OperatingSystem | Select-Object -ExpandProperty Caption
        }
        
        $osVersion = switch -Regex ($osInfo) {
            "2019" { "Windows Server 2019" }
            "2016" { "Windows Server 2016" }
            "2012 R2" { "Windows Server 2012 R2" }
            "2012" { "Windows Server 2012" }
            "2008 R2" { "Windows Server 2008 R2" }
            "2008" { "Windows Server 2008" }
            "2003" { "Windows Server 2003" }
            default { $osInfo }
        }

        # Guardar los resultados
        $results += [PSCustomObject]@{
            ServerName   = $serverName
            InstanceName = $instanceName
            OSVersion    = $osVersion
            SqlVersion   = $sqlVersionYear
        }

        $connection.Close()
    } catch {
        Write-Host "No se pudo conectar al servidor: $server"
    }
}

# Convertir los resultados a HTML
$html = $results | ConvertTo-Html -Property ServerName, InstanceName, OSVersion, SqlVersion -Fragment | Out-String

# Agregar el encabezado y estilos básicos al HTML
$html = @"
<!DOCTYPE html>
<html>
<head>
    <title>Información de Servidores SQL</title>
    <style>
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid black; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
    </style>
</head>
<body>
    <h1>Información de Servidores SQL</h1>
    $html
</body>
</html>
"@

# Definir la ruta completa del archivo de salida
$outputFilePath = Join-Path -Path $outputDirectory -ChildPath "ServerInfo.html"

# Guardar el HTML en un archivo
$html | Out-File -FilePath $outputFilePath -Encoding UTF8

Write-Host "El archivo HTML se ha generado correctamente en $outputFilePath"

~~~~

Este script realiza lo siguiente:

Define las rutas del archivo de servidores y la carpeta de salida.
Crea la carpeta de salida si no existe.
Lee la lista de servidores e instancias desde C:\PWtablas\server_instances.txt.
Se conecta a cada servidor para obtener la versión de SQL Server.
Usa Invoke-Command para obtener la información del sistema operativo remoto.
Almacena la información en un objeto personalizado.
Convierte los resultados en HTML y los guarda en C:\PWtablas\html\ServerInfo.html.
Asegúrate de tener permisos necesarios para ejecutar Invoke-Command en los servidores remotos y que WinRM esté configurado en esos servidores.





## Tamanos de carpetas y archivos a partir de una ruta usando Powershell<a name="3"></a>

#### Puedes crear un script de PowerShell que recorra todas las carpetas y subcarpetas a partir de una ruta indicada y muestre la información del tamaño de cada carpeta y archivo en una página web. Aquí tienes un ejemplo de cómo hacerlo:
# 
<img src="https://www.softzone.es/app/uploads-softzone.es/2022/06/tamano-archivo-windows.jpg?format=jpg&name=large" alt="JuveR" width="800px">

#

## codigo en GB.
~~~sql
# Define la ruta base
$basePath = "E:\Cursos"

# Definir la ruta del archivo de salida HTML
$outputFile = "C:\Ruta\informe.html"

# Función para calcular el tamaño de una carpeta o archivo en GB
function Get-ItemSize($item) {
    if (Test-Path $item) {
        $itemInfo = Get-Item $item
        $sizeInBytes = $itemInfo.Length
        $sizeInGB = [math]::Round($sizeInBytes / 1GB, 2)
        return $sizeInGB
    }
    return 0
}

# Función para generar el HTML
function Generate-HTML($path) {
    $htmlContent = "<html><head><title>Informe de Tamaño</title></head><body><h1>Informe de Tamaño</h1><table><tr><th>Nombre</th><th>Tamaño (GB)</th></tr>"
    
    Get-ChildItem -Path $path -File -Recurse | ForEach-Object {
        $item = $_
        $htmlContent += "<tr><td>$($item.FullName)</td><td>$(Get-ItemSize $item.FullName)</td></tr>"
    }
    
    Get-ChildItem -Path $path -Directory -Recurse | ForEach-Object {
        $item = $_
        $htmlContent += "<tr><td>$($item.FullName)</td><td>$(Get-ItemSize $item.FullName)</td></tr>"
    }
    
    $htmlContent += "</table></body></html>"
    
    $htmlContent | Out-File -FilePath $outputFile
}

# Genera el informe HTML
Generate-HTML -path $basePath

# Abre el archivo HTML en el navegador predeterminado
Invoke-Item $outputFile

~~~
# 

## Codigo en MB
~~~sql
# Define la ruta base
$basePath = "E:\Cursos"

# Definir la ruta del archivo de salida HTML
$outputFile = "C:\Ruta\informe.html"

# Función para calcular el tamaño de una carpeta o archivo en MB
function Get-ItemSize($item) {
    if (Test-Path $item) {
        $itemInfo = Get-Item $item
        $sizeInBytes = $itemInfo.Length
        $sizeInMB = [math]::Round($sizeInBytes / 1MB, 2)
        return $sizeInMB
    }
    return 0
}

# Función para generar el HTML
function Generate-HTML($path) {
    $htmlContent = "<html><head><title>Informe de Tamaño</title></head><body><h1>Informe de Tamaño</h1><table><tr><th>Nombre</th><th>Tamaño (MB)</th></tr>"
    
    Get-ChildItem -Path $path -File -Recurse | ForEach-Object {
        $item = $_
        $htmlContent += "<tr><td>$($item.FullName)</td><td>$(Get-ItemSize $item.FullName)</td></tr>"
    }
    
    Get-ChildItem -Path $path -Directory -Recurse | ForEach-Object {
        $item = $_
        $htmlContent += "<tr><td>$($item.FullName)</td><td>$(Get-ItemSize $item.FullName)</td></tr>"
    }
    
    $htmlContent += "</table></body></html>"
    
    $htmlContent | Out-File -FilePath $outputFile
}

# Genera el informe HTML
Generate-HTML -path $basePath

# Abre el archivo HTML en el navegador predeterminado
Invoke-Item $outputFile

~~~



#### Asegúrate de reemplazar $basePath con la ruta desde la cual deseas comenzar a recopilar información. El script crea un informe HTML que incluye el nombre y el tamaño (en bytes) de cada archivo y carpeta en la ruta especificada y sus subcarpetas. Finalmente, abre el informe en el navegador predeterminado.

#### Recuerda que debes ejecutar este script en PowerShell con permisos suficientes para acceder a las carpetas y archivos en la ruta especificada. También, asegúrate de que la ruta de salida especificada en $outputFile sea accesible para escribir.
# 


## Leer todos los programas instalados en una PC<a name="4"></a>

<img src="https://seguridadparaelpc.files.wordpress.com/2016/05/listar-todos-los-programas-instalados-en-windows-en-un-paso1.jpg?w=1366&h=720&crop=1?format=jpg&name=large" alt="JuveR" width="800px">


#### Guarda este código en un archivo con extensión ".ps1" (por ejemplo, "ListarProgramas.ps1") y luego ejecútalo en PowerShell. Ten en cuenta que este método utiliza la clase Win32_Product de WMI para obtener la lista de programas instalados, pero ten en cuenta que esta clase puede ser lenta y no incluir todos los programas instalados en la PC.

#### Una alternativa más rápida y completa es utilizar el Registro de Windows para obtener la lista de programas instalados. Aquí hay un ejemplo de cómo hacerlo:

~~~sql
# Obtiene el nombre de la máquina
$nombreMaquina = $env:COMPUTERNAME

# Obtiene una lista de programas instalados en la PC desde el Registro de Windows
$UninstallKey = Get-ChildItem "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall" -ErrorAction SilentlyContinue

# Crear un archivo HTML para almacenar la lista de programas
$htmlFilePath = "ProgramasInstalados.html"

# Inicializa el contenido del archivo HTML
$htmlContent = "<!DOCTYPE html>
<html>
<head>
    <title>Lista de Programas Instalados</title>
</head>
<body>
    <h1>Programas Instalados en $nombreMaquina</h1>
    <table border='1'>
        <tr>
            <th>Nombre de la máquina</th>
            <th>Nombre del programa</th>
        </tr>"

# Itera a través de la lista de programas instalados y agrega filas a la tabla
$UninstallKey | ForEach-Object {
    $programa = Get-ItemProperty $_.PSPath
    $nombrePrograma = $programa.DisplayName
    if ($nombrePrograma -ne $null) {
        $htmlContent += "<tr>"
        $htmlContent += "<td>$nombreMaquina</td>"
        $htmlContent += "<td>$nombrePrograma</td>"
        $htmlContent += "</tr>"
    }
}

# Cierra el contenido del archivo HTML
$htmlContent += "</table></body></html>"

# Guarda el contenido en el archivo HTML
$htmlContent | Set-Content -Path $htmlFilePath

# Abre el archivo HTML en el navegador predeterminado
Invoke-Item $htmlFilePath

~~~

#### Este script crea un archivo HTML llamado "ProgramasInstalados.html" en el directorio desde donde se ejecuta el script. Contiene una tabla con el nombre de la máquina y el nombre de los programas instalados. Luego, abre el archivo HTML en el navegador web predeterminado. Asegúrate de que el script tenga los permisos necesarios para crear archivos y abrir programas.


#


# Generador de Informe de Cores y Discos de Servidores en PowerShell<a name="5"></a>
# 
<img src="https://elsalvador.solutekla.com/photo/1/supermicro/servidores/server_supermicro_rack_1u_intel_bronze_3104_6core_8gb_ddr4_2666_2tb_hdd5019pmoto12/server_supermicro_rack_1u_intel_bronze_3104_6core_8gb_ddr4_2666_2tb_hdd5019pmoto12_0001?w=1366&h=720&crop=1?format=jpg&name=large" alt="JuveR" width="800px">

#### 

~~~sql


# Obtener la fecha y hora actual para agregar al nombre del archivo
# Creado por Ajejandro Jimenez Rosa.......................
# Finalizado 21 de Noviembre 2023..........................
# 
$fechaHora = Get-Date -Format "yyyyMMdd-HHmmss"

# Leer los nombres de los servidores desde el archivo servidores.txt
$servidores = Get-Content -Path "C:\PowerShellDiscosServidores\servidores.txt"

# Variable para almacenar los resultados HTML de los servidores no encontrados
$resultadosNoEncontradosHTML = "<html><head><title>Listado de Cores y discos de Servidores</title></head><body><h1>Listado de Cores y discos de Servidores</h1>"
# Variable para almacenar los resultados HTML de los servidores encontrados
$resultadosEncontradosHTML = "<html><head><title>Listado de Cores y discos de Servidores</title><style>table {border-collapse: collapse; width: 100%;} th, td {border: 1px solid black; padding: 8px; text-align: left;} th {background-color: #f2f2f2;}</style></head><body><h1>Listado de Cores y discos de Servidores</h1>"

# Variable para almacenar los nombres de los servidores no encontrados
$servidoresNoEncontrados = @()

# Iterar sobre cada servidor en la lista
foreach ($serverName in $servidores) {
    Write-Host "Obteniendo información para el servidor $serverName..."
    
    # Intentar obtener información sobre los núcleos y discos del servidor
    $cores = Get-WmiObject -ComputerName $serverName -Class Win32_Processor -ErrorAction SilentlyContinue
    $disks = Get-WmiObject -ComputerName $serverName -Class Win32_LogicalDisk -ErrorAction SilentlyContinue

    # Verificar si no se pudo obtener información y registrar el servidor no encontrado
    if (-not $cores -or -not $disks) {
        Write-Host "¡No se pudo acceder al servidor $serverName!"
        $servidoresNoEncontrados += $serverName
    }
    else {
        # Agregar los resultados del servidor a la tabla HTML de servidores encontrados
        $resultadosEncontradosHTML += "<h2>Información para el servidor $serverName ($($cores.NumberOfCores) cores)</h2>"
        $resultadosEncontradosHTML += "<table><tr><th>Disco</th><th>Tamaño total (GB)</th><th>Espacio libre (GB)</th></tr>"
        foreach ($disk in $disks) {
            $tamanioTotal = [math]::Round($disk.Size / 1GB, 2)
            $espacioLibre = [math]::Round($disk.FreeSpace / 1GB, 2)
            $resultadosEncontradosHTML += "<tr><td>$($disk.DeviceID)</td><td>$tamanioTotal</td><td>$espacioLibre</td></tr>"
        }
        $resultadosEncontradosHTML += "</table>"
    }
}

# Generar HTML con la lista de servidores no encontrados
if ($servidoresNoEncontrados.Count -gt 0) {
    $resultadosNoEncontradosHTML += "<h1>Servidores No Encontrados</h1>"
    $resultadosNoEncontradosHTML += "<ul>"
    foreach ($servidorNoEncontrado in $servidoresNoEncontrados) {
        $resultadosNoEncontradosHTML += "<li>$servidorNoEncontrado</li>"
    }
    $resultadosNoEncontradosHTML += "</ul>"
} else {
    $resultadosNoEncontradosHTML += "<h1>Todos los servidores están accesibles</h1>"
}

# Cerrar etiquetas HTML
$resultadosNoEncontradosHTML += "</body></html>"
$resultadosEncontradosHTML += "</body></html>"

# Guardar la lista de servidores no encontrados en un archivo HTML con fecha y hora en el nombre
$resultadosNoEncontradosHTML | Out-File -FilePath "C:\PowerShellDiscosServidores\NOENCONTRADOS\NoEncontrados_$fechaHora.html" -Encoding UTF8

# Guardar los resultados de servidores encontrados en archivos HTML individuales con fecha y hora en el nombre
$resultadosEncontradosHTML | Out-File -FilePath "C:\PowerShellDiscosServidores\ENCONTRADOS\Encontrados_$fechaHora.html" -Encoding UTF8

Write-Host "Los servidores no encontrados se han guardado en NoEncontrados_$fechaHora.html."
Write-Host "Los servidores encontrados se han guardado en Encontrados_$fechaHora.html."

~~~





# 
---

# Script de Reporte de Trabajos SQL<a name="6"></a>


<img src="https://i.octopus.com/blog/2019-11/sql-server-powershell/sql-server-powershell-examples.png?w=1366&h=720&crop=1?format=jpg&name=large" alt="JuveR" width="800px">


Claro, aquí tienes la documentación en español para que puedas colocar este script en un documento de GitHub:

---

# Script de Reporte de Trabajos SQL

## Descripción

Este script de PowerShell se conecta a una lista de servidores SQL, ejecuta una consulta SQL especificada y genera informes HTML. El informe principal lista detalles sobre los trabajos SQL en cada servidor, mientras que un informe secundario lista cualquier servidor al que no se pudo acceder.

## Características

- Se conecta a múltiples servidores SQL.
- Ejecuta una consulta SQL personalizada en cada servidor.
- Genera un informe HTML con detalles de los trabajos SQL.
- Genera un informe HTML que lista los servidores a los que no se pudo acceder.
- Imprime en consola si el servidor fue encontrado o no.

## Requisitos

- PowerShell
- Módulo de SQL Server para PowerShell (`SqlServer`)
- Archivo `servidores.txt` con la lista de servidores (uno por línea).

## Uso

1. **Clonar el repositorio:**
   ```sh
   git clone https://github.com/ajimenezrosa/reporte-trabajos-sql.git
   cd reporte-trabajos-sql
   ```

2. **Crear el archivo de servidores:**
   Crea un archivo `servidores.txt` en el mismo directorio del script, con el siguiente formato (un servidor por línea):
   ```
   Servidor1
   Servidor2
   Servidor3
   ```

3. **Ejecutar el script:**
   Ejecuta el script en PowerShell:
   ```sh
   .\PowerShellJobsSql.ps1
   ```

4. **Ver los informes:**
   - Carpeta `Encontrados`: Contiene los informes HTML con detalles de los trabajos SQL de los servidores encontrados.
   - Carpeta `NoEncontrados`: Contiene un informe HTML con la lista de servidores a los que no se pudo acceder.

## Script

~~~sql
 

#=======================================================================================================================#

# Códigos creados para extraer Jobs de servidores SQL para control M.---------------------------------------------------#

# Este código fue realizado en base a un código SQL que extrae datos de los servidores, pero debe ser ejecutado --------#

# servidor por servidor. Esto dificulta la tarea cuando los servidores pasan de un número X. Cuanto mayor sea el número-#

# de servidores, mayor será la cantidad de trabajo y tiempo invertido.--------------------------------------------------#

#    -------------------------------------------------------------------------------------------------------------------#

# Author:  Jose Alejandro Jimenez Rosa----------------------------------------------------------------------------------#

# ----------------------------------------------------------------------------------------------------------------------#

#=======================================================================================================================#

 

 

# Leer la lista de servidores desde el archivo servidores.txt

$servers = Get-Content -Path "C:\powershell sql\servidores.txt"

 

# Define la consulta SQL

$sqlQuery = @"

SELECT DISTINCT

    @@SERVERNAME AS Servidor,

    [sJOB].[name] AS [JobName],

    description = REPLACE(REPLACE(REPLACE([sJOB].description, CHAR(9), ''), CHAR(10), ''), CHAR(13), ''),

    [dbo].[fn_sysdac_get_username](sJOB.owner_sid) AS [JobOwner],

    CASE [sJOB].[enabled]

        WHEN 1 THEN 'Yes'

        WHEN 0 THEN 'No'

    END AS [IsEnabled],

    CASE

        WHEN [sSCH].[schedule_uid] IS NULL THEN 'No'

        ELSE 'Yes'

    END AS [IsScheduled],

    CASE [sSCH].[freq_type]

        WHEN 1 THEN 'One Time'

        WHEN 4 THEN 'Daily'

        WHEN 8 THEN 'Weekly'

        WHEN 16 THEN 'Monthly'

        WHEN 32 THEN 'Monthly - Relative to Frequency Interval'

        WHEN 64 THEN 'Start automatically when SQL Server Agent starts'

        WHEN 128 THEN 'Start whenever the CPUs become idle'

    END AS [Occurrence],

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

    [JobName];

"@

 

# Inicializa los arrays para almacenar resultados y errores

$results = @()

$notFound = @()

 

# Recorre cada servidor y ejecuta la consulta SQL

foreach ($server in $servers) {

    try {

        # Construye la cadena de conexión

        $connectionString = "Server=$server;Database=msdb;Integrated Security=True;"

 

        # Ejecuta la consulta SQL y almacena el resultado

        $data = Invoke-Sqlcmd -Query $sqlQuery -ConnectionString $connectionString

        if ($data) {

            $results += $data

            Write-Host ($server + ": Encontrado")

        } else {

            $notFound += $server

            Write-Host ($server + ": No Encontrado")

        }

    } catch {

        # Si hay un error, registra el servidor en la lista de no encontrados

        $notFound += $server

        Write-Host ($server + ": No Encontrado")

    }

}

 

# Crear carpetas si no existen

if (-not (Test-Path -Path "C:\powershell sql\Encontrados")) {

    New-Item -ItemType Directory -Path "C:\powershell sql\Encontrados"

}

if (-not (Test-Path -Path "C:\powershell sql\NoEncontrados")) {

    New-Item -ItemType Directory -Path "C:\powershell sql\NoEncontrados"

}

 

# Generar timestamp para los nombres de archivo

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"

 

# Genera la tabla HTML para los resultados

if ($results.Count -gt 0) {

    $header = @"

<html>

<head>

    <style>

        body { font-family: Arial, sans-serif; }

        h1, h2 { text-align: center; }

        h1 { color: #00008B; }

        h2 { color: #000000; }

        table { width: 100%; border-collapse: collapse; }

        th, td { border: 1px solid black; padding: 8px; text-align: left; }

        th { background-color: #f2f2f2; }

    </style>

</head>

<body>

    <h1>Banco Popular Dominicano</h1>

    <h2>Extracción de jobs de múltiples servidores SQL Server vía PowerShell</h2>

"@

    $footer = "</body></html>"

 

    $html = $results | ConvertTo-Html -Property Servidor, JobName, Description, JobOwner, IsEnabled, IsScheduled, Occurrence, Recurrence, active_start_time -PreContent $header -PostContent $footer

    $html | Out-File ("C:\powershell sql\Encontrados\ReporteTrabajosSQL_" + $timestamp + ".html")

}

 

# Genera la tabla HTML para los servidores no encontrados

if ($notFound.Count -gt 0) {

    $headerNotFound = @"

<html>

<head>

    <style>

        body { font-family: Arial, sans-serif; }

        h1, h2 { text-align: center; }

        h1 { color: #00008B; }

        h2 { color: #000000; }

        table { width: 100%; border-collapse: collapse; }

        th, td { border: 1px solid black; padding: 8px; text-align: left; }

        th { background-color: #f2f2f2; }

    </style>

</head>

<body>

    <h1>Banco Popular Dominicano</h1>

    <h2>Servidores No Encontrados</h2>

    <table>

        <tr><th>Servidor</th></tr>

"@

 

    $footerNotFound = "</table></body></html>"

 

    $rowsNotFound = $notFound | ForEach-Object { "<tr><td>$_</td></tr>" }

    $htmlNotFound = $headerNotFound + ($rowsNotFound -join "") + $footerNotFound

    $htmlNotFound | Out-File ("C:\powershell sql\NoEncontrados\ServidoresNoEncontrados_" + $timestamp + ".html")

}
~~~

# 


## Enable Failover Clustering Feature using PowerShell<a name="7"></a>



    1. Click Start > Windows PowerShell >right-click Windows PowerShell > More > select Run as administrator.

    
    2. In Windows PowerShell, type the following command.


~~~sql
Install-WindowsFeature “Failover-Clustering” -IncludeManagementTools
~~~

## Exercise 3: Creating a 3-node failover cluster
#### To run the validation tests using PowerShell, you can use the Test-Cluster cmdlet.


~~~sql
 Example: Validate specified nodes
Test-Cluster -Node "AlwaysOnN1", "AlwaysOnN2","AlwaysOnN3"

Example: Validate specified nodes for storage tests

Test-Cluster -Node "AlwaysOnN1", "AlwaysOnN2","AlwaysOnN3" -Include "Storage"
~~~
[More details can be found here](#https://learn.microsoft.com/en-us/powershell/module/failoverclusters/test-cluster?view=windowsserver2022-ps)



## To create a cluster using PowerShell, you can use the New-Cluster cmdlet.

~~~sql
Example: Create new cluster

New-Cluster -Name “AlwaysOnCluster” -Node AlwaysOnN1, AlwaysOnN2,AlwaysOnN3 -NoStorage
~~~

#### The above command will create a Windows Server 2022 Failover Cluster with no shared disks. The NoStorage parameter is used as we don't want any storage to be automatically added to the cluster.

#### [More details can be found here](#https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2008-R2-and-2008/ee460973(v=technet.10)?redirectedfrom=MSDN)




## Exercise 4: Review the 3-node failover cluster using GUI and PowerShell

## Task 2: Review the 3-node failover cluster using PowerShell.

#### To get a list of all cluster cmdlets, type the following:

~~~sql
Get-command -module FailoverClusters
~~~

#### Below are some more useful cluster cmdlets:

#### Gets cluster node list

~~~sql
Get-clusternode 
~~~

#### Gets cluster resource list

~~~sql
Get-clusterresource 
~~~

#### Creates a log file for all nodes, or a specific a node, in a failover cluster. They are stored in the %windir%\Cluster\Reports directory on each node of the cluster.

~~~sql
Get-clusterlog 
~~~


# 

# Powershell para leer los discos , memorias y si el servidor esta conectado y si es un AO y cual es su role en el (Primario , Secundario)<a name="20241031"></a>


~~~sql


#*********************************************************#

#* Monitor de espacio en Disco                           *#

#*Alejandro Jimenez                                      *#

#*********************************************************#

#* Modificado por Alejandro Jimenez 2024-10-31           *#

#*********************************************************#

 

# Continua aun encuentre algun error

$ErrorActionPreference = "Continue";

 

# Ajustamos el nivel de umbral para la alerta

$percentWarning = 30;

$percentCritcal = 20;

 

# REPORT PROPERTIES

# Path to the report

$reportPath = "C:\CleanSenseF\Logs\";  # Configurar la ruta donde se guardaran los reportes de logs

 

# Report name

$reportName = "EspacioDiscoRpt_$(get-date -format ddMMyyyy).html";

 

# Path and Report name together

$diskReport = $reportPath + $reportName

 

#Set colors for table cell backgrounds

$redColor = "#FF0000"

$orangeColor = "#FBB917"

$whiteColor  = "#FFFFFF"

$greenColor  =  "#00FF00"

 

# Obtiene el Listado de Servidores\PC para realizar la verificacion del Espacion en Disco

$computers = Get-Content "C:\CleanSenseF\servers.txt";  #proveemos la ruta del archivo server.txt que contiene los equipos que queremos monitorear.

 

# Validate that $computers is not null or empty

if (-not $computers) {

    Write-Host "No servers found in the servers.txt file. Please ensure the file contains server names."

    exit

}

 

Write-Host "Servers to be checked: $computers"

 

$datetime = Get-Date -Format "MM-dd-yyyy_HHmmss";

 

# Elimina el reporte si ya se ha ejecutado hoy para que no se agregue al reporte existente

If (Test-Path $diskReport)

{

    Remove-Item $diskReport

}

 

# Eliminando los archivos viejos del el log de Monitoreo..

$Daysback = "-20"  #Configuramos la limpieza de los reportes que son mayores de 20 días

$CurrentDate = Get-Date;

$DateToDelete = $CurrentDate.AddDays($Daysback);

Get-ChildItem $reportPath | Where-Object { $_.LastWriteTime -lt $DateToDelete } | Remove-Item;

 

# Creamos el  HTML Header del reporte

$titleDate = get-date -uformat "%m-%d-%Y - %A %H:%M:%S"

$header = "

  <html>

  <head>

  <meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'>

  <title>DiskSpace Report</title>

  <STYLE TYPE='text/css'>

  <!--

  td {

   font-family: Calibri;

   font-size: 12px;

   border-top: 1px solid #999999;

   border-right: 1px solid #999999;

   border-bottom: 1px solid #999999;

   border-left: 1px solid #999999;

   padding-top: 0px;

   padding-right: 0px;

   padding-bottom: 0px;

   padding-left: 0px;

  }

  body {

   margin-left: 5px;

   margin-top: 5px;

   margin-right: 0px;

   margin-bottom: 10px;

   table {

   border: thin solid #000000;

  }

  -->

  </style>

  </head>

  <body>

  <table width='100%'>

  <tr bgcolor='#548DD4'>

  <td colspan='7' height='30' align='center'>

  <font face='calibri' color='#003399' size='4'><strong>Reporte de Monitoreo $titledate</strong></font>

  </td>

  </tr>

  </table>

"

Add-Content $diskReport $header

 

# Start processing disk space

foreach($computer in $computers)

{ 

    if ([string]::IsNullOrEmpty($computer)) {

        Write-Host "Skipping empty computer name."

        continue

    }

 

    Write-Host "Checking computer: $computer"

 

    # Separar el nombre del servidor y la instancia si existe

    $parts = $computer -split '\\'

    if ($parts.Length -eq 2) {

        $serverName = $parts[0]

        $instanceName = $parts[1]

    } elseif ($parts.Length -eq 1) {

        $serverName = $parts[0]

        $instanceName = ""

    } else {

        Write-Host "Formato incorrecto para $computer. Asegúrate de que la cadena contenga un '\\' o solo el nombre del servidor."

        continue

    }

 

    Write-Host "Servidor: $serverName, Instancia: $instanceName"

 

    # Verificar disponibilidad del servidor SQL Server

    $sqlStatus = "OK"

    $availabilityGroup = "N/A"

    $role = "N/A"

   # $listener = "N/A"

 

   ##

 

   $serverInstance = $computers

##   $serverInstance = "CA01VAO2014\ALWAYSONI2"

# $databaseName = "master"

$connectionString = "Server=$serverInstance;Database=$databaseName;Integrated Security=True;"

 

$connection = New-Object System.Data.SqlClient.SqlConnection

# $connection.ConnectionString = $connectionString

##$connection.Open()

##$connection.close()

 

 

   ##

 

 

 

    try {

        $sqlTest = Test-NetConnection -ComputerName $serverName -Port 1433

 

        # if ($sqlTest.TcpTestSucceeded -eq $false) {

        if ( $connectionString -eq $false) {

       

            $sqlStatus = "Problemas Verificar Entorno... $Computer"

           

        } else {

            # Verificar si el servidor es parte de un Availability Group

            $query = @"

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

            WHERE arcs.replica_server_name = (select @@SERVERNAME)

 

 

 

                                               

"@

            if ($instanceName) {

                $result = Invoke-Sqlcmd -ServerInstance "$serverName\$instanceName" -Query $query

            } else {

                $result = Invoke-Sqlcmd -ServerInstance $serverName -Query $query

            }

            if ($result) {

                $availabilityGroup = $result.AvailabilityGroupName

                $role = $result.Role

                # $listener = $result.ListenerDnsName

            }

        }

    } catch {

        $sqlStatus = "Problemas Verificar Entorno... $Computer"

    }

 

    try {

        $disks = Get-WmiObject -ComputerName $serverName -Class Win32_LogicalDisk -Filter "Size > 0"

        if ($disks -eq $null) {

            Write-Host "No disks found for $serverName."

            continue

        }

    } catch {

        Write-Host "Failed to get WMI object for $serverName. Error: $_"

        continue

    }

 

    $serverName = $serverName.toupper()

 

    # Añadir un encabezado para cada servidor

    $serverHeader = "

    <h2>Servidor: $serverName</h2>

    <p>Estado del SQL Server: $sqlStatus</p>

    <p>Availability Group: $availabilityGroup</p>

    <p>Role: $role</p>

    <p>Listener: $listener</p>

    <table width='100%'><tbody>

    <tr bgcolor=#548DD4>

    <td width='10%' align='center'>Server</td>

    <td width='5%'  align='center'>Drive</td>

    <td width='15%' align='center'>Drive Label</td>

    <td width='10%' align='center'>Total Capacity(GB)</td>

    <td width='10%' align='center'>Used Capacity(GB)</td>

    <td width='10%' align='center'>Free Space(GB)</td>

    <td width='5%'  align='center'>Freespace %</td>

    </tr>

    "

    Add-Content $diskReport $serverHeader

 

    foreach($disk in $disks)

    {

        $deviceID = $disk.DeviceID;

        $volName = $disk.VolumeName;

        [float]$size = $disk.Size;

        [float]$freespace = $disk.FreeSpace; 

        $percentFree = [Math]::Round(($freespace / $size) * 100);

        $sizeGB = [Math]::Round($size / 1073741824, 2);

        $freeSpaceGB = [Math]::Round($freespace / 1073741824, 2);

        $usedSpaceGB = $sizeGB - $freeSpaceGB;

        $color = $whiteColor;

 

 

        # Ajustamos el background color a Naranja si es solo Advertencia

        if($percentFree -lt $percentWarning)      

        {

            $color = $orangeColor 

        }

        else

        {

            $color = $greenColor 

        }

 

        # Ajustamos el Color del background de Naranja a Rojo si el espacio es critico

        if($percentFree -lt $percentCritcal)

        {

            $color = $redColor

        }        

 

        # Creamos el table data rows 

        $dataRow = "

        <tr>

            <td width='10%'>$computer</td>

            <td width='5%' align='center'>$deviceID</td>

            <td width='10%' >$volName</td>

            <td width='10%' align='center'>$sizeGB GB</td>

            <td width='10%' align='center'>$usedSpaceGB GB</td>

            <td width='10%' align='center'>$freeSpaceGB GB</td>

            <td width='5%' bgcolor=`'$color`' align='center'>$percentFree %</td>

        </tr>

        "

        Add-Content $diskReport $dataRow;

        Write-Host -ForegroundColor DarkYellow "$computer $deviceID percentage free space = $percentFree";

    }

 

    # Cerrar la tabla para cada servidor

    Add-Content $diskReport "</tbody></table><br>"




        # Obtener información de memoria
    try {
        $memoryInfo = Get-WmiObject -ComputerName $serverName -Class Win32_OperatingSystem
        $totalMemory = [Math]::Round($memoryInfo.TotalVisibleMemorySize / 1MB, 2)
        $freeMemory = [Math]::Round($memoryInfo.FreePhysicalMemory / 1MB, 2)
        $usedMemory = $totalMemory - $freeMemory
        $percentFreeMemory = [Math]::Round(($freeMemory / $totalMemory) * 100)

        # Determinar color según el porcentaje de memoria libre
        $memoryColor = $greenColor
        if ($percentFreeMemory -lt $percentWarning) { $memoryColor = $orangeColor }
        if ($percentFreeMemory -lt $percentCritcal) { $memoryColor = $redColor }

        # Sección de reporte de memoria
        $memorySection = @"
        <h3>Consumo de Memoria del Servidor: $serverName</h3>
        <table width='100%'>
            <tr bgcolor='#548DD4'>
                <td width='25%' align='center'>Total Memoria (GB)</td>
                <td width='25%' align='center'>Memoria Utilizada (GB)</td>
                <td width='25%' align='center'>Memoria Libre (GB)</td>
                <td width='25%' align='center'>Porcentaje Libre</td>
            </tr>
            <tr>
                <td width='25%' align='center'>$totalMemory GB</td>
                <td width='25%' align='center'>$usedMemory GB</td>
                <td width='25%' align='center'>$freeMemory GB</td>
                <td width='25%' align='center' bgcolor='$memoryColor'>$percentFreeMemory %</td>
            </tr>
        </table><br>
"@
        Add-Content $diskReport $memorySection
    } catch {
        Write-Host "No se pudo obtener la información de memoria para $serverName. Error: $_"
    }

    # Información del disco
    try {
        $disks = Get-WmiObject -ComputerName $serverName -Class Win32_LogicalDisk -Filter "Size > 0"
        if ($disks -eq $null) {
            Write-Host "No disks found for $serverName."
            continue
        }
    } catch {
        Write-Host "Failed to get WMI object for $serverName. Error: $_"
        continue
    }

    $serverName = $serverName.ToUpper()



}

 

# Creamos una tabla al final del informe que muestre la leyenda de colores para la crítica y la advertencia

$tableDescription = "

<br><table width='20%'>

<tr bgcolor='White'>

    <td width='10%' align='center' bgcolor='#FBB917'>Warning less than 30% free space</td>

    <td width='10%' align='center' bgcolor='#FF0000'>Critical less than 20% free space</td>

</tr>

"

Add-Content $diskReport $tableDescription

Add-Content $diskReport "</body></html>"

 
 ~~~


# en este tenemos los servidores que presentan algun tipo de Alertas, o problemas

~~~sql
#*********************************************************#
#* Monitor de espacio en Disco                           *#
#* Alejandro Jimenez                                     *#
#*********************************************************#
#* Modificado por Alejandro Jimenez 2024-10-31           *#
#*********************************************************#

# Continua aun encuentre algun error
$ErrorActionPreference = "Continue";

# Ajustamos el nivel de umbral para la alerta
$percentWarning = 30;
$percentCritcal = 20;
$percentMemoryWarning = 90  # Warning si el consumo de memoria es mayor o igual al 90%

# REPORT PROPERTIES
# Path to the report
$reportPath = "C:\CleanSenseF\Logs\";  # Configurar la ruta donde se guardaran los reportes de logs

# Report name
$reportName = "EspacioDiscoRpt_$(get-date -format ddMMyyyy).html";

# Path and Report name together
$diskReport = $reportPath + $reportName

# Set colors for table cell backgrounds
$redColor = "#FF0000"
$orangeColor = "#FBB917"
$whiteColor  = "#FFFFFF"
$greenColor  =  "#00FF00"

# Obtiene el Listado de Servidores\PC para realizar la verificacion del Espacion en Disco
$computers = Get-Content "C:\CleanSenseF\servers.txt";  #proveemos la ruta del archivo server.txt que contiene los equipos que queremos monitorear.

# Validate that $computers is not null or empty
if (-not $computers) {
    Write-Host "No servers found in the servers.txt file. Please ensure the file contains server names."
    exit
}

Write-Host "Servers to be checked: $computers"

$datetime = Get-Date -Format "MM-dd-yyyy_HHmmss";

# Elimina el reporte si ya se ha ejecutado hoy para que no se agregue al reporte existente
If (Test-Path $diskReport) {
    Remove-Item $diskReport
}

# Eliminando los archivos viejos del el log de Monitoreo..
$Daysback = "-20"  #Configuramos la limpieza de los reportes que son mayores de 20 días
$CurrentDate = Get-Date;
$DateToDelete = $CurrentDate.AddDays($Daysback);
Get-ChildItem $reportPath | Where-Object { $_.LastWriteTime -lt $DateToDelete } | Remove-Item;

# Creamos el  HTML Header del reporte
$titleDate = get-date -uformat "%m-%d-%Y - %A %H:%M:%S"
$header = "
  <html>
  <head>
  <meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'>
  <title>DiskSpace Report</title>
  <STYLE TYPE='text/css'>
  <!--
  td {
   font-family: Calibri;
   font-size: 12px;
   border-top: 1px solid #999999;
   border-right: 1px solid #999999;
   border-bottom: 1px solid #999999;
   border-left: 1px solid #999999;
   padding-top: 0px;
   padding-right: 0px;
   padding-bottom: 0px;
   padding-left: 0px;
  }
  body {
   margin-left: 5px;
   margin-top: 5px;
   margin-right: 0px;
   margin-bottom: 10px;
   table {
   border: thin solid #000000;
  }
  -->
  </style>
  </head>
  <body>
  <table width='100%'>
  <tr bgcolor='#548DD4'>
  <td colspan='7' height='30' align='center'>
  <font face='calibri' color='#003399' size='4'><strong>Reporte de Monitoreo $titleDate</strong></font>
  </td>
  </tr>
  </table>
"

Add-Content $diskReport $header

# Lista para almacenar servidores no disponibles para discos
$serversNotFound = @()

# Start processing disk space
foreach($computer in $computers) { 
    if ([string]::IsNullOrEmpty($computer)) {
        Write-Host "Skipping empty computer name."
        continue
    }

    Write-Host "Checking computer: $computer"

    # Separar el nombre del servidor y la instancia si existe
    $parts = $computer -split '\\'
    if ($parts.Length -eq 2) {
        $serverName = $parts[0]
        $instanceName = $parts[1]
    } elseif ($parts.Length -eq 1) {
        $serverName = $parts[0]
        $instanceName = ""
    } else {
        Write-Host "Formato incorrecto para $computer. Asegúrate de que la cadena contenga un '\\' o solo el nombre del servidor."
        continue
    }

    Write-Host "Servidor: $serverName, Instancia: $instanceName"

    # Verificar disponibilidad del servidor SQL Server
    $sqlStatus = "OK"
    $availabilityGroup = "N/A"
    $role = "N/A"

    try {
        $sqlTest = Test-NetConnection -ComputerName $serverName -Port 1433
        if ($sqlTest.TcpTestSucceeded -eq $false) {
            $sqlStatus = "No se pudo conectar"
        } else {
            # Verificar si el servidor es parte de un Availability Group
            $query = @"
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
            WHERE arcs.replica_server_name = (select @@SERVERNAME)
"@
            if ($instanceName) {
                $result = Invoke-Sqlcmd -ServerInstance "$serverName\$instanceName" -Query $query
            } else {
                $result = Invoke-Sqlcmd -ServerInstance $serverName -Query $query
            }
            if ($result) {
                $availabilityGroup = $result.AvailabilityGroupName
                $role = $result.Role
            }
        }
    } catch {
        $sqlStatus = "No se pudo conectar"
    }

    # Obtener información del disco
    try {
        $disks = Get-WmiObject -ComputerName $serverName -Class Win32_LogicalDisk -Filter "Size > 0"
        if ($disks -eq $null) {
            Write-Host "No disks found for $serverName."
            $serversNotFound += "<p><strong>Servidor:</strong> $serverName - Estado: No se pudieron obtener los discos</p>"
            continue
        }
    } catch {
        Write-Host "Failed to get WMI object for $serverName. Error: $_"
        $serversNotFound += "<p><strong>Servidor:</strong> $serverName - Estado: No se pudieron obtener los discos</p>"
        continue
    }

    $serverName = $serverName.ToUpper()

    # Añadir un encabezado para cada servidor
    $serverHeader = "
    <h2>Servidor: $serverName</h2>
    <p>Estado del SQL Server: $sqlStatus</p>
    <p>Availability Group: $availabilityGroup</p>
    <p>Role: $role</p>
    <table width='100%'><tbody>
    <tr bgcolor='#548DD4'>
    <td width='10%' align='center'>Server</td>
    <td width='5%' align='center'>Drive</td>
    <td width='15%' align='center'>Drive Label</td>
    <td width='10%' align='center'>Total Capacity(GB)</td>
    <td width='10%' align='center'>Used Capacity(GB)</td>
    <td width='10%' align='center'>Free Space(GB)</td>
    <td width='5%' align='center'>Freespace %</td>
    </tr>
    "
    Add-Content $diskReport $serverHeader

    foreach($disk in $disks) {
        $deviceID = $disk.DeviceID;
        $volName = $disk.VolumeName;
        [float]$size = $disk.Size;
        [float]$freespace = $disk.FreeSpace; 
        $percentFree = [Math]::Round(($freespace / $size) * 100);
        $sizeGB = [Math]::Round($size / 1073741824, 2);
        $freeSpaceGB = [Math]::Round($freespace / 1073741824, 2);
        $usedSpaceGB = $sizeGB - $freeSpaceGB;
        $color = $whiteColor;

        if($percentFree -lt $percentWarning) { $color = $orangeColor }
        if($percentFree -lt $percentCritcal) { $color = $redColor }

        $dataRow = "
        <tr>
            <td width='10%'>$computer</td>
            <td width='5%' align='center'>$deviceID</td>
            <td width='10%'>$volName</td>
            <td width='10%' align='center'>$sizeGB GB</td>
            <td width='10%' align='center'>$usedSpaceGB GB</td>
            <td width='10%' align='center'>$freeSpaceGB GB</td>
            <td width='5%' bgcolor=`'$color`' align='center'>$percentFree %</td>
        </tr>
        "
        Add-Content $diskReport $dataRow;
        Write-Host -ForegroundColor DarkYellow "$computer $deviceID porcentaje de espacio libre = $percentFree";
    }

    # Cerrar la tabla para cada servidor (ya contiene discos)
    Add-Content $diskReport "</tbody></table><br>"

    # Obtener información de memoria y mostrar solo si es warning o critical
    try {
        $memoryInfo = Get-WmiObject -ComputerName $serverName -Class Win32_OperatingSystem
        $totalMemory = [Math]::Round($memoryInfo.TotalVisibleMemorySize / 1MB, 2)
        $freeMemory = [Math]::Round($memoryInfo.FreePhysicalMemory / 1MB, 2)
        $usedMemory = $totalMemory - $freeMemory
        $percentUsedMemory = [Math]::Round(($usedMemory / $totalMemory) * 100)

        # Determinar color según el porcentaje de memoria usada
        $memoryColor = $greenColor
        if ($percentUsedMemory -ge $percentMemoryWarning) { $memoryColor = $orangeColor }

        # Solo agregar sección si está en estado de advertencia o crítico
        if ($percentUsedMemory -ge $percentMemoryWarning) {
            $memorySection = @"
            <h3>Consumo de Memoria del Servidor: $serverName</h3>
            <table width='100%'>
                <tr bgcolor='#548DD4'>
                    <td width='25%' align='center'>Total Memoria (GB)</td>
                    <td width='25%' align='center'>Memoria Utilizada (GB)</td>
                    <td width='25%' align='center'>Memoria Libre (GB)</td>
                    <td width='25%' align='center'>Porcentaje Usado</td>
                </tr>
                <tr>
                    <td width='25%' align='center'>$totalMemory GB</td>
                    <td width='25%' align='center'>$usedMemory GB</td>
                    <td width='25%' align='center'>$freeMemory GB</td>
                    <td width='25%' align='center' bgcolor='$memoryColor'>$percentUsedMemory %</td>
                </tr>
            </table><br>
"@
            Add-Content $diskReport $memorySection
        }
    } catch {
        Write-Host "No se pudo obtener la información de memoria para $serverName. Error: $_"
    }
}

# Agregar los servidores no encontrados al final del reporte
if ($serversNotFound.Count -gt 0) {
    $notFoundSection = "<h3>Servidores No Encontrados</h3>" + ($serversNotFound -join "")
    Add-Content $diskReport $notFoundSection
}

# Creamos una tabla al final del informe que muestre la leyenda de colores para la crítica y la advertencia
$tableDescription = "
<br><table width='20%'>
<tr bgcolor='White'>
    <td width='10%' align='center' bgcolor='#FBB917'>Warning less than 30% free space</td>
    <td width='10%' align='center' bgcolor='#FF0000'>Critical less than 20% free space</td>
</tr>
"
Add-Content $diskReport $tableDescription
Add-Content $diskReport "</body></html>"

~~~



##   No hay nada debajo de esta linea






# 

