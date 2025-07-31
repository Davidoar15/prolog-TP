% -- BASE DE CONOCIMIENTO / MODELADO --

% DE CANJES Y PAQUETES

% Personas 
persona(andy).
persona(flor).
persona(bobby).
persona(lala).
persona(pablito).
persona(toto).
%---------------------------
persona(ama).

% Figuritas (1, ..., 9)
figurita(1).
figurita(2).
figurita(3).
figurita(4).
figurita(5).
figurita(6).
figurita(7).
figurita(8).
figurita(9).

% --"Origenes" de las figuritas--
% paquete(Persona, NroPaquete, Figurita)/3
paquete(andy, 1, 2).
paquete(andy, 1, 4).
paquete(andy, 2, 7).
paquete(andy, 2, 6).
paquete(andy, 3, 8).
paquete(andy, 3, 1).
paquete(andy, 3, 3).
paquete(andy, 3, 5).

paquete(flor, 1, 5).
paquete(flor, 2, 5).

paquete(bobby, 1, 3).
paquete(bobby, 1, 5).
paquete(bobby, 2, 7).

paquete(lala, 1, 3).
paquete(lala, 1, 7).
paquete(lala, 1, 1).

paquete(toto, 1, 1).
%---------------------------
paquete(ama, 1, 1).
paquete(ama, 1, 3).
paquete(ama, 1, 3).

% regalo(QuienRecibe, QuienDa, Figurita)/3
regalo(flor, andy, 4).
regalo(flor, andy, 7).
regalo(flor, bobby, 2).

regalo(andy, flor, 1).

regalo(bobby, flor, 1).
regalo(bobby, flor, 4).
regalo(bobby, flor, 6).

regalo(pablito, lala, 1).
regalo(pablito, toto, 2).

regalo(lala, pablito, 5).

regalo(toto, pablito, 6).

% IMAGENES Y PERSONAJES
% Personaje: Personaje -> Popularidad
personaje(kitty, 5).
personaje(cinnamoroll, 4).
personaje(badtzMaru, 2).
personaje(keroppi, 3).
personaje(pompompurin, 4).
personaje(gudetama, 1).
personaje(myMelody, 3).
personaje(littleTwinStars, 2).
personaje(kuromi, 5).

% imagen: NroFigurita -> tipoImagen()
imagen(1, basica([kitty, keroppi])).
imagen(2, brillante(kitty)).
imagen(3, brillante(myMelody)).
imagen(4, basica([])).
imagen(5, rompecabezas([5,6,7])).
imagen(6, rompecabezas([5,6,7])).
imagen(7, rompecabezas([5,6,7])).
imagen(8, TipoImagen):-
    findall(UnPersonaje, personaje(UnPersonaje, _), Personajes),
    TipoImagen = basica(Personajes).

% -- ACTIVIDADES --

% DE CANJES Y PAQUETES

% 1. Saber que figuritas tiene una Persona
% tiene(Persona, Figurita)/2

tiene(Persona, Figurita):-
    paquete(Persona, _, Figurita).
tiene(Persona, Figurita):-
    regalo(Persona, _, Figurita).

% 2. Relacionar a una persona con una figurita si la TIENE REPETIDA
% obtuvo(Persona, Figurita, Origen)/3 !!
obtuvo(Persona, Figurita, dePaquete(NroPaquete)):-
    paquete(Persona, NroPaquete, Figurita).
obtuvo(Persona, Figurita, deRegalo(QuienDa)):-
    regalo(Persona, QuienDa, Figurita).

% repetida(Persona, Figurita)/2 !!
repetida(Persona, Figurita):-
    figurita(Figurita),
    findall(Origen, obtuvo(Persona, Figurita, Origen), Origenes),
    length(Origenes, Cantidad),
    Cantidad > 1.

% 3. Saber si una figurita es Rara
% esRara(Figurita)/1
esRara(Figurita):-
    figurita(Figurita),
    noEnPrimerosDosPaquetes(Figurita).
esRara(Figurita):-
    figurita(Figurita),
    menosDeLaMitadConsiguio(Figurita),
    nadieTieneRepetida(Figurita).

noEnPrimerosDosPaquetes(Figurita):-
    forall(member(NroPaquete, [1,2]), not(paquete(_, NroPaquete, Figurita))).

menosDeLaMitadConsiguio(Figurita):-
    findall(Persona, persona(Persona), TodasLasPersonas),
    length(TodasLasPersonas, TotalDePersonas),
    consiguieronFiguritaAlMenosUnaVez(Figurita, Personas),
    length(Personas, CantidadPersonasConFigurita),
    CantidadPersonasConFigurita*2 < TotalDePersonas.

consiguieronFiguritaAlMenosUnaVez(Figurita, Personas):-
    findall(Persona, tiene(Persona, Figurita), Lista),
    sort(Lista, Personas).

nadieTieneRepetida(Figurita):-
    consiguieronFiguritaAlMenosUnaVez(Figurita, Personas),
    forall(member(Persona, Personas), not(repetida(Persona, Figurita))).

% IMAGENES Y PERSONAJES

% 5. Definir predicado para saber si una Figurita es VALIOSA
esValiosa(Figura):-
    esRara(Figura).
esValiosa(Figura):-
    esAtractiva(Figura).

esAtractiva(Figura):-
    atractivo(Figura, Atractivo),
    Atractivo > 7.

atractivo(Figura, Atractivo):-
    imagen(Figura, Imagen),
    nivelAtractivo(Imagen, Atractivo).

nivelAtractivo(basica(Personajes), Atractivo):-
    findall(Popularidad, (member(Personaje, Personajes), personaje(Personaje, Popularidad)), Popularidades),
    sumlist(Popularidades, Atractivo).    

nivelAtractivo(brillante(Personaje), Atractivo):-
    personaje(Personaje, Popularidad),
    Atractivo is Popularidad * 5.

nivelAtractivo(rompecabezas(Piezas), NivelAtractivo):-
    length(Piezas, Longitud),
    (Longitud < 3 ->  NivelAtractivo = 2; NivelAtractivo = 0).

% 6. Relacionar Persona con la Imagen MAS ATRACTIVA de las figuritas que tiene

laMasAtractivaDe(Persona, MejorImagen):-
    tiene(Persona, _),
    tiene(Persona, MejorFigura),
    forall((tiene(Persona, OtraFigura), OtraFigura \= MejorFigura), figura1EsMasAtractiva(MejorFigura, OtraFigura)),
    imagen(MejorFigura, MejorImagen).

figura1EsMasAtractiva(Figura1, Figura2):-
    imagen(Figura1, Imagen1),
    imagen(Figura2, Imagen2),
    nivelAtractivo(Imagen1, Atractivo1),
    nivelAtractivo(Imagen2, Atractivo2),
    Atractivo1 > Atractivo2.

% 7. Saber que tan interesante resulta para una Persona un Paquete o Canje con otra persona
% Obtencion -> (functores) paquete(FiguritasRecibidas) || canje(FiguritasRecibidas, FiguritasDadas, PersonaParaCanje)

% interes(Persona, Opcion, Puntos)/3 !! POR AHORA, Mejorar si se requiere
interes(Persona, paquete(FiguritasRecibidas), Puntos):-
    calculoInteres(Persona, FiguritasRecibidas, Puntos).
interes(Persona, canje(FiguritasRecibidas, _, _), Puntos):-
    calculoInteres(Persona, FiguritasRecibidas, Puntos).
    
calculoInteres(Persona, Recibidas, Puntos):-
    findall(Figurita, (member(Figurita, Recibidas), not(tiene(Persona, Figurita))), FiguritasNuevas),
    findall(Atractivo, (member(Figurita, FiguritasNuevas), atractivo(Figurita, Atractivo)), ListaAtractivos),
    sumlist(ListaAtractivos, SumaAtractivos),
    (member(Figurita, FiguritasNuevas), esRara(Figurita) ->  Bonus = 20; Bonus = 0),
    Puntos is SumaAtractivos + Bonus.
    
% 8. Analisis elemental sobre Canjes Posibles y Paquetes Nuevos

validarObtencion(paquete(Figuritas)):-
    forall(member(Figurita, Figuritas), figurita(Figurita)).
validarObtencion(canje(Persona, FiguritasRecibidas, FiguritasDadas, PersonaParaCanje)):-
	forall(member(Figurita, FiguritasRecibidas), tiene(PersonaParaCanje, Figurita)),
    forall(member(Figurita, FiguritasDadas), tiene(Persona, Figurita)).

% CAMBIO, CAMBIO...

% 9. Verificar si una Persona HACE NEGOCIO con un Canje

haceNegocio(Persona, canje(FiguritasRecibidas, FiguritasDadas, PersonaParaCanje)):-
    persona(Persona),
    persona(PersonaParaCanje),
    member(FiguritaRecibida, FiguritasRecibidas),
    esValiosa(FiguritaRecibida),
    forall(member(FiguritaDada, FiguritasDadas), not(esValiosa(FiguritaDada))).


% 10. Saber si una Persona NECESITA CON URGENCIA una Figurita !! Esto quedo NO INVERSIBLE porque se las agarra con una de las versiones si preguntas necesitaUrgentemente(X,Y)

necesitaUrgentemente(Persona, Figurita):-
    figurita(Figurita),
    not(tiene(Persona, Figurita)),
    tiene(Persona, AlgunRompecabezas),
    imagen(AlgunRompecabezas, rompecabezas(PiezasNecesarias)),
    member(Figurita, PiezasNecesarias).
necesitaUrgentemente(Persona, Figurita):-
    figurita(Figurita),
    not(tiene(Persona, Figurita)),
    tieneCasiTodas(Persona).

tieneCasiTodas(Persona):-
    persona(Persona),
    findall(Figurita, distinct(tiene(Persona, Figurita)), FiguritasDistintas),
    length(FiguritasDistintas, CantidadFiguritas),
    CantidadFiguritas = 8. % El total de figuritas es 9

% PROFESIONALES DEL COLECCIONISMO

% 11. Saber si una Persona es una AMENAZA

esAmenaza(Persona, Canjes):-
    member(Canje, Canjes),
    excelenteCanje(Persona, Canje).

excelenteCanje(Persona, Canje):-
    haceNegocio(Persona, Canje),
    saleGanando(Persona, Canje).

saleGanando(Persona, canje(FiguritasRecibidas, FiguritasDadas, _)):-
    calculoInteres(Persona, FiguritasRecibidas, InteresSobreRecibidas),
    calculoInteres(Persona, FiguritasDadas, InteresSobreDadas),
    InteresSobreRecibidas > InteresSobreDadas.

% 12. Encontrar los POSIBLES CANJES VALIDOS que podria hacer una Persona con otra para conseguir Figuritas
% Lista todos los canjes posibles entre Persona y Otra
posiblesCanjes(Persona, OtraPersona, Canjes):-
    persona(Persona),
    persona(OtraPersona),
    Persona \= OtraPersona, 
    findall(Canje, posibleCanje(Persona, OtraPersona, Canje), Canjes).

% Un solo canje válido entre Persona y Otra Persona según estilos
posibleCanje(Persona, OtraPersona, canje(FiguritasRecibidas, FiguritasDadas, OtraPersona)):-
    universoRecibibles(Persona, OtraPersona, ListaRecibibles),
    ListaRecibibles \= [],
    universoRepetidas(Persona, ListaDadas), 
    ListaDadas \= [],
    subconjunto(ListaRecibibles, FiguritasRecibidas),
    FiguritasRecibidas \= [],
    subconjunto(ListaDadas, FiguritasDadas),
    FiguritasDadas \= [],
    validarObtencion(canje(Persona, FiguritasRecibidas, FiguritasDadas, OtraPersona)),
    tipoEstilo(FiguritasRecibidas, FiguritasDadas, OtraPersona).

tipoEstilo(Recibidas, Dadas, OtraPersona):-
    ( 
    	esClasico(OtraPersona, Dadas); 
    	esDescartador(OtraPersona, Recibidas); 
    	esCazafortunas(Dadas); 
    	esUrgido(OtraPersona, Recibidas)
    ), !. % Para que verifique el canje con la 1ra que cumpla

% Generador de todos los subconjuntos de una lista
subconjunto([], []).
subconjunto([X|Xs], [X|Ys]):- 
    subconjunto(Xs, Ys).
subconjunto([_|Xs], Ys):- 
    subconjunto(Xs, Ys).

% Lista figuritas que Otra Persona tiene y Persona no tiene
universoRecibibles(Persona, OtraPersona, Recibidas):-
    findall(Figurita, (tiene(OtraPersona, Figurita), not(tiene(Persona, Figurita))), ListaFiguritas),
    sort(ListaFiguritas, Recibidas).

% Lista de figuritas repetidas que Persona puede dar
universoRepetidas(Persona, Dadas):-
    findall(Figurita, repetida(Persona, Figurita), ListaFiguritas),
    sort(ListaFiguritas, Dadas).

% Estilo clásico: Otra Persona no tiene ninguna de las que recibiría
esClasico(OtraPersona, Dadas):- 
    forall(member(Figurita, Dadas), not(tiene(OtraPersona, Figurita))).

% Estilo descartador: Otra Persona entrega repetidas
esDescartador(OtraPersona, Recibidas):- 
    forall(member(Figurita, Recibidas), repetida(OtraPersona, Figurita)).

% Estilo cazafortunas: al menos una de figuritas Dadas es valiosa
esCazafortunas(Dadas):- 
    member(Figurita, Dadas), 
    esValiosa(Figurita).

% Estilo urgido: al menos una de figuritas Dadas la necesita con urgencia
esUrgido(OtraPersona, Recibidas):- 
    member(Figurita, Recibidas), 
    necesitaUrgentemente(OtraPersona, Figurita).
