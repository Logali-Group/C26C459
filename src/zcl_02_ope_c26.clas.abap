CLASS zcl_02_ope_c26 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_02_ope_c26 IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    "lv_car

    DATA: number_a TYPE i VALUE 20,
          number_b TYPE i VALUE 5,
          total    TYPE p LENGTH 6 DECIMALS 2.

    " ══ 1. SUMA ═══════════════════════════════════════════════════
    total = number_a + number_b.
    out->write( |Number a: { number_a }  Number b: { number_b }  Total: { total }| ).

    " Forma clásica, SOLO para ver el aviso del compilador (obsoleta desde 7.54):
    ADD 5 TO total.

    total += 5.                               " acumulador: total = total + 5
    out->write( |+= 5           → Total: { total }| ).

    total = number_a + number_b + total.
    out->write( |a + b + total  → Total: { total }| ).

    CLEAR total.                              " vuelve al valor inicial: 0.00
    out->write( |CLEAR          → Total: { total }| ).

  " ══ 2. RESTA ══════════════════════════════════════════════════
    total = number_a - number_b.
    out->write( |a - b          → Total: { total }| ).

    "SUBTRACT 2 FROM total.                 " obsoleta: es total -= 2.

    total -= 2.
    out->write( |-= 2           → Total: { total }| ).

    total = number_a - 1.
    out->write( |a - 1          → Total: { total }| ).


*esto es un comentario


  " ══ 3. MULTIPLICACIÓN ═════════════════════════════════════════
    total = number_a * number_b.
    out->write( |a * b          → Total: { total }| ).

    "MULTIPLY total BY 5.                   " obsoleta: es total *= 5.

    total *= 5.
    total *= number_a.

    out->write( |*= 5, *= a     → Total: { total }| ).

    total = total * 2.
    out->write( |total * 2      → Total: { total }| ).



    " ══ 4. DIVISIÓN ═══════════════════════════════════════════════
    total = number_a / number_b.
    out->write( |a / b          → Total: { total }| ).

    DIVIDE total BY 2.                     " obsoleta: es total /= 2.

    total /= 2.
    out->write( |/= 2           → Total: { total }| ).

    CLEAR total.
    total = ( number_a + number_b ) / 3.      " los paréntesis mandan
    out->write( |( a + b ) / 3  → Total: { total }| ).


    " ══ 5. DIV y MOD: división entera y resto ═════════════════════
    number_a = 9.
    number_b = 4.

    total = number_a / number_b.              " 2.25 (el destino tiene 2 decimales)
    out->write( |9 / 4          → { total }| ).

    total = number_a DIV number_b.            " cociente entero, sin resto → 2
    out->write( |9 DIV 4        → { total }| ).

    total = number_a MOD number_b.            " resto: 9 = 2 × 4 + 1 → 1
    out->write( |9 MOD 4        → { total }| ).



  " ══ 6. POTENCIAS: ** e ipow ═══════════════════════════════════
    number_a = 3.
    number_a = number_a ** 2.                 " 9  (el operador ** calcula en coma flotante)
    out->write( |3 ** 2         → { number_a }| ).

    number_a = 3.
    DATA(exponent) = 3.

    number_a = number_a ** exponent.          " 27
    out->write( |3 ** 3         → { number_a }| ).

    DATA(power) = ipow( base = 2 exp = 3 ).   " 8, calculado con aritmética entera
    out->write( |ipow( 2, 3 )   → { power }| ).

    " ══ 7. RAÍZ CUADRADA ══════════════════════════════════════════
    DATA root TYPE i.                         " sqrt devuelve coma flotante; en un entero se redondea
    root = sqrt( 25 ).
    out->write( |sqrt( 25 )     → { root }| ).

    number_a = 9.
    root = sqrt( number_a ).
    out->write( |sqrt( 9 )      → { root }| ).








  ENDMETHOD.

ENDCLASS.
