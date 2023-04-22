create database DB_TRANSACTIONS;

use DB_TRANSACTIONS;


create table empleado (
	id int identity(1,1) primary key,
	nombre varchar(20),
	apellido varchar(20)
);

create procedure usp_save_empleado
@nombre varchar(20),
@apellido varchar(20)
as
begin
	begin transaction tSave
	insert into empleado (nombre, apellido)
	values (@nombre, @apellido);
	if(@@ERROR>0)
		begin
		rollback transaction tSave
		select 'Transaccion fallo'
		end
	else
		begin
		commit transaction tSave
		select 'La transaccion se ejecutó exitosamente'
		end
end

select * from empleado;

execute usp_save_empleado 'Andres Felipe','Delgado'