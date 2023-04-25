 use DB_TRANSACTIONS;


 create function f_promedio
 (@valor1 decimal(4,2),
  @valor2 decimal(4,2)
 )
 returns decimal (6,2)
 as
 begin 
   declare @resultado decimal(6,2)
   set @resultado=(@valor1+@valor2)/2
   return @resultado
 end;

select dbo.f_promedio(3.5,5.5) as total;


create function func_prom_notas
(
	@nota1 float, 
	@nota2 float, 
	@nota3 float, 
	@nota4 float,
	@notaMax float
)
returns varchar(50)
as
begin
	declare @prom float = 0;
	declare @text varchar = 'No Aprobado';
	set @prom = (@nota1 + @nota2 + @nota3 + @nota4 / 4);
	if((@prom / @notaMax)>= 0.6)
		set @text = 'Ha aprobado';
	return @text;
end

select dbo.func_prom_notas(3,3,3,3,5) as mensaje;