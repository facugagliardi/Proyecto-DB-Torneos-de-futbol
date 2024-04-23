Entre las tablas se encuentran:
- Tabla Equipos: almacena información sobre los equipos que participan en los eventos
    - id_equipo (PK, int): Identificador único del equipo
    - nombre (varchar): Nombre completo del equipo
    - ciudad (varchar): Ciudad de origen del equipo
    - fundación (date): Fecha de fundación del equipo
- Tabla Jugadores: contiene detalles sobre los jugadores que pertenecen a los equipos
    - id_jugador (PK, int): Identificador único del jugador
    - nombre (varchar): Nombre completo del jugador
    - posición (varchar): Posición en la que juega el jugador
    - edad (int): Edad del jugador
    - id_equipo (FK, int): Clave foránea que referencia al equipo al que pertenece el jugador
- Tabla Estadio: almacena detalles sobre los estadios donde se juegan los partidos
    - id_estadio (PK, int): Identificador único del estadio
    - nombre (varchar): Nombre del estadio
    - ciudad (varchar): Ciudad donde se encuentra el estadio
    - capacidad (int): Capacidad máxima de espectadores del estadio
- Tabla Árbitros: contiene información sobre los árbitros que dirigen los partidos
    - id_arbitro (PK, int): Identificador único del árbitro
    - nombre (varchar): Nombre completo del árbitro
    - país (varchar): País de origen del árbitro
- Tabla Torneos: registra información sobre los torneos en los que participan los equipos
    - id_torneo (PK, int): Identificador único del torneo
    - Nombre (varchar): Nombre completo del torneo
    - año (int): Año en que se disputa el torneo
- Tabla Partidos: registra información sobre los partidos programados y jugados
    - id_partido (PK, int): Identificador único del partido
    - fecha (date): Fecha en la que se juega el partido
    - hora (time): Hora de inicio del partido
    - id_estadio (FK, int): Llave foránea que referencia al estadio en el que se juega el partido
    - id_arbitro (FK, int): Llave foránea que referencia al árbitro que dirije el partido
    - id_torneo (FK, int): Llave foránea que referencia al torneo que pertenece el partido
    - id_equipo_local (FK, int): Llave foránea que referencia al equipo que juega de local
    - id_equipo_visitante (FK, int): Llave foránea que referencia al equipo que juega de visitante
- Tabla Goles: registra los goles marcados en cada partido e información adicional
    - id_gol (PK, int): Identificador único del gol
    - minuto (int): Minuto en el que se marcó el gol
    - id_jugador (FK, int): Llave foránea que referencia al jugador que marcó el gol
    - id_partido (FK, int): Llave foránea que referencia al partido en el que se marcó el gol
- Tabla Tarjetas: almacena información sobre las tarjetas (amarillas y rojas) mostradas durante los partidos
    - id_tarjeta (PK, int): Identificador único de la tarjeta
    - tipo (enum): Tipo de tarjeta (amarilla o roja)
    - minuto (int): Minuto en el que se mostró la tarjeta
    - id_jugador (FK, int): Llave foránea que referencia al jugador al que le mostraron la tarjeta
    - id_partido (FK, int): Llave foránea que referencia al torneo al que pertenece el partido
    - id_torneo (FK, int): Llave foránea que referencia al torneo al que pertenece el torneo
