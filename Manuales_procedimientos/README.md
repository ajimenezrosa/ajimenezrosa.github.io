

## Alejandro Jimenez Rosa

<table>
<thead>
<tr>
  <th>Inicio de  </th>
  <th> Manuales y Procedimientos -- AJ</th>
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

# Informacion :
<img src="https://gerenciales.com/img/eventos/5381_sistema_de_documenta_sl.jpg" alt="JuveR" width="800px">

# 

# Documentación de Proceso

## Introducción
 

# Documentación de Procedimientos de Cambios

## Menú
 - [Acceso a Herramientas](#acceso-a-herramientas)

- [1. Para Todos los Cambios](#1-para-todos-los-cambios)
- [2. Recalendarización de CH](#2-recalendarizacion-de-ch)
- [3. Cambios Estándar (Pre-evaluado)](#3-cambios-estándar-pre-evaluado)




 - [CH's para ser presentados los Jueves ](#chjueves)
 - [Plantilla para Notificación de Cambios y Mantenimiento](#planillamantenimiento)

 - [Ir al Contacto de Microsoft](#contacto-microsoft)
 - [Aprobacion de  CH EMERGENTE 2  plantilla para tomar como ejemplos](#CHEMERGENTE2plantilla)

 - [Set de disco (standard)](#discosstandar)
 - [Notificacion de finalizacion de trabajos Realizado. Ch entre otros.](#notificartrabajorealizado)

 - [Recomendaciones para Manejo de Índices](#indicesquehacer)

 - [Documentación de Cambios en Listener de SolarWinds en caso de presentar problemas](#cambiolistener)

 -  [Procedimientos Post Migración de Base de Datos](#migraciondebasededatos)`

 - [Plantilla para Eliminación de Bases de Datos en SQL Server](#eliminardb)


---




[Documentación del Proceso de Solicitud de Pago de Horas Extras](#horasextras)

[Checklist de Verificación para Ambientes de Alta Disponibilidad](#checklistAmbienteAO)

[Configuración de Clúster y Listener](#custerlistener)

[Cambio de Propietario (Owner) en EndPoints y Availability Groups para AlwaysOn en SQL Server](#owneeraocambio)


[Documentación de TSS2](#TSS2)


[Cambios Estándar y Normales para el Departamento de Bases de Datos del Banco Popular Dominicano](#cambios-estándar-y-normales-para-el-departamento-de-bases-de-datos-del-banco-popular-dominicano)


###### SSDT es una herramienta proporcionada por Microsoft que se integra con Visual Studio. Te permite realizar análisis de compatibilidad y actualizaciones de código SQL. Puedes utilizarla para identificar problemas de compatibilidad en el código SQL y hacer las actualizaciones necesarias.
[SQL Server Data Tools (SSDT)](#101)




# 

# Enlaces de Acceso
---

### <a name="acceso-a-herramientas"></a>Acceso a Herramientas

<p>Estos enlaces fundamentales son esenciales para facilitar mi trabajo diario, proporcionando acceso a las plataformas y herramientas necesarias para realizar mis tareas con eficiencia:
</p>

- [Link de PAM](https://co01uvm.corp.popular.local/webconsole/#!/passwordsafe/request)
- [FOGLIGHT](http://cohvsappfog01.corp.popular.local:8080/login/?redirect_uri=http%3A%2F%2Fcohvsappfog01.corp.popular.local%3A8080%2Faui%2Fauth&client_id=foglight&code_challenge=5c5wIa-vwjbL7vTpieTRzyylAY3GluYXcPI8T_6pB74)
- [Servicedesk](http://co01vservman/CAisd/pdmweb.exe)
---

# 

## 1. Para Todos los Cambios

Las solicitudes de cambios podrán ser rechazadas si las mismas presentan información incorrecta. Para evitar rechazos es necesario tomar en cuenta incluir de manera clara las siguientes informaciones:

- Tipificar de manera correcta el cambio:
  - Normal
  - Estándar (Pre-evaluado)
  - Emergente (Emergente-1 o Emergente-2)
- Llenar la encuesta de riesgo, excepto para los cambios estándar.
- Especificar la urgencia del cambio y el impacto para determinar la prioridad.
- Detallar paso a paso el plan de reverso e implementación.
- Incluir CI afectados, nombres de equipos, y otros detalles.
- Adjuntar evidencias de pruebas realizadas y certificaciones de usuarios.
- Procedimiento para cambios en excepción.

### Nota sobre Implementación Incompleta
Si el plan de trabajo no se completa en la ventana de tiempo asignada:
- Completar el CH inicial como Exitoso, indicando las tareas no completadas.
- Crear otro CH para continuar la implementación.

---

## 2. Recalendarización de CH

Si un cambio no es posible realizarlo en la fecha autorizada para aplicarlo, el ejecutor deberá realizar el siguiente procedimiento:
- Editar la orden de cambio para "Reschedule".
- Enviar correo al gerente explicando las causas y solicitar su acuerdo para recalendarizar, copiando a Control de Cambios.

---

## 3. Cambios Estándar (Pre-evaluado)

El procedimiento para CH pre-evaluados a seguir es el siguiente:
- Subgerente/Líder ingresa CH como Estándar con Pre-aprobación y fecha/hora deseada.
- Gestión de aprobación con el gerente.
- Contactar al personal de Control de Cambios para calendarizar.
- Iniciar y cerrar el CH según lo programado.

---

Esta documentación detalla los procedimientos para diversos tipos de cambios y cómo manejar situaciones específicas. Los enlaces te llevarán directamente a cada sección correspondiente.


# Procedimiento para CH's de los Jueves<a name="chjueves"></a>

## Aplicabilidad
Los CH's (Cambios Habituales) de los jueves aplicarán exclusivamente para:
- Control o solución de anomalías.
- Reporte regulatorio.
- Continuidad de proyecto.

## Tipo de CH's
Todos los CH's deben ser creados en formato normal para los fines mencionados.

## Proceso de Aprobación
Para su aprobación, Luis Manuel Mateo debe enviar un correo al Gerente de Producción, Victor Sanchez, con copia a Control de Cambios. Los cambios propuestos serán evaluados y aprobados mediante este proceso.

## Presentación en PowerPoint
Además, se debe incluir la presentación del CH en el PowerPoint correspondiente, según lo establecido en el proceso de aprobación.

# 

## Plantilla para Notificación de Cambios y Mantenimiento<a name="planillamantenimiento"></a>
<p>

<strong> Asunto: Inicio del CH054205 - Instalación del .Net Framework 4.6</strong>

Esperamos que este correo les encuentre bien, para su información, se estará dando inicio al siguiente CH.

Les informo que hoy, a las 8:00 PM, comenzaremos con el CH054205 para la instalación del .Net Framework 4.6 en el servidor COHVSRSTSQL04, como fue solicitado por el área de Base de Datos SQL.

Este cambio se encuentra actualmente en estado "En Ejecución". El responsable designado para esta tarea es Jeamphy Romero, quien llevará a cabo la instalación del framework.

Es importante tener en cuenta que será necesario reiniciar el servidor después de completar la instalación.</p>



<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Plantilla para Notificación de Cambios y Mantenimiento</title>
  <style>
    table {
      border-collapse: collapse;
      width: 100%;
      border: 1px solid #000;
    }
    th {
      background-color: blue;
      color: white;
    }
    th, td {
      border: 1px solid #000;
      padding: 8px;
      text-align: left;
    }
  </style>
</head>
<body>

<table>
  <tr>
    <!-- <th colspan="2">Buenas noches,</th> -->
  </tr>
  <tr>
    <!-- <td colspan="2">Para su información, se estará dando inicio al siguiente CH.</td> -->
  </tr>
  <tr>
    <th>RQ / CH</th>
    <th>CH054205 8:00 PM</th>
  </tr>
  <tr>
    <th>DESCRIPCIÓN</th>
    <td>A solicitud del área de Base de Datos SQL, se requiere instalar el .Net Framework 4.6 o superior en el servidor COHVSRSTSQL04.</td>
  </tr>
  <tr>
    <th>ESTATUS</th>
    <td>En Ejecución</td>
  </tr>
  <tr>
    <th>PARTICIPANTE(S)</th>
    <td>Jeamphy Romero</td>
  </tr>
  <tr>
    <th>DETALLES TÉCNICOS</th>
    <td>Instalar Framework</td>
  </tr>
  <tr>
    <th>NOTAS</th>
    <td>Es necesario reiniciar el servidor luego de la instalación.</td>
  </tr>

</table>

</body>
</html>


#



---

### <a name="contacto-microsoft"></a>Contacto de Microsoft

Teléfono: 9-1-888-751-2322 / 1800-751-3455 / 1809-200-8794 (Opción 1, 2, 2)

ID: 133600749
Nombre: Fausto Rodriguez

# 

## Aprobacion de  CH EMERGENTE 2  plantilla para tomar como ejemplos.<a name="CHEMERGENTE2plantilla"></a>

<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Lista de Correos y Correo Redactado</title>
  <style>
    h2 {
      color: blue;
    }
    ul {
      list-style-type: none;
      margin: 0;
      padding: 0;
    }
    li {
      margin-bottom: 8px;
    }
    table {
      border-collapse: collapse;
      width: 100%;
      border: 1px solid #000;
      margin-top: 20px;
    }
    th {
      background-color: blue;
      color: white;
      border: 1px solid #000;
      padding: 8px;
      text-align: left;
    }
    td {
      border: 1px solid #000;
      padding: 8px;
      text-align: left;
    }
  </style>
</head>
<body>

<h2>Enviado</h2>
<ul>
  <li>Luis Manuel Mateo Galvez &lt;lmmateo@bpd.com.do&gt;</li>
  <li>Victor Jose Sanchez Morales &lt;vsanchez@bpd.com.do&gt;</li>
  <!-- Otros correos de "Enviado" -->
</ul>

<h2>Copias</h2>
<ul>
  <li>Nestor Castro &lt;nestor.castro@multicomputos.com&gt;</li>
  <li>Vladimir Rosario &lt;vladimir.rosario@multicomputos.com&gt;</li>
  <!-- Otros correos de "Copias" -->
</ul>

<p>
  Asunto: Solicitud de Aprobación para CH Emergente 2<br><br>
  Estimados,<br><br>
  Espero se encuentren bien. Les escribo para solicitar su atención y aprobación para el CH emergente 2.<br><br>
  Descripción del Cambio:<br>
  A solicitud de Johny Eusebio (a través del suplidor), se requiere el retorno de las bases de datos VDI_DB_LOGS, VDI_DB_Monitoring y VDI_DB_SITE en el servidor CO01VSQL2016. Estas bases de datos se encuentran corrompidas, lo que ha afectado el funcionamiento de las VDI.<br><br>
  Fecha y Hora del Cambio Propuesto:<br>
  29 de agosto de 2023 a las 7:00 PM<br><br>
  Razón del Cambio:<br>
  Las bases de datos se encuentran corrompidas y las VDI no funcionan correctamente.<br><br>
  Agradeceríamos su revisión y aprobación para llevar a cabo este cambio urgente. Quedamos atentos a sus comentarios o sugerencias.<br><br>
  Saludos cordiales,<br>
  [Nombre]<br>
  [Posición]<br>
  [Información de Contacto]<br>
</p>

  <style>
    table {
      border-collapse: collapse;
      width: 100%;
      border: 1px solid #000;
    }
    th {
      background-color: blue;
      color: white;
      border: 1px solid #000;
      padding: 8px;
      text-align: left;
    }
    td {
      border: 1px solid #000;
      padding: 8px;
      text-align: left;
    }
  </style>
</head>
<body>

<table>
  <tr>
    <th>RFC / RFF o RFR</th>
    <th>Descripción</th>
    <th>Elemento Afectado</th>
    <th>Incluye Retiro/Entrada Equipos?</th>
    <th>Tiempo Fuera</th>
    <th>Incluye RE_DC?</th>
    <th>Justificación</th>
    <th>Fecha Cambio</th>
    <th>Hora Cambio</th>
    <th>Responsable del cambio</th>
    <th>No. Ticket y Fecha de la anomalía</th>
    <th>Fecha Ingreso QA</th>
    <th>Fecha Certificación</th>
    <th>Tiempo duración antes</th>
    <th>Tiempo duración después</th>
  </tr>
  <tr>
    <td>CH048253</td>
    <td>A solicitud de Johny Eusebio (via el suplidor) se requiere retornar las bd VDI_DB_LOGS VDI_DB_Monitoring VDI_DB_SITE en el co01vsql2016 ya están corrompidas y las VDI no están funcionando como se espera.</td>
    <td>VDI_DB_LOGS VDI_DB_Monitoring VDI_DB_SITE</td>
    <td>CO01VSQL2016</td>
    <td>0 HORAS</td>
    <td>Las bd están corrompidas y las VDI no están funcionando como se espera.</td>
    <td>El retorno de las bd es al 18 de agosto 2023 9:47 pm</td>
    <td>29/08/2023</td>
    <td>7:00 PM</td>
    <td>Rainiero Marte</td>
    <td>N/A</td>
    <td>N/A</td>
    <td>N/A</td>
    <td>N/A</td>
    <td>N/A</td>
  </tr>
</table>

</body>
</html>

# 



## Set de disco (standard)<a name="discosstandar"></a>


<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Estandarización de Discos de Servidores</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      line-height: 1.6;
      margin: 20px;
      padding: 20px;
    }
    h1 {
      text-align: center;
      color: #3498db;
    }
    table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 20px;
    }
    th, td {
      border: 1px solid #ccc;
      padding: 8px;
    }
    th {
      background-color: #3498db;
      color: white;
      text-align: left;
    }
  </style>
</head>
<body>

<h1>Estandarización de Discos de Servidores</h1>

<table>
  <tr>
    <th>SERVIDOR</th>
    <th>DRIVE LETTER</th>
    <th>SIZE (GB)</th>
    <th>TIPO DISCO</th>
    <th>LABEL</th>
    <th>DESCRIPCION</th>
  </tr>
  <tr>
    <td>Stand Alone</td>
    <td>B</td>
    <td></td>
    <td>SQL_Binaries</td>
    <td>Binarios de SQL Server</td>
  </tr>
  <tr>
    <td>Stand Alone</td>
    <td>C</td>
    <td></td>
    <td>OS_Windows</td>
    <td>Sistema Operativo</td>
  </tr>
  <tr>
    <td>Stand Alone</td>
    <td>D</td>
    <td></td>
    <td>APP_Files</td>
    <td>Disco para archivos de aplicación</td>
  </tr>
  <tr>
    <td>Stand Alone</td>
    <td>E</td>
    <td></td>
    <td>SQL_Data</td>
    <td>Archivos de Data de SQL Server</td>
  </tr>
  <tr>
    <td>Stand Alone</td>
    <td>I</td>
    <td></td>
    <td>SQL_Index</td>
    <td>Archivos de Indices de SQL Server</td>
  </tr>
  <tr>
    <td>Stand Alone</td>
    <td>L</td>
    <td></td>
    <td>SQL_Log</td>
    <td>Archivos de log de transacciones SQL Server</td>
  </tr>
  <tr>
    <td>Stand Alone</td>
    <td>P</td>
    <td></td>
    <td>OS_PageFile</td>
    <td>Archivo de paginación</td>
  </tr>
  <tr>
    <td>Stand Alone</td>
    <td>T</td>
    <td></td>
    <td>SQL_TempDB</td>
    <td>Archivos base de datos TempDB</td>
  </tr>
  <tr>
    <td>Stand Alone</td>
    <td>U</td>
    <td></td>
    <td>SQL_Backup</td>
    <td>Disco para respaldos de las bases de datos</td>
  </tr>
  <tr>
    <td>Stand Alone</td>
    <td>V</td>
    <td></td>
    <td>SQL_AUDIT</td>
    <td>Disco para auditorias</td>
  </tr>
</table>

</body>
</html>


#

## Notificacion de finalizacion de trabajos Realizado. Ch entre otros.<a name="notificartrabajorealizado"></a>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Notificación de Trabajo Completado</title>
  <style>
    /* Estilos del código previo */

    .details {
      padding: 10px;
    }
  </style>
</head>
<body>
  <!-- Encabezados y listas de correos previas -->

  <p>
    Saludos a todos,<br><br>
    Quería informarles que se ha completado el trabajo solicitado. El SQL SERVER AGENT ya estaba instalado, como se había mencionado previamente, y se ha realizado la instalación de Integration Services en el servidor CO01FRAUDEDB, tal como se especificó en el CH050587.<br><br>
    <strong>Detalles Técnicos:</strong> Se llevó a cabo la instalación siguiendo las pautas y recomendaciones de Microsoft para esta versión específica de SQL Server.<br><br>
  </p>

  <div class="details">
    <table>
      <tr>
        <th>TICKET/CHO</th>
        <td>CH050587</td>
      </tr>
      <tr>
        <th>DESCRIPCIÓN</th>
        <td>Se requiere instalar Integration Services en el servidor CO01FRAUDEDB.</td>
      </tr>
      <tr>
        <th>ESTATUS</th>
        <td>Completado</td>
      </tr>
      <tr>
        <th>PARTICIPANTE(S)</th>
        <td>Jose Alejandro Jimenez Rosa</td>
      </tr>
      <tr>
        <th>DETALLE TÉCNICO</th>
        <td>Se llevó a cabo la instalación siguiendo las pautas y recomendaciones de Microsoft para esta versión específica de SQL Server.</td>
      </tr>
    </table>
  </div>

  <p>
    Agradecemos su atención y quedamos atentos a cualquier comentario o seguimiento adicional.<br><br>
    Saludos cordiales,<br>
    

  </p>
</body>
</html>


# 

## Recomendaciones para Manejo de Índices<a name="indicesquehacer"></a>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Recomendaciones para Manejo de Índices</title>
  <style>
    /* Estilos del contenido */
    body {
      font-family: Arial, sans-serif;
      line-height: 1.6;
      padding: 20px;
    }
  </style>
</head>
<body>
  <!-- <h1>Recomendaciones para Manejo de Índices</h1> -->
  <p>
    Para futuros casos donde se requiera eliminar índices, es importante llevar a cabo algunas tareas previas antes de la implementación en producción. Aquí se detallan algunas recomendaciones clave:
  </p>

  <ul>
    <li>
      Gestionar con desarrollo la eliminación del índice en pre-producción y realizar pruebas para obtener diferentes puntos de vista antes de eliminar índices de manera masiva.
    </li>
    <li>
      No eliminar índices de manera masiva y siempre ingresar un CH solicitando la eliminación de cada índice por separado. Además, asegurarse de obtener un script de 'create' previo a la eliminación.
    </li>
  </ul>

  <p>
    De igual manera, al crear índices, es esencial evaluar los índices existentes y considerar si alguno de ellos debe ser eliminado previamente para evitar penalizaciones en el rendimiento.
  </p>

  <p>
    Siempre es recomendable crear un índice a la vez y esperar un período de tiempo antes de seguir creando más índices en caso de ser necesario. Cualquier duda o sugerencia es bienvenida.
  </p>
</body>
</html>

# 


# Documentación de Cambios en Listener de SolarWinds en caso de presentar problemas<a name="cambiolistener"></a>
## Introducción
<p>
En la implementación o puesta en producción de los servidores SolarWinds, se encontró la necesidad de realizar cambios en un listener existente. Este proceso implicó la eliminación del listener actual y la creación de uno nuevo con un nombre diferente. Sin embargo, surgió un problema debido a la persistencia del objeto en el Directorio Activo.
</p>
<p>
Para abordar este inconveniente, se solicitó la asistencia del Sr. Roberto Antonio Rodríguez Rincón, quien cuenta con experiencia en la resolución de este tipo de problemas en el pasado. El Sr. Rodríguez Rincón aplicó los permisos necesarios para permitir la eliminación y posterior creación del objeto sin contratiempos.
</p>


## Procedimiento Detallado
1. Identificación del Problema
Durante la fase de implementación de los servidores SolarWinds, se identificó la necesidad de modificar un listener existente.

2. Eliminación del Listener Actual
Se procedió a eliminar el listener actual mediante los siguientes pasos:

bash
Copy code
# Comando de Eliminación del Listener
SolarWindsCommandTool.exe --delete-listener --listener-name [NombreActual]
3. Creación de un Nuevo Listener
Se creó un nuevo listener con un nombre diferente al original:

bash
Copy code
# Comando de Creación de un Nuevo Listener
SolarWindsCommandTool.exe --create-listener --listener-name [NuevoNombre] --port [NuevoPuerto]
4. Detección de Persistencia en el Directorio Activo
Tras la eliminación del listener, se identificó la persistencia del objeto en el Directorio Activo, lo que generó conflictos para la creación del nuevo listener.

5. Asistencia de Roberto Antonio Rodríguez Rincón
Se contactó al Sr. Roberto Antonio Rodríguez Rincón para abordar la persistencia del objeto en el Directorio Activo.

6. Asignación de Permisos por el Sr. Rodríguez Rincón
El Sr. Rodríguez Rincón aplicó los siguientes permisos para permitir la eliminación y creación del objeto:

Permiso de Eliminación: Permisos para eliminar el objeto existente.
Permiso de Creación: Permisos para crear el nuevo objeto.
7. Confirmación de la Resolución
Una vez aplicados los permisos, se procedió nuevamente con la creación del nuevo listener, confirmando la resolución del problema.

Conclusiones
La asistencia del Sr. Roberto Antonio Rodríguez Rincón fue fundamental para superar los desafíos relacionados con la persistencia del objeto en el Directorio Activo. El procedimiento detallado garantiza una implementación exitosa de los cambios en el listener de SolarWinds.

Nota: Asegúrese de adaptar los comandos y nombres de objetos según la configuración específica de su entorno SolarWinds.

# 



---
# Plantilla para Eliminación de Bases de Datos en SQL Server<a name="eliminardb"></a>

## Descripción de la Orden

Se procederá a eliminar la base de datos `AmericanAirLine` del servidor `servidor Origen` debido a que la misma ya NO está brindando servicio. Esta acción tiene como objetivo mantener los entornos de trabajo limpios y organizados, asegurando un mejor rendimiento y gestión de los recursos.

### Antecedentes

- Esta base de datos fue colocada offline mediante la ejecución del cambio `CH000000`.
- La base de datos fue movida a los servidores `servidor Destino` y `servidor Destino`.

---

## Plan de Implementación

### Paso a Paso

1. **Conectar al servidor SQL Server**:

   - Asegúrate de tener acceso administrativo al servidor `servidor Origen`.

2. **Respaldo de la base de datos**:

   - Realiza un respaldo de la base de datos `AmericanAirLine` antes de eliminarla.
   - Nota: Este respaldo ya se encuentra en las siguientes rutas:
     - `\\servidor Destino`\u$\MSSQL\Backup`
     - `U:\MSSQL\Backup`

3. **Ejecutar el script de eliminación**:

   - Utiliza el siguiente script para eliminar la base de datos:

```sql
-- Conectar al servidor
USE master;
GO

-- Eliminar la base de datos
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'AmericanAirLine')
BEGIN
    DROP DATABASE AmericanAirLine;
    PRINT 'La base de datos AmericanAirLine ha sido eliminada exitosamente.';
END
ELSE
BEGIN
    PRINT 'La base de datos AmericanAirLine no existe.';
END
GO
```

4. **Verificar la eliminación**:

   - Confirma que la base de datos ha sido eliminada correctamente.

5. **Plan de reverso**:

   - En caso de ser necesario, restaura la base de datos desde el respaldo.

---

## Plan de Reverso

En caso de que necesites restaurar la base de datos, sigue estos pasos:

1. **Restaurar desde el respaldo**:
   - Utiliza el siguiente script para restaurar la base de datos desde el archivo de respaldo:

```sql
-- Restaurar la base de datos desde el archivo de respaldo
RESTORE DATABASE [AmericanAirLine]
FROM DISK = N'U:\MSSQL\AmericanAirLine.bak'
WITH FILE = 1, NOUNLOAD, STATS = 1
GO
```

2. **Verificar la restauración**:
   - Asegúrate de que la base de datos se haya restaurado correctamente y que todas las tablas y datos estén intactos.

---

Este documento puede ser utilizado como referencia y plantilla para futuras eliminaciones de bases de datos en SQL Server. Asegúrate de adaptar la información a los detalles específicos de cada caso.

--- 



## Procedimientos Post Migración de Base de Datos<a name="migraciondebasededatos">
#### Después de completar exitosamente la migración de la base de datos y asegurarnos de su correcto funcionamiento a nivel técnico, es crucial llevar a cabo una serie de pasos operativos para garantizar la integridad y eficiencia del sistema. A continuación, se detallan los procedimientos a seguir:

1. Notificación de Migración a CINTOTECA Soporte
Se recomienda generar un ticket de soporte dirigido al equipo de CINTOTECA para solicitar la incorporación de la nueva base de datos en el sistema de backup. Esto asegura que la información crítica esté respaldada adecuadamente y se pueda acceder a ella en caso de cualquier eventualidad.

2. Gestión de Backup en el Servidor de Origen
En el caso de que la base de datos original sea colocada offline o eliminada en el servidor de origen, es imperativo comunicar la suspensión de los backups correspondientes a esta base de datos. Esta medida preventiva evita posibles errores y garantiza la consistencia en las plataformas.

3. Configuración en Jobs STOS_DepuraDb_logs
Agregar la nueva base de datos a los trabajos programados, específicamente en los Jobs STOS_DepuraDb_logs. Este paso es esencial para controlar el crecimiento de los logs de la base de datos recién migrada, evitando posibles fallas en el servidor. Esta configuración ayuda a mantener un equilibrio en el espacio ocupado por los registros.

4. Verificación del Propietario de la Base de Datos
Es necesario verificar el Owner con el que se restauró la nueva base de datos. En caso de que sea diferente, ajustar el Owner del servidor para que coincida con las bases de datos existentes en el servidor. Esta uniformidad facilita la administración y coherencia en la gestión de bases de datos.

#####  Estos procedimientos post migración aseguran una transición suave y eficiente, minimizando posibles problemas operativos y garantizando la integridad de los datos en el entorno bancario.


# 


### Paso a Paso para la Solicitud de Pago de Horas Extras<a name="horasextras"></a>

1. **Colocar el archivo de las horas extras:**
   - Ubica el archivo de las horas extras en el grupo "Depto Administración Base de Datos" en Teams.

2. **Solicitar a los integrantes que coloquen sus horas extras:**
   - Pide a todos los integrantes del grupo que registren sus horas extras en el archivo correspondiente.

3. **Enviar un correo a la Sra. Yolanda Suárez:**
   - Redacta y envía un correo a la Sra. Yolanda Suárez solicitando la aprobación del Sr. Luis Manuel Mateo, Gerente de Área.

4. **Esperar la aprobación del Sr. Mateo:**
   - Una vez recibida la aprobación del Sr. Mateo, procede con la siguiente etapa.

5. **Crear un ticket a recursos humanos:**
   - Dirígete a la siguiente dirección para crear el ticket: [http://co02vsbridge/CAisd/pdmweb.exe](http://co02vsbridge/CAisd/pdmweb.exe)
   - Ruta a colocar para crear el ticket: 
     ```
     RRHH, Sistemas y Procesos y Gestión de Calidad.RRHH.Div Administrativo y Filiales.Depto Administrativo.6
     ```

6. **Dirigir el ticket a la persona correspondiente:**
   - Persona a quien está dirigido el ticket en RRHH: 
     ```
     Valenzuela Fortuna, Georibert, Joan
     ```

7. **Texto a colocar en el ticket:**
   - Asunto: `Pago Reporte horario Extendido`
   - Mensaje:
     ```
     Solicitamos su acostumbrada colaboración para el pago de las horas extras reportadas.
     Adjunto el reporte y el de acuerdo.
     ```

### Enlace al Documento en GitHub



# 



## Checklist de Verificación para Ambientes de Alta Disponibilidad<a name="checklistAmbienteAO"></a>

Este documento está diseñado como una guía paso a paso para la verificación de un ambiente de alta disponibilidad, específicamente en un clúster de FailOver de Windows. 

## Introducción y Objetivo

El objetivo principal de este documento es proporcionar un conjunto estructurado de instrucciones y comprobaciones que deben seguirse al momento de crear un nuevo ambiente, para asegurar que todos los componentes del sistema estén funcionando correctamente y sin errores. Esto incluye la configuración y el estado de los nodos del clúster, los roles, las redes y los parámetros específicos del servidor de base de datos. Al seguir esta guía, los administradores pueden asegurar la máxima disponibilidad y rendimiento del entorno, minimizando el riesgo de interrupciones inesperadas.

### Importancia de la Verificación

Realizar una verificación exhaustiva de los entornos de alta disponibilidad al crear un nuevo ambiente es fundamental para:

1. **Prevenir Fallos**: Identificar y resolver problemas potenciales antes de que causen interrupciones en el servicio.
2. **Optimizar el Rendimiento**: Asegurar que los recursos del sistema se utilicen de manera eficiente, lo que contribuye a un rendimiento óptimo.
3. **Cumplimiento de SLA**: Garantizar que los acuerdos de nivel de servicio (SLA) con los usuarios finales y clientes se cumplan mediante la reducción del tiempo de inactividad.
4. **Mantenimiento Proactivo**: Permitir una planificación adecuada de mantenimientos y actualizaciones sin afectar la disponibilidad del servicio.

### Estructura del Documento

Este documento está dividido en secciones que cubren diferentes áreas críticas del clúster de FailOver de Windows y del servidor de base de datos. Cada sección contiene pasos detallados para verificar la correcta configuración y operación de los componentes, incluyendo:

- **Configuración del Clúster de FailOver**: Verificación del estado del clúster, nodos y redes.
- **Configuración del Servidor de Base de Datos**: Ajustes de memoria, paralelismo y configuraciones específicas de bases de datos.
- **Verificación de Puertos y Conectividad**: Asegurar que los puertos críticos estén accesibles.
- **Ajustes del Sistema Operativo**: Configuraciones de rendimiento y tamaño de archivos de paginación.

Al final de cada sección, se proporcionan puntos de verificación específicos que deben ser completados y documentados por el administrador del sistema. Esto no solo garantiza que se siga un proceso consistente y exhaustivo, sino que también proporciona un registro detallado para auditorías y revisiones futuras.

---

## Verificación del Clúster de FailOver de Windows

### 1. Verificación del Nombre del Clúster
- Accede al FailOver cluster de Windows.
- Haz clic en el nombre del clúster para verificar que todo esté funcionando correctamente y no haya registros de errores en el ambiente.

### 2. Verificación de Roles
- Ir a **Roles** y verificar que todos los roles estén funcionando de manera correcta.

### 3. Verificación de Nodos
- Ir a **Nodes** y asegurarse de que los nodos estén activos, funcionando correctamente y sin errores.

### 4. Verificación de Redes
- Ir a **Networks** y verificar que el clúster tenga las tarjetas de red conectadas y que ninguna de ellas esté presentando errores.

## Verificación de Puertos

### 1. Puertos de los Servidores
- Verificar que los puertos 1433 y 5022 de los servidores tengan acceso tanto para entrada como para salida.

## Configuración del Servidor de Base de Datos

### 1. Memoria Máxima
- Verificar que el `max memory` del servidor de base de datos sea el 75% del valor de la memoria del servidor, a menos que se indique otra cosa.

### 2. Nivel de Paralelismo
- Ejecutar el query que determina el nivel de paralelismo recomendado.
- Ir a **Propiedades \ Advanced \ Max Degree of Parallelism** y colocar el valor entregado por el query.

### 3. Configuración de Remote DAC
- Ir a **Propiedades \ Facets**.
- En la ventana **Facet**, seleccionar la opción **Surface Area Configuration**.
- En la opción **RemoteDacEnabled**, colocar `True`.

### 4. Configuración de Autocrecimiento de Bases de Datos del Sistema
- Ir a las bases de datos del sistema (`master`, `model` y `msdb`).
- Ir a **Propiedades \ Files** y en **Autogrowth / Maxsize** colocar el valor en `500MB`.

### 5. Modelo de Recuperación
- Ir a las bases de datos (`model` y `msdb`).
- En **Propiedades \ Options**, colocar el **Recovery Model** en `Full`.

### 6. Configuración de TempDB
- Ir a la base de datos `TempDB`.
- En la opción **Files**, modificar el **Size (MB)** y colocar `2000` a todos menos al archivo log de la base de datos `TempDB`.

## Verificaciones Adicionales

### 1. Proxy de Mantenimiento Preventivo
- Verificar en **SQL Server Agent \ Proxies** que tenga el `Proxy_PreventiveMaintenance` colocado.

### 2. Paquetes SSIS (Opcional)
- Verificar en **SQL Server Agent \ SSIS Package Execution** que tenga esta opción colocada. ***Esto es opcional, para algunos casos esto no se requiere***

## Configuración del Sistema Operativo

### 1. Configuración Avanzada del Sistema
- Ir a **View Advanced System Setting**.
- En **Performance**, presionar el botón **Settings**.
- En la siguiente pantalla, ir a **Advanced** y hacer clic en el botón **Change**.

#### Cambios para los Discos:

- **C:**
  - Hacer clic en **Custom Size** y colocar los siguientes valores:
    - Initial Size (MB): `5192`
    - Maximum Size (MB): `5192`

- **P:**
  - Hacer clic en **Custom Size** y colocar los siguientes valores:
    - Initial Size (MB): `4096`
    - Maximum Size (MB): `16384` (***Nota: para nuestro caso, esto es un 75% del tamaño total del disco***).

# 

# 

## Configuración de Clúster y Listener<a name="custerlistener"></a>

<img src="https://bairesdev.mo.cloudinary.net/blog/2023/10/What-is-SQL-Server.jpg?tx=w_1920,q_auto">


Esta documentación describe los pasos para agregar nodos a los contenedores y configurar un clúster y un listener en un dominio.

### Pasos para Agregar Nodos a los Contenedores

1. **Identificar los Contenedores Existentes:**
   - Los contenedores de ambiente incluyen AO2022, 2029, etc.
   
2. **Agregar Nodos a los Contenedores:**
   - Determine los nodos que se agregarán a cada contenedor.
   - Use los comandos específicos de su infraestructura para agregar los nodos a los contenedores pertinentes.

### Crear el Clúster en el Dominio

1. **Crear el Objeto Clúster:**
   - Use la herramienta de administración de su dominio para crear un objeto clúster.
   - Asegúrese de que el objeto clúster esté correctamente configurado y asociado al dominio.

2. **Configurar el Listener:**
   - Cree y configure el listener necesario para el clúster.
   - Asegúrese de que el listener esté correctamente asociado al clúster creado.

### Agregar el Grupo de Permisos de Failover Cluster

1. **Agregar Clúster al Grupo de Permisos:**
   - Una vez que el clúster esté creado, agréguelo al grupo de permisos de failover cluster.
   - Asegúrese de que todos los nodos y recursos necesarios tengan los permisos adecuados para operar dentro del clúster.

### Ejemplo de Código

A continuación se muestra un ejemplo de cómo podría ser el código para realizar algunas de estas tareas en un script de PowerShell:

```powershell
# Crear el clúster
New-Cluster -Name "NombreDelCluster" -Node "Nodo1","Nodo2","Nodo3" -StaticAddress "DirecciónIP"

# Configurar el listener
Add-ClusterResource -Name "NombreDelListener" -ResourceType "IP Address" -Cluster "NombreDelCluster"
Set-ClusterParameter -Name Address -Value "DirecciónIPDelListener"

# Agregar al grupo de permisos de failover cluster
Add-ClusterGroup -Name "NombreDelGrupo" -Cluster "NombreDelCluster"
Grant-ClusterAccess -User "NombreDelUsuario" -Permission FullControl
```

### Verificación y Pruebas

1. **Verificar Configuración:**
   - Asegúrese de que todos los nodos y recursos estén configurados correctamente y sean visibles en el clúster.
   
2. **Pruebas de Failover:**
   - Realice pruebas de failover para asegurar que los recursos pueden cambiar de nodo sin problemas.
   - Verifique que el listener esté funcionando correctamente y respondiendo a las solicitudes.

### Notas Adicionales

- Es importante revisar la documentación específica de su infraestructura y software para comandos y pasos específicos.
- Asegúrese de tener permisos administrativos adecuados para realizar estas configuraciones.
- Mantenga un registro de todos los cambios realizados para futuras referencias y auditorías.

# 

Esta documentación debe incluirse en el archivo `README.md` de su repositorio de GitHub, o en un archivo de documentación específico si es necesario.



# 

## **Cambio de Propietario (Owner) en EndPoints y Availability Groups para AlwaysOn en SQL Server**<a name="owneeraocambio">


#### **Introducción**

#### El proceso de cambiar el propietario de EndPoints y Availability Groups en una configuración de AlwaysOn en SQL Server es crucial para asegurar que los servicios funcionen correctamente y que las cuentas de servicio apropiadas tengan el control necesario. Este documento proporciona los pasos detallados y los scripts necesarios para realizar estas tareas de manera segura y eficiente.



### **1. Cambio de Propietario (Owner) de un EndPoint de AlwaysOn**

#### **Paso 1: Verificación de EndPoints Existentes y su Propietario**

Antes de realizar cualquier cambio, es fundamental verificar los EndPoints existentes y su propietario actual. Esto se puede hacer ejecutando el siguiente script en la base de datos `master`:

```sql
USE master
GO
SELECT SUSER_NAME(principal_id) AS endpoint_owner, name AS endpoint_name
FROM sys.database_mirroring_endpoints
GO
```

#### **Paso 2: Verificación de Cuentas de Servicio con Permisos sobre los EndPoints**

Es importante conocer qué cuentas de servicio y usuarios tienen permisos sobre los EndPoints para asegurar que los cambios no afecten el acceso. Utilice el siguiente script:

```sql
USE master;
GO
SELECT EPS.name, SPS.STATE, CONVERT(nvarchar(38), SUSER_NAME(SPS.grantor_principal_id)) AS [GRANTED BY],
SPS.TYPE AS PERMISSION, CONVERT(nvarchar(46), SUSER_NAME(SPS.grantee_principal_id)) AS [GRANTED TO]
FROM sys.server_permissions SPS, sys.endpoints EPS 
WHERE SPS.major_id = EPS.endpoint_id AND name = 'Hadr_endpoint'
ORDER BY Permission, [GRANTED BY], [GRANTED TO];
GO
```

#### **Paso 3: Cambio de Propietario del EndPoint y Asignación de Permisos**

Para garantizar que el propietario del EndPoint sea correcto y que las cuentas de servicio necesarias tengan acceso, se deben ejecutar los siguientes bloques de código **uno a la vez**:

```sql
BEGIN TRAN
USE master;

-- Establecer el usuario SA como propietario del EndPoint.
ALTER AUTHORIZATION ON ENDPOINT::Hadr_endpoint TO corpsa;

-- Conceder permisos sobre el EndPoint a la cuenta de servicio especificada.
GRANT CONNECT ON ENDPOINT::Hadr_endpoint TO [NTAS\_SSEP-PRORPA];

-- Conceder permisos al EndPoint a la cuenta que administra el servicio principal de SQL Server.
GRANT CONNECT ON ENDPOINT::Hadr_endpoint TO [NTAS\_SSDS-PRORPA];

COMMIT
```

---

### **2. Cambio de Propietario (Owner) de un Availability Group**

#### **Paso 1: Verificación del Propietario Actual del Availability Group**

Antes de cambiar el propietario del Availability Group, es importante conocer quién es el propietario actual. Ejecute el siguiente script:

```sql
USE master
GO
SELECT g.name AS GroupName, p.name AS OwnerName
FROM sys.availability_groups AS g
JOIN sys.availability_replicas AS r ON g.group_id = r.group_id
JOIN sys.server_principals AS p ON r.owner_sid = p.sid
GO
```

#### **Paso 2: Asignación de Nuevo Propietario al Availability Group**

Finalmente, cambie el propietario del Availability Group a la cuenta de servicio del EndPoint correspondiente:

```sql
USE master
GO
ALTER AUTHORIZATION ON AVAILABILITY GROUP::ALWAYSONPRORPA TO [NTAS\_SSEP-PRORPA]
GO
```



### **Conclusión**

Al seguir estos pasos, asegurará que los EndPoints y Availability Groups de su entorno AlwaysOn estén correctamente configurados y gestionados por las cuentas de servicio adecuadas. Esto es esencial para el correcto funcionamiento y la seguridad de su infraestructura SQL Server.

**Nota:** Cada bloque de código debe ser ejecutado individualmente y con cuidado, asegurándose de que todas las cuentas de servicio sean correctas antes de realizar cualquier cambio.






# 

# Documentación de TSS2<a name="TSS2"></a>
<img src="https://img.site24x7static.com/images/es/applogs-banner-Image2.svg?format=jpg&name=large" alt="JuveR" width="800px">

**Autor:** ***José Alejandro Jiménez Rosa***

Esta documentación ha sido creada para documentar la solución presentada por Microsoft en el caso del servidor de Internet Banking del Banco Popular, que hizo failover y no se registró en los logs del servidor el 12 de junio de 2024 a las 21:35.

## Descripción de TSS2

TSS2 (Troubleshooting Support Script) de Microsoft es una herramienta diseñada para ayudar a los administradores de SQL Server a recopilar información de diagnóstico y solucionar problemas en entornos de SQL Server. Esta herramienta automatiza la recopilación de registros, configuraciones, y otros datos importantes para la solución de problemas.

## Principales Comandos

### 1. Start-TSS
Inicia la recopilación de datos.
```powershell
Start-TSS -Scenario SQLServer -OutputPath C:\TSS2Output
```

### 2. Stop-TSS
Detiene la recopilación de datos.
```powershell
Stop-TSS
```

### 3. Get-TSSStatus
Muestra el estado actual de la recopilación de datos.
```powershell
Get-TSSStatus
```

### 4. Export-TSSData
Exporta los datos recopilados a un archivo comprimido.
```powershell
Export-TSSData -OutputPath C:\TSS2Output.zip
```

## Principales Archivos de PowerShell

### 1. Start-TSS.ps1
Contiene la lógica para iniciar la recopilación de datos. Define los escenarios y los tipos de datos que se deben recopilar según el entorno especificado.

### 2. Stop-TSS.ps1
Implementa la lógica para detener la recopilación de datos, asegurándose de que todos los procesos en curso se finalicen correctamente.

### 3. Get-TSSStatus.ps1
Proporciona el estado actual de las operaciones de TSS, indicando qué datos se han recopilado y cualquier error que haya ocurrido.

### 4. Export-TSSData.ps1
Maneja la exportación y compresión de los datos recopilados para su análisis posterior.

### Análisis de Archivos de PowerShell

Para entender cómo funcionan estos scripts, aquí hay una breve descripción de cada uno:

#### `Start-TSS.ps1`
- **Propósito**: Inicia la recopilación de datos.
- **Funcionalidad**: Define qué tipo de datos se van a recopilar según el escenario especificado (por ejemplo, SQLServer).
- **Ejemplo**: Recopilar datos de procesos y exportarlos a un archivo CSV.

#### `Stop-TSS.ps1`
- **Propósito**: Detiene la recopilación de datos.
- **Funcionalidad**: Finaliza cualquier proceso de recopilación en curso de manera ordenada.

#### `Get-TSSStatus.ps1`
- **Propósito**: Proporciona el estado actual de la recopilación.
- **Funcionalidad**: Muestra información sobre qué datos se han recopilado y si ha habido errores.

#### `Export-TSSData.ps1`
- **Propósito**: Exporta los datos recopilados.
- **Funcionalidad**: Comprime los datos recopilados y los prepara para su análisis posterior.

## Ejecución en un Availability Group de SQL Server

### Posibilidad de Ejecución
TSS2 puede ejecutarse en un entorno de Availability Group de SQL Server, pero se deben considerar ciertos aspectos para evitar interferencias con el funcionamiento normal del grupo de disponibilidad.

### Posibles Riesgos
1. **Impacto en el Rendimiento**: La recopilación de datos intensiva puede consumir recursos significativos del sistema, lo que puede afectar el rendimiento del servidor SQL y, por ende, el Availability Group.
2. **Interrupciones en la Replicación**: En algunos casos, la recopilación de datos puede provocar retrasos en la replicación o incluso errores si no se maneja adecuadamente.
3. **Problemas de Conectividad**: La ejecución de scripts y la recopilación de datos puede temporalmente afectar la conectividad con los nodos del Availability Group.

### Mitigación de Riesgos
1. **Programar en Horas de Baja Carga**: Ejecutar TSS2 durante períodos de baja carga para minimizar el impacto en el rendimiento.
2. **Monitoreo Activo**: Supervisar activamente el rendimiento del servidor y la replicación durante la ejecución de TSS2.
3. **Pruebas Previas**: Realizar pruebas en un entorno de ensayo antes de implementar en producción para identificar posibles problemas.
4. **Limitación de Escenarios**: Configurar TSS2 para que recopile solo los datos necesarios, reduciendo la carga en el sistema.

## Instrucciones de Recopilación de Logs

1. **Descargar la Utilidad TSS SDP**
   - [Descargar Zip](http://aka.ms/getTSSv2)
   - Extraer los archivos.
   - Necesitas rol de administrador en la instancia de SQL para capturar los logs de SQL.

2. **Preparación del Entorno**
   - Navega al directorio donde extrajiste los archivos y copia el directorio.
   - Lanza PowerShell (NO ISE) como Administrador.
   - Cambia al directorio que copiaste (`cd <directorio>`).

3. **Ejecución del Script TSS**
   - Escribe `.\TSS.ps1 -SDP SQLbase -noPSR -AcceptEula` y presiona Enter.
   - Escribe “y” cuando se te pregunte si es la primera vez y si deseas recopilar eventos de seguridad.
   - No hagas clic en la ventana de PowerShell mientras la recopilación está en curso, ya que esto pausará la colección.

4. **Finalización y Recopilación de Datos**
   - Una vez completada la recopilación, los datos se guardarán en `C:\MS_DATA`.
   - Navega a ese directorio, comprime los archivos y súbelos a nuestro espacio de trabajo en el enlace proporcionado.

---
# 


### Cambios Estándar y Normales para el Departamento de Bases de Datos del Banco Popular Dominicano<a name="cambios-estándar-y-normales-para-el-departamento-de-bases-de-datos-del-banco-popular-dominicano"></a>

<img src="https://st4.depositphotos.com/24223224/38310/v/450/depositphotos_383100798-stock-illustration-tiny-businesswomen-and-businessmen-characters.jpg" alt="JuveR" width="800px">



#### Cambios Standard en SQL Server
1. **Modificación de Procedimientos Almacenados STOS_ de Mantenimiento del Servidor**
   - **Descripción:** Realizar modificaciones menores en procedimientos almacenados STOS_ de mantenimiento del servidor, como optimización de consultas o corrección de errores.
   - **Riesgo:** Bajo
   - **Impacto:** Mínimo

2. **Actualización de Estadísticas**
   - **Descripción:** Actualizar estadísticas de la base de datos para asegurar un rendimiento óptimo de las consultas.
   - **Riesgo:** Bajo
   - **Impacto:** Mínimo

3. **Regeneración de Índices Fragmentados**
   - **Descripción:** Reorganizar o reconstruir índices fragmentados para mantener la eficiencia de la base de datos.
   - **Riesgo:** Bajo
   - **Impacto:** Mínimo

4. **Ejecución de Scripts para Recolectar Logs de Errores del Sistema Operativo y/o SQL Server**
   - **Descripción:** Ejecutar scripts recomendados por el fabricante para recolectar logs de errores del sistema operativo y/o SQL Server para análisis y solución de problemas.
   - **Riesgo:** Bajo
   - **Impacto:** Mínimo

#### Cambios Normales en SQL Server
1. **Creación, Configuración y Eliminación de Vistas**
   - **Descripción:** Crear, configurar y eliminar vistas basadas en consultas existentes sin modificar las tablas subyacentes.
   - **Riesgo:** Bajo
   - **Impacto:** Mínimo

2. **Actualización de Vistas**
   - **Descripción:** Actualizar vistas para corregir errores o mejorar el rendimiento, sin cambiar la lógica de negocio.
   - **Riesgo:** Bajo
   - **Impacto:** Mínimo

3. **Adición de Índices**
   - **Descripción:** Agregar índices a tablas existentes para mejorar el rendimiento de las consultas.
   - **Riesgo:** Bajo
   - **Impacto:** Mínimo

4. **Modificación de Procedimientos Almacenados de Aplicativos**
   - **Descripción:** Realizar modificaciones menores en procedimientos almacenados de aplicativos existentes, como optimización de consultas o corrección de errores.
   - **Riesgo:** Bajo
   - **Impacto:** Mínimo

5. **Creación de Bases de Datos**
   - **Descripción:** Crear nuevas bases de datos según las necesidades del negocio, asegurando la correcta configuración inicial y cumplimiento de los estándares internos.
   - **Riesgo:** Bajo
   - **Impacto:** Mínimo

6. **Colocar Bases de Datos Offline**
   - **Descripción:** Colocar bases de datos en estado offline para mantenimiento o desuso temporal.
   - **Riesgo:** Bajo
   - **Impacto:** Mínimo

7. **Eliminar Bases de Datos**
   - **Descripción:** Eliminar bases de datos que ya no son necesarias y que han sido respaldadas adecuadamente.
   - **Riesgo:** Bajo
   - **Impacto:** Mínimo

8. **Parchado de Seguridad**
   - **Descripción:** Aplicar parches de seguridad recomendados por los proveedores de bases de datos sin impacto en la lógica de negocio.
   - **Riesgo:** Bajo
   - **Impacto:** Mínimo

9. **Creación de Archivos TempDB Nuevos**
   - **Descripción:** Crear nuevos archivos TempDB para mejorar el rendimiento y la capacidad de la base de datos temporal.
   - **Riesgo:** Bajo
   - **Impacto:** Mínimo

10. **Movilizar Archivos TempDB**
    - **Descripción:** Movilizar archivos TempDB a diferentes discos para optimizar el rendimiento del sistema.
    - **Riesgo:** Bajo
    - **Impacto:** Mínimo

11. **Ejecución de Scripts que Modifiquen o Eliminen Información de la Base de Datos**
    - **Descripción:** Ejecutar scripts que modifiquen o eliminen información en la base de datos según los requerimientos específicos del negocio.
    - **Riesgo:** Bajo
    - **Impacto:** Mínimo

12. **Proyectos de Migración tanto On-premise como a Cloud**
    - **Descripción:** Ejecución de proyectos de migración de bases de datos tanto a entornos on-premise como a la nube, según los requerimientos y estrategias del negocio.
    - **Riesgo:** Bajo
    - **Impacto:** Mínimo

13. **Cambios de Max Memory del Servidor de Base de Datos (Requieren Reinicio)**
    - **Descripción:** Realizar cambios en la configuración de memoria máxima del servidor de base de datos que requieren reinicio del servidor para aplicar los cambios.
    - **Riesgo:** Bajo
    - **Impacto:** Mínimo

14. **Cambios de Max Memory del Servidor de Base de Datos (No Requieren Reinicio)**
    - **Descripción:** Realizar cambios en la configuración de memoria máxima del servidor de base de datos que no requieren reinicio del servidor para aplicar los cambios.
    - **Riesgo:** Bajo
    - **Impacto:** Mínimo

#### Cambios Standard en Oracle
1. **Modificación de PL/SQL Packages**
   - **Descripción:** Realizar modificaciones menores en packages PL/SQL existentes, como optimización de consultas o corrección de errores.
   - **Riesgo:** Bajo
   - **Impacto:** Mínimo

2. **Actualización de Estadísticas**
   - **Descripción:** Actualizar estadísticas de la base de datos para asegurar un rendimiento óptimo de las consultas.
   - **Riesgo:** Bajo
   - **Impacto:** Mínimo

3. **Reorganización de Segmentos**
   - **Descripción:** Reorganizar segmentos de tablas e índices para mejorar el rendimiento y el uso del espacio.
   - **Riesgo:** Bajo
   - **Impacto:** Mínimo

4. **Ejecución de Scripts para Recolectar Logs de Errores del Sistema Operativo y/o Oracle Database**
   - **Descripción:** Ejecutar scripts recomendados por el fabricante para recolectar logs de errores del sistema operativo y/o Oracle Database para análisis y solución de problemas.
   - **Riesgo:** Bajo
   - **Impacto:** Mínimo

#### Cambios Normales en Oracle
1. **Creación, Configuración y Eliminación de Vistas**
   - **Descripción:** Crear, configurar y eliminar vistas basadas en consultas existentes sin modificar las tablas subyacentes.
   - **Riesgo:** Bajo
   - **Impacto:** Mínimo

2. **Actualización de Vistas**
   - **Descripción:** Actualizar vistas para corregir errores o mejorar el rendimiento, sin cambiar la lógica de negocio.
   - **Riesgo:** Bajo
   - **Impacto:** Mínimo

3. **Adición de Índices**
   - **Descripción:** Agregar índices a tablas existentes para mejorar el rendimiento de las consultas.
   - **Riesgo:** Bajo
   - **Impacto:** Mínimo

4. **Creación de Bases de Datos**
   - **Descripción:** Crear nuevas bases de datos según las necesidades del negocio, asegurando la correcta configuración inicial y cumplimiento de los estándares internos.
   - **Riesgo:** Bajo
   - **Impacto:** Mínimo

5. **Colocar Bases de Datos Offline**
   - **Descripción:** Colocar bases de datos en estado offline para mantenimiento o desuso temporal.
   - **Riesgo:** Bajo
   - **Impacto:** Mínimo

6. **Eliminar Bases de Datos**
   - **Descripción:** Eliminar bases de datos que ya no son necesarias y que han sido respaldadas adecuadamente.
   - **Riesgo:** Bajo
   - **Impacto:** Mínimo

7. **Parchado de Seguridad**
   - **Descripción:** Aplicar parches de seguridad recomendados por los proveedores de bases de datos sin impacto en la lógica de negocio.
   - **Riesgo:** Bajo
   - **Impacto:** Mínimo

8. **Ejecución de Scripts que Modifiquen o Eliminen Información de la Base de Datos**
   - **Descripción:** Ejecutar scripts que modifiquen o eliminen información en la base de datos según los requerimientos específicos del negocio.
   - **Riesgo:** Bajo
   - **Impacto:** Mínimo

### Recomendaciones

1. **Documentación y Respaldo:**
   - Siempre documentar los cambios realizados y asegurar que exista un respaldo actualizado antes de aplicar cualquier cambio.
   
2. **Pruebas Previas:**
   - Realizar pruebas en entornos de desarrollo o pruebas antes de implementar cambios en producción para evitar posibles interrupciones o problemas.

3. **Aprobación Adecuada:**
   - Asegurarse de obtener las aprobaciones necesarias de gerentes o comités antes de realizar cambios, siguiendo las políticas establecidas.

4. **Monitoreo Post-Implementación:**
   - Monitorear el rendimiento y el comportamiento del sistema después de aplicar los cambios para identificar y resolver rápidamente cualquier problema.

5. **Capacitación Continua:**
   - Mantener al equipo de bases de datos capacitado en las mejores prácticas y en las últimas actualizaciones de los sistemas SQL Server y Oracle.

**Todos estos CH's deberán ser registrados en el sistema de control de cambios y deberán cumplir y pasar todos los pasos de aprobación para poder ser implementados

.**
# 


# Análisis de SQL Server Data Tools (SSDT)<a name="101"></a>
<img src="https://learn.microsoft.com/es-es/sql/ssdt/media/previous-releases-of-sql-server-data-tools-ssdt-and-ssdt-bi/iso-image.png?view=sql-server-ver16" alt="JuveR" width="800px">

# 

**SQL Server Data Tools (SSDT)** es un conjunto de herramientas integradas en Visual Studio que permite a los desarrolladores y administradores de bases de datos diseñar, construir, probar y desplegar bases de datos de SQL Server, tanto locales como en la nube. SSDT es una herramienta esencial para la gestión del ciclo de vida de bases de datos, proporcionando un entorno de desarrollo unificado para bases de datos y aplicaciones.

#### **Características Principales:**

1. **Diseño y Desarrollo de Bases de Datos:**
   - SSDT permite crear proyectos de bases de datos en Visual Studio, donde puedes definir el esquema de la base de datos, almacenar procedimientos, funciones, triggers, y otros objetos de base de datos.
   - Puedes trabajar en un entorno de desarrollo offline, lo que significa que puedes diseñar y modificar la base de datos sin necesidad de conectarte a un servidor SQL.

2. **Compatibilidad de Versiones:**
   - SSDT incluye herramientas para verificar la compatibilidad de tu código SQL con diferentes versiones de SQL Server. Puedes definir el nivel de compatibilidad y obtener advertencias o errores si utilizas características que no son compatibles con la versión objetivo.

3. **Implementación de Bases de Datos:**
   - SSDT facilita la implementación de cambios en la base de datos, generando scripts de actualización que se pueden aplicar a diferentes entornos (desarrollo, pruebas, producción).
   - Puedes comparar esquemas y datos entre diferentes bases de datos y sincronizarlos.

4. **Pruebas Unitarias de Bases de Datos:**
   - SSDT permite crear y ejecutar pruebas unitarias para asegurarte de que los procedimientos almacenados, funciones, y otras partes de la base de datos funcionen correctamente.

5. **Control de Versiones y CI/CD:**
   - SSDT se integra con sistemas de control de versiones (como Git) y pipelines de CI/CD (Continuous Integration/Continuous Deployment), permitiendo la automatización del despliegue de bases de datos.

#### **Ejemplos de Uso:**

1. **Creación de un Proyecto de Base de Datos:**
   - Abre Visual Studio y selecciona "Crear un nuevo proyecto".
   - Elige "SQL Server Database Project" como tipo de proyecto.
   - Una vez creado, puedes agregar tablas, procedimientos almacenados, vistas, funciones, etc.

2. **Verificación de Compatibilidad:**
   - En el proyecto de la base de datos, ve a "Propiedades del proyecto" y selecciona la versión de SQL Server con la que deseas ser compatible.
   - Al construir el proyecto, SSDT te avisará si hay problemas de compatibilidad.

3. **Implementación de Cambios:**
   - Haz clic derecho en el proyecto y selecciona "Publicar". Esto te permitirá generar scripts de implementación o aplicar cambios directamente a una base de datos.

4. **Comparación de Esquemas:**
   - Usa la herramienta "Schema Compare" para comparar el esquema del proyecto con el esquema de una base de datos en vivo y generar scripts de sincronización.

#### **Disponibilidad y Costo:**

- **Gratuito:** SSDT es gratuito y se incluye con Visual Studio. Sin embargo, algunas características avanzadas pueden requerir una edición específica de Visual Studio, como Visual Studio Enterprise. Pero para la mayoría de las tareas relacionadas con bases de datos, la versión gratuita de Visual Studio Community es suficiente.
  
#### **Descarga y Requisitos:**

1. **Descargar Visual Studio:**
   - Puedes descargar Visual Studio (que incluye SSDT) desde [Visual Studio Downloads](https://visualstudio.microsoft.com/downloads/).

2. **Instalación de SSDT:**
   - Durante la instalación de Visual Studio, asegúrate de seleccionar la carga de trabajo "Data storage and processing" para instalar SSDT.
   - Si ya tienes Visual Studio instalado, puedes agregar SSDT desde el instalador de Visual Studio seleccionando la misma carga de trabajo.

3. **Documentación Oficial:**
   - [Documentación de SSDT](https://docs.microsoft.com/en-us/sql/ssdt/sql-server-data-tools?view=sql-server-ver15)

#### **Conclusión:**
SSDT es una herramienta poderosa y gratuita que te permite gestionar de manera efectiva proyectos de bases de datos en SQL Server. Es ideal para el desarrollo, la verificación de compatibilidad, la implementación de cambios, y el control de versiones. Su integración con Visual Studio lo convierte en una solución integral para desarrolladores y administradores de bases de datos.







*Fin del documento*

