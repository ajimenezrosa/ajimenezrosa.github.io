#### **6. Auditoría y Seguridad**
- 6.1 [Detener un proceso de auditoría en SQL Server](#13)  
- 6.2 [Cambiar el Collation en una instancia de SQL Server](#cambiarcollattionsql)  
- 6.3 [Cambio del esquema de una tabla por query](#cambiarsquemad)  
- 6.4 [Lista de permisos por usuario](#listausuariosdb)  
- 6.5 [Número de sesiones por usuario en SQL Server](#numeroseccionessqlserver)  
* 6.6 [Objetos modificados en los últimos 10 días](#objectosmodificadosultimosdias)  
 - 6.7 [Listado de transacciones bloqueadas en un servidor DB](#bloqueos2)  
 - 6.8 [Verificar logs de errores del SQL Server](#errorlogsql)  
 - 6.9 [Cerrar todas las conexiones a una base de datos](#cerrarconexionessql)  
 - 6.10 [Documentación de SQL Scripts para backup y restore con TDE](#tde1)  

 -  6.11 [Cómo saber si una base de datos tiene TDE](#49)  
 -  6.11.1 [Validación de Bases de Datos: TDE y Columnas Encriptadas]
    - [Introducción](#introducción)
    - [Consulta de Columnas Encriptadas](#consulta-de-columnas-encriptadas)
    - [Consulta de Bases de Datos con TDE Habilitado](#consulta-de-bases-de-datos-con-tde-habilitado)

 - 6.12 [Script de Microsoft para detectar problemas SDP](#45sdp)  

 - 6.13 [Documentación del Tamaño de Bases de Datos en SQL Server](#6.13)

 ## Detener un proceso de auditoría en SQL Server generalmente implica deshabilitar o detener la auditoría en sí. Aquí te muestro cómo hacerlo:<a name="13"></a>

<img src="https://i.ytimg.com/vi/wOdycyG4yx0/maxresdefault.jpg?format=jpg&name=large" alt="JuveR" width="800px">


1. **Detener una auditoría de servidor**:

   Si deseas detener una auditoría de nivel de servidor, puedes utilizar el siguiente comando:

   ~~~sql
   ALTER SERVER AUDIT NombreDeTuAuditoria WITH (STATE = OFF);
   ~~~

   Asegúrate de reemplazar `NombreDeTuAuditoria` con el nombre real de tu auditoría.

2. **Detener una auditoría de base de datos**:

   Si deseas detener una auditoría de nivel de base de datos, utiliza el siguiente comando:

   ~~~sql
   ALTER DATABASE AUDIT SPECIFICATION NombreDeTuAuditoria WITH (STATE = OFF);
   ~~~

   Nuevamente, asegúrate de reemplazar `NombreDeTuAuditoria` con el nombre real de tu auditoría de base de datos.

3. **Detener una sesión de auditoría**:

   Las auditorías en SQL Server se ejecutan a través de sesiones de auditoría. Para detener una sesión de auditoría, puedes utilizar el siguiente comando:

   ~~~sql
   ALTER SERVER AUDIT SPECIFICATION NombreDeTuSesion WITH (STATE = OFF);
   ~~~

   Reemplaza `NombreDeTuSesion` con el nombre real de tu sesión de auditoría.

4. **Eliminar una auditoría o sesión de auditoría**:

   Si deseas eliminar completamente una auditoría o sesión de auditoría, puedes usar el siguiente comando:

   ~~~sql
   DROP SERVER AUDIT NombreDeTuAuditoria;
   ~~~

   O

   ~~~sql
   DROP DATABASE AUDIT SPECIFICATION NombreDeTuAuditoria;
   ~~~

   O

   ~~~sql
   DROP SERVER AUDIT SPECIFICATION NombreDeTuSesion;
   ~~~

   Ten en cuenta que eliminar una auditoría o sesión de auditoría borrará todos los datos relacionados con ella, por lo que ten cuidado al utilizar este comando.

#### Recuerda que para ejecutar estos comandos, generalmente necesitas permisos de administrador o permisos adecuados en tu instancia de SQL Server.
#


# Cambiar el Collation en una instancia SQL Server<a name="cambiarcollattionsql"></a>


#### El collation o intercalación de nuestra base de datos va a definir qué caracter se asocia con el valor almacenado. Por lo tanto, un mismo valor almacenado puede tener una representación diferente dependiendo del collation asignado.

#### Esto solo aplica a formatos no unicode. La desventaja de los formatos unicode es que ocupan un mayor tamaño de almacenamiento.

#### Vemos cómo cambiar el collation de nuestra base de datos SQL Server.

## Cambiar Collation
#### En la siguiente sentencia vamos a establecer «single_user» en nuestra base de datos «PRODB»  y cambiaremos la intercalación a «SQL_Latin1_General_CP1_CI_AS«.

#### Por último, volvemos a poner la base de datos en «multi_user«.

#### Recuerda acordar una ventana de mantenimiento si esta base de datos está en producción.
# 


~~~sql
USE MASTER
GO
ALTER DATABASE PRODB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO
ALTER DATABASE PRODB COLLATE SQL_Latin1_General_CP1_CI_AS;
GO
ALTER DATABASE PRODB SET MULTI_USER;
GO
~~~
# 


# Cambio del Esquema de una tabla por Query<a name="cambiarsquemad"></a>

#### El codigó para cambiar el esquema de una tabla es el siguente:
# 


~~~sql
ALTER SCHEMA esquema_nuevo TRANSFER esquema_viejo.Tabla;
~~~
# 




