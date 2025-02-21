# Instalación y Configuración de PostgreSQL en Docker en Fedora

Este documento detalla los pasos necesarios para instalar, configurar y conectar un servidor **PostgreSQL en Docker** en un sistema **Fedora Linux**, asegurando que sea accesible desde otras máquinas para simulaciones de alta disponibilidad y ambientes de producción.

## **1. Instalación de Docker en Fedora**
Si Docker no está instalado en el servidor Fedora, instálelo con los siguientes comandos:

```bash
sudo dnf install -y docker
sudo systemctl enable --now docker
sudo usermod -aG docker $USER
```

Luego, cierre sesión y vuelva a iniciar sesión para aplicar los cambios del grupo `docker`.
Para verificar la instalación:

```bash
docker --version
```

## **2. Descargar e Iniciar PostgreSQL en un Contenedor Docker**
Para descargar e iniciar PostgreSQL en Docker sin afectar una instalación existente de PostgreSQL en el servidor, ejecute:

```bash
docker pull postgres:15
```

Ahora, cree y ejecute un contenedor PostgreSQL:

```bash
docker run -d \
  --name postgres-ha \
  -e POSTGRES_USER=admin \
  -e POSTGRES_PASSWORD=admin123 \
  -e POSTGRES_DB=mydb \
  -p 5433:5432 \
  -v pgdata:/var/lib/postgresql/data \
  postgres:15
```

📌 **Explicación de los parámetros:**
- `-d`: Ejecuta el contenedor en segundo plano.
- `--name postgres-ha`: Nombre del contenedor.
- `-e POSTGRES_USER=admin`: Usuario administrador.
- `-e POSTGRES_PASSWORD=admin123`: Contraseña del usuario.
- `-e POSTGRES_DB=mydb`: Base de datos predeterminada.
- `-p 5433:5432`: Mapea el puerto 5433 en Fedora al 5432 dentro del contenedor.
- `-v pgdata:/var/lib/postgresql/data`: Usa un volumen persistente.

Para verificar que el contenedor está corriendo:

```bash
docker ps
```

Para ver los logs del contenedor:

```bash
docker logs postgres-ha
```

## **3. Configurar PostgreSQL para Conexiones Remotas**
Para permitir conexiones externas, edite `postgresql.conf` y `pg_hba.conf` dentro del contenedor.

### **3.1. Modificar `postgresql.conf`**
Acceda al contenedor:

```bash
docker exec -it postgres-ha bash
```

Ejecute:

```bash
cat /var/lib/postgresql/data/postgresql.conf | grep listen_addresses
```

Si muestra `listen_addresses = 'localhost'`, debe cambiarlo. Use el siguiente comando para modificarlo:

```bash
psql -U admin -d mydb -c "ALTER SYSTEM SET listen_addresses = '*';"
```

### **3.2. Modificar `pg_hba.conf`**
Ejecute:

```bash
echo "host    all     all     0.0.0.0/0      md5" >> /var/lib/postgresql/data/pg_hba.conf
```

Reinicie PostgreSQL dentro del contenedor:

```bash
docker restart postgres-ha
```

## **4. Configurar el Firewall en Fedora**
Para permitir conexiones externas al puerto 5433, ejecute:

```bash
sudo firewall-cmd --add-port=5433/tcp --permanent
sudo firewall-cmd --reload
```

## **5. Conectar PostgreSQL desde Otra Máquina**
Desde otra máquina con **pgAdmin** o `psql`, conéctese al servidor PostgreSQL en Docker.

### **5.1. Obtener la IP del Servidor Fedora**
Ejecute en Fedora:

```bash
ip a
```

Tome nota de la IP de la interfaz de red principal (ejemplo: `192.168.1.100`).

### **5.2. Conectar con `pgAdmin`**
1. Abrir **pgAdmin** y seleccionar `Add New Server`.
2. En la pestaña **General**, ingresar un nombre (ejemplo: `PostgreSQL Docker`).
3. En la pestaña **Connection**:
   - **Host name/address**: `192.168.1.100` (IP del servidor Fedora).
   - **Port**: `5433`.
   - **Maintenance database**: `mydb`.
   - **Username**: `admin`.
   - **Password**: `admin123`.
4. Guardar y conectar.

### **5.3. Conectar con `psql` desde Otra Máquina**
Si `psql` está instalado, usar:

```bash
psql -h 192.168.1.100 -p 5433 -U admin -d mydb
```

## **6. Solución de Problemas**
Si la conexión falla:

1. **Revisar los logs del contenedor:**
   ```bash
   docker logs postgres-ha
   ```
2. **Verificar que PostgreSQL escucha en todas las interfaces:**
   ```bash
   docker exec -it postgres-ha psql -U admin -c "SHOW listen_addresses;"
   ```
3. **Verificar que el puerto está abierto:**
   ```bash
   sudo netstat -tulnp | grep 5433
   ```
4. **Revisar reglas de `pg_hba.conf` dentro del contenedor:**
   ```bash
   cat /var/lib/postgresql/data/pg_hba.conf
   ```
5. **Verificar si SELinux está bloqueando el acceso:**
   ```bash
   sestatus
   ```
   Si está activo, desactivarlo temporalmente:
   ```bash
   sudo setenforce 0
   ```

---

Con estos pasos, tienes un **servidor PostgreSQL en Docker** en Fedora configurado para permitir conexiones remotas, ideal para pruebas de alta disponibilidad y ambientes de producción. 🚀

