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

       out->write( '═══════════════════════════════════════════════' ).
    out->write( '   SISTEMA DE GESTIÓN DE EMPLEADOS' ).
    out->write( '═══════════════════════════════════════════════' ).
    out->write( | | ).

    out->write( '--- ESCENARIO 1: Carga inicial del mes ---' ).
    out->write( 'RR.HH. tiene 3 empleados nuevos que empiezan hoy' ).
    out->write( | | ).

    " VALUE construye la tabla; cada paréntesis interior crea una fila.
    DATA(empleados_mes) = VALUE employees(
                                           ( id = '00000001'
                                             first_name = 'Carlos'
                                             last_name = 'García'
                                             email = 'carlos.garcia@empresa.com'
                                             phone_number = '+34 912345601'
                                             salary = '2500.00'
                                             currency_code = 'EUR' )
                                           ( id = '00000002'
                                             first_name = 'Ana'
                                             last_name = 'Martínez'
                                             email = 'ana.martinez@empresa.com'
                                             phone_number = '+34 912345602'
                                             salary = '2800.00'
                                             currency_code = 'EUR' )
                                           ( id = '00000003'
                                             first_name = 'Luis'
                                             last_name = 'Rodríguez'
                                             email = 'luis.rodriguez@empresa.com'
                                             phone_number = '+34 912345603'
                                             salary = '2600.00'
                                             currency_code = 'EUR' )
   ).
    out->write( 'Empleados cargados con VALUE:' ).
    out->write( | | ).

    LOOP AT empleados_mes INTO DATA(empleado).
      out->write( |{ empleado-id } - { empleado-first_name } { empleado-last_name }| ).
    ENDLOOP.
    out->write( | | ).
    out->write( 'VALUE es ideal para carga inicial' ).
    out->write( '  porque podemos definir todos los registros de una vez' ).
    out->write( | |  ).
    out->write( | |  ).


**********************************************************************


   out->write( '--- ESCENARIO 2: Llega el nuevo director ---' ).
    out->write( 'Debe aparecer en la primera posición de la lista' ).
    out->write( | | ).

    " La estructura reúne los datos de la fila que se insertará.
    DATA directora TYPE employee.
    directora-id = '00000004'.
    directora-first_name = 'María'.
    directora-last_name = 'Fernández'.
    directora-email = 'maria.fernandez@empresa.com'.
    directora-phone_number = '+34 912345604'.
    directora-salary = '4500.00'.
    directora-currency_code = 'EUR'.

    " INDEX 1 inserta al principio y desplaza las posiciones posteriores.
    INSERT directora INTO empleados_mes INDEX 1.

    out->write( 'Director insertado en posición 1 con INSERT' ).
    out->write( | |  ).
    out->write( 'Lista actualizada:' ).
    out->write( | |  ).

    LOOP AT empleados_mes INTO empleado.
      IF sy-tabix = 1.
        out->write( |-> { empleado-id } - { empleado-first_name } { empleado-last_name } (DIRECTOR)| ).
      ELSE.
        out->write( |  { empleado-id } - { empleado-first_name } {  empleado-last_name }| ).
      ENDIF.
    ENDLOOP.

    out->write( | |  ).
    out->write( 'INSERT es ideal para posiciones específicas' ).
    out->write( '  porque podemos usar INDEX para indicar dónde' ).
    out->write( | |  ).
    out->write( | |  ).

********************************************************************************************

    out->write( '--- ESCENARIO 3: Solicitudes durante el día ---' ).
    out->write( 'Cada solicitud se agrega al final de la cola' ).
    out->write( | |  ).

    DATA empleado_nuevo TYPE employee.
    empleado_nuevo-id = '00000005'.
    empleado_nuevo-first_name = 'Pedro'.
    empleado_nuevo-last_name = 'Sánchez'.
    empleado_nuevo-email = 'pedro.sanchez@empresa.com'.
    empleado_nuevo-phone_number = '+34 912345605'.
    empleado_nuevo-salary = '2400.00'.
    empleado_nuevo-currency_code = 'EUR'.

    " APPEND añade esta estructura al final de la tabla STANDARD.
    APPEND empleado_nuevo TO empleados_mes.
    out->write( 'Solicitud 1: Pedro agregado al final con APPEND' ).

    " El tipo de la fila se infiere de la tabla destino mediante #.
    APPEND VALUE #(
     id = '00000006'
     first_name = 'Laura'
     last_name = 'López'
     email = 'laura.lopez@empresa.com'
     phone_number = '+34 912345606'
     salary = '2700.00'
     currency_code = 'EUR'
   ) TO empleados_mes.

    out->write( 'Solicitud 2: Laura agregada al final con APPEND' ).
    out->write( | |  ).
    out->write( 'Lista final completa:' ).
    out->write( | |  ).

    LOOP AT empleados_mes INTO empleado.
      out->write( |{ sy-tabix }. { empleado-id } - {
                   empleado-first_name } { empleado-last_name } | &&
                 |({ empleado-salary } { empleado-currency_code })| ).
    ENDLOOP.

    out->write( | | ).
    out->write( 'APPEND es ideal para agregar al final' ).
    out->write( '  porque expresa que añadimos al final de esta STANDARD' ).
    out->write( | | ).
    out->write( | | ).


*********************************************************************************************


    " El tipo destino conserva solo los tres campos necesarios del vuelo.
    TYPES: BEGIN OF flight,
            carrier_id    TYPE /dmo/carrier_id,
            connection_id TYPE /dmo/connection_id,
            flight_date   TYPE /dmo/flight_date,
          END OF flight.

    " EMPTY KEY evita una clave por defecto implícita en la lista de resultados.
    DATA selected_flights TYPE STANDARD TABLE OF flight WITH EMPTY KEY.

    " La consulta recupera una muestra de vuelos EUR ordenada por su clave de base de datos.
    SELECT FROM /dmo/flight
     FIELDS *
     WHERE currency_code EQ 'EUR'
      ORDER BY PRIMARY KEY
     INTO TABLE @DATA(flights)
      UP TO 100 ROWS.

    out->write( |=======================================================| ).
    out->write( |  CASO 1: Copia básica con campos coincidentes        | ).
    out->write( |=======================================================| ).
    out->write( | | ).
    out->write( |Tabla origen tiene { lines( flights ) } registros con TODOS los campos| ).

    " MOVE-CORRESPONDING copia componentes con el mismo nombre.
    MOVE-CORRESPONDING flights TO selected_flights.

    out->write( |FORMA ANTIGUA: MOVE-CORRESPONDING flights TO selected_flights.| ).
    out->write( |Resultado: { lines( selected_flights ) } registros copiados| ).
    out->write( selected_flights ).
    out->write( | | ).

    " CLEAR elimina las filas actuales del destino.
    CLEAR selected_flights.

    " La expresión construye el resultado a partir de los nombres coincidentes.
    selected_flights = CORRESPONDING #( flights ).

    out->write( |FORMA MODERNA: selected_flights = CORRESPONDING #( flights ).| ).
    out->write( |Resultado: { lines( selected_flights ) } registros copiados| ).
    out->write( selected_flights ).
    out->write( |==> Ambas formas producen el MISMO resultado| ).
    out->write( |\n\n| ).



  out->write( |=======================================================| ).
    out->write( |  CASO : Mapeo de campos con nombres diferentes      | ).
    out->write( |=======================================================| ).
    out->write( | | ).

    " Los campos destino tienen nombres distintos de los campos origen.
    TYPES: BEGIN OF flight_renamed,
            carrier    TYPE /dmo/carrier_id,
            connection TYPE /dmo/connection_id,
            date       TYPE /dmo/flight_date,
          END OF flight_renamed.

    DATA renamed_flights TYPE STANDARD TABLE OF flight_renamed WITH EMPTY KEY.

    SELECT FROM /dmo/flight
     FIELDS *
     WHERE currency_code EQ 'EUR'
      ORDER BY PRIMARY KEY
     INTO TABLE @flights
     UP TO 5 ROWS.

    out->write( |Tabla origen tiene campos: carrier_id, connection_id, flight_date| ).
    out->write( |Tabla destino tiene campos: carrier, connection, date| ).
    out->write( |Los nombres NO coinciden, pero la información es la misma.| ).
    out->write( | | ).

    " MAPPING relaciona cada campo destino con su campo origen.
    renamed_flights = CORRESPONDING #( flights MAPPING carrier    = carrier_id
                                                       connection = connection_id
                                                       date       = flight_date ).



    out->write( |Usamos MAPPING para relacionar los campos:| ).
    out->write( |  carrier    = carrier_id| ).
    out->write( |  connection = connection_id| ).
    out->write( |  date       = flight_date| ).
    out->write( | | ).
    out->write( |Resultado con campos mapeados:| ).
    out->write( renamed_flights ).
    out->write( | | ).


  ENDMETHOD.

ENDCLASS.
