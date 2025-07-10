# 📘 Manual de Instalación de Oracle Database 21c XE en Oracle Linux (Azure)

## 👨‍💻 Autor: José Alejandro Jiménez Rosa

---

## 📌 Requisitos Previos

- Una máquina virtual con Oracle Linux 7 u 8 (recomendado: Oracle Linux 8.9)
- Acceso SSH como usuario con privilegios `sudo`
- Conexión a internet
- Al menos 2 GB de RAM y 10 GB de disco libre

---

## 🧱 1. Actualizar el sistema operativo

```bash
sudo dnf update -y
```

---

## 📦 2. Instalar pre-requisitos de Oracle

```bash
sudo dnf install -y oracle-database-preinstall-21c
```

Esto crea el usuario `oracle`, grupos necesarios y ajusta parámetros de kernel.

---

## 📥 3. Descargar Oracle Database XE 21c

```bash
cd /tmp
curl -L -o oracle-database-xe-21c-1.0-1.ol7.x86_64.rpm https://download.oracle.com/otn-pub/otn_software/db-express/oracle-database-xe-21c-1.0-1.ol7.x86_64.rpm
```

---

## 🧰 4. Instalar Oracle XE

```bash
sudo dnf localinstall -y oracle-database-xe-21c-1.0-1.ol7.x86_64.rpm
```

---

## ⚙️ 5. Configurar la base de datos Oracle

```bash
sudo /etc/init.d/oracle-xe-21c configure
```

Sigue las instrucciones:
- Ingresa una contraseña segura para SYS, SYSTEM y PDBADMIN (ej: Oracle123)
- Acepta los puertos por defecto: 1521 (listener) y 5500 (Enterprise Manager)

---

## 🔎 6. Verificar que Oracle esté instalado

```bash
sudo systemctl status oracle-xe-21c
```

Si no aparece el servicio, continúa con el paso siguiente para crearlo manualmente.

---

## 🔧 7. Iniciar Oracle manualmente (si systemd no lo reconoce)

```bash
sudo /etc/init.d/oracle-xe-21c start
```

---

## 🛠️ 8. Crear servicio systemd para Oracle

```bash
sudo nano /etc/systemd/system/oracle-xe.service
```

Contenido del archivo:

```ini
[Unit]
Description=Oracle XE 21c Database Service
After=network.target

[Service]
Type=forking
ExecStart=/etc/init.d/oracle-xe-21c start
ExecStop=/etc/init.d/oracle-xe-21c stop
Restart=always
User=root

[Install]
WantedBy=multi-user.target
```

Guardar y salir. Luego ejecutar:

```bash
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable oracle-xe
sudo systemctl start oracle-xe
sudo systemctl status oracle-xe
```

---

## 🔐 9. Configurar el entorno del usuario `oracle`

```bash
sudo passwd oracle
sudo su - oracle

echo 'export ORACLE_HOME=/opt/oracle/product/21c/dbhomeXE' >> ~/.bash_profile
echo 'export ORACLE_SID=XE' >> ~/.bash_profile
echo 'export PATH=$ORACLE_HOME/bin:$PATH' >> ~/.bash_profile
echo 'export LD_LIBRARY_PATH=$ORACLE_HOME/lib' >> ~/.bash_profile
source ~/.bash_profile
```

---

## 🧪 10. Ingresar a Oracle y validar

```bash
sqlplus / as sysdba
```

Verificar estado de la base:

```sql
SELECT name, open_mode FROM v$pdbs;
```

---

## 🗝️ 11. Cambiar contraseña del usuario SYSTEM

```sql
ALTER USER system IDENTIFIED BY Oracle123;
```

---

## 🌐 12. Abrir puerto 1521 en Azure

1. Ir al portal de Azure → VM → Red
2. Agregar regla de entrada:
   - Puerto: 1521
   - Protocolo: TCP
   - Acción: Permitir
   - Prioridad: 1000
   - Nombre: AllowOraclePort

---

## 🔗 13. Conectarse desde herramienta externa

| Parámetro  | Valor                          |
|------------|--------------------------------|
| Host       | IP pública de la VM en Azure   |
| Puerto     | 1521                           |
| Usuario    | system                         |
| Contraseña | Oracle123                      |
| Servicio   | XEPDB1                         |

---

## 🧼 14. Comandos útiles

| Acción               | Comando                             |
|----------------------|-------------------------------------|
| Iniciar Oracle       | `sudo systemctl start oracle-xe`    |
| Detener Oracle       | `sudo systemctl stop oracle-xe`     |
| Ver estado           | `sudo systemctl status oracle-xe`   |
| SQL*Plus como SYSDBA | `sqlplus / as sysdba`               |
| Ver proceso pmon     | `ps -ef | grep pmon`                |

---

## 🎯 Resultado Final

Entorno Oracle Database XE 21c instalado y listo en Oracle Linux sobre Azure, accesible por terminal y herramientas gráficas como SQL Developer o DBeaver.
