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

*Fin del documento*