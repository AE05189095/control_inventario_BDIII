CREATE DATABASE IF NOT EXISTS Control_Inventario;
USE Control_Inventario;

CREATE TABLE Productos (
    id_producto INT PRIMARY KEY AUTO_INCREMENT,
    codigo_producto VARCHAR(255) UNIQUE,
    nombre VARCHAR(255),
    descripcion TEXT,
    precio_unitario DECIMAL(10, 2),
    stock_disponible INT
);

CREATE TABLE Almacenes (
    id_almacen INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(255),
    direccion VARCHAR(255)
);

CREATE TABLE Ubicaciones (
    id_ubicacion INT PRIMARY KEY AUTO_INCREMENT,
    id_almacen INT,
    nombre VARCHAR(255),
    FOREIGN KEY (id_almacen) REFERENCES Almacenes(id_almacen)
);

CREATE TABLE Productos_Ubicaciones (
    id_producto INT,
    id_ubicacion INT,
    PRIMARY KEY (id_producto, id_ubicacion),
    FOREIGN KEY (id_producto) REFERENCES Productos(id_producto),
    FOREIGN KEY (id_ubicacion) REFERENCES Ubicaciones(id_ubicacion)
);

CREATE TABLE Roles (
    id_rol INT PRIMARY KEY AUTO_INCREMENT,
    nombre_rol VARCHAR(255)
);

CREATE TABLE Usuarios (
    id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    nombre_usuario VARCHAR(255),
    contrasena VARCHAR(255),
    id_rol INT,
    FOREIGN KEY (id_rol) REFERENCES Roles(id_rol)
);

CREATE TABLE Transacciones (
    id_transaccion INT PRIMARY KEY AUTO_INCREMENT,
    id_producto INT,
    id_usuario INT, -- Relación con Usuarios
    cantidad INT,
    tipo VARCHAR(255),
    fecha DATETIME,
    FOREIGN KEY (id_producto) REFERENCES Productos(id_producto),
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario), -- Nueva relación
    INDEX (id_producto)
);

CREATE TABLE Historial_Productos (
    id_historial INT PRIMARY KEY AUTO_INCREMENT,
    id_producto INT,
    id_usuario INT, -- Relación con Usuarios
    fecha_modificacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    cambios JSON,
    FOREIGN KEY (id_producto) REFERENCES Productos(id_producto),
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) -- Nueva relación
);

CREATE TABLE Usuarios_Almacenes (
    id_usuario INT,
    id_almacen INT,
    PRIMARY KEY (id_usuario, id_almacen),
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario),
    FOREIGN KEY (id_almacen) REFERENCES Almacenes(id_almacen)
);
