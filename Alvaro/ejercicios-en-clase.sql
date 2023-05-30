create database data_proc;
/*1. Escribe un procedimiento que no tenga ningún parámetro de entrada ni de
salida y que muestre el texto ¡Hola mundo!.*/

delimiter $$
drop procedure if exists data_proc.saludo$$
create procedure data_proc.saludo()
begin
    select "Hola mundo" as saludo;
end$$

call data_proc.saludo;

/*2. Escribe un procedimiento que reciba un número real de entrada y muestre
un mensaje indicando si el número es positivo, negativo o cero.*/

delimiter $$
drop procedure if exists data_proc.typeNumber$$
create procedure data_proc.typeNumber(IN numero float)
begin
	-- if(condicion, verdadero, falso)
	select if (numero > 0, "Mayor a cero", if(numero < 0 , "Menor a cero", "Es cero")) as comparacion;
end$$

call data_proc.typeNumber(0);
/*3. Modifique el procedimiento diseñado en el ejercicio anterior para que tenga
un parámetro de entrada, con el valor un número real, y un parámetro de
salida, con una cadena de caracteres indicando si el número es positivo,
negativo o cero.*/

delimiter $$
drop procedure if exists data_proc.typeNumberOUT$$
create procedure data_proc.typeNumberOUT(IN numero float, OUT salida varchar(30))
begin
	-- if(condicion, verdadero, falso)
	set salida = if (numero > 0, "Mayor a cero", if(numero < 0 , "Menor a cero", "Es cero"));
end$$

call data_proc.typeNumberOUT(0, @salida);
select @salida;

/*4. Escribe un procedimiento que reciba un número real de entrada, que
representa el valor de la nota de un alumno, y muestre un mensaje
indicando qué nota ha obtenido teniendo en cuenta las siguientes
condiciones:
• [0,5) = Insuficiente
• [5,6) = Aprobado
• [6, 7) = Bien
• [7, 9) = Notable
• [9, 10] = Sobresaliente
• En cualquier otro caso la nota no será válida.*/

delimiter $$
drop procedure if exists data_proc.notes$$
create procedure data_proc.notes(IN nota float)
begin
	select coalesce(
		(select if(nota >= 0 and nota < 5, "Insuficiente", NULL)),
        (select if(nota >= 5 and nota < 6, "Aprobado", NULL)),
        (select if(nota >= 6 and nota < 7, "Bien", NULL)),
        (select if(nota >= 7 and nota < 9, "Notable", NULL)),
        (select if(nota >= 9 and nota <= 10, "Sobresaliente", NULL)),
        "Nota no valida"
    ) as descripcion;
end$$

call data_proc.notes(15);

/*5. Modifique el procedimiento diseñado en el ejercicio anterior para que tenga
un parámetro de entrada, con el valor de la nota en formato numérico y un
parámetro de salida, con una cadena de texto indicando la nota
correspondiente.*/

delimiter $$
drop procedure if exists data_proc.notesOUT$$
create procedure data_proc.notesOUT(IN nota float, OUT total varchar(30))
begin
	set total = coalesce(
		(select if(nota >= 0 and nota < 5, "Insuficiente", NULL)),
        (select if(nota >= 5 and nota < 6, "Aprobado", NULL)),
        (select if(nota >= 6 and nota < 7, "Bien", NULL)),
        (select if(nota >= 7 and nota < 9, "Notable", NULL)),
        (select if(nota >= 9 and nota <= 10, "Sobresaliente", NULL)),
        "Nota no valida"
    );
end$$

call data_proc.notesOUT(15, @total);
select @total;

/*6. Resuelva el procedimiento diseñado en el ejercicio anterior haciendo uso de
la estructura de control CASE.*/

delimiter $$
drop procedure if exists data_proc.notesOutCase$$
create procedure data_proc.notesOutCase(IN nota float, OUT total varchar(30))
begin
	set total = 
		case 
			when nota >= 0 and nota < 5 then "Insuficiente"
			when nota >= 5 and nota < 6 then "Aprobado"
			when nota >= 6 and nota < 7 then "Bien"
			when nota >= 7 and nota < 9 then "Notable"
			when nota >= 9 and nota <= 10 then "Sobresaliente"
			else "Nota no válida"
		end;
end$$
call data_proc.notesOutCase(15, @total);
select @total;

/*7. Escribe un procedimiento que reciba como parámetro de entrada un valor
numérico que represente un día de la semana y que devuelva una cadena de
caracteres con el nombre del día de la semana correspondiente. Por
ejemplo, para el valor de entrada 1 debería devolver la cadena lunes.*/

delimiter $$
drop procedure if exists data_proc.dia_semana$$
create procedure data_proc.dia_semana(IN dia_semana int)
begin
    select case dia_semana
        when 1 then 'Lunes'
        when 2 then 'Martes'
        when 3 then 'Miércoles'
        when 4 then 'Jueves'
        when 5 then 'Viernes'
        when 6 then 'Sábado'
        when 7 then 'Domingo'
        else 'Valor no válido'
    end as nombre_dia_semana;
end$$

call data_proc.dia_semana(3);

/*1. Escribe un procedimiento que reciba el nombre de un país como parámetro
de entrada y realice una consulta sobre la tabla cliente para obtener todos
los clientes que existen en la tabla de ese país.*/

delimiter $$
drop procedure if exists jardineria.checkCountry$$
create procedure jardineria.checkCountry(IN pais varchar(30))
begin
	select * from jardineria.cliente c where c.pais = pais;
end$$

call jardineria.checkCountry("Spain");

/*2. Escribe un procedimiento que reciba como parámetro de entrada una forma
de pago, que será una cadena de caracteres (Ejemplo: PayPal, Transferencia,
etc). Y devuelva como salida el pago de máximo valor realizado para esa
forma de pago. Deberá hacer uso de la tabla pago de la base de
datos jardineria.*/

delimiter $$
drop procedure if exists jardineria.checkFormPay$$
create procedure jardineria.checkFormPay(IN tipoPago varchar(30), OUT pago float)
begin
	select max(total) into pago from jardineria.pago p where p.forma_pago = tipoPago;
end$$

call jardineria.checkFormPay("PayPal", @pago);
select @pago;

/*3. Escribe un procedimiento que reciba como parámetro de entrada una forma
de pago, que será una cadena de caracteres (Ejemplo: PayPal, Transferencia,
etc). Y devuelva como salida los siguientes valores teniendo en cuenta la
forma de pago seleccionada como parámetro de entrada:
• el pago de máximo valor,
• el pago de mínimo valor,
• el valor medio de los pagos realizados,
• la suma de todos los pagos,
• el número de pagos realizados para esa forma de pago.
Deberá hacer uso de la tabla pago de la base de datos jardineria.*/
delimiter $$
drop procedure if exists jardineria.checkFormPayMany$$
create procedure jardineria.checkFormPayMany(IN tipoPago varchar(30))
begin
	select max(total), min(total), avg(total), sum(total), count(total)  from jardineria.pago p where p.forma_pago = tipoPago;
end$$

call jardineria.checkFormPayMany("PayPal");

/*4. Crea una base de datos llamada procedimientos que contenga
una tabla llamada cuadrados. La tabla cuadrados debe tener dos columnas de
tipo INT UNSIGNED, una columna llamada número y otra columna
llamada cuadrado.
Una vez creada la base de datos y la tabla deberá crear un
procedimiento llamado calcular_cuadrados con las siguientes características. El
procedimiento recibe un parámetro de entrada llamado tope de tipo INT UNSIGNED y
calculará el valor de los cuadrados de los primeros números naturales hasta el valor
introducido como parámetro. El valor del números y de sus cuadrados deberán ser
almacenados en la tabla cuadrados que hemos creado previamente.
Tenga en cuenta que el procedimiento deberá eliminar el contenido actual de la
tabla antes de insertar los nuevos valores de los cuadrados que va a calcular.
Utilice un bucle WHILE para resolver el procedimiento.*/
create database if not exists procedimientos;
create table if not exists procedimientos.cuadrados(
	numero int unsigned,
    cuadrado int unsigned
);
delimiter $$
drop procedure if exists procedimientos.calcular_cuadrados$$
create procedure procedimientos.calcular_cuadrados(IN tope int unsigned)
begin
	declare inicial int;
    set inicial=1;
    truncate procedimientos.cuadrados;
    while inicial <= tope do
		insert into procedimientos.cuadrados (numero, cuadrado) values (inicial, power(inicial, 2));
        set inicial = inicial + 1;
    end while;
    select * from  procedimientos.cuadrados;
end$$
call procedimientos.calcular_cuadrados(10);
/*5. Utilice un bucle REPEAT para resolver el procedimiento del ejercicio anterior.*/
delimiter $$
drop procedure if exists procedimientos.calcular_cuadradosRPT$$
create procedure procedimientos.calcular_cuadradosRPT(IN tope int unsigned)
begin
	declare inicial int;
    set inicial=1;
    truncate procedimientos.cuadrados;
    repeat 
		insert into procedimientos.cuadrados (numero, cuadrado) values (inicial, power(inicial, 2));
        set inicial = inicial + 1;
	until inicial = tope end repeat;
    select * from  procedimientos.cuadrados;
end$$
call procedimientos.calcular_cuadradosRPT(10);
/*6. Utilice un bucle LOOP para resolver el procedimiento del ejercicio anterior.*/
delimiter $$
drop procedure if exists procedimientos.calcular_cuadradosLOP$$
create procedure procedimientos.calcular_cuadradosLOP(IN tope int unsigned)
begin
	declare inicial int;
    set inicial=1;
    truncate procedimientos.cuadrados;
    proc: loop
		insert into procedimientos.cuadrados (numero, cuadrado) values (inicial, power(inicial, 2));
        set inicial = inicial + 1;
        if inicial = tope then
			leave proc;
        end if;
    end loop;
    select * from  procedimientos.cuadrados;
end$$
call procedimientos.calcular_cuadradosLOP(10);
/*7. Crea una base de datos llamada procedimientos que contenga
una tabla llamada ejercicio. La tabla debe tener una única columna
llamada número y el tipo de dato de esta columna debe ser INT UNSIGNED.
Una vez creada la base de datos y la tabla deberá crear un
procedimiento llamado calcular_números con las siguientes características. El
procedimiento recibe un parámetro de entrada llamado valor_inicial de tipo INT
UNSIGNED y deberá almacenar en la tabla ejercicio toda la secuencia de números
desde el valor inicial pasado como entrada hasta el 1.
Tenga en cuenta que el procedimiento deberá eliminar el contenido actual de las
tablas antes de insertar los nuevos valores.
Utilice un bucle WHILE para resolver el procedimiento.*/
create table if not exists procedimientos.ejercicio(
	numero int unsigned
);
delimiter $$
drop procedure if exists procedimientos.calcular_numeros$$
create procedure procedimientos.calcular_numeros(IN valor_inicial int unsigned)
begin
	declare inicial int;
    set inicial=1;
    truncate procedimientos.ejercicio;
    /*while valor_inicial >= 1 do
		insert into procedimientos.ejercicio (numero) values (valor_inicial);
		set valor_inicial = valor_inicial - 1;
    end while;*/
    /*8. Utilice un bucle REPEAT para resolver el procedimiento del ejercicio anterior.*/
    /*repeat 
		insert into procedimientos.ejercicio (numero) values (valor_inicial);
		set valor_inicial = valor_inicial - 1;
    until valor_inicial < 1 end repeat;*/
    /*9. Utilice un bucle LOOP para resolver el procedimiento del ejercicio anterior.*/
    proc: loop
		insert into procedimientos.ejercicio (numero) values (valor_inicial);
		set valor_inicial = valor_inicial - 1;
        if valor_inicial < 1 then
			leave proc;
        end if;
    end loop;
    select * from  procedimientos.ejercicio;
end$$
call procedimientos.calcular_numeros(10);
/*10. Crea una base de datos llamada procedimientos que contenga
una tabla llamada pares y otra tabla llamada impares. Las dos tablas deben
tener única columna llamada número y el tipo de dato de esta columna debe
ser INT UNSIGNED.
Una vez creada la base de datos y las tablas deberá crear un
procedimiento llamado calcular_pares_impares con las siguientes características. El
procedimiento recibe un parámetro de entrada llamado tope de tipo INT UNSIGNED y
deberá almacenar en la tabla pares aquellos números pares que existan entre el
número 1 el valor introducido como parámetro. Habrá que realizar la misma
operación para almacenar los números impares en la tabla impares.
Tenga en cuenta que el procedimiento deberá eliminar el contenido actual de las
tablas antes de insertar los nuevos valores.
Utilice un bucle WHILE para resolver el procedimiento.*/
create table if not exists procedimientos.pares(
	numero int unsigned
);
create table if not exists procedimientos.impares(
	numero int unsigned
);
delimiter $$
drop procedure if exists procedimientos.calcular_pares_impares$$
create procedure procedimientos.calcular_pares_impares(IN tope int unsigned)
begin
	declare inicial int;
    set inicial=1;
    truncate procedimientos.pares;
    truncate procedimientos.impares;
    /*while tope >= inicial do
		case 
			when inicial % 2 = 0 then insert into procedimientos.pares(numero) values (inicial);
			else insert into procedimientos.impares(numero) values (inicial);
        end case;
        set inicial = inicial + 1;
    end while;*/
    /*11. Utilice un bucle REPEAT para resolver el procedimiento del ejercicio anterior.*/
    /*repeat 
		case 
			when inicial % 2 = 0 then insert into procedimientos.pares(numero) values (inicial);
			else insert into procedimientos.impares(numero) values (inicial);
        end case;
        set inicial = inicial + 1;
    until inicial > tope end repeat;*/
    /*12. Utilice un bucle LOOP para resolver el procedimiento del ejercicio anterior.*/
    proc: loop
		case 
			when inicial % 2 = 0 then insert into procedimientos.pares(numero) values (inicial);
			else insert into procedimientos.impares(numero) values (inicial);
        end case;
        set inicial = inicial + 1;
        if inicial > tope then
			leave proc;
        end if;
    end loop;
end$$
select * from  procedimientos.impares;
select * from  procedimientos.pares;
call procedimientos.calcular_pares_impares(10);