$servidores = Get-Content -Path "C:\PowerShellDiscosServidores\servidores.txt"
$servidoresEncontrados = @()
$noEncontrados = @()

foreach ($servidor in $servidores) {
    try {
        $sqlQuery = "SELECT SERVERPROPERTY('MachineName') AS 'NombreServidor',
                        SERVERPROPERTY('InstanceName') AS 'Instancia',
                        SERVERPROPERTY('ProductLevel') AS 'ServicePack',
                        (SELECT SUM(size) FROM sys.master_files WHERE type = 0) AS 'TamanoMB'
                        FROM sys.databases"

        $conexion = New-Object System.Data.SqlClient.SqlConnection
        $conexion.ConnectionString = "Server=$servidor;Integrated Security=True;"

        $comando = $conexion.CreateCommand()
        $comando.CommandText = $sqlQuery

        $conexion.Open()
        $resultado = $comando.ExecuteReader()

        while ($resultado.Read()) {
            $datosSQL = [PSCustomObject]@{
                NombreServidor = $resultado.GetString(0)
                Instancia = $resultado.GetString(1)
                ServicePack = $resultado.GetString(2)
                TamanoMB = $resultado.GetInt64(3)
            }
            $servidoresEncontrados += $datosSQL
        }

        $conexion.Close()
    } catch {
        $errorMessage = $_.Exception.Message
        Write-Host "Error al conectarse al servidor SQL $servidor: $errorMessage" -ForegroundColor Red
        $noEncontrados += $servidor
    }
}

# Procesar $servidoresEncontrados para generar HTML y guardar resultados...
