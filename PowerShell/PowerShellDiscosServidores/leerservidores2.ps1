# ...

# Definir el servidor específico
$servidorEspecifico = "DESKTOP-JV1PJU3"  # Reemplaza con el nombre de tu servidor

# Iterar solo a través del servidor específico
$datosSQL = ObtenerDatosSQL $servidorEspecifico
$datosServidor = ObtenerDatosServidor $servidorEspecifico

if ($datosSQL -is [PSCustomObject] -and $datosServidor -is [PSCustomObject]) {
    # Si se obtuvieron datos de ambos tipos de servidores, agregarlos a $resultados
    $resultados += $datosSQL, $datosServidor
} else {
    # Si no se encontró el servidor, agregarlo a $noEncontrados
    $noEncontrados += $servidorEspecifico
}

# Generar el contenido HTML para los resultados y servidores no encontrados
$fechaHora = Get-Date -Format "yyyyMMdd-HHmmss"

$htmlResultado = @"
<!DOCTYPE html>
<html>
<head>
    <title>Resultados de Servidores - $fechaHora</title>
    <style>
        body {
            font-family: Arial, sans-serif;
        }
        table {
            border-collapse: collapse;
            width: 80%;
            margin: 20px auto;
        }
        th, td {
            border: 1px solid #dddddd;
            text-align: left;
            padding: 8px;
        }
        th {
            background-color: #f2f2f2;
        }
        h2 {
            text-align: center;
        }
    </style>
</head>
<body>
    <h2>Información de Servidores</h2>
    <h3>Resultados obtenidos el $fechaHora</h3>
    <table>
        <tr>
            <th>Nombre del Servidor SQL</th>
            <th>Instancia</th>
            <th>Service Pack</th>
            <th>Tamaño de la base de datos (MB)</th>
        </tr>
"@

# Agregar datos del servidor específico al HTML
foreach ($resultado in $resultados) {
    if ($resultado.NombreServidor -eq $servidorEspecifico) {
        $htmlResultado += @"
        <tr>
            <td>$($resultado.NombreServidor)</td>
            <td>$($resultado.Instancia)</td>
            <td>$($resultado.ServicePack)</td>
            <td>$($resultado.TamanoMB)</td>
        </tr>
"@
    }
}

# Terminar el HTML
$htmlResultado += @"
    </table>
</body>
</html>
"@

# Guardar resultados en un archivo HTML
$htmlResultado | Out-File -FilePath "C:\PowerShellDiscosServidores\Resultados\ServidoresDiscos_$fechaHora.html"

# Resto del código para servidores no encontrados se mantiene igual
