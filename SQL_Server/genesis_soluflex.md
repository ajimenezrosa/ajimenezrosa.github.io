## 🧩 8. Sistemas Integrados: Genesis y Soluflex

### 📂 8.1 Sistema Genesis

Este conjunto de scripts y procedimientos se utiliza para la integración y análisis de datos provenientes del sistema de control de asistencia Genesis, alimentando reportes de Recursos Humanos y sincronización con Soluflex.

#### 🔄 8.1.1 [Ejecutar procedimiento que actualiza las tablas con los datos de ponches para reportes de RRHH](#genesiscargadatosreloj1)

Procedimiento encargado de actualizar tablas con los registros de entrada/salida capturados desde el reloj biométrico, con fines de reporte.

#### ⏱️ 8.1.2 [Cargar datos reloj](#genesiscargadatosreloj)

Carga masiva de registros de asistencia desde los relojes hacia la base de datos intermedia utilizada por Genesis.

#### 🍽️ 8.1.3 [Horas de almuerzo](#genesishorasdealmuerzo)

Consulta o procedimiento para detectar horarios de almuerzo utilizados, con fines de validación en nómina.

#### 🚫 8.1.4 [Personas que deben ponchar y no ponchan con envío a supervisores](#genesispersonasdebenponcharynoponc)

Informe de ausencias no justificadas. Automatización del envío a los supervisores.

#### 📤 8.1.5 [Insertar datos reloj a Soluflex](#queryinsertardatossoluflex25)

Query que toma los datos procesados en Genesis y los transfiere al sistema Soluflex para ser usados en procesos de nómina.

#### 🔍 8.1.6 [Verificación de salida INABIMA](#geneissalidasinabiama)

Validación específica para la institución INABIMA, asegurando la consistencia de los registros de salida.

#### 🛠️ 8.1.7 [Ejecutar procedimiento de carga de datos a Soluflex](#procedurecargadatossoluflex)

Ejecución de procedimiento almacenado que sincroniza registros desde Genesis hacia Soluflex de forma automática.

#### ⚠️ 8.1.8 [Jobs deshabilitados utilizados por Soluflex](#soluflexjobdisable)

Listado de jobs programados y deshabilitados, relacionados con los procesos de Soluflex.

#### 🔄 8.1.9 [Sincronización de empleados de Soluflex con el reloj](#procedurecargadatossoluflex)

Proceso para sincronizar los empleados existentes en Soluflex con los registrados en el sistema de reloj.

---

### 🔗 8.2 [Sincronizar datos de la tabla TA_ponchesreloj con SQL Server](#ta_ponchesrelojjob)

Consulta automatizada o job encargado de mantener actualizados los registros de la tabla `TA_ponchesreloj`, asegurando que los datos del reloj estén disponibles en SQL Server para reportes y auditorías.

---

---

# GENESIS<a name="sistemaponchesgenesis"></a>
<img src="https://hitek.com.do/wp-content/uploads/2019/10/reloj-hitek-1024x400.png?format=jpg&name=large" alt="JuveR" width="800px">

#### Esta base de datos corresponde al sistema de ponches del INABIMA.

#### A continuacion algunos de los trabajos realizados en la misma.


# Ejecutar procesure que Actualiza las tablas con los datos de los ponches para poder ejecutar el reporte de RRHH.<a name="genesiscargadatosreloj1"></a>
# 


~~~sql
declare @fecha varchar(10)
select @fecha from
openquery( [SOLUFLEX RRHH], N'EXECUTE PROCEDURE SPA_ACTUALIZA_PONCHESRELOJ ( ''2021-08-01'' , ''2021-10-07'')')
~~~

# 




# Cargar Datos Reloj<a name="genesiscargadatosreloj"></a>
# 


~~~sql
declare @fecha varchar(10) ;
declare @hora  varchar(10);
truncate table [Genesis].[PonchesDB].[DatosReloj_Cargar_temporal]

Insert into [Genesis].[PonchesDB].[DatosReloj_Cargar_temporal]
(
[NOMBRE]
      ,[CEDULA]
      ,[COD_RELOJ]
      ,[FECHA]
      ,[HORA]
      ,[CLOCKID]
      ,[TIPO_PONCHE]
)
SELECT  RTRIM(LTRIM(B.FIRSTNAME))+' '+ RTRIM(LTRIM(B.LASTNAME)) AS NOMBRE
      , REPLACE(USER1,'-','') AS CEDULA  
      ,badge COD_RELOJ, CAST(DATE AS DATE) AS FECHA
     , CAST(SUBSTRING(TIME,1,2)+':'+SUBSTRING(TIME,3,2)+':'+SUBSTRING(TIME,5,2) AS TIME) AS HORA
       , CLOCKID
       ,CASE WHEN   A.TIME BETWEEN '060000' AND '091000' THEN 'ENTRADA NORMAL'   
              WHEN   A.TIME BETWEEN '091000' AND '103000' THEN 'ENTRADA TARDE' 
              WHEN   A.TIME BETWEEN '110000' AND '150000' THEN 'ALMUERZO' 
              WHEN   A.TIME BETWEEN '160000' AND '230000' THEN 'SALIDA' ELSE  'NO AUTORIZADO' END TIPO_PONCHE

FROM [Genesis].[dbo].rawdata A RIGHT JOIN [Genesis].[dbo].employee B ON (B.EMPLNUM = A.badge)

set @fecha = (select max(fecha) from [Genesis].[PonchesDB].[DatosReloj_Cargar]) ;
set @hora  = (select max(HORA) from [Genesis].[PonchesDB].[DatosReloj_Cargar] where FECHA = @fecha ) ;

print @fecha
print @hora

Insert into [Genesis].[PonchesDB].[DatosReloj_Cargar]
(
[NOMBRE]
      ,[CEDULA]
      ,[COD_RELOJ]
      ,[FECHA]
      ,[HORA]
      ,[CLOCKID]
      ,[TIPO_PONCHE]
)
select 
a.[NOMBRE]
      ,a.[CEDULA]
      ,a.[COD_RELOJ]
      ,a.[FECHA]
      ,a.[HORA]
      ,a.[CLOCKID]
      ,a.[TIPO_PONCHE]
  from 
[Genesis].[PonchesDB].[DatosReloj_Cargar_temporal] a
left join [Genesis].[PonchesDB].[DatosReloj_Cargar] b
 on 
 (
 a.NOMBRE = b.NOMBRE
 and a.CEDULA = b.CEDULA
 and a.COD_RELOJ = b.COD_RELOJ
 
 and a.FECHA = b.FECHA
 and a.HORA = b.HORA
 and a.CLOCKID = b.CLOCKID
 and a.TIPO_PONCHE = b.TIPO_PONCHE
 
 )
where b.NOMBRE is null and a.FECHA is not null
~~~
# 


# 

# Horas de Almuerzo<a name="genesishorasdealmuerzo"></a>
# 


~~~sql

use msdb
go


declare @fecha varchar(10) = 
(
select min(Fecha) from [Genesis].[PonchesDB].[DatosReloj_Cargar] 
    where 
    --fecha = @fecha
HORA > '11:00:00' AND HORA < '15:30:00'
        and enviado = 0
        )


declare @PivotPonches table
(
Cedula varchar(13)
,Nombres varchar(150)
,Fecha varchar(10)
,Entrada varchar(10)
,Sal_almuerzo varchar(10)
,Ent_Almuerzo Varchar(10)
,Min_Almuerzo int
,Salida VArchar(10)
,Salida2 VArchar(10)
,numPonches int
,id int
)


insert into @PivotPonches
(
Cedula
,Nombres
,id
)
select a.cedula, p.Nombre
    ,ROW_NUMBER() over(order by a.cedula) as row#

 from [Genesis].PonchesDB.horarioEmpleados a
join [Genesis].PonchesDB.DescripcionHoratios b
        on a.idTipoPonche = b.id
join [Genesis].[PonchesDB].[PersonalDB] P
            on a.cedula = P.cedula2

        where b.act = 1
            and b.Dias = DATENAME(weekday, @fecha)



/*
=====
*/


update  a
    set a.Entrada = b.Hora
      ,a.Fecha = @fecha
from  @PivotPonches a,
(
select 
  --distinct

     A.cedula  --, ''
    ,isNull( B.FECHA,@fecha) Fecha --,''
    ,IsNull(B.HORA,'00:00:00' ) Hora --, ''
    ,isNull(B.COD_RELOJ,'') Reloj --, ''
    --,td = 'No Definido', ''
    ,ROW_NUMBER() over(partition by a.cedula order by b.hora) 
    NumeroPonche  -- ,''
from [Genesis].[PonchesDB].[horarioEmpleados] A
left join (
SELECT  RTRIM(LTRIM(B.FIRSTNAME))+' '+ RTRIM(LTRIM(B.LASTNAME)) 
AS NOMBRE
      , REPLACE(USER1,'-','') AS CEDULA  
      ,badge COD_RELOJ, CAST(DATE AS DATE) AS FECHA
     , min(CAST(SUBSTRING(TIME,1,2)+':'+SUBSTRING(TIME,3,2)+':'
     +SUBSTRING(TIME,5,2) AS TIME)) AS HORA
       , CLOCKID
       ,CASE WHEN   A.TIME BETWEEN '060000' AND '091000' THEN 'ENTRADA NORMAL'   
              WHEN   A.TIME BETWEEN '091000' AND '103000' THEN 'ENTRADA TARDE' 
              WHEN   A.TIME BETWEEN '110000' AND '150000' THEN 'ALMUERZO' 
              WHEN   A.TIME BETWEEN '160000' AND '230000' THEN 'SALIDA' ELSE  'NO AUTORIZADO' END TIPO_PONCHE
    ,ROW_NUMBER() Over(partition by REPLACE(USER1,'-','')  order by REPLACE(USER1,'-','') ,
    SUBSTRING(TIME,1,2)+':'+SUBSTRING(TIME,3,2)+':'+SUBSTRING(TIME,5,2) ) Row#
FROM [Genesis].[dbo].rawdata A 
RIGHT 
--left
JOIN [Genesis].[dbo].employee B ON (B.EMPLNUM = A.badge) 
            where CAST(DATE AS DATE) = @fecha 
group by
   b.firstname,b.lastname
   ,b.user1
   ,badge, date
   ,clockid,a.time

)  	B ON A.cedula = b.CEDULA 

) b
where a.Cedula = b.cedula
            and b.NumeroPonche = 1 


/*
=====================================================================================================
*/




/*
=====================================================================================================
*/


update  a
    set a.Sal_almuerzo = b.Hora
      --,a.Fecha = @fecha
from  @PivotPonches a,
(
select 
  --distinct

     A.cedula  --, ''
    ,isNull( B.FECHA,@fecha) Fecha --,''
    ,IsNull(B.HORA,'00:00:00' ) Hora --, ''
    ,isNull(B.COD_RELOJ,'') Reloj --, ''
    --,td = 'No Definido', ''
    ,ROW_NUMBER() over(partition by a.cedula order by b.hora) NumeroPonche  -- ,''
from [Genesis].[PonchesDB].[horarioEmpleados] A
left join (
SELECT  RTRIM(LTRIM(B.FIRSTNAME))+' '+ RTRIM(LTRIM(B.LASTNAME)) AS NOMBRE
      , REPLACE(USER1,'-','') AS CEDULA  
      ,badge COD_RELOJ, CAST(DATE AS DATE) AS FECHA
     , min(CAST(SUBSTRING(TIME,1,2)+':'+SUBSTRING(TIME,3,2)+':'+SUBSTRING(TIME,5,2) AS TIME)) AS HORA
       , CLOCKID
       ,CASE WHEN   A.TIME BETWEEN '060000' AND '091000' THEN
        'ENTRADA NORMAL'   
              WHEN   A.TIME BETWEEN '091000' AND '103000' THEN 
              'ENTRADA TARDE' 
              WHEN   A.TIME BETWEEN '110000' AND '150000' THEN 
              'ALMUERZO' 
              WHEN   A.TIME BETWEEN '160000' AND '230000' THEN 
              'SALIDA' ELSE  'NO AUTORIZADO' END TIPO_PONCHE

    ,ROW_NUMBER() Over(partition by REPLACE(USER1,'-','') 
     order  by REPLACE(USER1,'-','')
      ,SUBSTRING(TIME,1,2)+':'+SUBSTRING

    (TIME,3,2)+':'+SUBSTRING(TIME,5,2) ) Row#
FROM [Genesis].[dbo].rawdata A 
RIGHT 
--left
JOIN [Genesis].[dbo].employee B ON (B.EMPLNUM = A.badge) 
            where CAST(DATE AS DATE) = @fecha 
group by
   b.firstname,b.lastname
   ,b.user1
   ,badge, date
   ,clockid,a.time

)  	B ON A.cedula = b.CEDULA 

) b
where a.Cedula = b.cedula
            and b.NumeroPonche = 2 


update  a
    set a.Ent_Almuerzo = b.Hora
      --,a.Fecha = @fecha
from  @PivotPonches a,
(
select 
  --distinct

     A.cedula  --, ''
    ,isNull( B.FECHA,@fecha) Fecha --,''
    ,IsNull(B.HORA,'00:00:00' ) Hora --, ''
    ,isNull(B.COD_RELOJ,'') Reloj --, ''
    --,td = 'No Definido', ''
    ,ROW_NUMBER() over(partition by a.cedula order by b.hora) 
    NumeroPonche  -- ,''
from [Genesis].[PonchesDB].[horarioEmpleados] A
left join (
SELECT  RTRIM(LTRIM(B.FIRSTNAME))+' '+ RTRIM(LTRIM(B.LASTNAME)) AS NOMBRE
      , REPLACE(USER1,'-','') AS CEDULA  
      ,badge COD_RELOJ, CAST(DATE AS DATE) AS FECHA

     , ISNULL( min(CAST(SUBSTRING(TIME,1,2)+':'+SUBSTRING(TIME,3,
     2)+':'+SUBSTRING(TIME,5,2) AS TIME)),'00:00:00') AS HORA

       , CLOCKID
       ,CASE WHEN   A.TIME BETWEEN '060000' AND '091000' THEN 'ENTRADA NORMAL'   
              WHEN   A.TIME BETWEEN '091000' AND '103000' THEN 'ENTRADA TARDE' 
              WHEN   A.TIME BETWEEN '110000' AND '150000' THEN 'ALMUERZO' 
              WHEN   A.TIME BETWEEN '160000' AND '230000' THEN 'SALIDA' ELSE  'NO AUTORIZADO' END TIPO_PONCHE
    ,ROW_NUMBER() Over(partition by REPLACE(USER1,'-','')  order 
    by REPLACE(USER1,'-','') ,SUBSTRING(TIME,1,2)+':'+SUBSTRING
    (TIME,3,2)+':'+SUBSTRING(TIME,5,2) ) Row#
FROM [Genesis].[dbo].rawdata A 
RIGHT 
--left
JOIN [Genesis].[dbo].employee B ON (B.EMPLNUM = A.badge) 
            where CAST(DATE AS DATE) = @fecha 
group by
   b.firstname,b.lastname
   ,b.user1
   ,badge, date
   ,clockid,a.time

)  	B ON A.cedula = b.CEDULA 

) b
where a.Cedula = b.cedula
            and b.NumeroPonche = 3


update  a
    set a.Salida = b.Hora
    ,Min_Almuerzo = IsNull(datediff(minute, Sal_almuerzo , Ent_Almuerzo),0 )
      --,a.Fecha = @fecha
from  @PivotPonches a,
(
select 
  --distinct

     A.cedula  --, ''
    ,isNull( B.FECHA,@fecha) Fecha --,''
    ,IsNull(B.HORA,'00:00:00' ) Hora --, ''
    ,isNull(B.COD_RELOJ,'') Reloj --, ''
    --,td = 'No Definido', ''
    ,ROW_NUMBER() over(partition by a.cedula order by b.hora) NumeroPonche  -- ,''
from [Genesis].[PonchesDB].[horarioEmpleados] A
left join (
SELECT  RTRIM(LTRIM(B.FIRSTNAME))+' '+ RTRIM(LTRIM(B.LASTNAME)) AS NOMBRE
      , REPLACE(USER1,'-','') AS CEDULA  
      ,badge COD_RELOJ, CAST(DATE AS DATE) AS FECHA

     , ISNULL( min(CAST(SUBSTRING(TIME,1,2)+':'+SUBSTRING(TIME,3,
     2)+':'+SUBSTRING(TIME,5,2) AS TIME)),'00:00:00') AS HORA

       , CLOCKID
       ,CASE WHEN   A.TIME BETWEEN '060000' AND '091000' THEN 'ENTRADA NORMAL'   
              WHEN   A.TIME BETWEEN '091000' AND '103000' THEN 'ENTRADA TARDE' 
              WHEN   A.TIME BETWEEN '110000' AND '150000' THEN 'ALMUERZO' 
              WHEN   A.TIME BETWEEN '160000' AND '230000' THEN 
              'SALIDA' ELSE  'NO AUTORIZADO' END TIPO_PONCHE

    ,ROW_NUMBER() Over(partition by REPLACE(USER1,'-','')  order 
    by REPLACE(USER1,'-','') ,SUBSTRING(TIME,1,2)+':'+SUBSTRING(TIME,3,2)+':'+SUBSTRING(TIME,5,2) ) Row#
FROM [Genesis].[dbo].rawdata A 
RIGHT 
--left
JOIN [Genesis].[dbo].employee B ON (B.EMPLNUM = A.badge) 
            where CAST(DATE AS DATE) = @fecha 
group by
   b.firstname,b.lastname
   ,b.user1
   ,badge, date
   ,clockid,a.time

)  	B ON A.cedula = b.CEDULA 

) b
where a.Cedula = b.cedula
            and b.NumeroPonche = 4


update  a
    set a.Salida2 = b.Hora
    --,Min_Almuerzo = IsNull(datediff(minute, Sal_almuerzo , Ent_Almuerzo),0 )
      --,a.Fecha = @fecha
from  @PivotPonches a,
(
select 
  --distinct

     A.cedula  --, ''
    ,isNull( B.FECHA,@fecha) Fecha --,''
    ,IsNull(B.HORA,'00:00:00' ) Hora --, ''
    ,isNull(B.COD_RELOJ,'') Reloj --, ''
    --,td = 'No Definido', ''
    ,ROW_NUMBER() over(partition by a.cedula order by b.hora) 
    NumeroPonche  -- ,''
from [Genesis].[PonchesDB].[horarioEmpleados] A
left join (
SELECT  RTRIM(LTRIM(B.FIRSTNAME))+' '+ RTRIM(LTRIM(B.LASTNAME)) AS NOMBRE
      , REPLACE(USER1,'-','') AS CEDULA  
      ,badge COD_RELOJ, CAST(DATE AS DATE) AS FECHA
     ,ISNULL( min(CAST(SUBSTRING(TIME,1,2)+':'+SUBSTRING(TIME,3,2)+':'+SUBSTRING(TIME,5,2) AS TIME)) 
     ,'00:00:00')AS HORA
       , CLOCKID
       ,CASE WHEN   A.TIME BETWEEN '060000' AND '091000' THEN 'ENTRADA NORMAL'   
              WHEN   A.TIME BETWEEN '091000' AND '103000' THEN 'ENTRADA TARDE' 
              WHEN   A.TIME BETWEEN '110000' AND '150000' THEN 'ALMUERZO' 
              WHEN   A.TIME BETWEEN '160000' AND '230000' THEN 
              'SALIDA' ELSE  'NO AUTORIZADO' END TIPO_PONCHE
    ,ROW_NUMBER() Over(partition by REPLACE(USER1,'-','')  
    order by REPLACE(USER1,'-','') ,SUBSTRING(TIME,1,2)+':'+SUBSTRING(TIME,3,2)+':'+SUBSTRING(TIME,5,2) ) Row#
FROM [Genesis].[dbo].rawdata A 
RIGHT 
--left
JOIN [Genesis].[dbo].employee B ON (B.EMPLNUM = A.badge) 
            where CAST(DATE AS DATE) = @fecha 
group by
   b.firstname,b.lastname
   ,b.user1
   ,badge, date
   ,clockid,a.time

)  	B ON A.cedula = b.CEDULA 

) b
where a.Cedula = b.cedula
            and b.NumeroPonche = 5

/*
=====================================================================================================
*/

declare @email varchar(500) = 
(

SELECT 
      [Email]
  FROM [AuditoriaDB].[dbo].[tblParametros]
  where id = 6
)

DECLARE @Body NVARCHAR(MAX),
    @TableHead VARCHAR(1000),
    @TableTail VARCHAR(1000)
    ,@dias int = 2

if exists (
select * from  @PivotPonches
)
begin

SET @TableTail = '</table></body></html>' ;
SET @TableHead = '<html><head>' + '<style>'
    + 'td {border: solid black;border-width: 1px;
    padding-left:5px;padding-right:5px;padding-top:1px;
    padding-bottom:1px;font: 11px arial} '
    + '</style>' + '</head>' + '<body>' + '<h1>Reporte de Eventos horas de Almuerzo del: ' + @fecha +'  </h1> '
    + CONVERT(VARCHAR(50), GETDATE(), 100) 
    + ' <br> <table cellpadding=0 cellspacing=0 border=0>' 
    + '<tr> <td bgcolor=#E6E6FA><b>Cédula</b></td>'
    + '<td bgcolor=#E6E6FA><b>Nombres</b></td>'
    + '<td bgcolor=#E6E6FA><b>Fecha</b></td>'
    + '<td bgcolor=#ffffb3><b>Entrada</b></td>'
    + '<td bgcolor=#ffffb3><b>Sal_Almuerzo</b></td>'
    + '<td bgcolor=#ffffb3><b>Ent_Almuerzo</b></td>'
    + '<td bgcolor=#ffffb3><b>Minutos</b></td>'
    + '<td bgcolor=#ffffb3><b>Salida</b></td>'
    --+ '<td bgcolor=#E6E6FA><b>Tipo_ponche</b></td>'
    --+ '<td bgcolor=#E6E6FA><b>Código Reloj</b></td>'
    --+ '<td bgcolor=#E6E6FA><b>Sucursal</b></td>
    + '</tr>' ;

SET @Body = (

select 
    td = cedula, ''
    ,td = nombres, ''
    ,td = Fecha , ''
    ,td = isnull(Entrada,'00:00:00'), ''
    , td =isnull(Sal_almuerzo,'00:00:00') , ''
    ,td = isnull(Ent_Almuerzo,'00:00:00') , ''
    ,td = isnull(Min_Almuerzo,0)-60 , ''

    ,td = isnull( Salida,'00:00:00') , ''
 from @PivotPonches 
        where (Min_Almuerzo > 65 or Min_Almuerzo < 5)
                    and cedula  not in 
                (
                
                select Cedula
                    from  [Genesis].[PonchesDB].VacacionesRH
                    where  getdate() between fecha_Inicio and fecha_fin


                )

    order by nombres
 
            FOR   XML RAW('tr'),
                  ELEMENTS
            )



SELECT  @Body = @TableHead + ISNULL(@Body, '') + @TableTail



EXEC sp_send_dbmail 
  @profile_name='SqlMail',
  @copy_recipients ='jose.jimenez@INABIMA.GOB.DO; francis.rodriguez@inabima.gob.do' , 
  @recipients=  @email,  --'jose.jimenez@INABIMA.GOB.DO', --; ja.jimenezrosa@gmail.com',
  @subject='Reporte de Eventos horas de Almuerzo.',
  @body=@Body ,
  @body_format = 'HTML' ;


end

if exists (
select * from  @PivotPonches
)
begin

exec [Genesis].[dbo].[sp_EnviarCorreosDepto] @fecha

while exists(
select top 1 
   emailsupervisor
from
[genesis].[PonchesDB].[SupervisoresCorreos] 
Where  [activarEnvioCorreo]= 1
and enviado = 0
)
begin


set @email = 
(
        select top 1 
           [EMAILSUPERVISOR]
        from
        [genesis].[PonchesDB].[SupervisoresCorreos] 
            Where  [activarEnvioCorreo]= 1
                and enviado = 0
)



SET @TableTail = '</table></body></html>' ;
SET @TableHead = '<html><head>' + '<style>'
    + 'td {border: solid black;border-width: 1px;padding-left:5px;padding-right:5px;padding-top:1px;
    padding-bottom:1px;font: 11px arial} '
    + '</style>' + '</head>' + '<body>' + '<h1>Reporte de Eventos horas de Almuerzo del: ' + @fecha +   '   </h1> '
    + CONVERT(VARCHAR(50), GETDATE(), 100) 
    + ' <br> <table cellpadding=0 cellspacing=0 border=0>' 
    + '<tr> <td bgcolor=#E6E6FA><b>Cédula</b></td>'
    + '<td bgcolor=#E6E6FA><b>Nombres</b></td>'
    + '<td bgcolor=#E6E6FA><b>Fecha</b></td>'
    + '<td bgcolor=#ffffb3><b>Entrada</b></td>'
    + '<td bgcolor=#ffffb3><b>Sal_Almuerzo</b></td>'
    + '<td bgcolor=#ffffb3><b>Ent_Almuerzo</b></td>'
    + '<td bgcolor=#ffffb3><b>Minutos</b></td>'
    + '<td bgcolor=#ffffb3><b>Salida</b></td>'
    + '</tr>' ;

SET @Body = (


select 
    td = cedula, ''
    ,td = nombres, ''
    ,td = Fecha , ''
    ,td = isnull(Entrada,'00:00:00'), ''
    , td =isnull(Sal_almuerzo,'00:00:00') , ''
    ,td = isnull(Ent_Almuerzo,'00:00:00') , ''
    ,td = isnull(Min_Almuerzo,0)-60 , ''

    ,td = isnull( Salida,'00:00:00') , ''
 from @PivotPonches 
        where (Min_Almuerzo > 65 or Min_Almuerzo < 5)
                    and cedula  not in 
                (
                
                select Cedula
                    from  [Genesis].[PonchesDB].VacacionesRH
                    where  getdate() between fecha_Inicio and fecha_fin


                )
    and cedula in (
                select CEDULA_EMP from genesis.[PonchesDB].[SupervisoresCorreos] where EMAILSUPERVISOR = @email
                )


/*===========================*/

    order by nombres
 
            FOR   XML RAW('tr'),
                  ELEMENTS
            )



SELECT  @Body = @TableHead + ISNULL(@Body, '') + @TableTail

EXEC sp_send_dbmail 
  @profile_name='SqlMail',
  @copy_recipients ='jose.jimenez@INABIMA.GOB.DO' , -- ; francis.rodriguez@inabima.gob.do' , 
  @recipients=  @email,  --'jose.jimenez@INABIMA.GOB.DO', --; ja.jimenezrosa@gmail.com',
  @subject='Reporte de Eventos horas de Almuerzo.',
  @body=@Body ,
  @body_format = 'HTML' ;


  update [genesis].[PonchesDB].[SupervisoresCorreos] 
    set enviado = 1 
        Where  [activarEnvioCorreo]= 1
        and enviado = 0
        and [EMAILSUPERVISOR] = @email
  end

  update [Genesis].[PonchesDB].[DatosReloj_Cargar] 
    set enviado = 1
    where fecha = @fecha
        AND HORA > '11:00:00' AND HORA < '15:30:00'


end
~~~
# 



# Persona que deben Ponchas Salida y no Ponchan
# 


~~~sql
declare @email varchar(500) = 
(

SELECT 
      [Email]
  FROM [AuditoriaDB].[dbo].[tblParametros]
  where id = 6
)


while exists (
select distinct top 1 fecha, enviado from [Genesis].[PonchesDB].[DatosReloj_Cargar]
where enviado = 0 AND HORA < '23:00:00'

order by fecha asc

)
begin

DECLARE @Body NVARCHAR(MAX),
    @TableHead VARCHAR(1000),
    @TableTail VARCHAR(1000)
    ,@dias int = 2
    ,@fecha varchar(10) 
    
    /*
    
    Asignar fecha a enviar al personal de resursos humanos
    */
set @fecha = (
select distinct top 1 fecha from [Genesis].PonchesDB.[DatosReloj_Cargar]
where enviado < 3 AND HORA < '23:00:00'
order by fecha asc


)


--set @fecha = '2019-05-27'

SET @TableTail = '</table></body></html>' ;
SET @TableHead = '<html><head>' + '<style>'
    + 'td {border: solid black;border-width: 1px;
    padding-left:5px;padding-right:5px;padding-top:1px;padding-bottom:1px;font: 11px arial} '
    + '</style>' + '</head>' + '<body>' + 
    '<h1>Reporte de Eventos Personas No Poncharon En el Dia el: ' + @fecha +'  </h1> '
    + CONVERT(VARCHAR(50), GETDATE(), 100) 
    + ' <br> <table cellpadding=0 cellspacing=0 border=0>' 
    + '<tr> <td bgcolor=#E6E6FA><b>Cédula</b></td>'
    + '<td bgcolor=#E6E6FA><b>Nombres</b></td>'
    + '<td bgcolor=#E6E6FA><b>Fecha</b></td>'
    + '<td bgcolor=#ffffb3><b>Hora</b></td>'
    + '<td bgcolor=#E6E6FA><b>Tipo_ponche</b></td>'
    + '<td bgcolor=#E6E6FA><b>Código Reloj</b></td>'
    + '<td bgcolor=#E6E6FA><b>Sucursal</b></td></tr>' ;

SET @Body = (
select 

    td =  A.cedula, ''
    , td = Per.NOMBRE,''
    --,a.CEDULA
    , td =isNull( B.FECHA,@fecha),''
    ,td = IsNull(B.HORA,'00:00:00' ), ''
    ,td = IsNull(B.TIPO_PONCHE,'No poncho' ), ''
    ,td = isNull(B.COD_RELOJ,''), ''
    ,td = 'No Definido', ''
    
from [Genesis].[PonchesDB].[horarioEmpleados] A
left join (
SELECT  RTRIM(LTRIM(B.FIRSTNAME))+' '+ RTRIM(LTRIM(B.LASTNAME)) AS NOMBRE
      , REPLACE(USER1,'-','') AS CEDULA  
      ,badge COD_RELOJ, CAST(DATE AS DATE) AS FECHA
     , CAST(SUBSTRING(TIME,1,2)+':'+SUBSTRING(TIME,3,2)+':'+SUBSTRING(TIME,5,2) AS TIME) AS HORA
       , CLOCKID
       ,CASE WHEN   A.TIME BETWEEN '060000' AND '091000' THEN 'ENTRADA NORMAL'   
              WHEN   A.TIME BETWEEN '091000' AND '103000' THEN 'ENTRADA TARDE' 
              WHEN   A.TIME BETWEEN '110000' AND '150000' THEN 'ALMUERZO' 
              WHEN   A.TIME BETWEEN '160000' AND '230000' THEN 'SALIDA' ELSE  'NO AUTORIZADO' END TIPO_PONCHE


FROM [Genesis].[dbo].rawdata A 
RIGHT 
--left
JOIN [Genesis].[dbo].employee B ON (B.EMPLNUM = A.badge) 
            where CAST(DATE AS DATE) = @fecha 
            and 
            SUBSTRING(TIME,1,2)+':'+SUBSTRING(TIME,3,2)+':'+SUBSTRING(TIME,5,2)  < '11:00:00'

)  	B ON A.cedula = b.CEDULA


 join [Genesis].[PonchesDB].[PersonalDB] Per
                on per.cedula2 = a.cedula

join 
 (
 
select * from [Genesis].[PonchesDB].[DescripcionHoratios] where  dias = DATENAME(weekday ,getdate()) and act = 1
 ) c on c.id = A.idTipoPonche
    Where b.hora is null


 order by per.NOMBRE 


            FOR   XML RAW('tr'),
                  ELEMENTS
            )



SELECT  @Body = @TableHead + ISNULL(@Body, '') + @TableTail


EXEC sp_send_dbmail 
  @profile_name='SqlMail',
  @copy_recipients ='jose.jimenez@INABIMA.GOB.DO',
  @recipients=  @email,  --'jose.jimenez@INABIMA.GOB.DO', --; ja.jimenezrosa@gmail.com',
  @subject='Query Result',
  @body=@Body ,
  @body_format = 'HTML' ;

  update [Genesis].[PonchesDB].[DatosReloj_Cargar] 
    set enviado = 1
    where fecha = @fecha
    AND HORA < '11:00:00'


end 
~~~
# 


#
# personas que deben ponchas y no ponchan con envio a supervisores<a name="genesispersonasdebenponcharynoponc"></a>
# 


~~~sql
/*
Query de los ponches de entrada personas que deben ponchas y no ponchan.
Alejandro Jimenez 2019-06-07
*/

declare @Correo varchar(100) ;
declare @Mensaje varchar(1000);

declare @email varchar(500) = 
(

SELECT 
      [Email]
  FROM [AuditoriaDB].[dbo].[tblParametros]
  where id = 6
)
--set @email = 'jose.jimenez@inabima.gob.do'

update  [Genesis].[PonchesDB].[DatosReloj_Cargar]
    set enviado = 3 where fecha = '2019-06-11'

update [Genesis].[PonchesDB].[DatosReloj_Cargar]
set enviado = 0 where fecha  =convert(varchar(10),getdate(),120)

while exists (
select distinct top 1 fecha, enviado from [Genesis].[PonchesDB].[DatosReloj_Cargar]
where enviado = 0 
    and fecha > convert(varchar(10),getdate()-3,120)
AND HORA < '11:00:00'

order by fecha asc

)
begin

DECLARE @Body NVARCHAR(MAX),
    @TableHead VARCHAR(1000),
    @TableTail VARCHAR(1000)
    ,@dias int = 2
    ,@fecha varchar(10) 
    
    /*
    
    Asignar fecha a enviar al personal de resursos humanos
    */
set @fecha = (
select distinct top 1 fecha from [Genesis].PonchesDB.[DatosReloj_Cargar]
where enviado = 0 AND HORA < '11:00:00'
order by fecha asc
)
--set @fecha = '2019-05-27'
SET @TableTail = '</table></body></html>' ;
SET @TableHead = '<html><head>' + '<style>'
    + 'td {border: solid black;border-width: 1px;
    padding-left:5px;padding-right:5px;padding-top:1px;
    padding-bottom:1px;font: 11px arial} '
    + '</style>' + '</head>' + '<body>' + '<h1>Reporte de 
    Eventos Personas No Poncharon el: ' + @fecha +'  </h1> '
    + CONVERT(VARCHAR(50), GETDATE(), 100) 
    + ' <br> <table cellpadding=0 cellspacing=0 border=0>' 
    + '<tr> <td bgcolor=#E6E6FA><b>Cédula</b></td>'
    + '<td bgcolor=#E6E6FA><b>Nombres</b></td>'
    + '<td bgcolor=#E6E6FA><b>Fecha</b></td>'
    + '<td bgcolor=#ffffb3><b>Hora</b></td>'
    + '<td bgcolor=#E6E6FA><b>Tipo_ponche</b></td>'
    + '<td bgcolor=#E6E6FA><b>Código Reloj</b></td>'
    + '<td bgcolor=#E6E6FA><b>Sucursal</b></td></tr>' ;

SET @Body = (
select 
    td =  A.cedula, ''
    , td = Per.NOMBRE,''
    , td =isNull( B.FECHA,@fecha),''
    ,td = IsNull(B.HORA,'00:00:00' ), ''
    ,td = IsNull(B.TIPO_PONCHE,'No poncho' ), ''
    ,td = isNull(B.COD_RELOJ,''), ''
    ,td = 'No Definido', ''
    
from [Genesis].[PonchesDB].[horarioEmpleados] A
left join (
SELECT  RTRIM(LTRIM(B.FIRSTNAME))+' '+ RTRIM(LTRIM(B.LASTNAME)) AS NOMBRE
      , REPLACE(USER1,'-','') AS CEDULA  
      ,badge COD_RELOJ, CAST(DATE AS DATE) AS FECHA
     , CAST(SUBSTRING(TIME,1,2)+':'+SUBSTRING(TIME,3,2)+':'+SUBSTRING(TIME,5,2) AS TIME) AS HORA
       , CLOCKID
       ,CASE WHEN   A.TIME BETWEEN '060000' AND '091000' THEN 'ENTRADA NORMAL'   
              WHEN   A.TIME BETWEEN '091000' AND '103000' THEN 'ENTRADA TARDE' 
              WHEN   A.TIME BETWEEN '110000' AND '150000' THEN 'ALMUERZO' 
              WHEN   A.TIME BETWEEN '160000' AND '230000' THEN 'SALIDA' ELSE  'NO AUTORIZADO' END TIPO_PONCHE
FROM [Genesis].[dbo].rawdata A 
RIGHT 
--left
JOIN [Genesis].[dbo].employee B ON (B.EMPLNUM = A.badge) 
            where CAST(DATE AS DATE) = @fecha 
            and 
            SUBSTRING(TIME,1,2)+':'+SUBSTRING(TIME,3,2)+':'+SUBSTRING(TIME,5,2)  < '11:00:00'

)  	B ON A.cedula = b.CEDULA

 join [Genesis].[PonchesDB].[PersonalDB] Per
                on per.cedula2 = a.cedula
join 
 (
select * from [Genesis].[PonchesDB].[DescripcionHoratios] where  dias = DATENAME(weekday ,@fecha) and act = 1
 ) c on c.id = A.idTipoPonche
    Where b.hora is null

 order by per.NOMBRE 


            FOR   XML RAW('tr'),
                  ELEMENTS
            )

SELECT  @Body = @TableHead + ISNULL(@Body, '') + @TableTail

/*
=======================================================================================================
Inicio de bucles para envio de correos a los encargados de depto
Alejandro Jimenez Viernes 14 de Junio 2019
*/

exec [Genesis].[dbo].[sp_EnviarCorreosDepto] @fecha

update [Genesis].[PonchesDB].[SupervisoresCorreos]
set enviado = 1

update [Genesis].[PonchesDB].[SupervisoresCorreos]
set enviado = 0 where EMAILSUPERVISOR = 'evelyn.estrella@inabima.gob.do'

while exists(
select top 1 
   emailsupervisor
from
[genesis].[PonchesDB].[SupervisoresCorreos] 
Where  [activarEnvioCorreo]= 1 and EMAILSUPERVISOR = 'evelyn.estrella@inabima.gob.do'
and enviado = 0
)
begin

set @Correo = 
(
        select top 1 
           [EMAILSUPERVISOR]
        from
        [genesis].[PonchesDB].[SupervisoresCorreos] 
            Where  [activarEnvioCorreo]= 1
                and enviado = 0
)
/*
=============================================================================================================
*/
set @mensaje = ''
Set @Mensaje ='' + ( select distinct top 1 isnull(Depto,'') 
from [genesis].[PonchesDB].[SupervisoresCorreos] 
where [EMAILSUPERVISOR]  = @Correo)

Set @Mensaje += '</br> SUPERVISOR: '+ ( select top 1 isnull
([SUPERVISOR],'') 
from [genesis].[PonchesDB].[SupervisoresCorreos] 
where [EMAILSUPERVISOR]  = @Correo)
--print @correo

SET @TableTail = '</table></body></html>' ;
SET @TableHead = '<html><head>' + '<style>'
    + 'td {border: solid black;border-width: 1px;
    padding-left:5px;padding-right:5px;padding-top:1px;
    padding-bottom:1px;font: 11px arial} '
    + '</style>' + '</head>' + '<body>' + '<h2 
    Color="darkblue">Reporte de Eventos Personas No Poncharon el ' +@fecha + '</h2>'+
                            '<h4>' + @Mensaje+ '</h4>'
    + CONVERT(VARCHAR(50), GETDATE(), 100) 
    + ' <br> <table cellpadding=0 cellspacing=0 border=0>' 
    + '<tr> <td bgcolor=#E6E6FA><b>Cédula</b></td>'
    + '<td bgcolor=#E6E6FA><b>Nombres</b></td>'
    + '<td bgcolor=#E6E6FA><b>Fecha</b></td>'
    + '<td bgcolor=#ffffb3><b>Hora</b></td>'
    + '<td bgcolor=#E6E6FA><b>Tipo_ponche</b></td>'
    + '<td bgcolor=#E6E6FA><b>Código Reloj</b></td>'
    + '<td bgcolor=#E6E6FA><b>Sucursal</b></td></tr>' ;

SET @Body = (
select 
    td =  A.cedula, ''
    , td = Per.NOMBRE,''
    , td =isNull( B.FECHA,@fecha),''
    ,td = IsNull(B.HORA,'00:00:00' ), ''
    ,td = IsNull(B.TIPO_PONCHE,'No poncho' ), ''
    ,td = isNull(B.COD_RELOJ,''), ''
    ,td = 'No Definido', ''
    
from [Genesis].[PonchesDB].[horarioEmpleados] A
left join (
SELECT  RTRIM(LTRIM(B.FIRSTNAME))+' '+ RTRIM(LTRIM(B.LASTNAME)) AS NOMBRE
      , REPLACE(USER1,'-','') AS CEDULA  
      ,badge COD_RELOJ, CAST(DATE AS DATE) AS FECHA
     , CAST(SUBSTRING(TIME,1,2)+':'+SUBSTRING(TIME,3,2)+':'+SUBSTRING(TIME,5,2) AS TIME) AS HORA
       , CLOCKID
       ,CASE WHEN   A.TIME BETWEEN '060000' AND '091000' THEN 'ENTRADA NORMAL'   
              WHEN   A.TIME BETWEEN '091000' AND '103000' THEN 'ENTRADA TARDE' 
              WHEN   A.TIME BETWEEN '110000' AND '150000' THEN 'ALMUERZO' 
              WHEN   A.TIME BETWEEN '160000' AND '230000' THEN 'SALIDA' ELSE  'NO AUTORIZADO' END TIPO_PONCHE


FROM [Genesis].[dbo].rawdata A 
RIGHT 
--left
JOIN [Genesis].[dbo].employee B ON (B.EMPLNUM = A.badge) 
            where CAST(DATE AS DATE) = @fecha 
            and 
            SUBSTRING(TIME,1,2)+':'+SUBSTRING(TIME,3,2)+':'+SUBSTRING(TIME,5,2)  < '11:00:00'

)  	B ON A.cedula = b.CEDULA

 join [Genesis].[PonchesDB].[PersonalDB] Per
                on per.cedula2 = a.cedula
join 
 (
 
select * from [Genesis].[PonchesDB].[DescripcionHoratios] where  dias = DATENAME(weekday ,@fecha) and act = 1
 ) c on c.id = A.idTipoPonche
 
 
 join  [genesis].[PonchesDB].[SupervisoresCorreos]  Sper 
            on Sper.[CEDULA_EMP] = per.cedula2
                    and Sper.[EMAILSUPERVISOR] = @correo
    Where b.hora is null

 order by per.NOMBRE 

            FOR   XML RAW('tr'),
                  ELEMENTS
            )

SELECT  @Body = @TableHead + ISNULL(@Body, '') + @TableTail
declare @correo1 varchar(1000);
set @Correo1 = 'jose.jimenez@inabima.gob.do'

EXEC sp_send_dbmail 
  @profile_name='SqlMail',
  @copy_recipients ='',
  @recipients=  @correo1,    -----   @email,  --'jose.jimenez@INABIMA.GOB.DO', --; ja.jimenezrosa@gmail.com',
  @subject= @Mensaje  ,
  @body=@Body ,
  @body_format = 'HTML' ;
/*
=============================================================================================================
*/
update [genesis].[PonchesDB].[SupervisoresCorreos] 
    set enviado = 1 
        Where  [activarEnvioCorreo]= 1
        and enviado = 0
        and [EMAILSUPERVISOR] = @correo
end

/*

*/
  update [Genesis].[PonchesDB].[DatosReloj_Cargar] 
    set enviado = 1
    where fecha = @fecha
    AND HORA < '11:00:00'
end 
~~~

# Ponches Entrada Fuera del Horario
# 


~~~sql
/*
Query de los ponches de entrada fuera de Horario.
Alejandro Jimenez 2019-06-07
*/
use msdb
go

declare @email varchar(500) = 
(

SELECT 
      [Email]
  FROM [AuditoriaDB].[dbo].[tblParametros]
  where id = 6
)


while exists (
select distinct top 1 fecha, enviado from [Genesis].[PonchesDB].[DatosReloj_Cargar]
where enviado = 1 AND HORA < '11:00:00'

order by fecha asc

)
begin

DECLARE @Body NVARCHAR(MAX),
    @TableHead VARCHAR(1000),
    @TableTail VARCHAR(1000)
    ,@dias int = 2
    ,@fecha varchar(10) 
    
    /*
    Asignar fecha a enviar al personal de resursos humanos
    */
set @fecha = (select distinct top 1 fecha 
from [Genesis].PonchesDB.[DatosReloj_Cargar]
where enviado = 1 AND HORA < '11:00:00'
order by fecha asc
)

SET @TableTail = '</table></body></html>' ;
SET @TableHead = '<html><head>' + '<style>'
    + 'td {border: solid black;border-width: 1px;
    padding-left:5px;padding-right:5px;padding-top:1px;
    padding-bottom:1px;font: 11px arial} '
    + '</style>' + '</head>' + '<body>' + '<h1>Reporte de Eventos Entrada Tardias : ' + @fecha +'  </h1> '
    + CONVERT(VARCHAR(50), GETDATE(), 100) 
    + ' <br> <table cellpadding=0 cellspacing=0 border=0>' 
    + '<tr> <td bgcolor=#E6E6FA><b>Cédula</b></td>'
    + '<td bgcolor=#E6E6FA><b>Nombres</b></td>'
    + '<td bgcolor=#E6E6FA><b>Fecha</b></td>'
    + '<td bgcolor=#ffffb3><b>Hora</b></td>'
    + '<td bgcolor=#E6E6FA><b>Tipo_ponche</b></td>'
    + '<td bgcolor=#E6E6FA><b>Código Reloj</b></td>'
    + '<td bgcolor=#E6E6FA><b>Sucursal</b></td></tr>' ;

SET @Body = (
select 
    td =  h.cedula, ''
    , td = a.NOMBRE,''
    --,a.CEDULA
    , td = a.FECHA,''
    ,td = a.HORA, ''
    ,td = a.TIPO_PONCHE, ''
    ,td = a.COD_RELOJ, ''
    ,td = IsNull(c.descrip,'No Definido'), ''
 from [Genesis].[PonchesDB].[DatosReloj_Cargar] a
 left join [Genesis].[PonchesDB].[horarioEmpleados] h on h.cedula = a.CEDULA and a.FECHA = @fecha
 join [Genesis].[PonchesDB].[DescripcionHoratios] D on D.id = h.idTipoPonche 
  left Join [Genesis].[dbo].[clock] c on c.id = a.CLOCKID	
    where (a.HORA > D.entrada  and a.HORA < D.almuerzo )
                or a.HORA is null

 group by
    h.cedula 
    ,a.NOMBRE
    --,a.CEDULA
    ,a.FECHA
    ,a.HORA
    ,a.TIPO_PONCHE
    ,a.COD_RELOJ
    ,a.CLOCKID
    ,c.descrip
 order by fecha desc


            FOR   XML RAW('tr'),
                  ELEMENTS
            )

SELECT  @Body = @TableHead + ISNULL(@Body, '') + @TableTail

EXEC sp_send_dbmail 
  @profile_name='SqlMail',
  @copy_recipients ='jose.jimenez@INABIMA.GOB.DO',
  @recipients=  @email,  --'jose.jimenez@INABIMA.GOB.DO', --; ja.jimenezrosa@gmail.com',
  @subject='Query Result',
  @body=@Body ,
  @body_format = 'HTML' ;

  update [Genesis].[PonchesDB].[DatosReloj_Cargar] 
    set enviado = 2
    where fecha = @fecha
    AND HORA < '11:00:00'


end 
~~~
# 


# query Insertar datos reloj a soluflex<a name="queryinsertardatossoluflex25"></a>
# 


~~~sql

/*
=================================================================
*/

declare @fecha varchar(10) ;
declare @hora  varchar(10);
truncate table [Genesis].[PonchesDB].[DatosReloj_Cargar_temporal]

Insert into [Genesis].[PonchesDB].[DatosReloj_Cargar_temporal]
(
[NOMBRE]
      ,[CEDULA]
      ,[COD_RELOJ]
      ,[FECHA]
      ,[HORA]
      ,[CLOCKID]
      ,[TIPO_PONCHE]
)
SELECT  RTRIM(LTRIM(B.FIRSTNAME))+' '+ RTRIM(LTRIM(B.LASTNAME)) AS NOMBRE
      , REPLACE(USER1,'-','') AS CEDULA  
      ,badge COD_RELOJ, CAST(DATE AS DATE) AS FECHA
     , CAST(SUBSTRING(TIME,1,2)+':'+SUBSTRING(TIME,3,2)+':'+SUBSTRING(TIME,5,2) AS TIME) AS HORA
       , CLOCKID
       ,CASE WHEN   A.TIME BETWEEN '060000' AND '091000' THEN 'ENTRADA NORMAL'   
              WHEN   A.TIME BETWEEN '091000' AND '103000' THEN 'ENTRADA TARDE' 
              WHEN   A.TIME BETWEEN '110000' AND '150000' THEN 'ALMUERZO' 
              WHEN   A.TIME BETWEEN '160000' AND '230000' THEN 'SALIDA' ELSE  'NO AUTORIZADO' END TIPO_PONCHE
FROM [Genesis].[dbo].rawdata A RIGHT JOIN [Genesis].[dbo].employee B ON (B.EMPLNUM = A.badge)

set @fecha  =
(
select isNull(Fecha,'2017-01-01')  from  openquery( [SOLUFLEX RRHH],
'select  max(fecha) as fecha from datosreloj ')
)


set @hora  = 
(
select isNull(Hora,'00:00:00') from  openquery( [SOLUFLEX RRHH],
'select  max(hora) as Hora from datosreloj ')
)

/*
Registro de carga de datos desde Sql hacia soluflex.
alejandro JImenez 
2019-06-18

*/

Insert into openquery( [SOLUFLEX RRHH],
'select nombre, cedula, cod_reloj, fecha, hora,clockid,tipo_ponche from  datosreloj '
)

select 
a.[NOMBRE]
      ,a.[CEDULA]
      ,a.[COD_RELOJ]
      ,a.[FECHA]
      ,a.[HORA]
      ,a.[CLOCKID]
      ,a.[TIPO_PONCHE]

  from 
[Genesis].[PonchesDB].[DatosReloj_Cargar_temporal] a
left join 
(
select * from  openquery( [SOLUFLEX RRHH],
'select  * from datosreloj ') 
) b
 on 
 (
 a.NOMBRE = b.NOMBRE
 and a.CEDULA = b.CEDULA
 and a.COD_RELOJ = b.COD_RELOJ
 
 and a.FECHA = b.FECHA
 and a.HORA = b.HORA
 and a.CLOCKID = b.CLOCKID
 and a.TIPO_PONCHE = b.TIPO_PONCHE
 
 )
where b.NOMBRE is null and a.FECHA is not null
~~~
# 


# 
# Salida de ************ verificaciones<a name="geneissalidasinabiama"></a>
# 


~~~sql
/*
Query de los ponches de entrada fuera de Horario.
Alejandro Jimenez 2019-06-07
*/

declare @Mensaje varchar(1000);

declare @email varchar(500) = 
(

SELECT 
      [Email]
  FROM [AuditoriaDB].[dbo].[tblParametros]
  where id = 6
)


declare @fecha1 date

set @fecha1 =
(  select distinct top 1 min(fecha) As Fecha
--, enviado 
from [Genesis].[PonchesDB].[DatosReloj_Cargar]
where enviado = 0 AND HORA >  '14:00:00'
)


while exists (
select distinct top 1 fecha, enviado 
from [Genesis].[PonchesDB].[DatosReloj_Cargar]
where  (HORA <  '14:00:00' and fecha  = convert(Varchar(10),
 dateadd(DAY,1,@fecha1),120) )  --or @fecha1 is not null

)
begin

DECLARE @Body NVARCHAR(MAX),
    @TableHead VARCHAR(1000),
    @TableTail VARCHAR(1000)
    ,@dias int = 2
    ,@fecha varchar(10) 
    
    /*
    Asignar fecha a enviar al personal de resursos humanos
    Reporte de Eventos Salidas
    */
set @fecha = (
select distinct top 1 fecha from [Genesis].PonchesDB.[DatosReloj_Cargar]
where enviado < 2 AND HORA > '14:00:00'
order by fecha asc
)

SET @TableTail = '</table></body></html>' ;
SET @TableHead = '<html><head>' + '<style>'
    + 'td {border: solid black;border-width: 1px;
    padding-left:5px;padding-right:5px;padding-top:1px;
    padding-bottom:1px;font: 11px arial} '
    + '</style>' + '</head>' + '<body>' + '<h1>Reporte de Eventos Salidas : ' + @fecha +'  </h1> '
    + CONVERT(VARCHAR(50), GETDATE(), 100) 
    + ' <br> <table cellpadding=0 cellspacing=0 border=0>' 
    + '<tr> <td bgcolor=#E6E6FA><b>Cédula</b></td>'
    + '<td bgcolor=#E6E6FA><b>Nombres</b></td>'
    + '<td bgcolor=#E6E6FA><b>Fecha</b></td>'
    + '<td bgcolor=#ffffb3><b>Hora</b></td>'
    + '<td bgcolor=#E6E6FA><b>Tipo_ponche</b></td>'
    + '<td bgcolor=#E6E6FA><b>Código Reloj</b></td>'
    + '<td bgcolor=#E6E6FA><b>Sucursal</b></td></tr>' ;

SET @Body = (
select 
    td =  h.cedula, ''
    , td = a.NOMBRE,''
    , td = a.FECHA,''
    ,td = max(a.HORA), ''
    ,td = 'Salida', ''
    ,td = a.COD_RELOJ, ''
    ,td = IsNull(c.descrip,'No Definido'), ''
 from [Genesis].[PonchesDB].[DatosReloj_Cargar] a
 left join [Genesis].[PonchesDB].[horarioEmpleados] h on h.cedula = a.CEDULA and a.FECHA = @fecha
 join [Genesis].[PonchesDB].[DescripcionHoratios] D on D.id = h.idTipoPonche 
  left Join [Genesis].[dbo].[clock] c on c.id = a.CLOCKID	

   join 
  (
  
    select h.Cedula, Max(a.hora) horaSalida
from   [Genesis].[PonchesDB].[DatosReloj_Cargar] a
 left join [Genesis].[PonchesDB].[horarioEmpleados] h on h.cedula = a.CEDULA and a.FECHA = @fecha
 join [Genesis].[PonchesDB].[DescripcionHoratios] D on D.id = h.idTipoPonche 
        where hora >  D.regresoA
  group by h.cedula
  ) Sali on Sali.cedula = h.cedula and Sali.horaSalida = a.HORA
        where Sali.horaSalida < D.salida
 group by
    h.cedula 
    ,a.NOMBRE
    ,a.FECHA
    ,a.COD_RELOJ
    ,a.CLOCKID
    ,c.descrip
 order by a.NOMBRE 
            FOR   XML RAW('tr'),
                  ELEMENTS
            )

SELECT  @Body = @TableHead + ISNULL(@Body, '') + @TableTail

EXEC sp_send_dbmail 
  @profile_name='SqlMail',
  @copy_recipients ='jose.jimenez@INABIMA.GOB.DO',
  @recipients=  @email,  --'jose.jimenez@INABIMA.GOB.DO', --; ja.jimenezrosa@gmail.com',
  @subject='Reporte de Eventos Salidas :',
  @body=@Body ,
  @body_format = 'HTML' ;

  update [Genesis].[PonchesDB].[DatosReloj_Cargar] 
    set enviado = 2
    where fecha = @fecha
    AND HORA > '14:00:00'

    set @fecha1 = dateadd(DAY,1,@fecha1)


/*
====================================================================*/

/*
======================================================================
Inicio de bucles para envio de correos a los encargados de depto
Alejandro Jimenez Viernes 19 de Junio 2019
Reporte de Eventos Personas No Poncharon el:
================================================================
*/
declare @Correo varchar(100);

exec [Genesis].[dbo].[sp_EnviarCorreosDepto] @fecha

while exists(
select top 1 
   emailsupervisor
from
[genesis].[PonchesDB].[SupervisoresCorreos] 
Where  [activarEnvioCorreo]= 1
and enviado = 0
)
begin

set @Correo = 
(
        select top 1 
           [EMAILSUPERVISOR]
        from
        [genesis].[PonchesDB].[SupervisoresCorreos] 
            Where  [activarEnvioCorreo]= 1
                and enviado = 0
)
/*
============================================================================
*/
set @mensaje = ''
Set @Mensaje ='' + ( select distinct top 1 isnull(Depto,'')
 from [genesis].[PonchesDB].[SupervisoresCorreos] 
 where [EMAILSUPERVISOR]  = @Correo)
Set @Mensaje += '</br> SUPERVISOR: '+ ( select top 1 isnull([SUPERVISOR],'') 
from [genesis].[PonchesDB].[SupervisoresCorreos]
 where [EMAILSUPERVISOR]  = @Correo)
--print @correo

SET @TableTail = '</table></body></html>' ;
SET @TableHead = '<html><head>' + '<style>'
    + 'td {border: solid black;border-width: 1px;
    padding-left:5px;padding-right:5px;padding-top:1px;
    padding-bottom:1px;font: 11px arial} '
    + '</style>' + '</head>' + '<body>' + 
    '<h1>Reporte de Eventos Personas No Poncharon el: ' + @fecha +'  </h1> '
    + '<h4>' + @Mensaje+ '</h4>'
    + CONVERT(VARCHAR(50), GETDATE(), 100) 
    + ' <br> <table cellpadding=0 cellspacing=0 border=0>' 
    + '<tr> <td bgcolor=#E6E6FA><b>Cédula</b></td>'
    + '<td bgcolor=#E6E6FA><b>Nombres</b></td>'
    + '<td bgcolor=#E6E6FA><b>Fecha</b></td>'
    + '<td bgcolor=#ffffb3><b>Hora</b></td>'
    + '<td bgcolor=#E6E6FA><b>Tipo_ponche</b></td>'
    + '<td bgcolor=#E6E6FA><b>Código Reloj</b></td>'
    + '<td bgcolor=#E6E6FA><b>Sucursal</b></td></tr>' ;

SET @Body = (
select 
    td =  A.cedula, ''
    , td = Per.NOMBRE,''
    , td =isNull( B.FECHA,@fecha),''
    ,td = IsNull(B.HORA,'00:00:00' ), ''
    ,td = IsNull(B.TIPO_PONCHE,'No poncho' ), ''
    ,td = isNull(B.COD_RELOJ,''), ''
    ,td = 'No Definido', ''
    
from [Genesis].[PonchesDB].[horarioEmpleados] A
left join (
SELECT  RTRIM(LTRIM(B.FIRSTNAME))+' '+ RTRIM(LTRIM(B.LASTNAME)) AS NOMBRE
      , REPLACE(USER1,'-','') AS CEDULA  
      ,badge COD_RELOJ, CAST(DATE AS DATE) AS FECHA
     , CAST(SUBSTRING(TIME,1,2)+':'+SUBSTRING(TIME,3,2)+':'+SUBSTRING(TIME,5,2) AS TIME) AS HORA
       , CLOCKID
       ,CASE WHEN   A.TIME BETWEEN '060000' AND '091000' THEN 'ENTRADA NORMAL'   
              WHEN   A.TIME BETWEEN '091000' AND '103000' THEN 'ENTRADA TARDE' 
              WHEN   A.TIME BETWEEN '110000' AND '150000' THEN 'ALMUERZO' 
              WHEN   A.TIME BETWEEN '160000' AND '230000' THEN 'SALIDA' ELSE  'NO AUTORIZADO' END TIPO_PONCHE


FROM [Genesis].[dbo].rawdata A 
RIGHT 
--left
JOIN [Genesis].[dbo].employee B ON (B.EMPLNUM = A.badge) 
            where CAST(DATE AS DATE) = @fecha 
            and 
            SUBSTRING(TIME,1,2)+':'+SUBSTRING(TIME,3,2)+':'+SUBSTRING(TIME,5,2)  < '11:00:00'

)  	B ON A.cedula = b.CEDULA


 join [Genesis].[PonchesDB].[PersonalDB] Per
                on per.cedula2 = a.cedula

join 
 (
 
select * from [Genesis].[PonchesDB].[DescripcionHoratios] where  dias = DATENAME(weekday ,getdate()) and act = 1
 ) c on c.id = A.idTipoPonche

join  [genesis].[PonchesDB].[SupervisoresCorreos]  Sper 
            on Sper.[CEDULA_EMP] = a.cedula
                    and Sper.[EMAILSUPERVISOR] = @correo

    Where b.hora is null
            and REPLACE(A.cedula,'-','')  not in 
                (
                
                select Cedula
                    from  [Genesis].[PonchesDB].VacacionesRH
                    where  getdate() between fecha_Inicio and fecha_fin


                )


/*====================================================================*/
                and A.cedula not in 
                (
                
                select Cedula
                    from  [Genesis].[PonchesDB].VacacionesRH
                    where  getdate() between fecha_Inicio and fecha_fin


                )

 order by per.NOMBRE 

            FOR   XML RAW('tr'),
                  ELEMENTS
            )


SELECT  @Body = @TableHead + ISNULL(@Body, '') + @TableTail

--set @Correo = 'jose.jimenez@inabima.gob.do'

EXEC sp_send_dbmail 
  @profile_name='SqlMail',
  @copy_recipients ='jose.jimenez@INABIMA.GOB.DO',
  @recipients=  @correo,  --'jose.jimenez@INABIMA.GOB.DO', --; ja.jimenezrosa@gmail.com',
  @subject='Reporte de entradas Tardias.',
  @body=@Body ,
  @body_format = 'HTML' ;


  update [genesis].[PonchesDB].[SupervisoresCorreos] 
    set enviado = 1 
        Where  [activarEnvioCorreo]= 1
        and enviado = 0
        and [EMAILSUPERVISOR] = @correo
  end

    update [Genesis].[PonchesDB].[DatosReloj_Cargar] 
    set enviado = 2
    where fecha = @fecha
    AND HORA < '11:00:00'
/*
envios de Correos personas que no poncharon salidas en el dia
===========================================================================
*/
SET @TableTail = '</table></body></html>' ;
SET @TableHead = '<html><head>' + '<style>'
    + 'td {border: solid black;border-width: 1px;
    padding-left:5px;padding-right:5px;padding-top:1px;
    padding-bottom:1px;font: 11px arial} '
    + '</style>' + '</head>' + '<body>' + 
    '<h1>Reporte de Eventos Personas No Poncharon el: ' + @fecha +'  </h1> '
    + CONVERT(VARCHAR(50), GETDATE(), 100) 
    + ' <br> <table cellpadding=0 cellspacing=0 border=0>' 
    + '<tr> <td bgcolor=#E6E6FA><b>Cédula</b></td>'
    + '<td bgcolor=#E6E6FA><b>Nombres</b></td>'
    + '<td bgcolor=#E6E6FA><b>Fecha</b></td>'
    + '<td bgcolor=#ffffb3><b>Hora</b></td>'
    + '<td bgcolor=#E6E6FA><b>Tipo_ponche</b></td>'
    + '<td bgcolor=#E6E6FA><b>Código Reloj</b></td>'
    + '<td bgcolor=#E6E6FA><b>Sucursal</b></td></tr>' ;

SET @Body = (
select 

    td =  A.cedula, ''
    , td = Per.NOMBRE,''
    --,a.CEDULA
    , td =isNull( B.FECHA,@fecha),''
    ,td = IsNull(B.HORA,'00:00:00' ), ''
    ,td = IsNull(B.TIPO_PONCHE,'No poncho' ), ''
    ,td = isNull(B.COD_RELOJ,''), ''
    ,td = 'No Definido', ''
    
from [Genesis].[PonchesDB].[horarioEmpleados] A

left join (
SELECT  RTRIM(LTRIM(B.FIRSTNAME))+' '+ RTRIM(LTRIM(B.LASTNAME)) AS NOMBRE
      , REPLACE(USER1,'-','') AS CEDULA  
      ,badge COD_RELOJ, CAST(DATE AS DATE) AS FECHA
     , CAST(SUBSTRING(TIME,1,2)+':'+SUBSTRING(TIME,3,2)+':'+SUBSTRING(TIME,5,2) AS TIME) AS HORA
       , CLOCKID
       ,CASE WHEN   A.TIME BETWEEN '060000' AND '091000' THEN 'ENTRADA NORMAL'   
              WHEN   A.TIME BETWEEN '091000' AND '103000' THEN 'ENTRADA TARDE' 
              WHEN   A.TIME BETWEEN '110000' AND '150000' THEN 'ALMUERZO' 
              WHEN   A.TIME BETWEEN '160000' AND '230000' THEN 'SALIDA' ELSE  'NO AUTORIZADO' END TIPO_PONCHE


FROM [Genesis].[dbo].rawdata A 
RIGHT 
--left
JOIN [Genesis].[dbo].employee B ON (B.EMPLNUM = A.badge) 
            where CAST(DATE AS DATE) = @fecha 
            and 
            SUBSTRING(TIME,1,2)+':'+SUBSTRING(TIME,3,2)+':'+SUBSTRING(TIME,5,2)  < '11:00:00'

)  	B ON A.cedula = b.CEDULA


 join [Genesis].[PonchesDB].[PersonalDB] Per
                on per.cedula2 = a.cedula

join 
 (
 
select * from [Genesis].[PonchesDB].[DescripcionHoratios] where  dias = DATENAME(weekday ,getdate()) and act = 1
 ) c on c.id = A.idTipoPonche

    Where b.hora is null
            and REPLACE(A.cedula,'-','')  not in 
                (
                
                select Cedula
                    from  [Genesis].[PonchesDB].VacacionesRH
                    where  getdate() between fecha_Inicio and fecha_fin

                )

 order by per.NOMBRE 


            FOR   XML RAW('tr'),
                  ELEMENTS
            )

SELECT  @Body = @TableHead + ISNULL(@Body, '') + @TableTail

EXEC sp_send_dbmail 
  @profile_name='SqlMail',
  @copy_recipients ='',
  @recipients=  @email,  --'jose.jimenez@INABIMA.GOB.DO', --; ja.jimenezrosa@gmail.com',
  @subject='Query Result',
  @body=@Body ,
  @body_format = 'HTML' ;

    /*=====================================================================*/

    while exists(
select top 1 
   emailsupervisor
from
[genesis].[PonchesDB].[SupervisoresCorreos] 
Where  [activarEnvioCorreo]= 1
and enviado = 0
)
begin

set @Correo = 
(
        select top 1 
           [EMAILSUPERVISOR]
        from
        [genesis].[PonchesDB].[SupervisoresCorreos] 
            Where  [activarEnvioCorreo]= 1
                and enviado = 0
)
/*reporte personas no salidas
===========================================================================
*/
set @mensaje = ''
Set @Mensaje ='' + ( select distinct top 1 isnull(Depto,'') 
from [genesis].[PonchesDB].[SupervisoresCorreos]
 where [EMAILSUPERVISOR]  = @Correo)
Set @Mensaje += '</br> SUPERVISOR: '+ ( select top 1 isnull([SUPERVISOR],'') 
from [genesis].[PonchesDB].[SupervisoresCorreos] where [EMAILSUPERVISOR]  = @Correo)
--print @correo

SET @TableTail = '</table></body></html>' ;
SET @TableHead = '<html><head>' + '<style>'
    + 'td {border: solid black;border-width: 1px;
    padding-left:5px;padding-right:5px;padding-top:1px;
    padding-bottom:1px;font: 11px arial} '
    + '</style>' + '</head>' + '<body>' + 
    '<h1>Reporte de Eventos Salidas : ' + @fecha +'  </h1> '
    + '<h4>' + @Mensaje+ '</h4>'
    + CONVERT(VARCHAR(50), GETDATE(), 100) 
    + ' <br> <table cellpadding=0 cellspacing=0 border=0>' 
    + '<tr> <td bgcolor=#E6E6FA><b>Cédula</b></td>'
    + '<td bgcolor=#E6E6FA><b>Nombres</b></td>'
    + '<td bgcolor=#E6E6FA><b>Fecha</b></td>'
    + '<td bgcolor=#ffffb3><b>Hora</b></td>'
    + '<td bgcolor=#E6E6FA><b>Tipo_ponche</b></td>'
    + '<td bgcolor=#E6E6FA><b>Código Reloj</b></td>'
    + '<td bgcolor=#E6E6FA><b>Sucursal</b></td></tr>' ;

SET @Body = (
select 
    td =  A.cedula, ''
    , td = a.NOMBRE,''
    , td =isNull( a.FECHA,@fecha),''
    ,td = IsNull(a.HORA,'00:00:00' ), ''
    ,td = IsNull(a.TIPO_PONCHE,'No poncho' ), ''
    ,td = isNull(a.COD_RELOJ,''), ''
    ,td = 'No Definido', ''
    
 from [Genesis].[PonchesDB].[DatosReloj_Cargar] a
 left join [Genesis].[PonchesDB].[horarioEmpleados] h on h.cedula = a.CEDULA and a.FECHA = @fecha
 join [Genesis].[PonchesDB].[DescripcionHoratios] D on D.id = h.idTipoPonche 
  left Join [Genesis].[dbo].[clock] c on c.id = a.CLOCKID	

   join 
  (
  
    select h.Cedula, Max(a.hora) horaSalida
from   [Genesis].[PonchesDB].[DatosReloj_Cargar] a
 left join [Genesis].[PonchesDB].[horarioEmpleados] h on h.cedula = a.CEDULA and a.FECHA = @fecha
 join [Genesis].[PonchesDB].[DescripcionHoratios] D on D.id = h.idTipoPonche 
        where hora >  D.regresoA
  group by h.cedula
  ) Sali on Sali.cedula = h.cedula and Sali.horaSalida = a.HORA

        where Sali.horaSalida < D.salida
                    and REPLACE(A.cedula,'-','')  not in 
                (
                
                select Cedula
                    from  [Genesis].[PonchesDB].VacacionesRH
                    where  getdate() between fecha_Inicio and fecha_fin
                )

 order by a.NOMBRE 

            FOR   XML RAW('tr'),
                  ELEMENTS
            )


SELECT  @Body = @TableHead + ISNULL(@Body, '') + @TableTail


EXEC sp_send_dbmail 
  @profile_name='SqlMail',
  @copy_recipients ='jose.jimenez@INABIMA.GOB.DO',
  @recipients=  @correo,  --'jose.jimenez@INABIMA.GOB.DO', --; ja.jimenezrosa@gmail.com',
  @subject='Reporte de entradas Tardias.',
  @body=@Body ,
  @body_format = 'HTML' ;



  update [genesis].[PonchesDB].[SupervisoresCorreos] 
    set enviado = 1 
        Where  [activarEnvioCorreo]= 1
        and enviado = 0
        and [EMAILSUPERVISOR] = @correo
  end

    /*======================================================================*/

end 
~~~
# 


# 
# Ejecucion de procedure de soluflex que cargar los datos del reporte de Ponches<a name="procedurecargadatossoluflex"></a>
![](https://static.wixstatic.com/media/7fcb76_c2e0a583d06547cfa053a3a237edfc4c~mv2.png/v1/fill/w_618,h_160,al_c,q_85,usm_0.66_1.00_0.01/Logo_Soluflex_FINAL_2.webp)

#### La ejecucion de este procedure al momento de realizar esta documentacion fue para cargar los datos del reloj de ponches correspondientes al periodo Marzo 1 al Marzo 31 del 2021

## Para esto Ejecutamos lo siguiente.
# 


~~~sql
declare @fecha varchar(10)

select @fecha from
openquery( [SOLUFLEX RRHH], N'EXECUTE PROCEDURE
 SPA_ACTUALIZA_PONCHESRELOJ ( ''2021-03-01'' , ''2021-03-31'')')
~~~
# 





### Ademas tenemos el procedimiento original el cual es utilizado para cargar los ponches de  reloj a partir de la ultima fecha de carga de ponches.
# 


~~~sql
declare @fecha varchar(10)

select @fecha from
openquery( [SOLUFLEX RRHH], N'EXECUTE PROCEDURE 
SPA_ACTUALIZA_PONCHESRELOJ ( (select Max(fecha_ponche)+1 from 
ta_ponchesReloj) ,current_date-2)')

~~~
# 







# Sincronizar datos tabla TA_ponchesreloj con datos de sql server<a name="ta_ponchesrelojjob"></a>

#### Para cargar los datos del informe de ponches creado por el Sr. Jorge Villalona, se procederá a crear un proceso de sincronización de datos entre los registros de tomados de Soluflex y la base de datos Sql.
![](https://www.tecnologia-informatica.com/wp-content/uploads/2018/09/que-es-sincronizacion-1-2.jpeg)

# 


~~~sql

/*
Alejandro Jimenez 
Jueves 21 de Abril del 2022
Sincronizando datos de poches soluflex para las tablas de Sql server Genesis
ta-pochesreloj  para los reportes del sr Jorge Villalona
*/

insert into TA_PONCHESRELOJ
select * from
openquery( [SOLUFLEX RRHH], N'Select * from TA_PONCHESRELOJ')
--WHERE FECHA_PONCHE = '2020-02-04'
    WHERE NOT EXISTS
    (
        SELECT * FROM TA_PONCHESRELOJ
    )


~~~
# 



#### Vamos a construir un job de servidor Sql usando este código.
#### El job se ejecutará cada 10 minutos para sincronizar los datos de la base de datos soluflex con las bases de datos del servidor sql.

# 



# Query para la Sincronizacion de los empleados de soluflex con el Reloj.<a name="17.7"></a>

#### Porque las licencias del reloj de control de asistencias expiraron. Nos encontramos en la necesidad de realizar cargas manuales a las Bases de Datos del nuevo personal.

#### Decidimos crear una consulta a partir de la base de datos soluflex e insertarla en la base de datos de genesis.

#### Nos permitirá obtener los nuevos empleados de la base de datos de Recursos Humanos. Por tanto, no será necesario insertar nuevos empleados en de Db.
# 



~~~sql

USE [Genesis]
GO


TRUNCATE TABLE [PonchesDB].[SupervisoresCorreos]
GO

SELECT [id]
      ,[NOMBRE]
      ,[CEDULA_EMP]
      ,[SUPERVISOR]
      ,[EMAILSUPERVISOR]
      ,[DEPTO]
      ,[DIVISION]
      ,[activarEnvioCorreo]
      ,[enviado]
      ,[CorreoResguardado]
      ,[depto1]
      ,[emailsupervisor_bk]
  FROM [PonchesDB].[SupervisoresCorreos]
GO



INSERT INTO [PonchesDB].[SupervisoresCorreos]
select
CONVERT(INT,cODEMP)
--0 id
,Nombre
,REPLACE(cedula,'-','')
,supervisor
,Emailsupervisor
,Depto
,Division
,1
,0
,EMAILSUPERVISOR
,Depto
,Emailsupervisor
 from  openquery( [SOLUFLEX RRHH],
'select * from spa_empleados')
WHERE ESTATUS = 'A'
GO



~~~
# 


#### Este código sería parte de un código mucho más grande que describiremos a continuación, debe ejecutarse en un trabajo todos los días a las 6:00 a.m.
#### para asegurarnos de que nuestros datos estén sincronizados
# 


~~~sql

USE [Genesis]
GO

insert into  [Genesis].[PonchesDB].[DescripcionHoratios]
(
    id 
    ,dias
    ,entrada
    ,almuerzo
    ,regresoA
    ,Salida
    ,act
)
SELECT id 
, dias 
, entrada
,'11:30:00','15:30:00'
, salida
, act
 from  openquery( [SOLUFLEX RRHH],
'select * from descripcionhorarios')
--WHERE ESTATUS = 'A'
go

select * from 
[Genesis].[PonchesDB].[DescripcionHoratios]

TRUNCATE TABLE [PonchesDB].[SupervisoresCorreos]
GO

SELECT [id]
      ,[NOMBRE]
      ,[CEDULA_EMP]
      ,[SUPERVISOR]
      ,[EMAILSUPERVISOR]
      ,[DEPTO]
      ,[DIVISION]
      ,[activarEnvioCorreo]
      ,[enviado]
      ,[CorreoResguardado]
      ,[depto1]
      ,[emailsupervisor_bk]
  FROM [PonchesDB].[SupervisoresCorreos]
GO

INSERT INTO [PonchesDB].[SupervisoresCorreos]
select
CONVERT(INT,cODEMP)
--0 id
,Nombre
,REPLACE(cedula,'-','')
,supervisor
,Emailsupervisor
,Depto
,Division
,1
,0
,EMAILSUPERVISOR
,Depto
,Emailsupervisor
 from  openquery( [SOLUFLEX RRHH],
'select * from spa_empleados')
WHERE ESTATUS = 'A'
GO

SELECT [id]
      ,[NOMBRE]
      ,[CEDULA_EMP]
      ,[SUPERVISOR]
      ,[EMAILSUPERVISOR]
      ,[DEPTO]
      ,[DIVISION]
      ,[activarEnvioCorreo]
      ,[enviado]
      ,[CorreoResguardado]
      ,[depto1]
      ,[emailsupervisor_bk]
  FROM [PonchesDB].[SupervisoresCorreos]
  --WHERE EMAILSUPERVISOR = 'ruben.estrella@inabima.gob.do'
GO



insert into [PonchesDB].[horarioEmpleadosBks]
(
    cedula
    ,idTipoPonche
    ,fechaInicio
    ,fechaFinal
    ,estatus
)
SELECT a.cedula, a.idTipoPonche,a.fechaInicio,a.fechaFinal ,a.estatus FROM 
[PonchesDB].[horarioEmpleados] a
join 
(
SELECT 
HORARIOID
,HORARIO
,REPLACE(cedula,'-','') CEDULA
,NOMBRE
 from  openquery( [SOLUFLEX RRHH],
'select * from spa_empleados')
WHERE ESTATUS = 'A'
) b
   on a.cedula = b.CEDULA and a.idTipoPonche != b.horarioID
ORDER BY CEDULA, fechaInicio




UPDATE a

SET  idTipoPonche = b.horarioID
        ,a.fechaInicio = convert(varchar(10),getdate(),120)

from  [PonchesDB].[horarioEmpleados] a,
(
SELECT 
HORARIOID
,HORARIO
,REPLACE(cedula,'-','') CEDULA
,NOMBRE
 from  openquery( [SOLUFLEX RRHH],
'select * from spa_empleados')
WHERE ESTATUS = 'A'
)
b
where a.cedula = b.CEDULA and a.idTipoPonche != b.horarioID

~~~
# 



# Sincronizar Vacaciones

### primera parte carga de vacaciones
# 


~~~sql

declare @tabla table
(
id varchar(10)
, fechaInicio varchar(10)
,fechaFinal varchar(10)
,cedula varchar(13)
)


insert into @tabla
select * from openquery( [SOLUFLEX RRHH],
'select a.id,a.fechaefec, a.fechaf, e.cedula
   from accperemp a left join empleados e on (e.codigo=a.codemp) where codaccper in ( ''007'',''011'') 
    and fecha>''2019-01-01'' 
    and e.cedula is not null 
    and a.aplicado=''T''
   order by a.id desc'
)





insert into [PonchesDB].[VacacionesRH]
(
    [idSoluflex]
    ,[Fecha_Inicio]
      ,[Fecha_Fin]
      ,[Cedula]
)
select * from @tabla
Where id >
(
select  Max(isnull(idSoluflex,0))
from [PonchesDB].[VacacionesRH]
)

~~~

### Segunda parte Cargar Vacaciones soluflex.

# 


~~~sql
USE [Genesis]
GO
/****** Object:  StoredProcedure [dbo].[sp_Sincronizar_Soluflex_VacacionesPermisos]   

 Script Date: 13/07/2021 10:15:10 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER Procedure [dbo].[sp_Sincronizar_Soluflex_VacacionesPermisos]
as
truncate table  [PonchesDB].[VacacionesRH]



insert into  [PonchesDB].[VacacionesRH]
(
    Fecha_Inicio
    ,Fecha_Fin
    ,Fecha_a_Trabajar
    ,Cedula
    ,Nombre
    ,Departamento
    ,Localidad
    ,idSoluflex
)
select FECHAi,FECHAF,fecha_trabajo,replace(cedula,'-',''),NOMBRE,

DEPARTAMENTO,SUCURSAL,nUMERO  
from  openquery( [SOLUFLEX RRHH],
'select * from spa_licenciasponches')

~~~
# 


# 

## Jobs Colocados en Disbles Utilizados por Soluflex<a name="soluflexjobdisable"></a>
    Ponches Soluflex
    Limpiar tablas de supervisores para envios
    DatosDelReloj
    DatosDelReloj_CargaVacaciones
    DatosDelReloj_Sinc_Empleados
#### Estos procesos del servidor Sql de las tablas de Génesis utilizadas para los golpes no funcionan.
#### Esto se debe a que esta base de datos ya no está en servicio.







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
        <img src="data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAoHCBYSERgRERUVGBISEhgYGRgZEhkYGBoRGBgaHBgaGRkcIS8lHR8rHxgYJjgmKy8xNTU1GiY7QDs0Py81NTQBDAwMEA8QHxISHzQsJCs0NEA0NDQxNjo0NDQ0NDQxNDQ0NDQ0NjQxNDE0NDY0PTQ0NDQ0NDQ0NDY0NDQ9NTQ0NP/AABEIAOEA4QMBIgACEQEDEQH/xAAcAAEAAQUBAQAAAAAAAAAAAAAABwEDBAUGAgj/xABKEAACAQMBBAUGCQkHAwUAAAABAgADBBESBQYhMQcTIkFRMmFxgZPSQlJUkZKhscHRFBYjRGJygoPCFzNDU6Ky4iSj8BVjZHSU/8QAGgEBAAMBAQEAAAAAAAAAAAAAAAECAwQFBv/EAC0RAAICAQIEBQMFAQEAAAAAAAABAhEDBBIhMUFRBRMUYaFSkbEVMmJxgeFC/9oADAMBAAIRAxEAPwCZoiIAiIgCIiAIiIAiIgCIiAIiIAiIgCIiAIiIAiIgCIiAIiIAiIgCIiAIiIAiIgCIiAIiIAiIgCIiAUiY13eU6KGpWdEQc2dgoHrJxOauukXZ9M464uf2KTuPpAY+uQ2kRaOviajYG3ad9SNagKnV6ioZ6ZTURz055gcs+M28kkREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREApOP3330TZ69XTAe6ZcqhPZQHk74444HA5nHcOM3e8e1ls7Wpcvx6teC/GqE4RfWxE+d727etUetVbVUqNqdvFj4eYAAAdwAEpJ0VlKi7tTada6qdbcuzv3ZPBR4IvJR6J0+4u5TXrC4uAVtFPnDVSO5T3L4t6h3ke9w9yTeEXFyCtqp4Dk1U+A/Y8T38h4yR9rb22dlSHaDhKgpCnQ0MysAeBXUAoAHeR4SIQbZWMerOio0VpqEQBUUBQoGAFHAAAchL0xbG7StSStTOadVFdDjGUYZHDu4GZGZoaHqJ5zGYB6iIgCIiAIiIAiIgCIiAIiIAiIgCIiAIiIAiIgCIiARd0zX5C29sM4Zmqt59A0qD9Nj6ppNwtyDdkXF0pW1U5VTwNYj6wnn+F3cOMy+mVT+VUCeRoMB6Q/H/cJzu6+17g31shuK5pm5pLpNZymguo06c4xjhiZP93Ezf7icr+8p2lu9VxppUUzhV+Co7Kqo7+QA9EgP8opkVhSpBS7611kVdNNSWKKdIw3EnJzkKRw7513ntzUs6yrTNR+rJRAcaqq9pOOR8IKefdIAtmZFf8AcIOfjccekkBx6zO/TRTTJkTXudtYX1iFdRTdUFNkQlMJjCOgByisuCMcsHB4Ti95re8samDc3DUWPYfrn4/stx4MPr5jvAu9G98w2g9ECmU/JlQsAA2igFVDqzx8oBhjmw5Ynb72AGkEZQyOxDKeRGM8+4g8QRxBE49Ztxpt8jt0WXbkSpNPoyKP/Wbn5TX9u/4zpdwNsVmvRSq1ajrUpsMO7Nh17QI1Hhw1Tnds7JNuwYEtRY9lu8HnpbwYfWOI78bDcJc7RpY7g59WhpyY5200+B7ufHhlp5SilyfQmiIidp8wIiIAiIgCIiAIiIAiIgCIiAIiIAiIgCIiAIiIBH3S7sw1LNLhR2rap2uH+FU7J/1aD6jIo2NcrSuqFVzhKVxTdiASQiOrMQBxPAHhPpC7tlq02pVAClRSrA96sMET573n3fqbPuDRfJQ5NN8cHp9x/eHIjx8xEzkupSS6ksf2mbP/AMyp/wDnqe7I7c7POr/rHwxH6jV4Y/KPP/7y/QPjw5ObHYmx3u6mhMKiDL1CCURD3nHMnkF7z6zCzvHbTItydEkbl3VktzWrUKjOeopqxNq9NU0KFJ1twy5Gccz58GbDae0Grvk8FXyV8B4nzzXWtslGmtCipWmhzx4s7nm7nvY/MBwHCXJ4eu10sz2x5fk9zR6Xy1ulz/BQhWUoyhkcYZTyI9PcRzBHEGXtyN3equnuAdVJaemm3DVlj2lYdxUKOPI6siUt6DVGCIMsx/8ACfNO4sLUUqYRe7mfFjzM18MU232X59hrM2yLjF8Xz/ozIiJ7Z44iIgCIiAIiIAiIgCIiAIiIAiIgCIiAUiJot5d56OzwhrhyKmrToUHyQM5yR4iEm3SBvYnO7b3uoWaUalUVCtypKaUBOAFPa48PLEythbepXtA16BbSrMpDABgV48RnvGCPTJ2urrgRZuJrdtbGo3tI0bhAyHiDyZW7irc1Mw92t6KO0A7UA4FIrq1qB5QJGME+Ew9v78W9lXNvVFRnCqx0KpA1cgcsOOBn1iNjbquItHCbR6MK6VgKDo9Bm4u3B6a95ZB5fAcNPMnkOc3lvZrb01t6SMiIc9pcO74wXc44scegDgJ3eyr9LmglxTyUqqGXIwQO8EdxByJyT9JdkDgpX4HH90OYP705c+klmjti67m2DLHDLc1bMRVJ4AE+gZmwtNi1ah4rpXxbh8y85uNibx212jPbtnqxl1KlWUYJGQe44PEcOEtbu73W9/r6gVB1Sqza0C9ls4xx/ZM5IeEKLuTbr/Dqn4hJqoqjZ7P2alBcKMseZPM/gPNM+cjsnf61uq6W9MVQ9UkKWpgLkKWwTnzGbLeTeajs8Ia+s9aWChFDHsgEk5I4cR889OGHYlGKr2OGUnJ7m7N7E1WwNt076j19EME1svbXB1Lz4Zmh2h0jWlCs9FxVLUnKsyopXUpw2Dq44OR6pdQk3SRW0dpEt03DKGByCAQfEHlLkqSIiIAiIgCIiAIiIAiIgCIiAIlMxAEjDpo8i2/eq/7UknzhOkzYFxepRFsgcoX1ZdVxqC48o+YzTC0ppsh8jnOlBsWdgfCi5+ZKU87vVm2TtWpZOT1FwAqk/tZNB/rKHznzTc7+bs3N3bWlOhTDPRpMrg1FXDFEAGSePFT80z+kLdVrylTqW6g3FE4xkLqpNzGTwyCAR6/GbRnHaovrf/CrTuzT9DZ007kngFNPPmwr5nM2tSnf3d7cV6lNOso1TS11FTNQ4WhjUeJCoOU6Xd7d29tbC8pikBXuAi0x1i8jqV2znhhWJld2ujZWpMdoK61dZCqlUYFMAYyRkZJ1eqS5RUpSsU+Bl9EO09dtUtWPao1NajwpVBnH01f6QnB7u3T06tY07Rbksjgo1NnCLr8vSoJ83d6Z2u6u691YbTZ1TNo3WU9XWLnqidSErnOQQo9Zmo2Tu1tW0qO9tTRWqAqSXpt2C2eGTwPKE43KmuNDjwMjopp09Ny/WZrGhjq9JGKYz29XJsnA4cvXPPQ7+s//AF6f9c3e4+5ta0664uWU1qtFqaorZwGIZi7cixKry5YPE54eOjbdq5s+v/KUCdZSRVw6tll158k8OYkSlF7qfYVyI1sA1Kmt6mdVvd0+A8MF1+coR/FOp39uxe3rhDmlaWBqDHxiofn59dIeqZ+x9y7gbPvLetTC1KnVtSGtTqqU8sBkHhnlx+NPWwty7mnZXoqIPyi4orTpr1inKji2WzgZOkfwy7nG918URTNluBfi22JUuG5Unrv6SMYHrOBI+srdKlhdV6tSmLnrabIrOod+0Wqsqk5OesPLvWdkd2r5djixSkOte6Zqg6xOFEdocc4OWC8PMZl7I6NKJtkN11guSpLhag0hiTpHAccDHfKKcU275smmzedHO0/yjZ1PUcvRzSbjnyPIz5yhQzq5H3RtsO7snqpc0wtKoqkEOrDrVODwBzxB/wBMkCYZElJ1yLLkeolIlCSsSkrAEREAREQBERAKSOaiXSVDUUXDKUSmydvGKl5cEVAPFAtPOPgP4YkjSklOiGcDbWjVCylbhgu0F/SFrmmWpuxLhkZhjTgKWXskYIxxlDY1nYNi41/ke0Mduoo65a6Lb5GQurQ76c8x6BiQMRiW3sUcLTotcsKpW4FNr2kF1GtTPVC3RamUyCF1qRkjmD48b27KOLntC5DinW/KTU16GrGqDS0F+yezrxo4BSAZ2mIxI3dBRGlol4KX5My3DlreiquWdSadeoGqKXPkuirVXJ4gaPGXS1V0Y3C3QuhY6KOha2gVkp1FreR2dRcZBbnlMZkjYjEl5PYURzcU6/WOFF11+bguf0vVmzNs4ohD5GrrOqwF7WoOfGWrinesj2ypXaoj00WpqZAyUabvTqBzwyS1AMO9lcSS8RiPM9hRyeyL13F2GWur1GNVA1OoAKbW1EAI5GkEPq7IOc54TnqdOrookC6Fv19LIdLpm1i3cViVUh9BfRjPZ1ZPKSbiMSFOugoj/eWnXN+xpC409QfIFUJjqLkHLDsHtmn2cai2kg8Jae1ru9dFaulR7i30PprjSgWmdWonQU1jio4+VnnJExK4k+ZwXAURvRatUdXrC5pa6F3yp13enUNWtjQE7OoKQV1AggLjmJes1qIKFwaVf9Fa3bFVa5Ku9J6fUN1bHUC+pyEYZ4kccCSFiMRv9hRGZtrtEp0nW4BtnqM7ipUdtLGg+tWU4qMC1XCHhgEYOMTYb10rk16wodfouLdaeaevCsgeqWBHkllV0yOOXQTvMRiPM43Qoju7e6L3DhLgU7jCgqz6hRt6tNKnVoO0jPT69gRxbII7pZrmq1uW010RU7CKl0yuUuahVWA/SqHULx5rqXuGJJWIjf7CiPtpWbqtZ1S4Us9oca7ippRirVgFRssAR2tPGW2t7gXNZx14puVCaTWKtpqWhOpWPYwuvTgcQz5PDjIuIjexRwFvcXCO1WslwEq3KVxpDuRSFV109WgLL+jNHKY4kMcc53dJ9ShhnBAIyCDg+IPEGXJWVbsUIiJBIiIgHJ7175Js6olN6Lv1qFgysoHZOCMH0j55pV6V6Hfb1/pUz/VPXS/Y6rWlcAcaNUqT4JUHvKnzyI514cMJxtmcpNMl+n0qWx8qjcL/AAofseZdPpNsT5RrL6aLH/bmQrE0emgRvZO9Pf6wb9YA/ep1F+1ZmW+9li5wt3b58DVVT8zET58iQ9LHo2N7PpijdI4yjqw8VYH7Jfny+oxy4ejhNjabauaP91cVk8wqsR9EnEo9I+jJ3n0fEgiy39v6f+OHHhUpqw+ddJ+udBZdK1QHFxbqw7zTqFT6lYH7RM3p5rlxLbkSvE5DZvSJZVuDu1FvCqukfSGV+udTbXCVFD02VkbkysGB9BExlGUeaJTTL8REgkREQBERAEREAREQBERAEREAREQBERANXvBswXdrUtyQOsQgMRkK44q2PMQDIyforuR5NegfTrX7FMmCJeGWUFSIcUyFn6Mb4cmtz/Nf76csVOjm/X4FJv3aw/qAk4RNPUzK7EQBX3Mv052rnzqUf/a0wKuwrpPKtrgfyXP2CfR0Sy1UuqGxHzFVQocOrKfBlKn5jPIM+m6tFXGGVWHgVB+2au63Ys6v95a0CfEUlVvpKAZdavuiNh88RJquujWxfJRatMn4tViB6A2RNDe9FDAE0LkE9wqU8fOyH+maLUwZXYyM5k7Pv6ts2u3qNTbOcq2Af3hyb1zd7R3GvqAJNAuo+FTYPw8dPl/VOdqIUbS6srDmrKVI9IPGaqUZrhxIpomjo73oq36VEuAuuho7a8NQfXzXkCNPMc88hO1EiXocf/qLlfGlTPzM/wCMloTz80VGbSNYu0ViImRYREQBERAEREAREQBERAEREAREQBKSsQDzKzEvr+nQAatURFJwC7hQT4DPMzVvvdZD9Ypn0HV9khtLmXjjnL9qb/pG/icnW3+s15M7H9mk/wBpAExm6R7buSsf4VH9Ur5ke5qtJnfKL+x2kricG3SVR+DQqn0lR98sN0mDutm9dUD7pHmx7l1oNQ//ACSHEjo9Jv8A8b/vf8ZUdJg77Y+qqPdjzYdy36fqfp+USHiYG0tkULpdNxSSoO7UuSPQ3Meozk6XSVRPlUKo9BU/eJnW3SBaMcMaiZ+MhI+dcyyyx6Mzlo88ecWa2rs2hsJzd0RUanXApdUWBKtksGDtxIwMYOT55dTpJofCoVh9A/1TG6QNp0bizRqFRXArgHSwODpbmO6R3MsuWW7melovD8WTFc07t+xKydIlqea1l9KA/YTL6b+2R51HHpo1PuWRFEz86R0PwnC+/wByZV31sj/jj103H2rLq73WR/WaY9Jx9okKxJ89lX4Ri+p/BOabyWjcrmh7VPxmTT2nRbyatM+ioD98gPE8lB4D5pPnvsZvwePST+x9CLcoeTKf4hPYqA8iPnnzyFHhPauw5Mw9DEfZJ8/2KvwftL4PoQGVzIAW/rL5NasPRWcffL6bbuV8m4re0Y/aZPnrsUfg8+kkTxGZBy7zXg5XNX51P2ibjdra1/dXK0luH0AhnYpTOKYPH4PM8h5zJWVN1Rjk8MyY4ucmqRLWZWeVE9TY80REQBERANbtvZaXdBqNTkw4HvDjyWHnBkJbSsXtqrUaowyH1Fe5h5jJ9M53e3dxb2l2cLXQHQ3j+yx+Kfq5zLLDcrXM9DQazyJVLk/ghqJcuaDUmanUUqynDKeYMUaL1P7tHf8AdRm+wTkpn0u+NXfAtxNxabr3lXitBwPF9KD/AFEH6ptbfo+u2PbNFB53Zj8wXH1yyxyfQxnq8EOcl9zkokgUujNvhXI/hpfi0zKfRtRHlV6p9AUfcZZYZdjCXiWnXW/8ZGcSUx0c23x630l92cBvnZpYXQt0V2RqQcMagBySwIxpxwKxLFJK2MfiOHJLar+xmbm7Hp3ldqNUsFFPWCpAOQwHeDw4zsT0cW3+ZWH8S+7OH3M3io2tVrhxUKilpKKqltTuuCpLAEcDniDw5GdoOlCz+JcD+WnvzoxYHKN7Ty9dq5xzNQlSpFW6NaHdWrD6B/png9GlLur1fWqH7pfXpNsjz64emj+BM9DpLsfjVR/Jaaen/icnr8/1swj0aJ3XD+zX8Z5PRmO65PsR702X9pNh8ep7B/wlf7SLD/MqewqfhHpn9LLfqOo+v8GpPRn4XX/Y/wCc8N0ZN3XS+u3/AOc3Y6Rtn/5rewqe7Lq9IGzz+sY9NKp7sj038WT+paj6vhHNno0qd1ynroMP655PRtW/z6R/lsPvnUrv1s8/rKetHH2rLg31sD+tUvnP4SPTez+S36nqPq+Ecc3Rzcd1WkfUw+6W26Orrueif4mH9M7pd77A8ruh7QS7S3ls3IVLqgSSAAKq5JPIDjIenXZkrxPUd19iPD0e3fcaHtH9yd1upsAWVDScNVc5dvE9wHmH4nvnQYjERxxi7Rnm1ubNHbN8D1ERLnIIiIAiIgCUIlYgGuudkUKr9ZVo03cDGpqascekiZdOiqjCqAPAAAS7EiiXJtVYxGJWJJAiIgFJHPSVuvXvK1Cpb09WlKiudSDSuQV4MwzntAfXiSNEhq1TLQm4O0QO25O0MBVtGCA5wa1DJb4zfpOJ7vN3d+bf5jbR+SN7Wh78nyUnRHUSiqSRSa3u5MgT8xto/JG9tQ9+PzG2j8kb21D35PmIxLeqn2RXYiA/zG2j8kb2tD34/MbaPyRva0Pfk+RHqp9kNiID/MbaPyRva0Pfj8xto/JG9rQ9+T5iMR6qfZDYiA/zG2j8kb21D34/MbaPyRvbUPfk+YjEeqn2Q2IgP8xdo/JG9tQ9+SBuPuKLXFzdANc47K5BWlnw7i37Xd3eJ7zESk88pKiVFICViJiWEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQD//2Q==" 
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








Saludos cordiales,




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



