CLASS zcl_13_structures_c26 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_13_structures_c26 IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    " ══ 6.1 ESTRUCTURA ANIDADA (NESTED) ════════════════════════════
    DATA: BEGIN OF empleado,
            BEGIN OF info,
              id         TYPE i VALUE 123456,
              first_name TYPE string VALUE `Laura`,
              last_name  TYPE string VALUE `Martínez`,
            END OF info,
            BEGIN OF address,
              city    TYPE string VALUE `Frankfurt`,
              street  TYPE string VALUE `123 Main street`,
              country TYPE string VALUE `Germany`,
            END OF address,
            BEGIN OF position,
              department TYPE string VALUE `IT`,
              salary     TYPE p LENGTH 8 DECIMALS 2 VALUE '2000.25',
            END OF position,
          END OF empleado.


    out->write( |========================================| ).
    out->write( |EMPLOYEE INFORMATION| ).
    out->write( |========================================| ).
    out->write( |PERSONAL INFO:| ).
    out->write( empleado-info ).
    out->write( |ADDRESS:| ).
    out->write( empleado-address ).
    out->write( |POSITION:| ).
    out->write( empleado-position ).
    out->write( |  | ).

    " ══ 6.2 RELLENAR CON VALUE ══════════════════════════════════════
    empleado = VALUE #( info     = VALUE #( id = 1234598 first_name = 'María' last_name = 'Nova' )
                        address  = VALUE #( city = 'Madrid' street = 'Gran Vía' country = 'Spain' )
                        position = VALUE #( department = 'Finance' salary = '2500.23' ) ).

    out->write( |========================================| ).
    out->write( |EMPLOYEE INFORMATION (VALUE)| ).
    out->write( |========================================| ).
    out->write( |PERSONAL INFO:| ).
    out->write( empleado-info ).
    out->write( |ADDRESS:| ).
    out->write( empleado-address ).
    out->write( |POSITION:| ).
    out->write( empleado-position ).
    out->write( |  | ).


    " ══ 6.3 ESTRUCTURA PROFUNDA (DEEP): una tabla dentro ════════════
    " 1) Tipo de cada fila de la tabla anidada
    TYPES: BEGIN OF flight,
             flight_date   TYPE /dmo/flight-flight_date,
             price         TYPE /dmo/flight-price,
             currency_code TYPE /dmo/flight-currency_code,
           END OF flight.

    " 2) Estructura DEEP: un campo elemental y una TABLA INTERNA
    DATA: BEGIN OF airline,
            carrier TYPE /dmo/flight-carrier_id VALUE 'AA',
            flights TYPE STANDARD TABLE OF flight WITH EMPTY KEY,   " ← tabla interna
          END OF airline.

  " 3) Rellenamos la tabla anidada desde la tabla liberada /dmo/flight
    SELECT flight_date, price, currency_code
      FROM /dmo/flight
      WHERE carrier_id = @airline-carrier
      INTO CORRESPONDING FIELDS OF TABLE @airline-flights
      UP TO 4 ROWS.

    out->write( |Vuelos de { airline-carrier }: { lines( airline-flights ) }| ).

    IF airline-flights IS NOT INITIAL.
      out->write( airline-flights ).
    ELSE.
      out->write( |No flights found| ).
    ENDIF.
    out->write( |  | ).


    " ══ 6.4 CLEAR: volver al valor inicial ══════════════════════════
    SELECT SINGLE FROM /dmo/flight
      FIELDS *
      WHERE carrier_id = 'LH'
      INTO @DATA(flight).

    out->write( flight ).

    CLEAR flight-price.                               " solo el precio vuelve a 0
    out->write( data = flight name = 'flight' ).

    CLEAR flight.                                     " todos los campos a su valor inicial
    out->write( data = flight name = 'flight' ).



*****************************************************************************************************************************

   out->write( '=== STANDARD TABLE ===' ).
    out->write( ' ' ).

    " STANDARD conserva una secuencia de filas; EMPTY KEY declara una clave primaria vacía.
    DATA reservas TYPE STANDARD TABLE OF /dmo/booking.

    " UP TO limita la muestra; ORDER BY fija el orden de selección.
    SELECT * FROM /dmo/booking
      ORDER BY PRIMARY KEY
      INTO TABLE @reservas
      UP TO 100 ROWS.

    out->write( 'Datos cargados en memoria' ).
    out->write( ' ' ).

    " INTO copia la fila actual en la estructura reserva.
    LOOP AT reservas INTO DATA(reserva).

      " sy-tabix contiene el índice de la fila actual; el IF limita solo la salida.
      IF sy-tabix <= 5.
        out->write( reserva-booking_id ).
        out->write( reserva-customer_id ).
        out->write( reserva-flight_price ).
        out->write( ' ' ).
      ENDIF.

    ENDLOOP.

    out->write( 'Proceso completado' ).
    out->write( ' ' ).
    out->write( 'STANDARD TABLE es ideal cuando:' ).
    out->write( '- Procesamos todos los registros de inicio a fin' ).
    out->write( '- No necesitamos buscar registros específicos' ).
    out->write( '- Queremos el código más simple posible' ).

******************************************************************************************************

*    out->write( '=== SORTED TABLE - Lista Ordenada ===' ).
*    out->write( ' ' ).
*
*    " SORTED mantiene el orden por last_name; NON-UNIQUE permite apellidos repetidos.
*    DATA clientes TYPE SORTED TABLE OF /dmo/customer
*         WITH NON-UNIQUE KEY last_name.
*
*    SELECT * FROM /dmo/customer
*      INTO TABLE @clientes.
*
*    out->write( 'Clientes cargados y ordenados automáticamente' ).
*    out->write( ' ' ).
*    out->write( 'Lista en orden alfabético por apellido:' ).
*    out->write( ' ' ).
*
*    " Las filas se recorren en el orden de la clave de la tabla.
*    LOOP AT clientes INTO DATA(cliente).
*
*      " La condición muestra como máximo ocho filas; no limita la carga SQL.
*      IF sy-tabix <= 20.
*        out->write( | { cliente-last_name },{ cliente-first_name } |  ).
*        out->write( ' ' ).
*      ENDIF.
*
*    ENDLOOP.
*
*    out->write( ' ' ).
*    out->write( 'SORTED TABLE es ideal cuando:' ).
*    out->write( '- Necesitamos datos ordenados automáticamente' ).
*    out->write( '- Haremos búsquedas frecuentes más adelante' ).
*    out->write( '- Queremos mostrar información ordenada al usuario' ).


****************************************************************************************************************
    out->write( '=== HASHED TABLE - Datos Maestros ===' ).
    out->write( ' ' ).

    " HASHED permite acceso por clave completa; UNIQUE KEY exige customer_id único.
    DATA clientes TYPE HASHED TABLE OF /dmo/customer
         WITH UNIQUE KEY customer_id.

    " UP TO 20 ROWS limita la cantidad de clientes recuperados.
    SELECT * FROM /dmo/customer
      INTO TABLE @clientes
      UP TO 20 ROWS.

    out->write( 'Clientes cargados en estructura hash' ).
    out->write( ' ' ).

    out->write( 'Algunos clientes en la tabla:' ).
    out->write( ' ' ).

    " El recorrido de una HASHED no garantiza un orden alfabético ni tiene índice primario.
    LOOP AT clientes INTO DATA(cliente).

      out->write(  | { cliente-customer_id  } - { cliente-last_name }, { cliente-first_name } | ).

    ENDLOOP.

    out->write( 'HASHED TABLE es ideal cuando:' ).
    out->write( '- Tenemos datos con clave única (como IDs)' ).
    out->write( '- Haremos MUCHAS búsquedas más adelante' ).
    out->write( '- La velocidad de búsqueda es crítica' ).
    out->write( '- No nos importa el orden de los registros' ).

ENDMETHOD.
ENDCLASS.
