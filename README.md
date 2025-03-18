
Sistema de Gestión de Inventarios

Descripción
Este sistema permite administrar productos, ubicaciones, almacenes, transacciones y usuarios, garantizando la seguridad y optimización en la gestión de datos. Utiliza MySQL para la base de datos relacional y MongoDB para datos no relacionales.

Requisitos
MySQL Workbench
MySQL Server
MongoDB Compass
MongoDB Server

Instalación

MySQL:
Instalar MySQL Server y MySQL Workbench.
Crear la base de datos Control_Inventario utilizando el script proporcionado en la sección 2.2 del documento.
MongoDB:
Instalar MongoDB Server y MongoDB Compass.
Crear las siguientes colecciones en MongoDB:
almacenes
comentarrios_productos
historial_productos
productos
inventario_roles
transacciones
usuarios
Uso

Configuración de la Base de Datos MySQL:

Conectar a la base de datos Control_Inventario en MySQL Workbench.
Ejecutar los scripts de creación de tablas, relaciones, índices y restricciones proporcionados en la sección 2.2 del documento.

Configuración de MongoDB:
Conectar a MongoDB Server usando MongoDB Compass.
Asegurarse de que las colecciones mencionadas en la sección de Instalación (MongoDB) estén creadas.
Procedimientos Almacenados:

Los procedimientos almacenados para las operaciones CRUD (Crear, Leer, Actualizar, Eliminar) de productos y usuarios están definidos en la sección 3.1 del documento. Utilizar MySQL Workbench para crearlos en la base de datos Control_Inventario.

Consultas y Reportes:
Ejemplos de consultas para obtener información del inventario se encuentran en la sección 3.2 del documento.

Diagrama E-R
El diagrama Entidad-Relación se encuentra en la sección 2.1.2 del documento.

