-- Vistas

/*
Escriba una vista que se llame listado_pagos_clientes que muestre un listado donde aparezcan todos los clientes y los pagos que ha realizado cada uno de ellos.
 La vista deberá tener las siguientes columnas: nombre y apellidos del cliente concatenados, teléfono, ciudad, pais, fecha_pago, total del pago, id de la transacción
*/
create view jardineria.listado_pagos_clientes 
as
select 
	CONCAT(c.nombre_cliente, " ",  c.apellido_contacto) as nombre_completo,
    c.telefono,
    c.ciudad,
    c.pais,
    p.fecha_pago,
    p.total,
    p.id_transaccion
from jardineria.cliente c 
join jardineria.pago p on c.codigo_cliente = p.codigo_cliente;

select * from jardineria.listado_pagos_clientes;
-- drop view if exists jardineria.listado_pagos_clientes;

/*
2. Escriba una vista que se llame listado_pedidos_clientes que muestre un
listado donde aparezcan todos los clientes y los pedidos que ha realizado
cada uno de ellos. La vista deáber tener las siguientes columnas: nombre y
apellidos del cliente concatendados, teléfono, ciudad, pais, código del
pedido, fecha del pedido, fecha esperada, fecha de entrega y la cantidad
total del pedido, que será la suma del producto de todas las cantidades por
el precio de cada unidad, que aparecen en cada línea de pedido.
*/
create view jardineria.listado_pedidos_clientes
as 
select 
	CONCAT(c.nombre_cliente, " ",  c.apellido_contacto) as nombre_completo,
    c.telefono,
    c.ciudad,
    c.pais,
    p.codigo_pedido,
    p.fecha_pedido,
    p.fecha_esperada,
    p.fecha_entrega,
    sum(dp.cantidad * dp.precio_unidad) as total_pedido
from jardineria.cliente c
left join jardineria.pedido p on p.codigo_cliente = c.codigo_cliente
join jardineria.detalle_pedido dp on p.codigo_pedido = dp.codigo_pedido
group by p.codigo_pedido;

select * from jardineria.listado_pedidos_clientes;
/*
3. Utilice las vistas que ha creado en los pasos anteriores para devolver un
listado de los clientes de la ciudad de Madrid que han realizado pagos
*/
select * from jardineria.listado_pagos_clientes lpc where lpc.ciudad = "Madrid";

/*
4. Utilice las vistas que ha creado en los pasos anteriores para devolver un
listado de los clientes que todavía no han recibido su pedido.
*/
select * from jardineria.listado_pedidos_clientes lpc where lpc.codigo_pedido is null;
/*
5. Utilice las vistas que ha creado en los pasos anteriores para calcular el
número de pedidos que se ha realizado cada uno de los clientes.
*/
select
	lpc.nombre_completo,
	count(*) as pedidos
from jardineria.listado_pedidos_clientes lpc
group by lpc.nombre_completo;

/*
6. Utilice las vistas que ha creado en los pasos anteriores para calcular el valor
del pedido máximo y mínimo que ha realizado cada cliente.
*/
select
	lpc.nombre_completo,
	max(lpc.total_pedido) as maximo,
    min(lpc.total_pedido) as minimo
from jardineria.listado_pedidos_clientes lpc
group by lpc.nombre_completo;

/*
7. Modifique el nombre de las vista listado_pagos_clientes y asígnele el
nombre listado_de_pagos. Una vez que haya modificado el nombre de la
vista ejecute una consulta utilizando el nuevo nombre de la vista para
comprobar que sigue funcionando correctamente.
*/
rename table jardineria.listado_pagos_clientes to jardineria.listado_de_pagos;
select * from jardineria.listado_de_pagos;

/*
8. Elimine las vistas que ha creado en los pasos anteriores.
*/
drop view if exists jardineria.listado_de_pagos;
drop view if exists jardineria.listado_pedidos_clientes;