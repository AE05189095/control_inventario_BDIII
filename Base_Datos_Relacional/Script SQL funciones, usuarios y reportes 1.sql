#Creartabla
CREATE DATABASE InventarioDB;
USE InventarioDB;

CREATE TABLE Productos (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(50) UNIQUE NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL,
    ubicacion VARCHAR(100) NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    rol ENUM('Administrador', 'Operador') NOT NULL,
    clave_hash VARCHAR(255) NOT NULL
);

#Registro producto

DELIMITER //
CREATE PROCEDURE RegistrarProducto (
    IN p_codigo VARCHAR(50),
    IN p_nombre VARCHAR(100),
    IN p_descripcion TEXT,
    IN p_precio DECIMAL(10,2),
    IN p_stock INT,
    IN p_ubicacion VARCHAR(100)
)
BEGIN
    INSERT INTO Productos (codigo, nombre, descripcion, precio, stock, ubicacion)
    VALUES (p_codigo, p_nombre, p_descripcion, p_precio, p_stock, p_ubicacion);
END //
DELIMITER ;

#Actualizo producto

DELIMITER //
CREATE PROCEDURE ActualizarProducto (
    IN p_id INT,
    IN p_nombre VARCHAR(100),
    IN p_descripcion TEXT,
    IN p_precio DECIMAL(10,2),
    IN p_stock INT,
    IN p_ubicacion VARCHAR(100)
)
BEGIN
    UPDATE Productos 
    SET nombre = p_nombre, descripcion = p_descripcion, precio = p_precio, stock = p_stock, ubicacion = p_ubicacion
    WHERE id_producto = p_id;
END //
DELIMITER ;

#Elimino producto

DELIMITER //
CREATE PROCEDURE EliminarProducto (
    IN p_id INT
)
BEGIN
    DELETE FROM Productos WHERE id_producto = p_id;
END //
DELIMITER ;

#Gestion usuarios y roles


# tablas usuarios y roles
CREATE TABLE Roles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre ENUM('Administrador', 'Operador') UNIQUE NOT NULL
);

CREATE TABLE Usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    clave_hash VARCHAR(255) NOT NULL,
    rol_id INT NOT NULL,
    FOREIGN KEY (rol_id) REFERENCES Roles(id) ON DELETE CASCADE
);

# registro de usuarios
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

# modificar usuario
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

#eliminar usuario
DELIMITER //
CREATE PROCEDURE EliminarUsuario (IN p_id INT)
BEGIN
    DELETE FROM Usuarios WHERE id = p_id;
END //
DELIMITER ;

#definir permisos por rol
CREATE TABLE Permisos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE RolPermisos (
    rol_id INT,
    permiso_id INT,
    PRIMARY KEY (rol_id, permiso_id),
    FOREIGN KEY (rol_id) REFERENCES Roles(id) ON DELETE CASCADE,
    FOREIGN KEY (permiso_id) REFERENCES Permisos(id) ON DELETE CASCADE
);

/*
Ejemplo de asignación de permisos:
INSERT INTO Permisos (nombre) VALUES ('Gestionar Usuarios'), ('Ver Reportes');
INSERT INTO RolPermisos (rol_id, permiso_id) VALUES (1, 1), (1, 2), (2, 2); -- Admin tiene todos, Operador solo reportes
*/

#Reportes basicos

# Inventario general
SELECT codigo, nombre, stock, precio, (stock * precio) AS valor_total FROM Productos;

# Reporte de producto por ubicacion
SELECT ubicacion, GROUP_CONCAT(nombre SEPARATOR ', ') AS productos FROM Productos GROUP BY ubicacion;

# Producto con bajo stock
SELECT * FROM Productos WHERE stock < 10;

