## 🖥️ 11. Interacción con el Dominio de Windows

Esta sección contiene scripts diseñados para conectarse al dominio de Windows de la organización y consultar información relevante, como usuarios, grupos, políticas, y otros objetos del Directorio Activo.

---

### 🔐 11.1 [Conectar a un dominio de Windows y leer información](#leerdominio)

Script que permite establecer conexión con el dominio de Windows utilizando credenciales válidas y obtener información del Active Directory, útil para auditoría, validación de cuentas y sincronización con otros sistemas.

---


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