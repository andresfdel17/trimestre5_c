
-- //Query para revisar los usuarios creados

-- select user, host from mysql.user;

-- //Creacion de usuario
-- create user 'adso680'@'%' identified by 'Sena1234';

-- //Dar permisos
-- grant all privileges on jardineria.* to 'adso680'@'%' with grant option;
-- flush privileges;

-- //Ver permisos
-- show grants for 'adso680'@'%';