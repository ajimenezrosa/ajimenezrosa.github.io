## ☎️ 10. Central Telefónica

Esta sección incluye procedimientos relacionados con la captura y gestión de los registros de llamadas de la central telefónica institucional. Es útil para monitoreo, auditoría de comunicaciones y análisis de uso del sistema telefónico.

---

### 📞 10.1 [Cargar registros de llamadas de la central telefónica](#registrosdellamadas)

Procedimiento encargado de extraer, transformar y cargar (ETL) los datos de llamadas realizadas a través de la central telefónica hacia una base de datos SQL Server para su posterior análisis o generación de reportes.

---

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


###  Este reporte tiene la particularidad de tener un archivo de Css integrado en el es decir los estilos se manejan a traves de una variable Styles.



# Cargar Registros de Llamadas de la central Telefonica<a name="registrosdellamadas"></a>


procedimiento Sp_CDRReportTotal2 se ejecuta para colocar los datos de forma que puedan ser consumidos por el excel 
# 


~~~sql

alter procedure Sp_CDRReportTotal2
as

delete CDRReportTotal

insert into CDRReportTotal
select 
    
    --[Destination]
    --case when [Destination] = '1000' Then 'Desde Recepcion' else Destination end Origen
    cast(date as varchar(7)) Periodo
    ,subString([Dst_Channel],0,8) Destino
    ,status
    ,count(*)  Total

--Into  CDRReportTotal
FROM [dbo].[CDRReport]

where subString([Dst_Channel],5,1)  in ('1','2','3','4','5','6','7','8','9')

group by 
    
    --[Destination]
    --cast(date as varchar(10)),
    cast(date as varchar(7)) ,
    subString([Dst_Channel],0,8)
    ,status

Order by   Destino , Status

go
~~~

procedimiento Sp_CDRReportTotal se ejecuta para colocar los datos de forma que puedan ser consumidos por el excel 
~~~sql

alter procedure Sp_CDRReportTotal
as

delete CDRReportTotal


insert into CDRReportTotal
select 
    
    --[Destination]
    --case when [Destination] = '1000' Then 'Desde Recepcion' else Destination end Origen
    cast(date as varchar(10)) Periodo
    ,subString([Dst_Channel],0,8) Destino
    ,status
    ,count(*)  Total

--Into  CDRReportTotal
FROM [dbo].[CDRReport]

where subString([Dst_Channel],5,1)  in ('1','2','3','4','5','6','7','8','9')

group by 
    
    --[Destination]
    --cast(date as varchar(10)),
    date,
    subString([Dst_Channel],0,8)
    ,status

Order by cast(date as varchar(10)),  Destino , Status

go


~~~
# 




Actualizar el registro Historico de llamadas para la central Telefonica.
~~~sql

USE [AuditoriaDB]
GO


insert into [dbo].[CDRReport_Historico]
SELECT [Date]
      ,[Source]
      ,[Ring_Group]
      ,[Destination]
      ,[Src_Channel]
      ,[Account_Code]
      ,[Dst_Channel]
      ,[Status]
      ,[Duration]
      ,[UniqueID]
      ,[Recording]
      ,[Cnum]
      ,[Cnam]
      ,[OutboundCnum]
      ,[DID]


  FROM [dbo].[CDRReport]

  

GO
~~~
# 




#### [Conectar Link Server un dominio de Windows y leer Informacion]<a name="leerdominio"></a>

## Crear Linked Server
#### Lo primero que haremos será crear nuestro Linked Server, la interfaz de servicio de Active Directory, también conocida como ASDI, a Active Directory usando el siguiente código:
# 


~~~sql
USE [master]
GO

/****** Object:  LinkedServer [ADSI]    
Script Date: 28/11/2022 11:12:50 a.m. ******/
EXEC master.dbo.sp_addlinkedserver @server = N'ADSI', 
@srvproduct=N'Active Directory Service Interfaces', 
@provider=N'ADSDSOObject', @datasrc=N'adsdatasource'

 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'ADSI',
@useself=N'False',@locallogin=NULL,
@rmtuser=N'INABIMASD\Administrator',@rmtpassword='########'

GO

EXEC master.dbo.sp_serveroption @server=N'ADSI', @optname=N'collation compatible', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'ADSI', @optname=N'data access', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'ADSI', @optname=N'dist', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'ADSI', @optname=N'pub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'ADSI', @optname=N'rpc', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'ADSI', @optname=N'rpc out', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'ADSI', @optname=N'sub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'ADSI', @optname=N'connect timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'ADSI', @optname=N'collation name', @optvalue=null
GO

EXEC master.dbo.sp_serveroption @server=N'ADSI', @optname=N'lazy schema validation', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'ADSI', @optname=N'query timeout', @optvalue=N'600000'
GO

EXEC master.dbo.sp_serveroption @server=N'ADSI', @optname=N'use remote collation', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'ADSI', @optname=N'remote proc transaction promotion', @optvalue=N'true'
GO
~~~
# 


#
#### Asegúrese de Colocar los valores correctos a la variables variables @rmtuser y @rmtpassword que son (nombre de usuario y contraseña) Estas deben tener acceso al Active Directory.

# 


#### Así es como se descompone la conexión LDAP:
#### LDAP://DOMAIN.com/OU=Players,DC=DOMAIN,DC=com
#### **LDAP://Domain.com** - es el nombre de un controlador de dominio
#### **/OU=Jugadores** - esta es la Unidad de Organización, en nuestro caso (Jugadores)
#### ,**DC**: este es el nombre de dominio dividido por nombre de dominio y extensión
#### Entonces... LDAP://DomainControllerName.com/OU=OrganizationalUnit,DC=DOMINIO,DC=NOMBRE
# 


~~~sql
SELECT * FROM OpenQuery
(
ADSI,
'SELECT *
FROM  ''LDAP://inabimasd.local/CN=COMPUTERS,DC=inabimasd,DC=local''
 
') AS tblADSI
--WHERE objectClass =  ''''
~~~

~~~sql
SELECT * FROM OpenQuery
(
ADSI,
'SELECT pager, displayName, telephoneNumber, sAMAccountName,
mail, mobile, facsimileTelephoneNumber, department, physicalDeliveryOfficeName, givenname
FROM  ''LDAP://inabimasd.local/CN=Users,DC=inabimasd,DC=local''
') AS tblADSI
--WHERE objectClass =  ''''
~~~



~~~sql
SELECT * FROM OpenQuery
(
ADSI,
'SELECT pager, displayName, telephoneNumber, sAMAccountName,
mail, mobile, facsimileTelephoneNumber, department, physicalDeliveryOfficeName, givenname
FROM  ''LDAP://inabimasd.local/CN=Users,DC=inabimasd,DC=local''
') AS tblADSI
--WHERE objectClass =  ''''
~~~
#
# 