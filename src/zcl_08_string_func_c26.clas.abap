CLASS zcl_08_string_func_c26 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  interfaces if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_08_string_func_c26 IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    " ══ 1.1 LONGITUD: strlen y numofchar ══════════════════════════
    " CASO 1: STRING (dinámico) → backticks. "Logali Group" (12) + 4 espacios = 16
    DATA(as_string)         = `Logali Group    `.
    DATA(string_length)     = strlen( as_string ).      " 16: en string cuenta los blancos finales
    DATA(string_characters) = numofchar( as_string ).   " 12: nunca cuenta los blancos finales

    out->write( '--- RESULTADOS CON STRING (`...`) ---' ).
    out->write( |Texto    : "{ as_string }"| ).
    out->write( |STRLEN   : { string_length }| ).
    out->write( |NUMOFCHAR: { string_characters }| ).


    " CASO 2: CHAR (longitud fija) → comillas simples. Las dos ignoran el relleno
    DATA(as_char)         = 'Logali Group    '.
    DATA(char_length)     = strlen( as_char ).          " 12
    DATA(char_characters) = numofchar( as_char ).       " 12

    out->write( ` ` ).
    out->write( '--- RESULTADOS CON CHAR (''...'') ---' ).
    out->write( |Texto    : "{ as_char }"| ).           " al imprimir, el relleno ya no se ve
    out->write( |STRLEN   : { char_length }| ).
    out->write( |NUMOFCHAR: { char_characters }| ).


    " ══ 1.2 CONTEO: cuántas veces aparece algo ═════════════════════
    DATA sample TYPE string VALUE `LOGALI local`.

    DATA(hits) = count( val = sample sub = 'LO' ).                  " 1: solo el "LO" exacto
    out->write( |count 'LO'                : { hits }| ).

    hits = count( val = sample sub = 'LO' case = abap_false ).      " 2: también el "lo" de local
    out->write( |count 'LO' sin mayúsculas : { hits }| ).

    hits = count_any_of( val = sample sub = 'LO' ).                 " 3: L, O y L
    out->write( |count_any_of 'LO'         : { hits }| ).

    hits = count_any_not_of( val = sample sub = 'LO' ).             " 9: los 12 caracteres menos esos 3
    out->write( |count_any_not_of 'LO'     : { hits }| ).


    " ══ 1.3 POSICIÓN: dónde está (la primera posición es la 0) ════
    DATA(position) = find( val = sample sub = 'LI' ).               " 4
    out->write( |find 'LI'                 : { position }| ).

    position = find_any_of( val = sample sub = 'LI' ).              " 0: la L de LOGALI
    out->write( |find_any_of 'LI'          : { position }| ).

    position = find_any_not_of( val = sample sub = 'LI' ).          " 1: la O
    out->write( |find_any_not_of 'LI'      : { position }| ).


    " ══ 1.4 MAYÚSCULAS Y MINÚSCULAS ═══════════════════════════════
    " Backticks: así el string conserva los dos blancos del final
    DATA greeting TYPE string VALUE ` ¡Logali Group! Welcome to ABAP Cloud Master  `.

    out->write( |TO_UPPER   = { to_upper( greeting ) }| ).
    out->write( |TO_LOWER   = { to_lower( greeting ) }| ).
    out->write( |TO_MIXED   = { to_mixed( greeting ) }| ).
    out->write( |FROM_MIXED = { from_mixed( greeting ) }| ).

    " Para lo que sirven de verdad: pasar de camelCase a SNAKE_CASE y al revés
    DATA(camel_case) = 'SalesOrderItems'.
    out->write( |De camel a snake: { from_mixed( camel_case ) }| ).                " SALES_ORDER_ITEMS

    DATA(snake_case) = 'GET_MATERIAL_DATA'.
    out->write( |De snake a camel: { to_mixed( snake_case ) }| ).                  " GetMaterialData
    out->write( |Con case = 'a'  : { to_mixed( val = snake_case  ) }| ). " getMaterialData


    " ══ 1.5 CAMBIAR EL ORDEN ══════════════════════════════════════
    out->write( |REVERSE              = { reverse( greeting ) }| ).
    out->write( |SHIFT_LEFT  (places) = { shift_left(  val = greeting places   = 5 ) }| ).
    out->write( |SHIFT_RIGHT (places) = { shift_right( val = greeting places   = 5 ) }| ).
    out->write( |SHIFT_LEFT  (circ)   = { shift_left(  val = greeting circular = 5 ) }| ).
    out->write( |SHIFT_RIGHT (circ)   = { shift_right( val = greeting circular = 5 ) }| ).


    " ══ 1.6 EXTRAER SUBCADENAS ════════════════════════════════════
    out->write( |SUBSTRING        = { substring(        val = greeting off = 9 len = 6 ) }| ).  " Group!
    out->write( |SUBSTRING_FROM   = { substring_from(   val = greeting sub = 'ABAP' ) }| ).
    out->write( |SUBSTRING_AFTER  = { substring_after(  val = greeting sub = 'ABAP' ) }| ).
    out->write( |SUBSTRING_TO     = { substring_to(     val = greeting sub = 'ABAP' ) }| ).
    out->write( |SUBSTRING_BEFORE = { substring_before( val = greeting sub = 'ABAP' ) }| ).


    " ══ 1.7 CONDENSE, REPEAT y SEGMENT ═══════════════════════════
    out->write( |CONDENSE  = { condense( val = greeting ) }| ).
    out->write( |REPEAT    = { repeat(   val = greeting occ = 4 ) }| ).
    out->write( |SEGMENT 1 = { segment(  val = greeting sep = '!' index = 1 ) }| ). " abc-def*sdf-dsdf-fsfgd-sdasd-asdas
    out->write( |SEGMENT 2 = { segment(  val = greeting sep = '!' index = 2 ) }| ).



    " ══ 2.1 CONTAINS: ¿hay coincidencia? (sí / no) ═════════════════
    DATA(employee_note) = `The employee's number is: 123-456-7890`.
    DATA(phone_pattern) = `\d{3}-\d{3}-\d{4}`.        " 3 dígitos - 3 dígitos - 4 dígitos

    IF contains( val = employee_note pcre = phone_pattern ).
      out->write( 'The text contains a phone number' ).
    ELSE.
      out->write( 'The text does not contain a phone number' ).
    ENDIF.

    " ══ 2.2 MATCH: devuelve el texto que coincide ══════════════════
    DATA(phone_number) = match( val = employee_note pcre = phone_pattern occ = 1 ).
    out->write( phone_number ).



    " ══ 2.3 EMAIL: contains, count y find con el mismo patrón ═════
    DATA(contact_text)  = `Please contact us at support@logali.com laura@logali.com for more information`.
    DATA(email_pattern) = `\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\b`.

    IF contains( val = contact_text pcre = email_pattern ).
      out->write( 'The text contains an email address' ).

      DATA(email_count) = count( val = contact_text pcre = email_pattern ).           " 1
      out->write( email_count ).

      DATA(email_position) = find( val = contact_text pcre = email_pattern occ = 2 ). " 21
      out->write( email_position ).
    ELSE.
      out->write( 'The text does not contain an email address' ).
    ENDIF.


    " ══ 3.1 CONCATENAR ════════════════════════════════════════════
    DATA(welcome) = `Welcome to Logali Group`.
    DATA(student) = 'ABAP' && ` ` && 'Student'.        " sin el ` ` quedarían pegados: ABAPStudent

    DATA(with_template) = | Concatenation 1: { welcome } / { student } |.
    out->write( with_template ).

    CONCATENATE welcome student INTO DATA(with_statement) SEPARATED BY space.
    out->write( | Concatenation 2: { with_statement } | ).

    " Las filas de una tabla interna, unidas en un solo string
    SELECT DISTINCT carrier_id
      FROM /dmo/flight
      ORDER BY carrier_id
      INTO TABLE @DATA(carriers).

    out->write( | { concat_lines_of( table = carriers sep = ` ` ) } | ).


 out->write( '------------------------' ).

  " ══ 3.2 INSERT: meter una subcadena en una posición ═══════════
    DATA(invoice_code) = insert( val = '123CLIENT02' sub = 'INV' off = 3 ).
    out->write( invoice_code ).                                 " 123INVCLIENT02

    invoice_code = insert( val = '123CLIENT02' sub = `INV` ).    " sin off: al principio
    out->write( invoice_code ).                                 " INV123CLIENT02


    " ══ 3.3 OVERLAY: superponer conservando la longitud ═══════════
    DATA(company)    = '--------------->Logali Group'.
    DATA(class_name) = 'ABAP_Class                  '.
    OVERLAY class_name WITH company.            " solo se rellenan los BLANCOS de class_name
    out->write( class_name ).                   " ABAP_Class----->Logali Group

    DATA(letters) = 'a.b.c.a.b.c.A'.
    DATA(mask)    = 'z.x.y.Z.x.y.z'.
    OVERLAY letters WITH mask ONLY 'ab'.        " solo las a y las b minúsculas (distingue mayúsculas)
    out->write( letters ).                      " z.x.c.Z.x.c.A

    " ══ 3.4 SPLIT: trocear por un separador ═══════════════════════
    DATA(academy) = 'Logali-Group-SAP-Academy'.
    out->write( academy ).

    " Sabes cuántas partes hay: una variable por parte
    SPLIT academy AT '-' INTO DATA(word_1) DATA(word_2) DATA(word_3) DATA(word_4).
    out->write( word_1 ).
    out->write( word_2 ).
    out->write( word_3 ).
    out->write( word_4 ).


    " ══ 3.5 REPLACE: sustituir ════════════════════════════════════
    DATA(title)     = 'Logali-Group-Academia-SAP'.
    DATA(separator) = '-'.
    out->write( title ).                                        " valor inicial

    REPLACE FIRST OCCURRENCE OF separator IN title WITH '/'.    " solo la primera
    out->write( title ).                                        " Logali/Group-Academia-SAP

    REPLACE ALL OCCURRENCES OF separator IN title WITH '/'.     " todas las que quedan
    out->write( title ).                                        " Logali/Group/Academia/SAP

    " La forma funcional (la más actual): devuelve el resultado y no toca la variable
    title = 'Logali-Group-Academia-SAP'.
    out->write( replace( val = title sub = separator with = '/' occ = 0 ) ).   " occ = 0: todas
    out->write( replace( val = title with = `#` off = 5 len = 3 ) ).           " Logal#roup-Academia-SAP









  ENDMETHOD.

ENDCLASS.
