# Obtener la fecha y hora actual para agregar al nombre del archivo
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
