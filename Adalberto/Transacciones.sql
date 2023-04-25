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
	insert into empleado (nombre, apellido)	values (@nombre, @apellido);
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

create procedure usp_edit_empleado
@id int,
@nombre varchar(20),
@apellido varchar(20)
as
begin
	begin try
		begin transaction tEdit;
		if exists(select * from empleado where id=@id)
			begin
				update empleado set nombre=@nombre,apellido=@apellido where id=@id;
				commit transaction tEdit;
				select 'Transacción ejecutada correctamente';
			end
		else
			begin
				rollback transaction tEdit;
				select 'Transacción fallida';
			end
	end try
	begin catch
	if (@@ERROR>0)
		begin
			rollback transaction tEdit;
			select 'Error de transaction';
		end
	end catch
end

create procedure usp_delete_empleado
@id int
as
begin
	begin try
		begin transaction tDelete;
		if exists(select * from empleado where id=@id)
			begin
				delete from empleado where id=@id;
				commit transaction tDelete;
				select 'Transacción ejecutada correctamente';
			end
		else
			begin
				rollback transaction tDelete;
				select 'Transacción fallida';
			end
	end try
	begin catch
	if (@@ERROR>0)
		begin
			rollback transaction tDelete;
			select 'Error de transaction';
		end
	end catch
end

select * from empleado;

execute usp_save_empleado 'Andres Felipe','Delgado';
execute usp_edit_empleado 2,'Pipe','Delgado';
execute usp_delete_empleado 1;