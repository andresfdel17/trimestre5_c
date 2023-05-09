/* Triggers y procedimientos*/

/*
-- Escriba un procedimiento llamado listar_productos que reciba como entrada el nombre de la categoria y 
muestre un listado de todos los productos que existen dentro de esa categoria. 
Este procedimiento no devuelve ningún parámetro de salida, lo que hace es mostrar el listado de los productos.
*/
select * from jardineria.producto;
delimiter $$
drop procedure if exists jardineria.listar_producto$$
create procedure jardineria.listar_productos(IN categoria varchar(50))
begin
	select 
		*
    from jardineria.producto p
    where p.gama = categoria;
end
$$

delimiter ;
call jardineria.listar_productos("Aromáticas");

/*
-- Escriba un procedimiento llamado contar_productos que reciba como entrada el nombre de la gama 
y devuelva el número de productos que existen dentro de esa gama. 
Resuelva el ejercicio de dos formas distintas, utilizando SET y SELECT ... INTO.
*/
delimiter $$
drop procedure if exists jardineria.contar_productos$$
create procedure jardineria.contar_productos(IN categoria varchar(50), OUT total double unsigned)
begin
	SET total = (
    select 
		count(*)
    from jardineria.producto p
    where p.gama = categoria
    );
end
$$


delimiter ;
call jardineria.contar_productos("Aromáticas", @total);
select @total as total;

/*
-- Escribe un procedimiento que se llame calcular_max_min_media, 
que reciba como parámetro de entrada el nombre de la gama de un producto y devuelva como salida tres parámetros. 
El precio máximo, el precio mínimo y la media de los productos que existen en esa gama. Resuelva el ejercicio de dos formas distintas, utilizando SET y SELECT ... INTO
*/

delimiter $$
drop procedure if exists jardineria.calcular_max_min_media$$
create procedure jardineria.calcular_max_min_media(IN categoria varchar(50), OUT maximo double, OUT minimo double, OUT media double)
begin
	select 
		max(p.precio_venta) as maximo,
        min(p.precio_venta) as minimo,
        avg(p.precio_venta) as media
		into maximo, minimo, media
	from jardineria.producto p
    where p.gama = categoria;
end
$$

delimiter ;
call jardineria.calcular_max_min_media("Ornamentales", @max, @min, @avg);
select @max, @min, @avg;