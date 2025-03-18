-- Crear base de datos 'Control_Inventario'
CREATE DATABASE IF NOT EXISTS Control_Inventario;
USE Control_Inventario;

-- Tabla 'Productos'
CREATE TABLE Productos (
    id_producto INT PRIMARY KEY AUTO_INCREMENT,
    codigo_producto VARCHAR(255) UNIQUE,
    nombre VARCHAR(255),
    descripcion TEXT,
    precio_unitario DECIMAL(10, 2),
    stock_disponible INT
);

-- Tabla 'Almacenes'
CREATE TABLE Almacenes (
    id_almacen INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(255),
    direccion VARCHAR(255)
);

-- Tabla 'Ubicaciones'
CREATE TABLE Ubicaciones (
    id_ubicacion INT PRIMARY KEY AUTO_INCREMENT,
    id_almacen INT,
    nombre VARCHAR(255),
    FOREIGN KEY (id_almacen) REFERENCES Almacenes(id_almacen)
);

-- Tabla 'Productos_Ubicaciones'
CREATE TABLE Productos_Ubicaciones (
    id_producto INT,
    id_ubicacion INT,
    PRIMARY KEY (id_producto, id_ubicacion),
    FOREIGN KEY (id_producto) REFERENCES Productos(id_producto),
    FOREIGN KEY (id_ubicacion) REFERENCES Ubicaciones(id_ubicacion)
);

-- Crear roles y usuarios
CREATE TABLE Roles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre ENUM('Administrador', 'Operador') UNIQUE NOT NULL
);

-- Tabla 'Usuarios'
CREATE TABLE Usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    rol ENUM('Administrador', 'Operador') NOT NULL,
    clave_hash VARCHAR(255) NOT NULL,
    rol_id INT NOT NULL,
    FOREIGN KEY (rol_id) REFERENCES Roles(id) ON DELETE CASCADE
);

-- Tabla 'Transacciones'
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

-- Tabla 'Historial_Productos'
CREATE TABLE Historial_Productos (
    id_historial INT PRIMARY KEY AUTO_INCREMENT,
    id_producto INT,
    id_usuario INT, -- Relación con Usuarios
    fecha_modificacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    cambios JSON,
    FOREIGN KEY (id_producto) REFERENCES Productos(id_producto),
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) -- Nueva relación
);

-- Procedimiento para registrar un producto
DELIMITER //
CREATE PROCEDURE RegistrarProducto (
    IN p_codigo VARCHAR(50),
    IN p_nombre VARCHAR(100),
    IN p_descripcion TEXT,
    IN p_precio DECIMAL(10, 2),
    IN p_stock INT,
    IN p_ubicacion VARCHAR(100)
)
BEGIN
    INSERT INTO Productos (codigo, nombre, descripcion, precio, stock, ubicacion)
    VALUES (p_codigo, p_nombre, p_descripcion, p_precio, p_stock, p_ubicacion);
END //
DELIMITER ;

-- Procedimiento para actualizar un producto
DELIMITER //
CREATE PROCEDURE ActualizarProducto (
    IN p_id INT,
    IN p_nombre VARCHAR(100),
    IN p_descripcion TEXT,
    IN p_precio DECIMAL(10, 2),
    IN p_stock INT,
    IN p_ubicacion VARCHAR(100)
)
BEGIN
    UPDATE Productos 
    SET nombre = p_nombre, descripcion = p_descripcion, precio = p_precio, stock = p_stock, ubicacion = p_ubicacion
    WHERE id_producto = p_id;
END //
DELIMITER ;

-- Procedimiento para eliminar un producto
DELIMITER //
CREATE PROCEDURE EliminarProducto (
    IN p_id INT
)
BEGIN
    DELETE FROM Productos WHERE id_producto = p_id;
END //
DELIMITER ;

-- Procedimiento para registrar un usuario
DELIMITER //
CREATE PROCEDURE RegistrarUsuario (
    IN p_nombre VARCHAR(100),
    IN p_clave_hash VARCHAR(255),
    IN p_rol_nombre ENUM('Administrador', 'Operador')
)
BEGIN
    DECLARE v_rol_id INT;
    
    -- Obtener el ID del rol
    SELECT id INTO v_rol_id FROM Roles WHERE nombre = p_rol_nombre;
    
    -- Insertar el usuario
    INSERT INTO Usuarios (nombre, clave_hash, rol_id)
    VALUES (p_nombre, p_clave_hash, v_rol_id);
END //
DELIMITER ;

-- Procedimiento para modificar un usuario
DELIMITER //
CREATE PROCEDURE ModificarUsuario (
    IN p_id INT,
    IN p_nombre VARCHAR(100),
    IN p_clave_hash VARCHAR(255),
    IN p_rol_nombre ENUM('Administrador', 'Operador')
)
BEGIN
    DECLARE v_rol_id INT;
    
    -- Obtener el ID del rol
    SELECT id INTO v_rol_id FROM Roles WHERE nombre = p_rol_nombre;
    
    -- Actualizar el usuario
    UPDATE Usuarios 
    SET nombre = p_nombre, clave_hash = p_clave_hash, rol_id = v_rol_id
    WHERE id = p_id;
END //
DELIMITER ;

-- Procedimiento para eliminar un usuario
DELIMITER //
CREATE PROCEDURE EliminarUsuario (
    IN p_id INT
)
BEGIN
    DELETE FROM Usuarios WHERE id = p_id;
END //
DELIMITER ;

-- Tabla 'Permisos'
CREATE TABLE Permisos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE NOT NULL
);

-- Tabla 'RolPermisos'
CREATE TABLE RolPermisos (
    rol_id INT,
    permiso_id INT,
    PRIMARY KEY (rol_id, permiso_id),
    FOREIGN KEY (rol_id) REFERENCES Roles(id) ON DELETE CASCADE,
    FOREIGN KEY (permiso_id) REFERENCES Permisos(id) ON DELETE CASCADE
);

-- Ejemplo de asignación de permisos
-- INSERT INTO Permisos (nombre) VALUES ('Gestionar Usuarios'), ('Ver Reportes');
-- INSERT INTO RolPermisos (rol_id, permiso_id) VALUES (1, 1), (1, 2), (2, 2); -- Admin tiene todos, Operador solo reportes

-- Reportes básicos
-- Inventario general
SELECT codigo_producto AS codigo, nombre, stock_disponible AS stock, precio_unitario AS precio, 
       (stock_disponible * precio_unitario) AS valor_total 
FROM Productos;

-- Reporte de productos por ubicación
SELECT u.nombre AS ubicacion, GROUP_CONCAT(p.nombre SEPARATOR ', ') AS productos 
FROM Productos p
JOIN Productos_Ubicaciones pu ON p.id_producto = pu.id_producto
JOIN Ubicaciones u ON pu.id_ubicacion = u.id_ubicacion
GROUP BY u.id_ubicacion;

-- Producto con bajo stock
SELECT * FROM Productos WHERE stock_disponible < 10;
