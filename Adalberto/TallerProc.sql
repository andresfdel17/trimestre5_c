CREATE DATABASE DB_ventas
	use DB_ventas;

CREATE TABLE cliente
(
	id_cliente varchar(15)primary key NOT NULL,
	nombre_cliente varchar(40) NULL,
	apellido_cliente varchar(40) NULL,
	direccion_cliente varchar(70) NULL,
	telefono_cliente varchar(20) NULL,
	correo_cliente varchar(70) NULL,
);
	
CREATE TABLE producto
(
	id_producto varchar(15)primary key NOT NULL,
	nombre_producto varchar(20) NULL,
	valor decimal(10, 2) NULL,
	existencia_producto int NULL,
	);

CREATE TABLE vendedor
(
	id_vendedor varchar(15)primary key NOT NULL,
	nombre_vendedor varchar(40) NULL,
	apellido_vendedor varchar(40) NULL,
	telefono_vendedor varchar(20) NULL,
	correo_vendedor varchar(70) NULL,
	salario decimal(10, 2) NULL,
	);

CREATE TABLE venta
(
	id_venta varchar(15)primary key NOT NULL,
	fecha_venta date NULL,
	subtotal_venta float NULL,
	iva_venta float NULL,
	total_venta float NULL,
	id_cliente varchar(15) NULL,
	id_vendedor varchar(15) NULL,
	foreign key (id_cliente)references cliente(id_cliente),
	foreign key (id_vendedor)references vendedor(id_vendedor)
);

CREATE TABLE venta_producto
(
PRIMARY KEY (id_producto, id_venta),
cantidad int,
valor_total float,
id_producto varchar(15),
id_venta varchar(15),
foreign key (id_producto)references producto(id_producto),
foreign key (id_venta)references venta(id_venta)
);

select * from venta_producto

insert into cliente(id_cliente,nombre_cliente,apellido_cliente,direccion_cliente,telefono_cliente,correo_cliente)
values('66978041','Juliana','Montero','25 mayo mz D casa 2','3136578901','Bernan@gmail.com')

insert into cliente(id_cliente,nombre_cliente,apellido_cliente,direccion_cliente,telefono_cliente,correo_cliente)
values('1093657890','Roberto','Quintero','Granada mz E casa 10','3113393486','Rbeto27@gmail.com')

insert into cliente(id_cliente,nombre_cliente,apellido_cliente,direccion_cliente,telefono_cliente,correo_cliente)
values('7508964','Catalina','Suares','pavona mz k casa 35','3002066457','cata5475@gmail.com')

insert into cliente(id_cliente,nombre_cliente,apellido_cliente,direccion_cliente,telefono_cliente,correo_cliente)
values('1005387692','David','Gonzalez','modelo mz j casa 20','3016503654','Dav0031@gmail.com')

insert into producto(id_producto,nombre_producto,valor,existencia_producto)
values('1276','atun',8000,'23')

insert into producto(id_producto,nombre_producto,valor,existencia_producto)
values('4523','salsa',2500,'15')

insert into producto(id_producto,nombre_producto,valor,existencia_producto)
values('6543','galletas',8000,'70')

insert into producto(id_producto,nombre_producto,valor,existencia_producto)
values('7650','aceite',30000,'36')

insert into vendedor(id_vendedor,nombre_vendedor,apellido_vendedor,telefono_vendedor,correo_vendedor,salario)
values('1007654321','Juan','Perez','7457632','juanito2453@hotmail.com',1200000)

insert into vendedor(id_vendedor,nombre_vendedor,apellido_vendedor,telefono_vendedor,correo_vendedor,salario)
values('1038724227','Jhonatan','Gomez','7368861','jhoan0076@hotmail.com',1000000)

insert into vendedor(id_vendedor,nombre_vendedor,apellido_vendedor,telefono_vendedor,correo_vendedor,salario)
values('947204','Miguel','Andrade','3002038896','migue3304@gmail.com',1500000)

insert into vendedor(id_vendedor,nombre_vendedor,apellido_vendedor,telefono_vendedor,correo_vendedor,salario)
values('1008373945','Anderson','Henao','3236549809','aneshe@hotmail.com',2600000)

CREATE PROCEDURE usp_guardar_cliente
	@id_cliente VARCHAR(15),
	@nombre_cliente VARCHAR(40),
	@apellido_cliente VARCHAR(40),
	@direccion_cliente VARCHAR(70),
	@telefono_cliente VARCHAR(20),
	@correo_cliente VARCHAR(70)
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION ;
		
		IF NOT EXISTS (SELECT 1 FROM cliente WHERE id_cliente = @id_cliente)
		BEGIN
			INSERT INTO cliente (id_cliente, nombre_cliente, apellido_cliente, direccion_cliente, telefono_cliente, correo_cliente)
			VALUES (@id_cliente, @nombre_cliente, @apellido_cliente, @direccion_cliente, @telefono_cliente, @correo_cliente);
			
			COMMIT TRANSACTION;
			
			SELECT 'SE GUARDÓ EXITOSAMENTE' AS [Mensaje];
		END
		ELSE
		BEGIN
			SELECT 'YA EXISTE EL REGISTRO' AS [Mensaje];
		END
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;

		SELECT 'ERROR EN LA TRANSACCIÓN' AS [Mensaje];
	END CATCH;
END

CREATE PROCEDURE usp_actualizar_cliente
	@id_cliente VARCHAR(15),
	@nombre_cliente VARCHAR(40),
	@apellido_cliente VARCHAR(40),
	@direccion_cliente VARCHAR(70),
	@telefono_cliente VARCHAR(20),
	@correo_cliente VARCHAR(70)
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION;

		IF EXISTS (SELECT 1 FROM cliente WHERE id_cliente = @id_cliente)
		BEGIN
			UPDATE cliente
			SET nombre_cliente = @nombre_cliente,
				apellido_cliente = @apellido_cliente,
				direccion_cliente = @direccion_cliente,
				telefono_cliente = @telefono_cliente,
				correo_cliente = @correo_cliente
			WHERE id_cliente = @id_cliente;

			COMMIT TRANSACTION;

			SELECT 'SE ACTUALIZÓ EXITOSAMENTE' AS [Mensaje];
		END
		ELSE
		BEGIN
			SELECT 'NO SE ENCONTRÓ EL REGISTRO' AS [Mensaje];
		END
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;

		SELECT 'ERROR EN LA TRANSACCIÓN' AS [Mensaje];
	END CATCH;
END

execute USP_actualizar_cliente '1005387692','Daniel','Guerrero','modelo mz j casa 20','3016503654','dani554@gmail.com'

CREATE PROCEDURE usp_delete_cliente
@id_cliente VARCHAR(15)
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION;

		IF EXISTS (SELECT 1 FROM cliente WHERE id_cliente = @id_cliente)
		BEGIN
			DELETE FROM cliente WHERE id_cliente = @id_cliente;

			COMMIT TRANSACTION;

			SELECT 'SE ELIMINÓ CORRECTAMENTE' AS [Mensaje];
		END
		ELSE
		BEGIN
			SELECT 'EL REGISTRO NO EXISTE' AS [Mensaje];
		END
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;

		SELECT 'ERROR EN LA TRANSACCIÓN' AS [Mensaje];
	END CATCH;
END

CREATE PROCEDURE usp_guardar_producto
	@id_producto VARCHAR(15),
	@nombre_producto VARCHAR(20),
	@valor DECIMAL(10, 2),
	@existencia_producto INT
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION;

		IF NOT EXISTS (SELECT 1 FROM producto WHERE id_producto = @id_producto)
		BEGIN
			INSERT INTO producto (id_producto, nombre_producto, valor, existencia_producto)
			VALUES (@id_producto, @nombre_producto, @valor, @existencia_producto);

			COMMIT TRANSACTION;

			SELECT 'LA TRANSACCIÓN SE REALIZÓ CORRECTAMENTE' AS [Mensaje];
		END
		ELSE
		BEGIN
			SELECT 'NO SE ENCONTRÓ LA TRANSACCIÓN' AS [Mensaje];
		END
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;

		SELECT 'ERROR EN LA TRANSACCIÓN' AS [Mensaje];
	END CATCH;
END
	
	CREATE PROCEDURE usp_actualizar_producto
	@id_producto VARCHAR(15),
	@nombre_producto VARCHAR(20),
	@valor DECIMAL(10, 2),
	@existencia_producto INT
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION;

		IF EXISTS (SELECT 1 FROM producto WHERE id_producto = @id_producto)
		BEGIN
			UPDATE producto
			SET nombre_producto = @nombre_producto,
				valor = @valor,
				existencia_producto = @existencia_producto
			WHERE id_producto = @id_producto;

			COMMIT TRANSACTION;

			SELECT 'SE ACTUALIZÓ CORRECTAMENTE' AS [Mensaje];
		END
		ELSE
		BEGIN
			SELECT 'NO SE ENCONTRÓ EL REGISTRO' AS [Mensaje];
		END
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;

		SELECT 'ERROR EN LA TRANSACCIÓN' AS [Mensaje];
	END CATCH;
END


	CREATE PROCEDURE usp_delete_producto
	@id_producto VARCHAR(15)
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION;

		IF EXISTS (SELECT 1 FROM producto WHERE id_producto = @id_producto)
		BEGIN
			DELETE FROM producto WHERE id_producto = @id_producto;

			COMMIT TRANSACTION;

			SELECT 'SE ELIMINÓ CORRECTAMENTE' AS [Mensaje];
		END
		ELSE
		BEGIN
			SELECT 'EL REGISTRO NO EXISTE' AS [Mensaje];
		END
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;

		SELECT 'ERROR EN LA TRANSACCIÓN' AS [Mensaje];
	END CATCH;
END

CREATE PROCEDURE usp_guardar_vendedor
	@id_vendedor VARCHAR(15),
	@nombre_vendedor VARCHAR(40),
	@apellido_vendedor VARCHAR(40),
	@telefono_vendedor VARCHAR(20),
	@correo_vendedor VARCHAR(70),
	@salario DECIMAL(10, 2)
AS
BEGIN

	BEGIN TRY
		BEGIN TRANSACTION;

		IF NOT EXISTS (SELECT 1 FROM vendedor WHERE id_vendedor = @id_vendedor)
		BEGIN
			INSERT INTO vendedor (id_vendedor, nombre_vendedor, apellido_vendedor, telefono_vendedor, correo_vendedor, salario)
			VALUES (@id_vendedor, @nombre_vendedor, @apellido_vendedor, @telefono_vendedor, @correo_vendedor, @salario);

			COMMIT TRANSACTION;

			SELECT 'SE GUARDÓ EXITOSAMENTE' AS [Mensaje];
		END
		ELSE
		BEGIN
			SELECT 'YA EXISTE EL REGISTRO' AS [Mensaje];
		END
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;

		SELECT 'ERROR EN LA TRANSACCIÓN' AS [Mensaje];
	END CATCH;
END


	
CREATE PROCEDURE usp_actualizar_vendedor
	@id_vendedor VARCHAR(15),
	@nombre_vendedor VARCHAR(40),
	@apellido_vendedor VARCHAR(40),
	@telefono_vendedor VARCHAR(20),
	@correo_vendedor VARCHAR(70),
	@salario DECIMAL(10, 2)
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION;

		IF EXISTS (SELECT 1 FROM vendedor WHERE id_vendedor = @id_vendedor)
		BEGIN
			UPDATE vendedor
			SET nombre_vendedor = @nombre_vendedor,
				apellido_vendedor = @apellido_vendedor,
				telefono_vendedor = @telefono_vendedor,
				correo_vendedor = @correo_vendedor,
				salario = @salario
			WHERE id_vendedor = @id_vendedor;

			COMMIT TRANSACTION;

			SELECT 'SE ACTUALIZÓ EXITOSAMENTE' AS [Mensaje];
		END
		ELSE
		BEGIN
			SELECT 'NO SE ENCONTRÓ EL REGISTRO' AS [Mensaje];
		END
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;

		SELECT 'ERROR EN LA TRANSACCIÓN' AS [Mensaje];
	END CATCH;
END


CREATE PROCEDURE usp_delete_vendedor
	@id_vendedor VARCHAR(15)
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION;

		IF EXISTS (SELECT 1 FROM vendedor WHERE id_vendedor = @id_vendedor)
		BEGIN
			DELETE FROM vendedor WHERE id_vendedor = @id_vendedor;

			COMMIT TRANSACTION;

			SELECT 'SE ELIMINÓ CORRECTAMENTE' AS [Mensaje];
		END
		ELSE
		BEGIN
			SELECT 'EL REGISTRO NO EXISTE' AS [Mensaje];
		END
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;

		SELECT 'ERROR EN LA TRANSACCIÓN' AS [Mensaje];
	END CATCH;
END

CREATE PROCEDURE usp_guardar_venta
	@id_venta INT OUTPUT,
	@id_cliente VARCHAR(15),
	@id_vendedor VARCHAR(15),
	@fecha_venta DATE,
	@total_venta DECIMAL(10, 2)
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION;

		-- Validar si el cliente existe
		IF NOT EXISTS (SELECT 1 FROM cliente WHERE id_cliente = @id_cliente)
		BEGIN
			Select 'El cliente especificado no existe.';
			ROLLBACK TRANSACTION;
			RETURN;
		END;

		-- Validar si el vendedor existe
		IF NOT EXISTS (SELECT 1 FROM vendedor WHERE id_vendedor = @id_vendedor)
		BEGIN
			SELECT  'El vendedor especificado no existe.';
			ROLLBACK TRANSACTION;
			RETURN;
		END;

		-- Insertar la venta
		INSERT INTO venta (id_cliente, id_vendedor, fecha_venta, total_venta)
		VALUES (@id_cliente, @id_vendedor, @fecha_venta, @total_venta);

		COMMIT TRANSACTION;

		SELECT 'La venta se guardó exitosamente.' AS [Mensaje];
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;

		THROW;
	END CATCH;
END


CREATE PROCEDURE usp_guardar_linea_producto
	@id_venta INT,
	@id_producto VARCHAR(15),
	@cantidad INT,
	@precio_unitario DECIMAL(10, 2)
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION;

		-- Validar si la venta existe
		IF NOT EXISTS (SELECT 1 FROM venta WHERE id_venta = @id_venta)
		BEGIN
			SELECT 'La venta especificada no existe.';
			ROLLBACK TRANSACTION;
			RETURN;
		END;

		-- Validar si el producto existe
		IF NOT EXISTS (SELECT 1 FROM producto WHERE id_producto = @id_producto)
		BEGIN
			SELECT 'El producto especificado no existe.';
			ROLLBACK TRANSACTION;
			RETURN;
		END;

		-- Insertar la línea de producto
		INSERT INTO venta_producto (id_venta, id_producto, cantidad, valor_total)
		VALUES (@id_venta, @id_producto, @cantidad, @precio_unitario);

		COMMIT TRANSACTION;

		SELECT 'La línea de producto se guardó exitosamente.' AS [Mensaje];
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;

		THROW;
	END CATCH;
END
