/*1. Devuelve un listado con todos los pedidos que ha realizado Adela Salas 
Díaz. (Sin utilizar INNER JOIN).*/

select * from ventas.pedido p 
where p.id_cliente 
in (select id from ventas.cliente c where c.nombre like "Adela" and c.apellido1 like "Salas" and c.apellido2 like "Diaz");

/*2. Devuelve el número de pedidos en los que ha participado el comercial 
Daniel Sáez Vega. (Sin utilizar INNER JOIN)*/

select * from ventas.pedido p 
where p.id_comercial 
in (select id from ventas.comercial co where co.nombre like "Daniel" and co.apellido1 like "Saez" and co.apellido2 like "Vega");

/*3. Devuelve los datos del cliente que realizó el pedido más caro en el año 
2019. (Sin utilizar INNER JOIN)*/

select c.* from ventas.cliente c
where c.id
in (select p.id_cliente from ventas.pedido p where YEAR(p.fecha)="2019" order by total desc);

/*4. Devuelve la fecha y la cantidad del pedido de menor valor realizado por el 
cliente Pepe Ruiz Santana.*/

select p.fecha, min(p.total) from ventas.pedido p
where p.id_cliente
in (select c.id from ventas.cliente c where c.nombre like "Pepe" and c.apellido1 like "Ruiz" and c.apellido2 like "Santana" );

/*5. Devuelve un listado con los datos de los clientes y los pedidos, de todos los 
clientes que han realizado un pedido durante el año 2017 con un valor 
mayor o igual al valor medio de los pedidos realizados durante ese mismo 
año.*/

/*Subconsultas con ALL y ANY
1. Devuelve el pedido más caro que existe en la tabla pedido si hacer uso de 
MAX, ORDER BY ni LIMIT.*/
/*2. Devuelve un listado de los clientes que no han realizado ningún pedido. 
(Utilizando ANY o ALL).*/
/*3. Devuelve un listado de los comerciales que no han realizado ningún pedido. 
(Utilizando ANY o ALL).*/
/*Subconsultas con IN y NOT IN
1. Devuelve un listado de los clientes que no han realizado ningún pedido. 
(Utilizando IN o NOT IN).*/
/*2. Devuelve un listado de los comerciales que no han realizado ningún pedido. 
(Utilizando IN o NOT IN).*/
/*Subconsultas con EXISTS y NOT EXISTS
1. Devuelve un listado de los clientes que no han realizado ningún pedido. 
(Utilizando EXISTS o NOT EXISTS).*/
/*2. Devuelve un listado de los comerciales que no han realizado ningún pedido. 
(Utilizando EXISTS o NOT EXISTS)*/