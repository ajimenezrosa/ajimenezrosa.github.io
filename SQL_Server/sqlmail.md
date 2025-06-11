## 📬 9. Notificaciones de SQL Mail

Esta sección contiene scripts y procedimientos automatizados que utilizan SQL Mail para enviar alertas, reportes y recordatorios desde SQL Server a través de correo electrónico. Son fundamentales para la gestión proactiva y la notificación de eventos relevantes en el sistema.

---

### 💽 9.1 [Reporte de variación de espacio en disco K:\\](#reporteespacioendiscok)

Script automatizado que detecta variaciones en el uso de espacio de la unidad `K:\\` y notifica a los administradores en caso de alcanzar umbrales críticos.

---

### 🗳️ 9.2 [Notificar cambios en el padrón electoral](#notificarcambios2)

Procedimiento para identificar y reportar cambios en los registros del padrón electoral, permitiendo un seguimiento y auditoría eficaz.

---

### 📅 9.3 [Consulta para enviar por correo de e-Flow citas](#consultaseflowcitas)

Script que extrae las citas programadas en el sistema e-Flow y las envía por correo electrónico a los usuarios responsables, garantizando el cumplimiento de agendas.

---

### 📦 9.4 [Remisión de encuesta de satisfacción de servicios de mensajería](#encuestamensajeria)

Automatización para enviar encuestas de satisfacción sobre el servicio de mensajería a los usuarios, recolectando datos valiosos para la mejora del servicio.

---

### 🧾 9.5 [Reporte de registros modificados en las tablas de afiliados del INABIMA](#repafiliadosinabima)

Consulta que monitorea los cambios realizados en las tablas de afiliados pertenecientes a INABIMA, enviando reportes a los supervisores para control y trazabilidad.

---


# Reporte de Variacion Espacio en Disco K:\ <a name="reporteespacioendiscok"></a>
![](https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSCo4xsDe7NTcu8R6Gb6gIVsz9nziuLA6D6Aw&usqp=CAU)


### este reporte nos muestra el espacio disponible en el disco de en el cual se ecuentra la base de datos TRANSDOC.

# 


~~~sql
declare @email varchar(1000) = 
( select email from [AuditoriaDB].[dbo].[tblParametros] where id = 8)



DECLARE @Body NVARCHAR(MAX),
    @TableHead VARCHAR(1000),
    @TableTail VARCHAR(1000)
    --,@dias int = 2
    ,@fecha varchar(10) = convert(varchar(10), getdate(),120)



SET @TableTail = '</table></body></html>' ;
SET @TableHead = '<html><head>' + '<style>'
    + 'td {border: solid black;border-width: 1px;
    padding-left:5px;padding-right:5px;padding-top:1px;
    padding-bottom:1px;font: 11px arial} '
    + '</style>' + '</head>' + '<body>' + 
    '<h1>Reporte de Variacion Espacio en Disco K:\ Servidor 10.0.0.252 de fecha : ' + @fecha +'  </h1> '
    + '<b>Variaciones de Espacio en disco K:\ Servidor 10.0.0.252</b>' 
    --+ '<b> no Comprendidos entre las 7:00 AM y 18:00 PM </b>'
    --+'<b>(No contempla los usuarios de transdoc...) </b>'
    --+'<br>'
    + '<br><b>Fecha y hora de envio: </b>'+ CONVERT(VARCHAR(50), GETDATE(), 100) 
    + ' <br> <table cellpadding=0 cellspacing=0 border=0>' 

    + '<tr> <td bgcolor=#E6E6FA><b>ServerName</b></td>'
    + '<td bgcolor=#E6E6FA><b>DBName</b></td>'
    + '<td bgcolor=#E6E6FA><b>LogicalName</b></td>'
    + '<td bgcolor=#ffffb3><b>Drive</b></td>'
    + '<td bgcolor=#E6E6FA><b>FreeSpaceGB</b></td>'
    + '<td bgcolor=#E6E6FA><b>Date</b></td>'
    + '<td bgcolor=#E6E6FA><b>FreeSpaceGB_DateBefore</b></td>'
    + '<td bgcolor=#E6E6FA><b>DateBefore</b></td>'

    + '<td bgcolor=#E6E6FA><b>Differences in GB</b></td></tr>' ;


SET @Body = (

SELECT top 20 
    td =		 [ServerName] , ''
      ,td =		[DBName], ''
      --,[PhysicalFileLocation]
      ,td =		[LogicalName], ''
      ,td =		a.[Drive] , ''
      --,[FreeSpaceInMB]
      ,td =		a.[FreeSpaceInGB], ''
       ,td =	[Date_verif] , '' 

      ,td =		b.FreeSpaceInGB, ''
      ,td =		 b.FechaReal
      ,td =		convert(int, a.FreeSpaceInGB) - convert(int, b.FreeSpaceInGB) , ''
     
  FROM [AuditoriaDB].[dbo].[Db_Space_ServerDisk_Pdr] a
  join
  (
  select FreeSpaceInGB,  convert(varchar(10), dateadd(d,1, 
  convert(date, Date_verif)),120) fecha, Date_verif FechaReal ,
  Drive from [AuditoriaDB].[dbo].[Db_Space_ServerDisk_Pdr] 

  ) b on a.Drive = b.drive  and a.Date_verif = b.fecha

  where a.drive = 'k:\'
  order by Date_verif desc


  
            FOR   XML RAW('tr'),
                  ELEMENTS
            )



SELECT  @Body = @TableHead + ISNULL(@Body, '') + @TableTail

/*
Enviar Correo electronico 
alejandro Jimenez 
2019-11-20 
*/



EXEC sp_send_dbmail 
  @profile_name='SqlMail',
  @copy_recipients ='jose.jimenez@INABIMA.GOB.DO',
  @recipients=  @email,  --'jose.jimenez@INABIMA.GOB.DO', --; ja.jimenezrosa@gmail.com',
  @subject='Reporte de Variacion Espacio en Disco K:\ Servidor 10.0.0.252 ',
  @body=@Body ,
  @body_format = 'HTML' ;


~~~
# 



# Notificar cambios en el padron Electoral<a name="notificarcambios2"></a>
#
![](https://www.diariolibre.com/binrepository/546x292/0c0/0d0/none/10904/BKBP/image-content-5565560-20150923132934_14617159_20200821143255.jpg)
# 

~~~sql
/****** Object:  StoredProcedure [dbo].[sp_ModificacionesPadron]    Script Date: 04/11/2020 08:36:21 a.m. ******/
--USE [AuditoriaDB]
--GO


/*
NOTIFICACION
de los registros modificados en el padron
usando  html y sql

 Alejandro Jimenez 
 2019-10-20
*/

if exists
(
SELECT 'CEDULA: '+ a.[CEDULA] 
, a.[NOMBRES] 
,a.[APELLIDO1]
, a.[APELLIDO2]
,a.[ComputerName] 
--,b.pc
,b.[usuario]
,b.[Comentario]
--, [username] 
,CONVERT(VARCHAR(20), [FechaRegistroAudi],120) As Fecha_Reg
 FROM [AuditoriaDB].[dbo].[CEDULADOS_Audit] a
 left join  [AuditoriaDB].[dbo].[Pc_Usuario_Inabima] b  on (ltrim( A.ComputerName) = ltrim( b.Pc))

 WHERE ENVIADO IS NULL
)
begin

declare  @ModificacionesPadron  table
(
    Cedula varchar(30)
    ,Nombres varchar(30)
    ,apellido1 varchar(20)
    ,apellido2 Varchar(20)
    ,Computador varchar(20)
    ,usuario varchar(30)
    ,Comentario varchar(100)
    ,Fecha varchar(30)
    
      )



insert into @ModificacionesPadron

SELECT 'CEDULA: '+ a.[CEDULA] 
, a.[NOMBRES] 
,a.[APELLIDO1]
, a.[APELLIDO2]
,a.[ComputerName] 
--,b.pc
,b.[usuario]
,b.[Comentario]
--, [username] 
,CONVERT(VARCHAR(20), [FechaRegistroAudi],120) As Fecha_Reg
 FROM [AuditoriaDB].[dbo].[CEDULADOS_Audit] a
 left join  [AuditoriaDB].[dbo].[Pc_Usuario_Inabima] b  on (ltrim( A.ComputerName) = ltrim( b.Pc))

 WHERE ENVIADO IS NULL


 update [AuditoriaDB].[dbo].[CEDULADOS_Audit] 
        set ENVIADO = 1 
        where ENVIADO is null



declare @email varchar(1000) =
( select email from [AuditoriaDB].[dbo].[tblParametros] where id = 3)



DECLARE @Body NVARCHAR(MAX),
    @TableHead VARCHAR(1000),
    @TableTail VARCHAR(1000)
    --,@dias int = 2
    ,@fecha varchar(10) = convert(varchar(10), getdate(),120)



SET @TableTail = '</table></body></html>' ;
SET @TableHead = '<html><head>' + '<style>'
    + 'td {border: solid black;border-width: 1px;
    padding-left:5px;padding-right:5px;padding-top:1px;
    padding-bottom:1px;font: 11px arial} '
    + '</style>' + '</head>' + '<body>' + 
    '<h1>Reporte de Registros Modificados en el Padron dia : ' + @fecha +'  </h1> '
    + '<b>Modificaciones al Padron Electroral del INABIMA</b>' 
    --+ '<b> no Comprendidos entre las 7:00 AM y 18:00 PM </b>'
    --+'<b>(No contempla los usuarios de transdoc...) </b>'
    --+'<br>'
    + '<br><b>Fecha y hora de envio: </b>'+ CONVERT(VARCHAR(50), GETDATE(), 100) 
    + ' <br> <table cellpadding=0 cellspacing=0 border=0>' 

    + '<tr> <td bgcolor=#E6E6FA><b>Cedula</b></td>'
    + '<td bgcolor=#E6E6FA><b>Nombres</b></td>'
    + '<td bgcolor=#E6E6FA><b>Apellido1</b></td>'
    + '<td bgcolor=#ffffb3><b>Apellido2</b></td>'
    + '<td bgcolor=#E6E6FA><b>Computadora</b></td>'
    + '<td bgcolor=#E6E6FA><b>Usuario</b></td>'
    + '<td bgcolor=#E6E6FA><b>Comentario</b></td>'
    + '<td bgcolor=#E6E6FA><b>Fecha</b></td></tr>' ;

SET @Body = (

SELECT --[session_id]
    td =Cedula  , '',
    td = Nombres ,'',
    td = apellido1,'',
    td = apellido2 ,'',
    td = Computador ,'',
    td = isNull(usuario,'') ,'',
    td = isnull(Comentario,'') ,'',
    td = Fecha ,''
  FROM @ModificacionesPadron
  order by Fecha desc

  
            FOR   XML RAW('tr'),
                  ELEMENTS
            )



SELECT  @Body = @TableHead + ISNULL(@Body, '') + @TableTail

/*
Enviar Correo electronico 
alejandro Jimenez 
2019-11-20 
*/

EXEC sp_send_dbmail 
  @profile_name='SqlMail',
  @copy_recipients ='jose.jimenez@INABIMA.GOB.DO',
  @recipients=  @email,  --'jose.jimenez@INABIMA.GOB.DO', --; ja.jimenezrosa@gmail.com',
  @subject='Reporte de Registros Modificados en el padrón del INABIMA.',
  @body=@Body ,
  @body_format = 'HTML' ;


end
~~~
# 



# Consulta para enviar por correo de e-Flow citas<a name="consultaseflowcitas"></a>
![](https://gdm-catalog-fmapi-prod.imgix.net/ProductScreenshot/a6161d80-6b28-4106-9fe3-970967401140.png?w=600&h=450&fit=fill&fill=blur&auto=format&q=50)
#### Crearemos una consulta de las Citas del Sistema **E-FLOW** para ser enviadas via Correo electronico al personal de servicio al Cliente tanto de Plaza Aurora como de la CEDE CENTRAL.

#### Inicialmente la idea es que esta consulta se envíe de lunes a viernes a las 3:00 p.m., en lo que estamos en pruebas, que me llegue a mí, luego incluimos al personal de atención al usuario de Plaza Aurora, yo te suministraría los correos a los que esto debe llegar.

#### El servidor está en el 10.0.0.168 es un SQL Express Edition, por teléfono te informo de las credenciales de acceso.
#

#### Esta solicitud de información fue realizada originalmente por el Sr. Teodoro Mejía quien está coordinando la parte de atención al usuario en plaza aurora. Lamentablemente el sistema que se utiliza para citas no provee esta información, no de esta forma, por lo que tuvimos que recurrir a hacerla directa desde las bases de datos.
# 
#### procederemoa a realizar un procedure que inserte los datos en el Servidor de produccion desde el servidor de E-FLOW.
# 


~~~SQL
ALTER procedure sp_enviarCitasSedna
as
/*Eliminamos los registros en caso de que el proceso 
se ejecute varias veces */
delete  [10.0.0.252].[AuditoriaDB].[dbo].[notificacionSEDNA] 
where convert(varchar(10), fechaHoraCita, 120)
 = convert(varchar(10), getdate()+1, 120)

/*
Alejandro JImenez 
2021.4.15
Insertamos los datos en el servidor sql de produccion

esto para poder realizar el envio de los datos desde el 

servidor Mail de Sql server.
*/
INSERT INTO [10.0.0.252].[AuditoriaDB].[dbo].[notificacionSEDNA]
           ([NumeroDocumento]
           ,[Nombres]
           ,[Apellidos]
           ,[FechaHoraCita]
           ,[CodigoCita]
           ,[Servicio]
           ,[CreadaPor])
select dac.ClientDocumentNumber as NumeroDocumento,
       UPPER(dac.ClientName) as Nombres,
       UPPER(dac.ClientLastName) as Apellidos,
       da.AppointmentDate as FechaHoraCita,
       da.AppointmentCode as CodigoCita,
       ds.[Description] as Servicio,
       UPPER(da.UserCode) CreadaPor
     --Into [10.0.0.252].[AuditoriaDB].[dbo].[notificacionSEDNA]
  from dbo.Appointment da
  left join dbo.AppointmentClient dac
    on ( da.AppointmentClientId = dac.AppointmentClientId )
  left join dbo.AppointmentByService das
    on ( da.AppointmentId = das.AppointmentId )
  left join dbo.[Service] ds
    on ( das.ServiceId = ds.ServiceId )
 where CAST(AppointmentDate as DATE) = CAST(GETDATE() + 1 as DATE)
 order by AppointmentDate asc;

 --Activar envio de correo via sqlmail
--esto hace que se dispare un Tregger para que reporte sea enviado 

insert into  [10.0.0.252].[AuditoriaDB].[dbo].[enviarSEDNA]
select fecha = convert(varchar(10), getdate(),120)
        , enviar = 1

go
~~~
# 


#### Como se podra notar para que esto funcione debemos tener un LinkServer hacia el servidor 10.0.0.252 que seria en este caso el servidor de produccion.

#### Esto me permitira de una forma indirecta utilizar los recursos de **Servidor de Correos Sql** de este servidor.

***La Cuestion de la falta de Servicios de Job en el Servidor de E-FLOW lo veremos mas adelante.***


### Creacion de Store Procedure que Envia las notificaciones de las citas via SqlMail.

# 


~~~sql

/*
NOTIFICACION
de los Datos del Servidor SEDNA.

 Alejandro Jimenez 
 2021.4.15
*/

alter procedure sp_EnviarCitasSEDNA
AS
if exists
(
 SELECT * from AuditoriaDB.dbo.enviarSEDNA WHERE enviar = 1 and fecha= convert(varchar(10),Getdate(), 120)
)
begin

-- en este lugar colocaremos una lista que se encuentra en una 
tabla creado para estos fines.
--   dicha lista de correos debera ser consumida por el sql y 
asi podremos actualizarla a gusto sin tener que modificar el codigo.
declare @email varchar(1000) = 'jose.jimenez@inabima.gob.do'
-- ============================================================================================
DECLARE @Body NVARCHAR(MAX),
    @TableHead VARCHAR(1000),
    @TableTail VARCHAR(1000)
    --,@dias int = 2
    ,@fecha varchar(10) = convert(varchar(10), getdate()+1,120)

SET @TableTail = '</table></body></html>' ;
SET @TableHead = '<html><head>' + '<style>'
    + 'td {border: solid black;border-width: 1px;
    padding-left:5px;padding-right:5px;padding-top:1px;
    padding-bottom:1px;font: 11px arial} '
    + '</style>' + '</head>' + '<body>' +
     '<h1>Consulta para enviar por correo de e-Flow citas: ' + @fecha +'  </h1> '
    + '<b>Registros de citas de e-Flow</b>' 
    + '<br><b>Fecha y hora de envio: </b>'+ CONVERT(VARCHAR(50), GETDATE()+1, 100) 
    + ' <br> <table cellpadding=0 cellspacing=0 border=0>' 
    + '<tr> <td bgcolor=#E6E6FA><b>NumeroDocumento</b></td>'
    + '<td bgcolor=#E6E6FA><b>Nombres</b></td>'
    + '<td bgcolor=#E6E6FA><b>Apellidos</b></td>'
    + '<td bgcolor=#ffffb3><b>FechaHoraCita</b></td>'
    + '<td bgcolor=#E6E6FA><b>CódigoCita</b></td>'
    + '<td bgcolor=#E6E6FA><b>Servicio</b></td>'
    + '<td bgcolor=#E6E6FA><b>CreadoPor</b></td></tr>' ;

SET @Body = (

SELECT td=[NumeroDocumento] ,''
      ,td=[Nombres] ,''
      ,td=[Apellidos] ,''
      ,td=[FechaHoraCita] ,''
      ,td=[CodigoCita] ,''
      ,td=[Servicio] ,''
      ,td=[CreadaPor] ,''
  FROM [AuditoriaDB].[dbo].[notificacionSEDNA]
 
    Where convert(varchar(10), fechaHoraCita, 120) = convert(varchar(10), getdate()+1, 120)
 order by [FechaHoraCita] desc

            FOR   XML RAW('tr'),
                  ELEMENTS
            )



SELECT  @Body = @TableHead + ISNULL(@Body, '') + @TableTail

-- Envio por correo Electronico utilizando el servidor SqlMail
EXEC sp_send_dbmail 
  @profile_name='SqlMail',
  @copy_recipients ='jose.jimenez@INABIMA.GOB.DO',
  @recipients=  @email,  
  @subject='Citas E-flow',
  @body=@Body ,
  @body_format = 'HTML' ;



-- Realizamos la Catulizacion de la tabla  AuditoriaDB.dbo.enviarSEDNA
-- con la misma controlamos que este envio no se realice nuevamente por error.

update AuditoriaDB.dbo.enviarSEDNA
    set enviar = 0;

end
~~~
# 



para disparar este store procedure lo haremos a travez del siguiente codigo.
el mismo se colocar en el servidor de produccion en la tabla **[enviarSEDNA]** 
# 

~~~sql
-- the definition of the function.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alejandro Jimenez
-- Create date: 2021.04.15
-- Description:	Tabla de control para los envios de correos electronicos de las citas del E-FLOW
-- =============================================
CREATE TRIGGER enviarCorreosSedna on dbo.enviarSEDNA
FOR INSERT
as
EXEC msdb.dbo.sp_EnviarCitasSEDNA
GO
~~~
# 



## Disparar una Tarea Automatica del servidor 10.0.0.168 **(Sql Express no tinene Ni job ni sql Mail)**
# 
![](https://img.freepik.com/vector-premium/icono-lampara-idea-glifo-linea-contorno-relleno-version-colorida-contorno-bombilla-abstracto-relleno_662353-164.jpg)
# 

#### Para estos propósitos podemos crear una conexión al servidor SQL usando los comandos cmd.

#### Crearemos una conexión y dispararemos un procedimiento que se encuentra en las bases de datos de E-flow.

#### El código SQL que tenemos en nuestros servidores hará el resto.

#### Luego solo tenemos que crear una tarea programada de Windows Server 2016 para este caso y dispararla en los períodos que queramos.

# 


~~~cmd
@ECHO OFF
ECHO ----------------------------------------------------------------------------
ECHO Insertando datos para Ser Enviados proceso E-FLOW
ECHO Fecha: 2021.4.15
ECHO Alejandro Jimenez
ECHO ----------------------------------------------------------------------------

CLS
Sqlcmd -S SEDNA\SQLEXPRESS -d Appointment -U sa -P sa -Q "sp_enviarCitasSedna"
Sqlcmd.close()
CLS
@EXIT
ECHO successfully finished....
ECHO exit /b 0
~~~
# 


Este codigo realiza la conexion al Servidor y dispara el procedure que queremos para este caso.

# 

# REMISIÓN ENCUESTA DE SATISFACCIÓN SERVICIOS DE MENSAJERIA<a name="encuestamensajeria"></a> 


![](https://www.beetrack.com/hubfs/Modelo%20de%20encuesta%20de%20satisfaccion%20del%20cliente.jpg)


#### Con el objetivo de evaluar a nuestros colaboradores de mensajería para mejorar la calidad en los servicios brindados, solicitamos interpongan de sus buenos y valiosos servicios a los fines de que sea completada una breve encuesta de satisfacción de la gestión realizada por los colaboradores Wilber Peña Escolástico, Wilselin Ramos y Raúl Mayora.

## Esta Solicitud fue realizada por el Departamento de Mesa DE ENTRADA  en la persona de ***Paola Ogando*** la misma quiere que este correo le sea entregado  cada dos (2) meses a un listado de supervisores o encargados de departamentos.

#### Procedimos a realizar dicha solicitud via Sql Server, integrando ***Html con Sql S*** para estos fines.  Documentamos el Caso, no por su dificultad mas si por ser un caso unico en el cual se integra la pagina Html dentro del correo sql de forma fija.   

#### Esto en Realidad lo hace ser mas simple, pero no teniamos un ejemplo de un caso similar hasta ahora.

##  Realizar el envio de las encuestas a los encargados.
#### Para Esto ejecutamos el siguiente codigo.
# 


~~~sql
/*
Alejandro Jimenez Rosa

*/
declare @listaCorreos varchar(max) = 
(SELECT listamail from  AuditoriaDB.DBO.mensajeria_mail 
where id = 1)


exec [dbo].[sp_CorreoEncuestaMensajeria] @listaCorreos

~~~
# 


#  
#### En la ***tabla mensajeria_mail*** se encentra el listdo de los encargado a los cuales se debe envia la encuesta.  Esta conformado en una lista y como se puede apreciar es el registro con el ***id # 1***



#### Anexo el procedimiento que realiza el envio del  HTML  utilizando sql server para realizar las encuestas de satisfaccion de mensajeria.

# 


~~~sql
USE [msdb]
GO
/****** Object:  StoredProcedure [dbo].[sp_CorreoEncuestaMensajeria]   
 Script Date: 14/07/2021 07:33:16 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[sp_CorreoEncuestaMensajeria]
    @emailSupervisorVC varchar(max)
as

DECLARE @Body NVARCHAR(MAX)
=
'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    
<!-- 
    <div style="margin-bottom: 50px; " >
        <img src="https://inabima.gob.do/wp-content/uploads/2021/04/LOGO-inabima.jpg" 
        alt="HTML5 Icon" 
        >
    </div> -->
    <div style="margin-bottom: 50px; " >
        <img src="data:image/jpeg;base64,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" 
        alt="HTML5 Icon" 
        >
    </div>

    <h1>
        Buenas tardes estimados,
    </h1>
    <p style="font-size: 20px;">
        Con el objetivo de evaluar a nuestros colaboradores de mensajería para mejorar la calidad en los servicios brindados, solicitamos interpongan de sus buenos y 
        valiosos servicios a los fines de que sea completada una breve encuesta de satisfacción de la gestión realizada por los 
        colaboradores  <strong>Wilber Peña Escolástico, Wilselin Ramos y Raúl Mayora.</strong> 
    </p>

    <li>
        <a href="https://forms.office.com/Pages/ResponsePage.aspx?id=2kxlrbvqc0u1nr5OmH-PrnYcBkpYTzVDlx1515JPfF9UNEJETzVZVlM2NThHTUI3MU9QNlg3SzhXTS4u" >
            <strong>
                Wilber Peña Escolástico.
            </strong>
        </a>
    </li>
    <li>    
        <a href="https://forms.office.com/pages/responsepage.aspx?id=2kxlrbvqc0u1nr5OmH-Prv4wqDaVJV1Fqx4OE-v03xVURjFaMEUxMlI3VzE5OUoxSzgyN1A3T0Q0Si4u" >
            <strong>
                Wilselin Ramos
            </strong>
        </a>
    </li>
    <!-- <li>
        <a href="https://forms.office.com/pages/responsepage.aspx?id=2kxlrbvqc0u1nr5OmH-Prv4wqDaVJV1Fqx4OE-v03xVURjFaMEUxMlI3VzE5OUoxSzgyN1A3T0Q0Si4u" >
            <strong>
                Raúl Mayora
            </strong>
        </a>
    </li> -->


    <p style="font-size: 20px;">
        ¡Tu opinión es importante para nosotros, ayudamos a mejorar!
    </p>

    <p style="font-size: 20px; font-style:italic; font-weight: 700;">

        Muchas gracias por tu colaboración.
    </p>

    <br>
    <br>
    <div>
        <img src="http://inabima.gob.do/wp-content/uploads/2021/03/imagen.png" 
        alt="HTML5 Icon" 
        >
    </div>



</body>
</html>
'

    --,@dias int = 2
--	,@fecha varchar(10) = convert(varchar(10), getdate(),120)



EXEC sp_send_dbmail 
  @profile_name='SqlMail',
  --@copy_recipients ='jose.jimenez@INABIMA.GOB.DO',
  @recipients=  @emailSupervisorVC,
  --@recipients=  @emailSupervisor, 
  @subject='REMISIÓN ENCUESTA DE SATISFACCIÓN SERVICIOS DE MENSAJERIA',
  @body=@Body ,
  @body_format = 'HTML' ;

~~~
# 



# Reporte de Registros Modificados en las tablas de Afiliados del INABIMA<a name="repafiliadosinabima"></a> 
#### Reporte de notificacion de las modificaciones en la tabla de Afiliados al Plan de retiro de **************.

![](imagenes/reporteAfiliados.jpg)
# 


~~~sql
USE [msdb]
GO
/****** Object:  StoredProcedure [dbo].[sp_NotificarCambiosAfiliados]    
Script Date: 31/08/2021 12:14:31 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[sp_NotificarCambiosAfiliados]
as

/*
Declare Variables for DML
*/

while exists (
SELECT 
  'Registro modificado para la Cedula numero :' 
   +  [Cag_Cedula]+' Con los nombres : '+ ''+ ' Apellidos : ' 
    + [cag_APELLIDO1] + ' ' + ISNULL([cag_APELLIDO2],'') + ' '
    + '' + ' ' + ' Desde la Computadora : ' + '' 
    + ' Con el Usuario de Sistemas:  ' 
  FROM [AuditoriaDB].[dbo].[tblAfiliados_Audit] 
  WHERE ENVIADO IS NULL or enviado = 0

  )
begin



declare @email varchar(1000) = 
( select email from [AuditoriaDB].[dbo].[tblParametros] where id = 8)
--'jose.jimenez@inabima.gob.do'


 
DECLARE @ReportingDate varchar(10);
 
 -- Reporting date will from the beginning of the current week
SET @ReportingDate = convert(varchar(10), getdate(), 120)
--SET @ReportingPeriodEnd = DATEADD(WEEK, DATEDIFF(WEEK, 0, DATEADD(YEAR, -3, GETDATE())) + 1, 0);
 


 /*
Declare Variables for HTML
*/
 DECLARE @Body NVARCHAR(MAX) 
DECLARE @Style NVARCHAR(MAX)= '';
 
/*
Define CSS for html to use
*/
SET @Style += +N'<style type="text/css">' + N'.tg  {border-collapse:collapse;border-spacing:0;border-color:#aaa;}'

    + N'.tg td{font-family:Arial, sans-serif;font-size:14px;
    padding:10px 5px;border-style:solid;border-width:1px;
    overflow:hidden;word-break:normal;border-color:#aaa;
    color:#333;background-color:#fafafa;}'

    + N'.tg th{font-family:Arial, sans-serif;font-size:14px;
    font-weight:normal;padding:10px 5px;border-style:solid;
    border-width:1px;overflow:hidden;word-break:normal;
    border-color:#aaa;color:#fff;background-color:#0039cb;}'

    + N'.tg .tg-9ajh{font-weight:bold;background-color:#0039cb; 
    color:#FFF}' + N'.tg .tg-hgcj{font-weight:bold;
    text-align:center}'

    + N'</style>';



/*
Declare Variables for HTML
*/
 
DECLARE @tableHTML NVARCHAR(MAX)= '';

DECLARE @IMAGENTHML NVARCHAR(1000) =		   
'<div style="margin-bottom: 50px; " ><img src="https://lh3.
googleusercontent.com/proxy/5BGJvOMR_Vsub62ydbn2peBSjRjSLnNvuTuV_Ar9p3esa6KnNB1e9inbajHN4bME-
QJW7kaeUJANLs-QG0GHVeF7wl8LG73g4MTFwVk"alt="HTML5 Icon"></
div>'   
   
           ;



 
SET @tableHTML += @Style + @tableHTML + N'<H2>Reporte de 
Registros Modificados en las tablas de Afiliados del INABIMA.' + 
CAST(@ReportingDate  AS CHAR(10)) + '</H2>'


+  N'<table class="tg">' --DEFINE TABLE

/*
Define Column Headers and Column Span for each Header Column
*/

/*
Define Column Sub-Headers
*/


    + '<tr>'
   --+ '<tr> <class="tg-9ajh"><b>Cedula</b></td>'
    + '<td class="tg-9ajh"><b>Cedula</b></td>'
    + '<td class="tg-9ajh"><b>Nombres</b></td>'
    + '<td class="tg-9ajh"><b>Genero</b></td>'
    + '<td class="tg-9ajh"><b>Sueldo</b></td>'
    + '<td class="tg-9ajh"><b>Fecha Ingreso</b></td>'
    + '<td class="tg-9ajh"><b>Es/No Docente</b></td>'
    + '<td class="tg-9ajh"><b>Evento</b></td>'
    + '<td class="tg-9ajh"><b>Fecha_Registro</b></td>'
    + '<td class="tg-9ajh"><b>Computadora</b></td>'
    + '<td class="tg-9ajh"><b>Usuario</b></td>'
    + '<td class="tg-9ajh"><b>Descripcion</b></td></tr>' 
/*
Define data for table and cast to xml
*/

/*
Define data for table and cast to xml
*/
    + CAST(( SELECT --a.[Id]
     td=		 'Cedula: ' +a.[Cag_Cedula] , ''
      ,td=		  a.[Cag_Nombre1] + ' '+ isnull(a.[Cag_Nombre2],
      '') + ' ' + isnull( [Cag_Apellido1],'') + ' ' + isnull( 
        [Cag_Apellido2],'')  , ''
      ,td=		 Case a.[Cag_Sexo] when 'M' then 'Masculino' 
      when 'F' then 'Femenino' else '-------' end , ''
      ,td=		 a.[Cag_Sueldo] , ''
      ,td=		 a.[Cag_FIngreso] , ''
      ,td=		 Case a.[cag_esdocente] when 1 then 'Docente' 
      else 'No Docente' end , ''
      ,td=		 substring( a.[audit_Action],0,17) , ''
      ,td=		 a.[FechaRegistroAudi]  , ''
      ,td=		 a.[Computername] , ''
      ,td=		 b.[usuario] , ''
     ,td=		 b.[Comentario] , ''
  FROM [AuditoriaDB].[dbo].[tblAfiliados_Audit] a
  left join  [AuditoriaDB].[dbo].[Pc_Usuario_Inabima] b  on (ltrim( A.ComputerName) = ltrim( b.Pc))
 WHERE ( ENVIADO != 1)
 --WHERE  convert(varchar(10), a.FechaRegistroAudi, 120) = '2021-08-31'

FOR
             XML PATH('tr') ,
                 TYPE
           ) AS NVARCHAR(MAX)) + N'</table>';
           



set @Body = @tableHTML +@IMAGENTHML
 


 EXEC sp_send_dbmail 
  @profile_name='SqlMail',
  @copy_recipients ='jose.jimenez@INABIMA.GOB.DO',
  @recipients=  @email,  --'jose.jimenez@INABIMA.GOB.DO', --; ja.jimenezrosa@gmail.com',
  @subject='Reporte de Registros Modificados en las tablas de Afiliados del INABIMA.',
  @body=@Body ,
  @body_format = 'HTML' ;



update [AuditoriaDB].[dbo].[tblAfiliados_Audit]
set ENVIADO = 1
where ENVIADO != 1

end
~~~
# 