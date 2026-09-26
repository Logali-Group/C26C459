CLASS zcl_myfirstclass_c26 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_myfirstclass_c26 IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    out->write(  'This is my first class in ABAP' ).


   " DECLARACIÓN DE OBJETOS DE DATOS
   " string: Tipo completo. Para cadenas de caracteres de longitud variable.
   DATA string_var TYPE string.

   " i: Tipo completo. Entero de 4 bytes.
   DATA int TYPE i VALUE 20250110.

   " d: Tipo completo. Fecha con longitud fija de 8 caracteres.
   DATA lv_date TYPE datum.

   " p: Tipo incompleto. Se especifica una longitud total de 8 dígitos, con 2 decimales.
   DATA lv_dec TYPE p LENGTH 8 DECIMALS 2 VALUE '202501.10'.

   " c: Tipo incompleto. Campo de texto con una longitud fija de 10 caracteres.
   DATA lv_car TYPE c LENGTH 10 VALUE 'Logali'.



   " ASIGNACIÓN Y SALIDA
   " Asignación de un literal de texto.
   string_var = '20250110'.

   " El runtime de ABAP realiza una conversión implícita del string al formato de fecha interno.
   lv_date   = '20250110'.

   " La salida por consola muestra la representación externa de cada tipo de dato.
   out->write( |String: { string_var }| ).  " Salida: String: 20250110
   out->write( |Integer: { int }| ).   " Salida: Integer: 20250110
   out->write( |Date: { lv_date }| ).     " Salida: Date: 2025-01-10 (El IDE formatea la salida para mejorar la legibilidad)
   out->write( |Packed: { lv_dec }| ).    " Salida: Packed: 202501.10

   " El valor 'Logali' (6 caracteres) se alinea a la izquierda y se rellena con 4 espacios
   " a la derecha para completar la longitud definida de 10.
   out->write( |Char(10): '{ lv_car }'| ). " Salida: Char(10): 'Logali    '



CONSTANTS: lc_const TYPE c LENGTH 6 VALUE 'LOGALI',
           lc_date  TYPE d VALUE '20250510',
           lc_int   TYPE i VALUE 220.



  ENDMETHOD.

ENDCLASS.
