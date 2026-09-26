CLASS zcl_04_textsym_c26 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_04_textsym_c26 IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.


    " ══ 1. LITERALES: lo que NO hay que hacer ═════════════════════
    out->write( 'Welcome ABAP Student' ).
    out->write( 'This is your first text symbol' ).

    " ══ 2. SÍMBOLOS DE TEXTO: se crean en directo con Quick Fix ══
    out->write( text-001 ).
    out->write( TEXT-002 ).
    out->write( TEXT-003 ).



  ENDMETHOD.

ENDCLASS.
