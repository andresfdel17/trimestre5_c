create database if not exists bd_ventas;
use bd_ventas;
CREATE TABLE perfiles(
	id_perfil smallint auto_increment,
	perfil varchar(20) not null,
	CONSTRAINT pk_perfiles PRIMARY KEY (id_perfil),
	CONSTRAINT uk_perfiles UNIQUE (perfil)
);

-- CREACIÓN DE LA TABLA DE USUARIOS
CREATE TABLE usuarios (
	id_usuario smallint auto_increment,
	usuario varchar(20) NOT NULL,
	nombre varchar(100) NOT NULL,
	clave varchar(32) NOT NULL,
	id_perfil smallint,
	CONSTRAINT pk_usuarios PRIMARY KEY (id_usuario),
	CONSTRAINT uk_usuarios UNIQUE (usuario),
	CONSTRAINT fk_usuarios_perfiles FOREIGN KEY (id_perfil)
	REFERENCES perfiles (id_perfil) ON UPDATE RESTRICT ON DELETE RESTRICT
);

-- CREACIÓN DE LA TABLA DE CLIENTES
CREATE TABLE terceros(
	id_tercero smallint auto_increment,
	identificacion varchar(20) NOT NULL,
	nombre varchar(100) NOT NULL,
	direccion varchar(100) NOT NULL,
	telefono varchar(20) NOT NULL,
	CONSTRAINT pk_terceros PRIMARY KEY (id_tercero),
	CONSTRAINT uk_terceros UNIQUE (identificacion)
);

CREATE TABLE productos (
	id_producto smallint auto_increment,
	nombre varchar(20) NOT NULL,
	cantidad smallint,
	precio smallint,
	id_usuario smallint,
	CONSTRAINT pk_productos PRIMARY KEY (id_producto),
	CONSTRAINT uk_productos UNIQUE (nombre),
	CONSTRAINT fk_productos_usuarios FOREIGN KEY (id_usuario)
	REFERENCES usuarios (id_usuario) ON UPDATE RESTRICT ON DELETE RESTRICT,
	CONSTRAINT ck_cantidad CHECK(cantidad > 0),
	CONSTRAINT ck_precio CHECK(precio > 0)
);

-- CREACIÓN DE LA TABLA DE COMPRAS
CREATE TABLE compras(
	id_compra smallint AUTO_INCREMENT,
	fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
	id_tercero smallint NOT NULL,
	id_producto smallint NOT NULL,
	cantidad smallint NOT NULL,
	valor smallint NOT NULL,
	id_usuario smallint NOT NULL,
	CONSTRAINT pk_compras PRIMARY KEY (id_compra),
	CONSTRAINT fk_compras_terceros FOREIGN KEY (id_tercero)
	REFERENCES terceros (id_tercero) ON UPDATE RESTRICT ON DELETE RESTRICT,
	CONSTRAINT fk_compras_productos FOREIGN KEY (id_producto)
	REFERENCES productos (id_producto) ON UPDATE RESTRICT ON DELETE RESTRICT,
	CONSTRAINT ck_compras_cantidad CHECK (cantidad > 0),
	CONSTRAINT ck_compras_valor CHECK (valor > 0),
	CONSTRAINT fk_compras_usuarios FOREIGN KEY (id_usuario)
	REFERENCES usuarios (id_usuario) ON UPDATE RESTRICT ON DELETE RESTRICT
);

CREATE TABLE ventas (
	id_venta smallint auto_increment,
	fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
	id_tercero smallint NOT NULL,
	id_producto smallint NOT NULL,
	cantidad smallint NOT NULL,
	valor smallint NOT NULL,
	id_usuario smallint NOT NULL,
	CONSTRAINT pk_ventas PRIMARY KEY (id_venta),
	CONSTRAINT fk_ventas_terceros FOREIGN KEY (id_tercero)
	REFERENCES terceros (id_tercero) ON UPDATE RESTRICT ON DELETE RESTRICT,
	CONSTRAINT fk_ventas_productos FOREIGN KEY (id_producto)
	REFERENCES productos (id_producto) ON UPDATE RESTRICT ON DELETE RESTRICT,
	CONSTRAINT ck_ventas_cantidad CHECK (cantidad > 0),
	CONSTRAINT ck_ventas_valor CHECK (valor > 0),
	CONSTRAINT fk_ventas_usuario FOREIGN KEY (id_usuario)
	REFERENCES usuarios (id_usuario) ON UPDATE RESTRICT ON DELETE RESTRICT
);

-- CREACIÓN DE LA TABLA DE AUDITORIA
CREATE TABLE auditoria(
	id_auditoria smallint auto_increment,
	fecha timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	id_usuario smallint NOT NULL,
	accion varchar(20) NOT NULL,
	tabla varchar(20) NOT NULL,
	anterior json NOT NULL,
	nuevo json,
	CONSTRAINT pk_auditoria PRIMARY KEY (id_auditoria),
	CONSTRAINT fk_auditoria_usuarios FOREIGN KEY (id_usuario)
	REFERENCES usuarios (id_usuario) ON DELETE RESTRICT ON UPDATE RESTRICT
);

-- INSERCIÓN DE DATOS BÁSICOS

-- PERFILES
INSERT INTO perfiles (perfil) VALUES ('ADMINISTRADOR'), ('CAJERO');

-- USUARIOS
INSERT INTO usuarios (usuario, nombre, clave, id_perfil)
VALUES ('arodriguez', 'Avaro Rodriguez', md5('Clave123+'), 1),
       ('vendedor', 'PEDRO PEREZ', md5('Clave123+'), 2);
INSERT INTO usuarios (usuario, nombre, clave, id_perfil) VALUES ('alvaro.rodriguez','alvaro rodriguez', 'Eam1234', 1);
select * from usuarios;

-- TERCEROS
INSERT INTO terceros (identificacion, nombre, direccion, telefono)
VALUES ('123456789', 'PROVETODO LTDA', 'CRA 1 # 2 - 3', '2114477 EXT 123'),
	('987654321', 'COMPRATODO S.A.S.', 'AV BUSQUELA CRA ENCUENTRELA', '4857965'),
	('741852963', 'CLIENTE FRECUENTE', 'EL VECINO', '5478414');

-- PRODUCTOS
INSERT INTO productos (nombre, cantidad, precio, id_usuario)
VALUES ('NEVERA', 5, 12000, 1),
	('LAVADORA', 1, 8900, 2),
	('SECADORA', 3, 7400, 1),
	('CALENTADOR', 1, 3200, 2);

alter table usuarios modify column clave text;

select * from bd_ventas.usuarios;
delimiter $$
drop trigger if exists bd_ventas.cryptPass$$
create trigger bd_ventas.cryptPass
before insert on bd_ventas.usuarios for each row begin
	set NEW.clave = sha2(new.clave, 256);
END$$

INSERT INTO bd_ventas.usuarios (usuario, nombre, clave, id_perfil)
VALUES ('afdelgado', 'Andres Rodriguez', 'Clave123+', 1);

delimiter $$
drop trigger if exists bd_ventas.cryptPassUpdate$$
create trigger bd_ventas.cryptPassUpdate
before update on bd_ventas.usuarios for each row begin
	set NEW.clave = sha2(new.clave, 256);
END$$

DELIMITER $$
DROP TRIGGER IF EXISTS bd_ventas.auditoria_producto$$
CREATE TRIGGER bd_ventas.auditoria_producto AFTER UPDATE ON bd_ventas.productos FOR EACH ROW BEGIN
    INSERT INTO bd_ventas.auditoria (id_usuario, accion, tabla, nuevo, anterior)
    VALUES (NEW.id_usuario, 'ACTUALIZAR', 'PRODUCTO', (json_object(new.id_producto, new.nombre, new.cantidad, new.precio)), 
    (json_object(old.id_producto, old.nombre, old.cantidad, old.precio)));
END$$

DELIMITER $$
DROP TRIGGER IF EXISTS bd_ventas.auditoria_producto$$
CREATE TRIGGER bd_ventas.auditoria_producto AFTER DELETE ON bd_ventas.productos FOR EACH ROW BEGIN
    INSERT INTO bd_ventas.auditoria (id_usuario, accion, tabla, anterior)
    VALUES (old.id_usuario, 'ELIMINAR', 'PRODUCTO', (json_object(old.id_producto, old.nombre, old.cantidad, old.precio)));
END$$
