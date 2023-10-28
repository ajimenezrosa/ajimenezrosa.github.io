

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
- 3 [Tamanos de carpetas y archivos a partir de una ruta usando Powershell](#3)

- 4 [Leer todos los programas instalados en una PC](#4)


# 


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

No hay nada debajo de esta linea
# 

