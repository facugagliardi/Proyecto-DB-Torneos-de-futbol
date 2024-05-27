drop schema if exists torneos_proyecto;
create schema if not exists torneos_proyecto;
use torneos_proyecto;

-- Descripción: es una base de datos diseñada para un sistema de gestión de torneos que administre competiciones, equipos, jugadores, resultados y otro tipo de estadísticas y datos

-- Tabla Equipos: almacena información sobre los equipos que participan en los torneos
create table if not exists equipos(
	id_equipo int auto_increment,
    nombre varchar(30) not null,
    ciudad varchar(30) not null,
    fundación date not null,
    primary key(id_equipo)
);

-- Tabla Jugadores: contiene detalles sobre los jugadores que pertenecen a los equipos
create table if not exists jugadores(
	id_jugador int auto_increment,
    nombre varchar(50) not null,
    posición varchar(20) not null,
    edad int not null,
    id_equipo int not null,
    primary key(id_jugador),
    foreign key (id_equipo) references equipos(id_equipo)
);

-- Tabla Estadio: almacena detalles sobre los estadios donde se juegan los partidos
create table if not exists estadio(
	id_estadio int auto_increment,
    nombre varchar(45) not null,
    ciudad varchar(30) not null,
    capacidad int not null,
    primary key(id_estadio)
);

-- Tabla Árbitros: contiene información sobre los árbitros que dirigen los partidos
create table if not exists árbitros(
	id_arbitro int auto_increment,
    nombre varchar(45) not null,
    país varchar(25) not null,
    primary key(id_arbitro)
);

-- Tabla Torneos: registra información sobre los torneos en los que participan los equipos
create table if not exists torneo(
	id_torneo int auto_increment,
	nombre varchar(40) not null,
    año int not null,
    primary key(id_torneo)
);

-- Tabla Partidos: registra información sobre los partidos programados y jugados
create table if not exists partidos(
	id_partido int auto_increment,
    fecha date not null,
    hora time not null,
    id_estadio int not null,
    id_arbitro int not null,
    id_torneo int not null,
    id_equipo_local int not null,
    id_equipo_visitante int not null,
    primary key(id_partido),
    foreign key (id_estadio) references estadio(id_estadio),
    foreign key (id_arbitro) references árbitros(id_arbitro),
    foreign key (id_torneo) references torneo(id_torneo),
    foreign key (id_equipo_local) references equipos(id_equipo),
    foreign key (id_equipo_visitante) references equipos(id_equipo)
);

-- Tabla Goles: registra los goles marcados en cada partido e información adicional
create table if not exists goles(
	id_gol int auto_increment,
    minuto int not null,
    id_jugador int not null,
    id_partido int not null,
    primary key(id_gol),
    foreign key (id_jugador) references jugadores(id_jugador),
    foreign key (id_partido) references partidos(id_partido)
);

-- Tabla Tarjetas: almacena información sobre las tarjetas (amarillas y rojas) mostradas durante los partidos
create table if not exists tarjetas(
	id_tarjeta int auto_increment,
    tipo enum('A','R') not null,
    minuto int not null,
    id_jugador int not null,
    id_partido int not null,
    id_torneo int not null,
    primary key(id_tarjeta),
    foreign key (id_jugador) references jugadores(id_jugador),
    foreign key (id_partido) references partidos(id_partido),
    foreign key (id_torneo) references torneo(id_torneo)
);

-- CREACIÓN DE VISTAS

-- 1. Vista que muestre los 3 jugadores que hicieron más goles

create or replace view vw_goleadores as
	select jugadores.nombre, count(goles.id_gol) as total_goles
    from jugadores
    join goles on jugadores.id_jugador = goles.id_jugador
    group by jugadores.id_jugador, jugadores.nombre
    order by total_goles desc
    limit 3;
    
select * from vw_goleadores;

-- 2. Vista que muestre el jugador con más tarjetas amarillas
create or replace view vw_max_amarillas as
	select jugadores.nombre, count(tarjetas.id_tarjeta) as total_amarillas
    from jugadores
    join tarjetas on jugadores.id_jugador = tarjetas.id_jugador
    where tarjetas.tipo = 'A'
    group by jugadores.id_jugador, jugadores.nombre
    order by total_amarillas desc
    limit 1;
    
select * from vw_max_amarillas;

-- 3. Vista que muestre el jugador con más tarjetas rojas
create or replace view vw_max_rojas as
	select jugadores.nombre, count(tarjetas.id_tarjeta) as total_rojas
    from jugadores
    join tarjetas on jugadores.id_jugador = tarjetas.id_jugador
    where tarjetas.tipo = 'R'
    group by jugadores.id_jugador, jugadores.nombre
    order by total_rojas desc
    limit 1;
    
select * from vw_max_rojas;

-- 4. Vista que muestre el arbitro que más tarjetas mostró 
create or replace view vw_arb_max_tarjetas as
	select árbitros.nombre, count(tarjetas.id_tarjeta) as total_tarjetas
    from árbitros
    join partidos on árbitros.id_arbitro = partidos.id_arbitro
    join tarjetas on partidos.id_partido = tarjetas.id_partido
    group by árbitros.id_arbitro, árbitros.nombre
    order by total_tarjetas desc
    limit 1;
    
select * from vw_arb_max_tarjetas;

-- 5. Vista que muestre los dos estadios donde se disputaron más partidos
create or replace view vw_estadios_mas_usados as
	select estadio.nombre, count(partidos.id_partido) as total_partidos
    from estadio
    join partidos on estadio.id_estadio = partidos.id_estadio
    group by estadio.id_estadio, estadio.nombre
    order by total_partidos desc
    limit 2;

select * from vw_estadios_mas_usados;    


-- FUNCIONES

-- 1. Función para calcular el número total de goles en un torneo
drop function if exists fn_golestotales;
delimiter $$
create function fn_golestotales(p_id_torneo int)
returns varchar(60)
deterministic
begin
declare total int;
set total = (select count(id_gol) 
			from goles
            join partidos on goles.id_partido = partidos.id_partido
            where partidos.id_torneo = p_id_torneo
            );
return concat('Goles totales del torneo: ', total) ;
end $$
delimiter ;

select fn_golestotales(1);

-- 2. Función que calcule el promedio de edad de los jugadores de un equipo
drop function if exists fn_promedioedad;
delimiter %%
create function fn_promedioedad(p_id_equipo int)
returns varchar(50)
deterministic
begin
declare promedio int;
set promedio = (select avg(edad)
				from jugadores
                where jugadores.id_equipo = p_id_equipo
                );
return concat('Promedio de edad del equipo: ', promedio);
end %%
delimiter ;

select fn_promedioedad(8);

-- PROCEDIMIENTOS

-- 1. Procedimiento para ordenar la tabla "equipos"
drop procedure if exists sp_ordenar_equipos;
delimiter $$
create procedure sp_ordenar_equipos(in p_campo varchar(20), in p_orden char(4))
begin
	declare v_salida varchar(80); -- declaro variable de salida
	set v_salida = concat(' select * from equipos order by ', p_campo, ' ', p_orden); -- le asigno a la variable una funcion concat para construir la consulta con el campo y orden que recibe como parámetros
    set @sql = v_salida; -- asigno la consulta a una variable de usuario
	prepare stmt from @sql; -- preparo la consulta
    execute stmt; -- ejecuto la consulta preparada
    deallocate prepare stmt; -- libero el stmt
end $$
delimiter ; -- Utilicé este método ya que con lo visto en la clase de Procedimientos no se podía realizar

call sp_ordenar_equipos('ciudad','desc');

-- 2. Procedimiento que ingrese registros si es que no existe o elimine registros si es que ya existe en la tabla equipos

-- Anteriormente, como la tabla Equipos tiene FK en otras tablas, debo configurarles la opción ON CASCADE 
show create table jugadores; -- para verificar el nombre de la restricción de la FK
alter table jugadores drop foreign key jugadores_ibfk_1; 
alter table jugadores
add foreign key (id_equipo) references equipos(id_equipo) on delete cascade;

show create table partidos; 
alter table partidos drop foreign key partidos_ibfk_4; 
alter table partidos
add foreign key (id_equipo_local) references equipos(id_equipo) on delete cascade;

alter table partidos drop foreign key partidos_ibfk_5; 
alter table partidos
add foreign key (id_equipo_visitante) references equipos(id_equipo) on delete cascade;

-- Ahora si, inicio el procedimiento
drop procedure if exists sp_agregar_eliminar;
delimiter $$
create procedure sp_agregar_eliminar(in p_nombre varchar(30), in p_ciudad varchar(30), in p_fundacion date)
begin
	declare v_count int; 
	select count(*) into v_count -- Asigno a la variable la consulta
    from equipos
    where nombre = p_nombre; 
    
	if v_count = 1 then -- Eliminar si existe
		delete from equipos where nombre = p_nombre;
	elseif v_count = 0 then -- Insertar si no existe
		insert into equipos(nombre, ciudad, fundación) values (p_nombre, p_ciudad, p_fundacion);
	end if;
end $$
delimiter ;

set sql_safe_updates = 0; -- Desactivo el Modo de Actualización Segura temporalmente para poder eliminar registros de la tabla sin tener que utilizar un WHERE que use la PK
call sp_agregar_eliminar('Estudiantes de La Plata', 'La Plata', '1905-08-04');
set sql_safe_updates = 1; -- Vuelvo a activar el Modo de Actualización Segura 

select * from equipos; -- para verificar las modificaciones en la tabla

-- TRIGGERS 
create table if not exists auditoria_equipos(
	id_equipo int not null,
    fecha_hora datetime,
    usuario varchar(50)
);

-- Creacion de triggers

-- Before

-- 1. Update
create trigger tr_update_before
before update on auditoria_equipos
for each row
insert into auditoria_equipos(id_equipo, fecha_hora, usuario) values (new.id_equipo, now(), user());

-- 2. Insert
create trigger tr_insert_before
before insert on auditoria_equipos
for each row
insert into auditoria_equipos(id_equipo, fecha_hora, usuario) values (new.id_equipo, now(), user());

-- 3. Delete
create trigger tr_delete_before
before delete on auditoria_equipos
for each row
insert into auditoria_equipos(id_equipo, fecha_hora, usuario) values (old.id_equipo, now(), user());

-- After

create trigger tr_update_after
before update on auditoria_equipos
for each row
insert into auditoria_equipos(id_equipo, fecha_hora, usuario) values (new.id_equipo, now(), user());

-- 2. Insert
create trigger tr_insert_after
before insert on auditoria_equipos
for each row
insert into auditoria_equipos(id_equipo, fecha_hora, usuario) values (new.id_equipo, now(), user());

-- 3. Delete
create trigger tr_delete_after
before delete on auditoria_equipos
for each row
insert into auditoria_equipos(id_equipo, fecha_hora, usuario) values (old.id_equipo, now(), user());
