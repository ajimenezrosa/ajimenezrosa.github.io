

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





