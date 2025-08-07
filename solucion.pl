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

todasLasFiguritas(Persona, FigurasOrdenadas):-
    findall(Figuritas, tiene(Persona,Figuritas), TodasLasFiguritas),
    msort(TodasLasFiguritas, FigurasOrdenadas).

% 2. Relacionar a una persona con una figurita si la TIENE REPETIDA
% repetida(Persona, Figurita)/2 !!
repetida(Persona, Figurita):-
    persona(Persona),
    figurita(Figurita),
    findall(Figura, (tiene(Persona, Figura), Figura = Figurita), CopiasDeFigura),
    length(CopiasDeFigura, Cantidad),
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
    list_to_set(Lista, Personas).

nadieTieneRepetida(Figurita):-
    consiguieronFiguritaAlMenosUnaVez(Figurita, Personas),
    forall(member(Persona, Personas), not(repetida(Persona, Figurita))).

% IMAGENES Y PERSONAJES

% 5. Definir predicado para saber si una Figurita es VALIOSA
esValiosa(Figurita):-
    esRara(Figurita).
esValiosa(Figurita):-
    esAtractiva(Figurita).

esAtractiva(Figurita):-
    atractivo(Figurita, Atractivo),
    Atractivo > 7.

atractivo(Figurita, Atractivo):-
    imagen(Figurita, Imagen),
    nivelAtractivo(Imagen, Atractivo).

nivelAtractivo(basica(Personajes), Atractivo):-
    findall(Popularidad, (member(Personaje, Personajes), personaje(Personaje, Popularidad)), Popularidades),
    sumlist(Popularidades, Atractivo).    

nivelAtractivo(brillante(Personaje), Atractivo):-
    personaje(Personaje, Popularidad),
    Atractivo is Popularidad * 5.

nivelAtractivo(rompecabezas(Piezas), Atractivo):-
    length(Piezas, Longitud),
    Longitud >= 3,
    Atractivo is 0.
nivelAtractivo(rompecabezas(Piezas), Atractivo):-
    length(Piezas, Longitud),
    Longitud < 3,
    Atractivo is 2.
%(Longitud < 3 ->  Atractivo is 2; Atractivo is 0).

% 6. Relacionar Persona con la Imagen MAS ATRACTIVA de las figuritas que tiene

laMasAtractivaDe(Persona, MejorImagen):-
    tiene(Persona, MejorFigurita),
    forall((tiene(Persona, OtraFigurita), OtraFigurita \= MejorFigurita), figuritaEsMasAtractiva(MejorFigurita, OtraFigurita)),
    imagen(MejorFigurita, MejorImagen).

figuritaEsMasAtractiva(Figurita1, Figurita2):-
    imagen(Figurita1, Imagen1),
    imagen(Figurita2, Imagen2),
    nivelAtractivo(Imagen1, Atractivo1),
    nivelAtractivo(Imagen2, Atractivo2),
    Atractivo1 > Atractivo2.

% 7. Saber que tan interesante resulta para una Persona un Paquete o Canje con otra persona
% Obtencion -> (functores) paquete(FiguritasRecibidas) || canje(Persona, FiguritasRecibidas, FiguritasDadas, PersonaParaCanje)

% interes(Persona, Opcion, NivelInteres)/3 !! POR AHORA, Mejorar si se requiere
interes(Persona, paquete(FiguritasRecibidas), NivelInteres):-
    calculoInteres(Persona, FiguritasRecibidas, NivelInteres).
interes(Persona, canje(Persona, FiguritasRecibidas, _, _), NivelInteres):-
    calculoInteres(Persona, FiguritasRecibidas, NivelInteres).
    
calculoInteres(Persona, FiguritasTotales, NivelInteres):-
    figuritasFaltantes(Persona, FiguritasTotales, FiguritasDeInteres),
    totalDeAtractivos(FiguritasDeInteres, AtractivoTotal),
    calcularBonus(FiguritasDeInteres, Bonus),
    NivelInteres is AtractivoTotal + Bonus.
    
figuritasFaltantes(Persona, FiguritasTotales, FiguritasNuevas):-
    findall(Figurita, (member(Figurita, FiguritasTotales), not(tiene(Persona, Figurita))), FiguritasNuevas).

totalDeAtractivos(Figuritas, AtractivoTotal):-
    Figuritas \= [],
    findall(Atractivo, (member(Figurita, Figuritas), atractivo(Figurita, Atractivo)), ListaAtractivos),
    sumlist(ListaAtractivos, SumaAtractivos),
    AtractivoTotal is SumaAtractivos.
totalDeAtractivos([], 0).

calcularBonus(FiguritasNuevas, Bonus):-
    member(Figurita, FiguritasNuevas),
    esRara(Figurita),
    Bonus is 20.
calcularBonus(FiguritasNuevas, Bonus):-
    forall(member(Figurita, FiguritasNuevas), not(esRara(Figurita))),
    Bonus is 0.
    
% 8. Analisis elemental sobre Canjes Posibles y Paquetes Nuevos

validarObtencion(paquete(Figuritas)):-
    forall(member(Figurita, Figuritas), figurita(Figurita)).
validarObtencion(canje(Persona, FiguritasRecibidas, FiguritasDadas, PersonaParaCanje)):-
	validarCanjeFiguritas(Persona, FiguritasDadas),
    validarCanjeFiguritas(PersonaParaCanje, FiguritasRecibidas).

validarCanjeFiguritas(Persona, FiguritasCanje):-
    todasLasFiguritas(Persona, FiguritasDePersonaOrdenadas),
    msort(FiguritasCanje, FiguritasCanjeOrdenadas),
    ord_subset(FiguritasCanjeOrdenadas, FiguritasDePersonaOrdenadas).

% CAMBIO, CAMBIO...

% 9. Verificar si una Persona HACE NEGOCIO con un Canje

haceNegocio(Persona, canje(Persona, FiguritasRecibidas, FiguritasDadas, PersonaParaCanje)):-
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
    todasLasFiguritas(Persona, TodasLasFiguritas),
    list_to_set(TodasLasFiguritas, FiguritasDistintas),
    length(FiguritasDistintas, CantidadFiguritas),
    CantidadFiguritas is 8. % El total de figuritas es 9

% PROFESIONALES DEL COLECCIONISMO

% 11. Saber si una Persona es una AMENAZA

esAmenaza(Persona, Canjes):-
    member(Canje, Canjes),
    haceNegocio(Persona, Canje),
    forall(member(Canje, Canjes), saleGanando(Persona, Canje)).

saleGanando(Persona, canje(Persona, FiguritasRecibidas, FiguritasDadas, _)):-
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
posibleCanje(Persona, OtraPersona, canje(Persona, FiguritasRecibidas, FiguritasDadas, OtraPersona)):-
    posiblesFigurasDeCanje(Persona, FiguritasDadas),
    hayAlgunaRepetida(Persona, FiguritasDadas),
    posiblesFigurasDeCanje(OtraPersona, FiguritasRecibidas),
    validarObtencion(canje(Persona, FiguritasRecibidas, FiguritasDadas, OtraPersona)),
    tipoEstilo(FiguritasRecibidas, FiguritasDadas, OtraPersona).

posiblesFigurasDeCanje(Persona, FigurasParaCanje):-
    todasLasFiguritas(Persona, ListaTotalDeCanje),
    subconjuntosPosibles(ListaTotalDeCanje, FigurasParaCanje),
    FigurasParaCanje \= [].

hayAlgunaRepetida(Persona, Figuritas):-
    member(UnaRepetida, Figuritas),
    repetida(Persona, UnaRepetida).
% Para que verifique el canje con la 1ra que cumpla

% Generador de todos los subconjuntos de una lista
subconjuntosPosibles([], []).
subconjuntosPosibles([Cabeza|Cola], [Cabeza|ColaResultante]):- 
    subconjuntosPosibles(Cola, ColaResultante).
subconjuntosPosibles([_|Cola], ColaResultante):- 
    subconjuntosPosibles(Cola, ColaResultante).

tipoEstilo(_, Dadas, OtraPersona):-
   	esClasico(OtraPersona, Dadas).
tipoEstilo(Recibidas, _, OtraPersona):-
  	esDescartador(OtraPersona, Recibidas). 
tipoEstilo(_, Dadas, _):-
   	esCazafortunas(Dadas).
tipoEstilo(Recibidas, _, OtraPersona):-
    esUrgido(OtraPersona, Recibidas).

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
