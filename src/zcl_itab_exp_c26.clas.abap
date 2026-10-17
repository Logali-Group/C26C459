CLASS zcl_itab_exp_c26 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.

        " Tipo de línea: cada empleado conserva identificación, contacto, salario y moneda.
    TYPES: BEGIN OF employee,
            id            TYPE n LENGTH 8,
            first_name    TYPE c LENGTH 40,
            last_name     TYPE c LENGTH 40,
            email         TYPE c LENGTH 50,
            phone_number  TYPE c LENGTH 20,
            salary        TYPE p LENGTH 8 DECIMALS 2,
            currency_code TYPE c LENGTH 3,
          END OF employee.

    " Tipo de tabla STANDARD sin campos en su clave primaria.
    TYPES employees TYPE STANDARD TABLE OF employee
         WITH EMPTY KEY.



ENDCLASS.



CLASS zcl_itab_exp_c26 IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

*       out->write( '═══════════════════════════════════════════════' ).
*    out->write( '   SISTEMA DE GESTIÓN DE EMPLEADOS' ).
*    out->write( '═══════════════════════════════════════════════' ).
*    out->write( | | ).
*
*    out->write( '--- ESCENARIO 1: Carga inicial del mes ---' ).
*    out->write( 'RR.HH. tiene 3 empleados nuevos que empiezan hoy' ).
*    out->write( | | ).
*
*    " VALUE construye la tabla; cada paréntesis interior crea una fila.
*    DATA(empleados_mes) = VALUE employees(
*                                           ( id = '00000001'
*                                             first_name = 'Carlos'
*                                             last_name = 'García'
*                                             email = 'carlos.garcia@empresa.com'
*                                             phone_number = '+34 912345601'
*                                             salary = '2500.00'
*                                             currency_code = 'EUR' )
*                                           ( id = '00000002'
*                                             first_name = 'Ana'
*                                             last_name = 'Martínez'
*                                             email = 'ana.martinez@empresa.com'
*                                             phone_number = '+34 912345602'
*                                             salary = '2800.00'
*                                             currency_code = 'EUR' )
*                                           ( id = '00000003'
*                                             first_name = 'Luis'
*                                             last_name = 'Rodríguez'
*                                             email = 'luis.rodriguez@empresa.com'
*                                             phone_number = '+34 912345603'
*                                             salary = '2600.00'
*                                             currency_code = 'EUR' )
*   ).
*    out->write( 'Empleados cargados con VALUE:' ).
*    out->write( | | ).
*
*    LOOP AT empleados_mes INTO DATA(empleado).
*      out->write( |{ empleado-id } - { empleado-first_name } { empleado-last_name }| ).
*    ENDLOOP.
*    out->write( | | ).
*    out->write( 'VALUE es ideal para carga inicial' ).
*    out->write( '  porque podemos definir todos los registros de una vez' ).
*    out->write( | |  ).
*    out->write( | |  ).
*
*
***********************************************************************
*
*
*   out->write( '--- ESCENARIO 2: Llega el nuevo director ---' ).
*    out->write( 'Debe aparecer en la primera posición de la lista' ).
*    out->write( | | ).
*
*    " La estructura reúne los datos de la fila que se insertará.
*    DATA directora TYPE employee.
*    directora-id = '00000004'.
*    directora-first_name = 'María'.
*    directora-last_name = 'Fernández'.
*    directora-email = 'maria.fernandez@empresa.com'.
*    directora-phone_number = '+34 912345604'.
*    directora-salary = '4500.00'.
*    directora-currency_code = 'EUR'.
*
*    " INDEX 1 inserta al principio y desplaza las posiciones posteriores.
*    INSERT directora INTO empleados_mes INDEX 1.
*
*    out->write( 'Director insertado en posición 1 con INSERT' ).
*    out->write( | |  ).
*    out->write( 'Lista actualizada:' ).
*    out->write( | |  ).
*
*    LOOP AT empleados_mes INTO empleado.
*      IF sy-tabix = 1.
*        out->write( |-> { empleado-id } - { empleado-first_name } { empleado-last_name } (DIRECTOR)| ).
*      ELSE.
*        out->write( |  { empleado-id } - { empleado-first_name } {  empleado-last_name }| ).
*      ENDIF.
*    ENDLOOP.
*
*    out->write( | |  ).
*    out->write( 'INSERT es ideal para posiciones específicas' ).
*    out->write( '  porque podemos usar INDEX para indicar dónde' ).
*    out->write( | |  ).
*    out->write( | |  ).
*
*********************************************************************************************
*
*    out->write( '--- ESCENARIO 3: Solicitudes durante el día ---' ).
*    out->write( 'Cada solicitud se agrega al final de la cola' ).
*    out->write( | |  ).
*
*    DATA empleado_nuevo TYPE employee.
*    empleado_nuevo-id = '00000005'.
*    empleado_nuevo-first_name = 'Pedro'.
*    empleado_nuevo-last_name = 'Sánchez'.
*    empleado_nuevo-email = 'pedro.sanchez@empresa.com'.
*    empleado_nuevo-phone_number = '+34 912345605'.
*    empleado_nuevo-salary = '2400.00'.
*    empleado_nuevo-currency_code = 'EUR'.
*
*    " APPEND añade esta estructura al final de la tabla STANDARD.
*    APPEND empleado_nuevo TO empleados_mes.
*    out->write( 'Solicitud 1: Pedro agregado al final con APPEND' ).
*
*    " El tipo de la fila se infiere de la tabla destino mediante #.
*    APPEND VALUE #(
*     id = '00000006'
*     first_name = 'Laura'
*     last_name = 'López'
*     email = 'laura.lopez@empresa.com'
*     phone_number = '+34 912345606'
*     salary = '2700.00'
*     currency_code = 'EUR'
*   ) TO empleados_mes.
*
*    out->write( 'Solicitud 2: Laura agregada al final con APPEND' ).
*    out->write( | |  ).
*    out->write( 'Lista final completa:' ).
*    out->write( | |  ).
*
*    LOOP AT empleados_mes INTO empleado.
*      out->write( |{ sy-tabix }. { empleado-id } - {
*                   empleado-first_name } { empleado-last_name } | &&
*                 |({ empleado-salary } { empleado-currency_code })| ).
*    ENDLOOP.
*
*    out->write( | | ).
*    out->write( 'APPEND es ideal para agregar al final' ).
*    out->write( '  porque expresa que añadimos al final de esta STANDARD' ).
*    out->write( | | ).
*    out->write( | | ).
*
*
**********************************************************************************************
*
*
*    " El tipo destino conserva solo los tres campos necesarios del vuelo.
*    TYPES: BEGIN OF flight,
*            carrier_id    TYPE /dmo/carrier_id,
*            connection_id TYPE /dmo/connection_id,
*            flight_date   TYPE /dmo/flight_date,
*          END OF flight.
*
*    " EMPTY KEY evita una clave por defecto implícita en la lista de resultados.
*    DATA selected_flights TYPE STANDARD TABLE OF flight WITH EMPTY KEY.
*
*    " La consulta recupera una muestra de vuelos EUR ordenada por su clave de base de datos.
*    SELECT FROM /dmo/flight
*     FIELDS *
*     WHERE currency_code EQ 'EUR'
*      ORDER BY PRIMARY KEY
*     INTO TABLE @DATA(flights)
*      UP TO 100 ROWS.
*
*    out->write( |=======================================================| ).
*    out->write( |  CASO 1: Copia básica con campos coincidentes        | ).
*    out->write( |=======================================================| ).
*    out->write( | | ).
*    out->write( |Tabla origen tiene { lines( flights ) } registros con TODOS los campos| ).
*
*    " MOVE-CORRESPONDING copia componentes con el mismo nombre.
*    MOVE-CORRESPONDING flights TO selected_flights.
*
*    out->write( |FORMA ANTIGUA: MOVE-CORRESPONDING flights TO selected_flights.| ).
*    out->write( |Resultado: { lines( selected_flights ) } registros copiados| ).
*    out->write( selected_flights ).
*    out->write( | | ).
*
*    " CLEAR elimina las filas actuales del destino.
*    CLEAR selected_flights.
*
*    " La expresión construye el resultado a partir de los nombres coincidentes.
*    selected_flights = CORRESPONDING #( flights ).
*
*    out->write( |FORMA MODERNA: selected_flights = CORRESPONDING #( flights ).| ).
*    out->write( |Resultado: { lines( selected_flights ) } registros copiados| ).
*    out->write( selected_flights ).
*    out->write( |==> Ambas formas producen el MISMO resultado| ).
*    out->write( |\n\n| ).
*
*
*
*  out->write( |=======================================================| ).
*    out->write( |  CASO : Mapeo de campos con nombres diferentes      | ).
*    out->write( |=======================================================| ).
*    out->write( | | ).
*
*    " Los campos destino tienen nombres distintos de los campos origen.
*    TYPES: BEGIN OF flight_renamed,
*            carrier    TYPE /dmo/carrier_id,
*            connection TYPE /dmo/connection_id,
*            date       TYPE /dmo/flight_date,
*          END OF flight_renamed.
*
*    DATA renamed_flights TYPE STANDARD TABLE OF flight_renamed WITH EMPTY KEY.
*
*    SELECT FROM /dmo/flight
*     FIELDS *
*     WHERE currency_code EQ 'EUR'
*      ORDER BY PRIMARY KEY
*     INTO TABLE @flights
*     UP TO 5 ROWS.
*
*    out->write( |Tabla origen tiene campos: carrier_id, connection_id, flight_date| ).
*    out->write( |Tabla destino tiene campos: carrier, connection, date| ).
*    out->write( |Los nombres NO coinciden, pero la información es la misma.| ).
*    out->write( | | ).
*
*    " MAPPING relaciona cada campo destino con su campo origen.
*    renamed_flights = CORRESPONDING #( flights MAPPING carrier    = carrier_id
*                                                       connection = connection_id
*                                                       date       = flight_date ).
*
*
*    out->write( |Usamos MAPPING para relacionar los campos:| ).
*    out->write( |  carrier    = carrier_id| ).
*    out->write( |  connection = connection_id| ).
*    out->write( |  date       = flight_date| ).
*    out->write( | | ).
*    out->write( |Resultado con campos mapeados:| ).
*    out->write( renamed_flights ).
*    out->write( | | ).
*
**_________________________________________________________________________________________________
*
*
*  out->write( |=======================================================| ).
*    out->write( |  CASO : Agregar datos conservando los existentes    | ).
*    out->write( |=======================================================| ).
*    out->write( | | ).
*
*    SELECT FROM /dmo/flight
*     FIELDS *
*     WHERE currency_code EQ 'EUR'
*      ORDER BY PRIMARY KEY
*     INTO TABLE @flights
*     UP TO 3 ROWS.
*
*    selected_flights = CORRESPONDING #( flights ).
*
*    out->write( |Comenzamos con { lines( selected_flights ) } vuelos en EUR| ).
*    out->write( selected_flights ).
*    out->write( | | ).
*
*    SELECT FROM /dmo/flight
*     FIELDS *
*     WHERE currency_code EQ 'USD'
*      ORDER BY PRIMARY KEY
*     INTO TABLE @flights
*     UP TO 3 ROWS.
*
*    out->write( |Queremos agregar { lines( flights ) } vuelos en USD| ).
*    out->write( | | ).
*
*    " KEEPING TARGET LINES conserva el destino y añade las filas copiadas.
*    MOVE-CORRESPONDING flights TO selected_flights KEEPING TARGET LINES.
*    out->write( |FORMA ANTIGUA: MOVE-CORRESPONDING flights TO selected_flights KEEPING TARGET LINES.| ).
*
*    out->write( |Resultado: Ahora tenemos { lines( selected_flights ) } vuelos totales| ).
*    out->write( |Se conservaron los EUR y se agregaron los USD disponibles| ).
*    out->write( selected_flights ).
*    out->write( | | ).
*
*    CLEAR selected_flights.
*
*    SELECT FROM /dmo/flight
*     FIELDS *
*     WHERE currency_code EQ 'EUR'
*      ORDER BY PRIMARY KEY
*     INTO TABLE @DATA(eur_flights)
*     UP TO 3 ROWS.
*
*    selected_flights = CORRESPONDING #( eur_flights ).
*
*    " BASE conserva las filas del destino durante la construcción del resultado.
*
*    selected_flights = CORRESPONDING #( BASE ( selected_flights ) flights ).
*
*    out->write( |FORMA MODERNA: selected_flights = CORRESPONDING #( BASE ( selected_flights ) flights ).| ).
*
*    out->write( |Resultado: Ahora tenemos { lines( selected_flights ) } vuelos totales| ).
*    out->write( |Se conservaron los EUR y se agregaron los USD disponibles| ).
*    out->write( selected_flights ).
*    out->write( |==> Ambas formas producen el MISMO resultado| ).
*    out->write( |\n\n| ).


*"READ TABLE*****************************************************************
*
*    " La tabla interna contiene los aeropuertos de Alemania devueltos por la consulta.
*    SELECT FROM /dmo/airport
*     FIELDS *
*     WHERE country EQ 'DE'
*     INTO TABLE @DATA(airports).
*
*    IF sy-subrc EQ 0.
*
*      out->write( |CASO 1: Acceso por ÍNDICE (muy rápido siempre)| ).
*      out->write( |-------------------------------------------| ).
*
*      " INDEX 1 lee la primera fila; sy-subrc informa si la lectura encontró una fila.
*      READ TABLE airports INTO DATA(first_airport) INDEX 1.
*
*      IF sy-subrc <> 0.
*        out->write( |READ TABLE: no se encontró la fila solicitada.| ).
*      ENDIF.
*
*      out->write( |Forma antigua: READ TABLE ... INDEX 1| ).
*      out->write( first_airport ).
*
*      " Una expresión de tabla puede lanzar CX_SY_ITAB_LINE_NOT_FOUND si falta la fila.
*      DATA second_airport TYPE /dmo/airport.
*      TRY.
*          second_airport = airports[ 2 ].
*        CATCH cx_sy_itab_line_not_found.
*          out->write( |No existe la fila solicitada en esta muestra.| ).
*      ENDTRY.
*
*      out->write( |Forma moderna: airports[ 2 ]| ).
*      out->write( second_airport ).
*
*      " OPTIONAL devuelve una línea inicial del tipo indicado si no existe el índice.
*      DATA(safe_airport) = VALUE /dmo/airport( airports[ 999 ] OPTIONAL ).
*
*      out->write( |Con OPTIONAL no falla si no existe el índice| ).
*      out->write( safe_airport ).
*      out->write( |\n| ).
*
******************************************************************************************************************************
*      out->write( |CASO 2: Acceso por CAMPO (lento si hay muchos registros)| ).
*      out->write( |-------------------------------------------| ).
*
*      " WITH KEY busca por los componentes indicados en la clave libre.
*      READ TABLE airports INTO DATA(berlin_airport)
*       WITH KEY city = 'Berlin'.
*
*      IF sy-subrc <> 0.
*        out->write( |READ TABLE: no se encontró la fila solicitada.| ).
*      ENDIF.
*
*      out->write( |Forma antigua: WITH KEY city = 'Berlin'| ).
*      out->write( berlin_airport ).
*
*      DATA munich_airport TYPE /dmo/airport.
*
*      TRY.
*          munich_airport = airports[ city = 'Munich' ].
*        CATCH cx_sy_itab_line_not_found.
*          out->write( |No existe la fila solicitada en esta muestra.| ).
*      ENDTRY.
*
*      out->write( |Forma moderna: airports[ city = 'Munich' ]| ).
*      out->write( munich_airport ).
*
*      out->write( airports ).
*
*      " line_exists comprueba existencia en memoria sin recuperar una copia de la fila.
*      IF line_exists( airports[ city = 'Munich' ] ).
*        out->write( 'El aeropuerto existe en la tabla interna' ).
*      ELSE.
*        out->write( 'El aeropuerto no existe en la tabla interna' ).
*      ENDIF.
*
*      " line_index devuelve el índice de este acceso o cero si no encuentra la fila.
*      DATA(airport_index) = line_index( airports[ city = 'Munich' ] ).
*      out->write( airport_index ).
*
*      " El selector -name accede a un componente de la fila encontrada.
*      DATA airport_name TYPE /dmo/airport-name.
*
*      TRY.
*          airport_name = airports[ city = 'Hamburg' ]-name.
*        CATCH cx_sy_itab_line_not_found.
*          out->write( |No existe la fila solicitada en esta muestra.| ).
*      ENDTRY.
*
*      out->write( |Acceso a componente: ...[ city = 'Hamburg' ]-name| ).
*      out->write( |Resultado: { airport_name }| ).
*      out->write( |\n| ).
*
*
*
*      out->write( |CASO 3: Acceso OPTIMIZADO con tabla SORTED| ).
*      out->write( |-------------------------------------------| ).
*
*      " SORTED administra el orden y el acceso por airport_id.
*      DATA airports_by_id TYPE SORTED TABLE OF /dmo/airport
*       WITH NON-UNIQUE KEY airport_id.
*
*      SELECT FROM /dmo/airport
*       FIELDS *
*       INTO TABLE @airports_by_id.
*
*      out->write( airports_by_id ).
*
*      " KEY primary_key selecciona explícitamente la clave primaria.
*      DATA airport_by_primary_key TYPE /dmo/airport.
*
*      TRY.
*          airport_by_primary_key = airports_by_id[ KEY primary_key airport_id = 'FRA' ].
*        CATCH cx_sy_itab_line_not_found.
*          out->write( |No existe la fila solicitada en esta muestra.| ).
*      ENDTRY.
*
*      out->write( |Con KEY primary_key: Búsqueda MUY rápida| ).
*      out->write( airport_by_primary_key ).
*
*      " Una clave libre compatible también puede aprovechar la clave primaria.
*
*      DATA airport_by_free_key TYPE /dmo/airport.
*
*      TRY.
*          airport_by_free_key = airports_by_id[ airport_id = 'MUC' ].
*        CATCH cx_sy_itab_line_not_found.
*          out->write( |No existe la fila solicitada en esta muestra.| ).
*      ENDTRY.
*
*      out->write( |Sin KEY: Clave libre compatible con la clave primaria| ).
*      out->write( airport_by_free_key ).
*      out->write( |\n| ).
*  ENDIF.


***************************************** FOR **********************************************************
*
*
*    " El precio usa un tipo decimal; la categoría determina el filtro posterior.
*    TYPES: BEGIN OF producto,
*            id       TYPE i,
*            nombre   TYPE string,
*            precio   TYPE p LENGTH 10 DECIMALS 2,
*            categoria TYPE string,
*          END OF producto.
*
*    TYPES: BEGIN OF producto_con_descuento,
*            id              TYPE i,
*            nombre          TYPE string,
*            precio_original TYPE p LENGTH 10 DECIMALS 2,
*            descuento       TYPE i,
*            precio_final    TYPE p LENGTH 10 DECIMALS 2,
*          END OF producto_con_descuento.
*
*    DATA productos TYPE TABLE OF producto WITH EMPTY KEY.
*
*    DATA productos_con_descuento TYPE TABLE OF producto_con_descuento WITH EMPTY KEY.
*
*    out->write( |CASO 1: Generar productos automáticamente| ).
*    out->write( |======================================| ).
*
*    " FOR UNTIL genera diez filas con identificador, precio y categoría.
*    productos = VALUE #(
*     FOR i = 1 UNTIL i > 10
*         ( id        = i
*           nombre    = |Producto { i }|
*           precio    = 100 + ( i * 20 )
*           categoria = COND #( WHEN i <= 5 THEN 'Basico' ELSE 'Premium' ) )
*       ).
*
*    out->write( |Generados { lines( productos ) } productos| ).
*    out->write( productos ).
*    out->write( |\n| ).
*
*
*    out->write( |CASO 2: Aplicar descuentos según precio| ).
*    out->write( |==================================| ).
*
*    " FOR IN construye una fila de salida por cada producto del origen.
*
*    productos_con_descuento = VALUE #(
*                                       FOR producto IN productos
*                                       " COND evalúa los tramos en orden; LET conserva el porcentaje en la expresión.
*                                       LET descuento_aplicado = COND i( WHEN producto-precio >= 200 THEN 20
*                                                                        WHEN producto-precio >= 150 THEN 15
*                                                                         ELSE 10 )
*                                       IN
*
*                                       ( id              = producto-id
*                                         nombre          = producto-nombre
*                                         precio_original = producto-precio
*                                         descuento       = descuento_aplicado
*                                         precio_final    = producto-precio * ( 100 - descuento_aplicado ) / 100 )
*   ).
*
*    out->write( |Todos los productos con descuento aplicado:| ).
*
*    LOOP AT productos_con_descuento INTO DATA(producto_rebajado).
*      out->write( |{ producto_rebajado-nombre }: { producto_rebajado-precio_original } EUR -> { producto_rebajado-precio_final } EUR ({ producto_rebajado-descuento }% desc)| ).
*    ENDLOOP.
*
*    out->write( |\n| ).
*
*
*
*    out->write( |CASO 3: Reporte solo de productos Premium| ).
*    out->write( |====================================| ).
*
*    " WHERE selecciona las filas Premium y conserva su estructura.
*
*    DATA productos_premium TYPE TABLE OF producto WITH EMPTY KEY.
*
*    productos_premium = VALUE #( FOR producto IN productos
*                                WHERE ( categoria = 'Premium' )
*                                ( producto ) ).
*
*    out->write( |Productos Premium: { lines( productos_premium ) } de { lines( productos ) }| ).
*
*    out->write( productos_premium ).
*    out->write( |\n| ).
*
*
*
*

****************************************SORT **************************
*
*
*    " La declaración inline crea una tabla STANDARD con clave primaria vacía.
*    SELECT FROM /DMO/I_Flight
*     FIELDS AirlineID,
*            ConnectionID,
*            FlightDate,
*            Price,
*            CurrencyCode
*     WHERE CurrencyCode = 'EUR'
*     INTO TABLE @DATA(vuelos)
*     UP TO 10 ROWS.
*
*    out->write( |Datos originales sin ordenar:| ).
*    out->write( vuelos ).
*    out->write( |\n| ).
*
*    out->write( |CASO 1: SORT con clave vacía (sin efecto)| ).
*    out->write( |================================| ).
*
*    " Sin BY, SORT usa la clave primaria; una clave vacía no ordena por ningún campo.
*    SORT vuelos.
*    out->write( |Después de SORT sin BY: mismo orden, clave vacía.| ).
*    out->write( vuelos ).
*    out->write( |\n| ).
*
*    out->write( |CASO 2: Ordenar descendente| ).
*    out->write( |=======================| ).
*
*    " DESCENDING ordena las fechas de mayor a menor.
*    SORT vuelos BY FlightDate DESCENDING.
*
*    out->write( |Después de SORT BY FlightDate DESCENDING:| ).
*    out->write( vuelos ).
*    out->write( |\n| ).
*
*    out->write( |CASO 3: Ordenar por campo específico (FlightDate)| ).
*    out->write( |=============================================| ).
*
*    " Sin dirección explícita, el criterio se ordena ascendentemente.
*    SORT vuelos BY FlightDate.
*
*    out->write( |Ordenado por FlightDate ascendente:| ).
*
*    LOOP AT vuelos INTO DATA(vuelo).
*      out->write( |{ vuelo-AirlineID }{ vuelo-ConnectionID } - { vuelo-FlightDate } - { vuelo-Price } { vuelo-CurrencyCode }| ).
*    ENDLOOP.
*    out->write( |\n| ).
*
*    out->write( |CASO 4: Ordenar por precio (más caro primero)| ).
*    out->write( |=========================================| ).
*
*    " El precio se compara dentro del conjunto de vuelos en EUR.
*
*    SORT vuelos BY Price DESCENDING.
*
*    out->write( |Ordenado por Price descendente:| ).
*
*    LOOP AT vuelos INTO vuelo.
*      out->write( |{ vuelo-AirlineID }{ vuelo-ConnectionID } - Precio: { vuelo-Price } { vuelo-CurrencyCode }| ).
*    ENDLOOP.
*    out->write( |\n| ).
*
*    out->write( |CASO 5: Ordenar por varios campos| ).
*    out->write( |=============================| ).
*
*    " Primero se ordena por aerolínea y después por precio descendente dentro de ella.
*    SORT vuelos BY AirlineID ASCENDING
*                     Price DESCENDING.
*
*    out->write( |Ordenado por AirlineID (asc) y luego Price (desc):| ).
*
*    LOOP AT vuelos INTO vuelo.
*      out->write( |{ vuelo-AirlineID } - { vuelo-ConnectionID } - { vuelo-Price } EUR| ).
*    ENDLOOP.
*
*    out->write( |\n| ).



"BORRADO

*    SELECT FROM /DMO/I_Customer
*     FIELDS CustomerID, FirstName, LastName, CountryCode
*      ORDER BY CustomerID
*      INTO TABLE @DATA(clientes)
*     UP TO 15 ROWS.
*
*    out->write( |Clientes iniciales: { lines( clientes ) }| ).
*    out->write( clientes ).
*    out->write( |\n| ).
*
*    out->write( |CASO 1: Eliminar el segundo cliente (posición 2)| ).
*    " Elimina la fila de la posición 2 si existe; pueden cambiar los índices posteriores.
*
*    DELETE clientes INDEX 2.
*
*    out->write( |Después de DELETE INDEX 2: { lines( clientes ) } clientes| ).
*    out->write( clientes ).
*    out->write( |\n| ).
*
*    out->write( |CASO 2: Eliminar clientes de Alemania| ).
*    " WHERE elimina todas las filas que cumplen la condición.
*
*    DELETE clientes WHERE CountryCode = 'DE'.
*
*    out->write( |Después de DELETE WHERE: { lines( clientes ) } clientes| ).
*    out->write( clientes ).
*    out->write( |\n| ).
*
*    out->write( |CASO 3: Conservar un representante por país| ).
*
*    " La ordenación reúne países iguales y define el representante por CustomerID.
*
*    SORT clientes BY CountryCode CustomerID.
*
*    " COMPARING CountryCode conserva una fila por país entre las filas contiguas.
*    DELETE ADJACENT DUPLICATES FROM clientes COMPARING CountryCode.
*
*    out->write( |Solo un cliente por país: { lines( clientes ) }| ).
*    out->write( clientes ).
*    out->write( |\n| ).
*
*    out->write( |CASO 4: Tres formas de vaciar una tabla| ).
*
*    DATA clientes_temporales TYPE TABLE OF /dmo/i_customer WITH EMPTY KEY.
*
*    SELECT FROM /DMO/I_Customer
*     FIELDS *
*     INTO CORRESPONDING FIELDS OF TABLE @clientes_temporales
*     UP TO 50 ROWS.
*
*    out->write( |Tabla con { lines( clientes_temporales ) } registros| ).
*
*    " CLEAR vacía el contenido y conserva la reserva inicial de memoria.
*
*    CLEAR clientes_temporales.
*    out->write( |Después de CLEAR: { lines( clientes_temporales ) } - conserva reserva inicial| ).
*
*    SELECT FROM /DMO/I_Customer
*     FIELDS *
*     INTO CORRESPONDING FIELDS OF TABLE @clientes_temporales
*     UP TO 50 ROWS.
*
*    " FREE vacía el contenido y libera también la reserva inicial.
*    FREE clientes_temporales.
*
*    out->write( |Después de FREE: { lines( clientes_temporales ) } - memoria liberada| ).
*
*
*
*    SELECT FROM /DMO/I_Customer
*     FIELDS *
*     INTO CORRESPONDING FIELDS OF TABLE @clientes_temporales
*     UP TO 50 ROWS.
*
*    " Una expresión VALUE sin filas asigna una tabla inicial.
*    clientes_temporales = VALUE #( ).
*    out->write( |Después de VALUE #(): { lines( clientes_temporales ) } - forma moderna| ).
*    out->write( |\n| ).
*
*


"COLLECT

*
*    TYPES: BEGIN OF venta,
*            producto  TYPE string,
*            cantidad  TYPE i,
*            importe   TYPE p LENGTH 10 DECIMALS 2,
*          END OF venta.
*
*    " producto es la clave; cantidad e importe son los componentes numéricos a sumar.
*    DATA ventas_acumuladas TYPE HASHED TABLE OF venta
*     WITH UNIQUE KEY producto.
*
*    DATA venta TYPE venta.
*
*    out->write( |Simulando ventas del día...| ).
*    out->write( |\n| ).
*
*    " COLLECT inserta si falta la clave; si existe, suma los componentes numéricos no clave.
*    venta = VALUE #( producto = 'Laptop' cantidad = 2 importe = 1000 ).
*    COLLECT venta INTO ventas_acumuladas.
*    out->write( |Venta 1: 2 Laptops por 1000 EUR| ).
*
*    venta = VALUE #( producto = 'Mouse' cantidad = 5 importe = 50 ).
*    COLLECT venta INTO ventas_acumuladas.
*    out->write( |Venta 2: 5 Mouse por 50 EUR| ).
*
*    " Esta venta se acumula en la fila Laptop ya existente.
*    venta = VALUE #( producto = 'Laptop' cantidad = 1 importe = 500 ).
*    COLLECT venta INTO ventas_acumuladas.
*    out->write( |Venta 3: 1 Laptop por 500 EUR (se suma a la anterior)| ).
*
*    venta = VALUE #( producto = 'Mouse' cantidad = 10 importe = 100 ).
*    COLLECT venta INTO ventas_acumuladas.
*    out->write( |Venta 4: 10 Mouse por 100 EUR (se suma a la anterior)| ).
*
*    venta = VALUE #( producto = 'Teclado' cantidad = 3 importe = 150 ).
*    COLLECT venta INTO ventas_acumuladas.
*    out->write( |Venta 5: 3 Teclados por 150 EUR| ).
*
*    venta = VALUE #( producto = 'Laptop' cantidad = 1 importe = 600 ).
*    COLLECT venta INTO ventas_acumuladas.
*
*    out->write( |Venta 6: 1 Laptop por 600 EUR (se suma a las anteriores)| ).
*    out->write( |\n| ).
*    out->write( |RESULTADO: Ventas acumuladas por producto| ).
*    out->write( |=========================================| ).
*
*    LOOP AT ventas_acumuladas INTO DATA(acumulado).
*      out->write( |Producto: { acumulado-producto }| ).
*      out->write( |  Cantidad total: { acumulado-cantidad } unidades| ).
*      out->write( |  Importe total: { acumulado-importe } EUR| ).
*      out->write( |---| ).
*    ENDLOOP.


*
*    SELECT FROM /DMO/I_Customer
*     FIELDS CustomerID, FirstName, LastName, CountryCode, City
*     INTO TABLE @DATA(clientes).
*
*    out->write( |Total de clientes: { lines( clientes ) }| ).
*    out->write( |\n| ).
*
*    out->write( |CASO 1: Agrupar clientes por país| ).
*    out->write( |===============================| ).
*
*    " El LOOP recorre grupos por país; el field symbol actúa como representante.
*    LOOP AT clientes ASSIGNING FIELD-SYMBOL(<cliente>)
*     GROUP BY <cliente>-CountryCode.
*
*      out->write( |País: { <cliente>-CountryCode }| ).
*
*      DATA clientes_del_pais LIKE clientes.
*
*      CLEAR clientes_del_pais.
*
*      " LOOP AT GROUP recorre los miembros del grupo actual.
*
*      LOOP AT GROUP <cliente> INTO DATA(miembro).
*        clientes_del_pais = VALUE #( BASE clientes_del_pais ( miembro ) ).
*      ENDLOOP.
*
*      out->write( |  Total clientes: { lines( clientes_del_pais ) }| ).
*      out->write( clientes_del_pais ).
*      out->write( |---| ).
*    ENDLOOP.
*    out->write( |\n| ).

"CORRESPONDING

    TYPES: BEGIN OF empleado_completo,
             id TYPE i,
             nombre TYPE string,
             salario TYPE p LENGTH 10 DECIMALS 2,
             departamento TYPE string,
             telefono TYPE string,
           END OF empleado_completo,
           BEGIN OF empleado_publico,
             id TYPE i,
             nombre TYPE string,
             departamento TYPE string,
           END OF empleado_publico,
           BEGIN OF empleado_con_telefono,
             id TYPE i,
             nombre TYPE string,
             departamento TYPE string,
             telefono TYPE string,
           END OF empleado_con_telefono.

    DATA empleados_completos TYPE STANDARD TABLE OF empleado_completo WITH EMPTY KEY.
    DATA empleados_publicos TYPE STANDARD TABLE OF empleado_publico WITH EMPTY KEY.
    DATA empleados_destino TYPE STANDARD TABLE OF empleado_con_telefono WITH EMPTY KEY.

    empleados_completos = VALUE #(
      ( id = 1 nombre = 'Ana García' salario = 45000 departamento = 'IT' telefono = '600111222' )
      ( id = 2 nombre = 'Carlos López' salario = 38000 departamento = 'Ventas' telefono = '600333444' )
      ( id = 3 nombre = 'María Ruiz' salario = 52000 departamento = 'IT' telefono = '600555666' ) ).

    out->write( 'EMPLEADOS COMPLETOS' ).
    out->write( empleados_completos ).

    "Solo se asignan componentes con nombres coincidentes en el destino.
    empleados_publicos = CORRESPONDING #( empleados_completos ).
    out->write( 'DESTINO SIN SALARIO NI TELÉFONO' ).
    out->write( empleados_publicos ).

    "EXCEPT omite telefono; en este resultado nuevo queda inicial.
    empleados_destino = CORRESPONDING #( empleados_completos EXCEPT telefono ).
    out->write( 'DESTINO CON TELÉFONO INICIAL' ).
    out->write( empleados_destino ).



    TYPES: BEGIN OF venta,
             producto TYPE string,
             cantidad TYPE i,
           END OF venta.

    DATA ventas_dia TYPE STANDARD TABLE OF venta WITH EMPTY KEY.
    DATA ventas_unicas TYPE SORTED TABLE OF venta WITH UNIQUE KEY producto.

    ventas_dia = VALUE #(
      ( producto = 'Laptop' cantidad = 2 )
      ( producto = 'Mouse' cantidad = 5 )
      ( producto = 'Laptop' cantidad = 1 )
      ( producto = 'Teclado' cantidad = 3 )
      ( producto = 'Mouse' cantidad = 2 ) ).
    out->write( |Filas de origen: { lines( ventas_dia ) }| ).
    out->write( ventas_dia ).

    "Se conserva la primera fila encontrada por clave; no se suman cantidades.
    ventas_unicas = CORRESPONDING #( ventas_dia DISCARDING DUPLICATES ).
    out->write( |Productos únicos: { lines( ventas_unicas ) }| ).
    out->write( ventas_unicas ).
    out->write( 'Laptop: 2; Mouse: 5; Teclado: 3. No es una acumulación.' ).
























  ENDMETHOD.

ENDCLASS.
