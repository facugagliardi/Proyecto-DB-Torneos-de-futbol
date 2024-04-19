drop schema if exists torneos_proyecto;
create schema if not exists torneos_proyecto;
use torneos_proyecto;

-- Descripción: es una base de datos diseñada para un sistema de gestión de torneos que administre competiciones, equipos, jugadores, resultados y otro tipo de estadísticas y datos

-- Tabla Equipos: almacena información sobre los equipos que participan en los eventos
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