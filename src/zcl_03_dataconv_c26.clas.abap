CLASS zcl_03_dataconv_c26 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_03_dataconv_c26 IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

*  DATA(text_string) =  `12345`.
*  DATA(text_char)   =  '12345'.


   DATA: text   TYPE string VALUE `12345`,
         number TYPE i,
         date   TYPE d,
         amount TYPE p LENGTH 3 DECIMALS 2.   " máximo 999.99

    " ══ 1. CONVERSIÓN IMPLÍCITA string → i ════════════════════════
    number = text.                            " "12345" → 12345
    out->write( 'OK' ).
    out->write( number ).

    " ══ 2. CONVERSIÓN IMPLÍCITA string → d ════════════════════════
    text = `20230101`.
    date = text.                              " reconoce el formato AAAAMMDD
    out->write( |String value: { text }| ).
    out->write( |Date  (USER): { date DATE = USER }| ).        " máscara del usuario
    out->write( |Date  (ISO) : { date DATE = ISO }| ).         " 2023-01-01
    out->write( |Date  (ENV) : { date DATE = ENVIRONMENT }| ). " configuración del entorno


   " ══ 3. DUMP 1: una letra en un texto que va a entero ══════════
    "CX_SY_CONVERSION_NO_NUMBER.

*   text   = `12A45`.
*   number = text.
*   out->write( number ).

*    " La forma profesional: capturar la excepción en vez de dejar caer el programa.
    text = `12A45`.
    TRY.
        number = text.
        out->write( number ).
      CATCH cx_sy_conversion_no_number.
        out->write( |'{ text }' no es un número: no se puede convertir a entero| ).
    ENDTRY.



    " ══ 5. DUMP 2: número más largo que el tipo destino ═══════════

*   text   = `1234678`.
*   amount = text.                            " CX_SY_CONVERSION_OVERFLOW
*   out->write( amount ).

    text = `1234678`.
    TRY.
        amount = text.
        out->write( amount ).
      CATCH cx_sy_conversion_overflow.
        out->write( |{ text } no cabe en p LENGTH 3 DECIMALS 2 (máximo 999.99)| ).
    ENDTRY.

    " ══ 6. LA FECHA DEL SISTEMA, a la manera Cloud ════════════════
    "date = sy-datum. "obsoleta
    date = cl_abap_context_info=>get_system_date( ).
    out->write( |Hoy (USER): { date DATE = USER }| ).


"TRUNCAMIENTO Y REDONDEO

   " ══ 1. TRUNCAMIENTO DE CARACTERES (pérdida de datos) ══════════
    DATA: company_name TYPE string VALUE `LOGALI`,
          short_code   TYPE c LENGTH 2.

    short_code = company_name.                " "LOGALI" (6) en una caja de 2 → "LO"
    out->write( |'{ company_name }' en c LENGTH 2 → '{ short_code }'| ).


   " ══ 2. REDONDEO DE DECIMALES ══════════════════════════════════
    DATA quotient TYPE p LENGTH 3 DECIMALS 2.

    quotient = 1 / 6.                         " 0.1666… → 0.17 (el 3er decimal es 6: sube)
    out->write( |1 / 6  → { quotient }| ).

    quotient = 1 / 12.                        " 0.0833… → 0.08 (el 3er decimal es 3: baja)
    out->write( |1 / 12 → { quotient }| ).

    " ══ 3. DECLARACIONES EN LÍNEA: el tipo lo decide la asignación ═
    DATA(product) = 8 * 16.                   " entero (i) → 128. Míralo en el depurador.
    out->write( |8 * 16 → { product }| ).

    DATA(ratio) = 8 / 16.                     " ¡entero! 0.5 se redondea → 1
    out->write( |8 / 16 → { ratio }  (entero: se redondea)| ).

    DATA(course_name) = 'ABAP I - 2026'.      " c LENGTH 13
    out->write( |'{ course_name }' es un c de { strlen( course_name ) }| ).


   " ══ 4. CONVERSIÓN FORZADA CON CONV ════════════════════════════

    DATA(text_date) = '20250101'.             " es un c LENGTH 8, NO una fecha
    out->write( |Como c: { text_date }| ).
     "out->write( |{ text_date DATE = USER }| ).  ← error de sintaxis: DATE exige tipo d

    DATA(real_date) = CONV d( text_date ).   " ahora sí es una fecha
    out->write( |Como d: { real_date DATE = USER }| ).


"FECHA Y HORA

    " ══ 1. FECHA Y HORA DEL SISTEMA (clase liberada, no sy-) ══════
    DATA(today)        = cl_abap_context_info=>get_system_date( ).
    DATA(current_time) = cl_abap_context_info=>get_system_time( ).

    out->write( |Fecha del sistema: { today DATE = USER }| ).
    out->write( |Hora del sistema : { current_time TIME = USER }| ).


   " ══ 2. ARITMÉTICA: restar dos fechas = días ════════════════════
    DATA: start_date TYPE d VALUE '20260101',
          end_date   TYPE d VALUE '20260622'.

    DATA(days_between) = end_date - start_date.   " 172 días (probad también con 30)
    out->write( |Del { start_date DATE = USER } al { end_date DATE = USER } van { days_between } días| ).




    " ══ 3. OFFSET: trocear la fecha como si fuera texto ════════════
    DATA(year)  = end_date(4).                " 4 primeros caracteres → 2026
    DATA(month) = end_date+4(2).              " desde la posición 4, 2 caracteres → 06
    DATA(day)   = end_date+6(2).              " desde la posición 6, 2 caracteres → 22
    out->write( |Año: { year }  Mes: { month }  Día: { day }| ).

    " Sumar meses: el trozo "06" se convierte a número, se suma y cae en un n LENGTH 2
    DATA month_plus_two TYPE n LENGTH 2.      " n: dígitos con ceros a la izquierda
    month_plus_two = end_date+4(2) + 2.       " 06 + 2 → 08
    out->write( |Mes + 2: { month_plus_two }| ).
*
*    " ══ 4. SUMAR DÍAS a la fecha del sistema ═══════════════════════
*    DATA(in_ten_days) = cl_abap_context_info=>get_system_date( ) + 10.
*    out->write( |Hoy + 10 días: { in_ten_days DATE = USER }| ).



  ENDMETHOD.

ENDCLASS.
