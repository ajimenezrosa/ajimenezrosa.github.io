

## Alejandro Jimenez Rosa

<table>
<thead>
<tr>
  <th>Inicio de  </th>
  <th> manual de MongoDB  AJ</th>
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

# Administracion de MongoDB.
<img src="https://webimages.mongodb.com/_com_assets/cms/kuzt9r42or1fxvlq2-Meta_Generic.png?format=jpg&name=large" alt="JuveR" width="800px">

# Administracion





# Servers MONGO PROD

~~~bash
PROD: azhvcdbgmas01.corp.popular.local
      azhvcdbgmas02.corp.popular.local
      azhvcdbgmas03.corp.popular.local
~~~
#


### MONGO ATLAS – CoreLibrary 
 - PROYECTO DONDE SE SUELE MIGRAR LAS DB ONPREMISE DE MONGODB
 #

 <img src=".\img\atlas.png" alt="JuveR" width="700px">

<!-- ![](./img/atlas.png) -->

#





## SERVIDOR MONGO ONPREMISE PROD


 <img src="./img/ONPREMISE%20PROD.png" alt="JuveR" width="800px">


<!-- ![](./img/ONPREMISE%20PROD.png) -->
#


## SERVIDOR STAGIN MONGODB – NO SALE EN PAM Y DEBE ESTABLECER CONEXIÓN POR MOBAEXTERM O PUTTY

  AZDEHVSAPPATLA01
      User:
      _admin


    Pwd: 12345678As12345678As


  IP: 10.46.2.15
  AZDEHVSAPPATLA01



    User:
    _admin


    Pwd: 12345678As12345678As


  IP: 10.46.2.15


A screen shot of a computer

Description automatically generated

 <img src="./img/imagenpantalla2.png" alt="JuveR" width="800px">

<!-- ![](./img/imagenpantalla2.png) -->

~~~cmd
  Pass DB: #iHEgU9ynyKebI - root
  dbauserprod


  Popular001
~~~




1. Hacer backup de las bases de datos indicadas en el servidor de producción: Usar usuario root

#### Conectar al servidor de producción usando root.


 <img src="./img/imagenpantalla3.png" alt="JuveR" width="800px">

<!-- ![](./img/imagenpantalla3.png) -->

~~~bash
Pass DB: #iHEgU9ynyKebI - root
~~~

~~~bash
mongodump --ssl --authenticationDatabase admin 
--host=azhvcdbgmas01.corp.popular.local 
--port=27017 -u=root -p=#iHEgU9ynyKebI 
--sslPEMKeyFile=/etc/ssl/certs/server.pem 
--sslCAFile=/etc/ssl/certs/ca.pem --db=PersistentSessionStorageDB 
--archive=PersistentSessionStorageDB
~~~




#### Cambiar los permisos del backup en caso de ser necesario:

~~~bash
chmod 777 nombreBackup
~~~




2. Validar que accedemos al URI para mongo atlas.

~~~bash
mongosh mongodb+srv://msquarkus@corelibrary.fx2tn.mongodb.net --apiVersion 1
~~~




3. Mover backup generado en el servidor de producción a la maquina local y posteriormente moverlo al servidor stagin:

 <img src="./img/imagenpantalla4.png" alt="JuveR" width="700px">

<!-- ![](./img/imagenpantalla4.png) -->

#

#### Usamos WINSCP
 <img src="./img/imagenpantalla5.png" alt="JuveR" width="800px">

<!-- ![](./img/imagenpantalla5.png) -->



## CONEXIÓN AL SERVIDOR STAGIN USANDO WINSCP

 <img src="./img/imagenpantalla6.png" alt="JuveR" width="800px">

<!-- ![](./img/imagenpantalla6.png) -->





4. Restaurar la base de datos en mongoatlas a través del servidor stagin. Deben de compartir o validar la URI el equipo de Cloud. Usar usuario  DBAUSERPROD

~~~bash
User: dbauserprod
Pwd:  Popular001
~~~


~~~bash
mongorestore --uri=mongodb+srv://corelibrary.fx2tn.mongodb.net 
--username=dbauserprod --authenticationDatabase=admin 
--nsInclude="OnBoardingDB.*" --archive=OnBoardingDB
~~~







5. Conectar a la base de datos mongodb, para borrar colecciones en caso de ser necesario.


~~~bash
mongosh "mongodb+srv://corelibrary.fx2tn.mongodb.net" --apiVersion 1 --username dbauserprod
~~~


~~~bash
mongosh mongodb+srv://msquarkus@corelibrary.fx2tn.mongodb.net --apiVersion 1
~~~



~~~bash
use OnBoardingDB
db.customerDetails.drop()
~~~
