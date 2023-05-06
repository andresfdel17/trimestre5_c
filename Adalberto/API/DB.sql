create database DB_API;

use DB_API;

create table USUARIO(
IdU varchar(15) primary key,
Nombres varchar(80),
Telefono varchar(60),
Correo varchar(40),
Ciudad varchar(60),
FechaIngreso datetime default getdate()
);

INSERT USUARIO (IdU, Nombres, Telefono, Correo, Ciudad)
VALUES ( '545454', 'Sara', '3445654321', 'saracar@gmail.com','Cartagena');


create procedure usp_registrar(
@idu varchar(15),
@nombres varchar(80),
@telefono varchar(60),
@correo varchar(40),
@ciudad varchar(60)
)
as
begin
insert into USUARIO(IdU,Nombres,Telefono,Correo,Ciudad)
values
(
@idu,
@nombres,
@telefono,
@correo,
@ciudad
)
end

create procedure usp_actualizar (
@idu varchar(15),
@nombres varchar(80),
@telefono varchar(60),
@correo varchar(40),
@ciudad varchar(60)
)
as
begin
update USUARIO set
Nombres = @nombres,
Telefono = @telefono,
Correo = @correo,
Ciudad = @ciudad
where IdU = @idu
end


create procedure usp_eliminar(
@idu varchar(15)
)
as
begin
delete from usuario where IdU = @idu
end

create procedure usp_obtener
@idu varchar(15)
as
begin
select * from usuario where IdU = @idu
end

create procedure usp_listar
as
begin
select * from usuario
end