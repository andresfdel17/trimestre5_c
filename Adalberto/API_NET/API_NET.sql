create database API_NET;
use API_NET;

create table producto(
	Id_producto int primary key identity,
	Codigo_barra varchar(50) unique,
	Nombre varchar(50),
	Marca varchar(50),
	Categoria varchar(50),
	Precio decimal(10,2)
);

INSERT INTO PRODUCTO(Codigo_barra,Nombre,Marca,Categoria,Precio) values
('50910010','Monitor Aoc - Curvo Gaming ','AOC','Tecnologia','1200'),
('50910011','IdeaPad 3i','LENOVO','Tecnologia','1700'),
('50910012','SoyMomo Tablet Lite','SOYMOMO','Tecnologia','300'),
('50910013','Lavadora 21 KG WLA-21','WINIA','ElectroHogar','1749'),
('50910014','Congelador 145 Lt Blanco','ELECTROLUX','ElectroHogar','779'),
('50910015','Cafetera TH-130','THOMAS','ElectroHogar','119'),
('50910016','Reloj análogo Hombre 058','GUESS','Accesorios','699'),
('50910017','Billetera de Cuero Mujer Sophie','REYES','Accesorios','270'),
('50910018','Bufanda Rec Mango Mujer','MANGO','Accesorios','169.90'),
('50910019','Sofá Continental 3 Cuerpos','MICA','Muebles','1299'),
('50910020','Futón New Elina 3 Cuerpos','MICA','Muebles','1349'),
('50910021','Mesa Comedor Volterra 6 Sillas','TUHOME','Muebles','624.12');
select * from PRODUCTO


create proc sp_lista_productos
as
begin
	select 
		Id_producto,
		Codigo_barra,
		Nombre,
		Marca,
		Categoria,
		Precio
	from producto;
end

create proc sp_guardar_producto
@codigo_barra varchar(50),
@nombre varchar(50),
@marca varchar(50),
@categoria varchar(100),
@precio decimal(10,2)
as
begin
	insert into
		producto (Codigo_barra, Nombre, Marca, Categoria, Precio)
	values (@codigo_barra, @nombre, @marca, @categoria, @precio);
end


create proc sp_editar_producto
@id_producto int,
@codigo_barra varchar(50),
@nombre varchar(50),
@marca varchar(50),
@categoria varchar(100),
@precio decimal(10,2)
as
begin
	update producto set
		Codigo_barra= ISNULL(@codigo_barra, Codigo_barra),
		Nombre= ISNULL(@nombre, Nombre),
		Marca= ISNULL(@marca, Marca),
		Categoria= ISNULL(@categoria, Categoria),
		Precio= ISNULL(@precio, Precio)
	where Id_producto=@id_producto;
end

create proc sp_eliminar_producto
@id_producto int
as
begin
	delete from producto where Id_producto=@id_producto;
end