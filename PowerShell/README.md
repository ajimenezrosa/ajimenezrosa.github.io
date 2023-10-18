

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
# 


## A continuación, te proporciono un código en PowerShell que extrae la información del servidor y la formatea en una tabla HTML con títulos en fondo azul:<a name="1"></a>

~~~powershell
# Obtener información del servidor
$serverInfo = Get-WmiObject -Class Win32_ComputerSystem
$osInfo = Get-WmiObject -Class Win32_OperatingSystem
$cpuInfo = Get-WmiObject -Class Win32_Processor
$sqlInfo = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -like "Microsoft SQL Server*" }

# Crear una tabla HTML
$html = @"
<html>
<head>
<style>
th {
    background-color: blue;
    color: white;
}
</style>
</head>
<body>
<table border="1">
    <tr>
        <th>Server Name</th>
        <th>IP Address</th>
        <th>O.S.</th>
        <th>O.S. Edition</th>
        <th>O.S. Version</th>
        <th>O.S. Build</th>
        <th>O.S. Arquitecture</th>
        <th>Type</th>
        <th>Clustered</th>
        <th>RAM (GB)</th>
        <th>Processor Model</th>
        <th>Installed Processors (# Sockets)</th>
        <th>Cores</th>
        <th>Logic Processors</th>
        <th>Role</th>
        <th>SQL Version</th>
        <th>SQL Edition</th>
        <th>SQL Arquitecture</th>
        <th>Service Pack Level</th>
        <th>Current SQL Build</th>
        <th>Instance Name</th>
        <th>Perform Volume Maintenance Task Policy</th>
    </tr>
    <tr>
        <td>$($serverInfo.Name)</td>
        <td>$([System.Net.Dns]::GetHostAddresses($serverInfo.Name)[0].IPAddressToString)</td>
        <td>$($osInfo.Caption)</td>
        <td>$($osInfo.CSDVersion)</td>
        <td>$($osInfo.Version)</td>
        <td>$($osInfo.BuildNumber)</td>
        <td>$($osInfo.OSArchitecture)</td>
        <td>$($serverInfo.Manufacturer)</td>
        <td>$($serverInfo.PartOfDomain)</td>
        <td>$($serverInfo.TotalPhysicalMemory / 1GB)</td>
        <td>$($cpuInfo.Name)</td>
        <td>$($cpuInfo.NumberOfCores)</td>
        <td>$($cpuInfo.NumberOfLogicalProcessors)</td>
        <td>$($serverInfo.DomainRole)</td>
        <td>$($sqlInfo.InstallDate)</td>
        <td>$($sqlInfo.Version)</td>
        <td>$($sqlInfo.Caption)</td>
        <td>$($sqlInfo.ServicePackLevel)</td>
        <td>$($sqlInfo.Version) ($sqlInfo.InstallLocation)</td>
        <td>$($sqlInfo.Name)</td>
        <td>TODO</td>
    </tr>
</table>
</body>
</html>
"@

# Guardar el contenido HTML en un archivo
$html | Out-File -FilePath "ServerInfo.html"

# Abrir el archivo en el navegador predeterminado
Invoke-Item "ServerInfo.html"

~~~

#### Este script de PowerShell obtiene información del servidor y la formatea en una tabla HTML con los títulos en fondo azul. Asegúrate de modificar el contenido de la celda "Perform Volume Maintenance Task Policy" según tus necesidades, ya que no proporcionaste detalles sobre cómo obtener ese valor específico.

#### El script guarda el resultado en un archivo HTML llamado "ServerInfo.html" y lo abre en el navegador predeterminado. Asegúrate de ejecutar el script en un entorno donde tengas permisos para acceder a la información del servidor y crear archivos.

# 




### Sacar servidores con sus bases de datos usando PowerShell<a name="2"></a>
# 
#### Este código ejecutará la consulta proporcionada en cada uno de los servidores en el archivo server_instances.txt y mostrará los resultados. Cabe mencionar que este código solo muestra los resultados en la consola de PowerShell. Si deseas adaptarlo para generar archivos HTML como antes, puedes usar la estructura y el estilo que hemos discutido en las respuestas anteriores.

~~~sql
~#==========================================================================================================#
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



