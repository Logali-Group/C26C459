CLASS zcl_control_c26 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
   INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_control_c26 IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.


 "=================================================================
    " 1. IF - Calcular el descuento según el monto de compra
    "=================================================================
    out->write( '=== IF: CALCULAR DESCUENTO POR MONTO ===' ).
    DATA(monto_compra) = 1500.
    DATA(descuento) = 0.

    IF monto_compra >= 1000.
      descuento = 10.                                  " 10 % de descuento
      out->write( |Monto: { monto_compra } - Descuento: { descuento }%| ).
    ELSEIF monto_compra >= 500.
      descuento = 5.                                   " 5 % de descuento
      out->write( |Monto: { monto_compra } - Descuento: { descuento }%| ).
    ELSE.
      out->write( |Monto: { monto_compra } - Sin descuento| ).
    ENDIF.
    out->write( | | ).

  "=================================================================
    " 2. CASE - Estado de una orden de compra
    "=================================================================
    out->write( '=== CASE: ESTADO DE ORDEN DE COMPRA ===' ).
    DATA(estado_orden) = 'R'.          " A=Aprobada, P=Pendiente, R=Rechazada, E=Entregada

    CASE estado_orden.
      WHEN 'A'.
        out->write( 'Estado: APROBADA - Proceder con la entrega' ).
      WHEN 'P'.
        out->write( 'Estado: PENDIENTE - Esperando aprobación' ).
      WHEN 'R'.
        out->write( 'Estado: RECHAZADA - Contactar con compras' ).
      WHEN 'E'.
        out->write( 'Estado: ENTREGADA - Orden completada' ).
      WHEN OTHERS.
        out->write( 'Estado: DESCONOCIDO - Verificar sistema' ).
    ENDCASE.
    out->write( | | ).


    "=================================================================
    " 7. SWITCH - Comisión según la categoría del producto
    "=================================================================
    out->write( '=== SWITCH: CALCULAR COMISIÓN POR CATEGORÍA ===' ).
    DATA(categoria) = `ELECTRO`.                       " ELECTRO, ROPA, ALIMENTOS (backticks: string)
    DATA(precio_producto) = 1000.

    DATA(comision) = SWITCH decfloat34( categoria
                       WHEN 'ELECTRO'   THEN precio_producto * '0.15'   " 15 %
                       WHEN 'ROPA'      THEN precio_producto * '0.10'   " 10 %
                       WHEN 'ALIMENTOS' THEN precio_producto * '0.05'   " 5 %
                       ELSE                  precio_producto * '0.03' ). " 3 %

    out->write( |Categoría: { categoria }| ).
    out->write( |Precio: { precio_producto } - Comisión: { comision }| ).
    out->write( | | ).

    "=================================================================
    " 8. COND - Prioridad de envío según el tipo de cliente
    "=================================================================
    out->write( '=== COND: PRIORIDAD DE ENVÍO SEGÚN CLIENTE ===' ).
    DATA(tipo_cliente) = `VIP`.                        " VIP, REGULAR, NUEVO (backticks: string)

    DATA(prioridad) = COND string( WHEN tipo_cliente = 'VIP'     THEN 'ENVÍO EXPRESS - 24 horas'
                                   WHEN tipo_cliente = 'REGULAR' THEN 'ENVÍO ESTÁNDAR - 3-5 días'
                                   WHEN tipo_cliente = 'NUEVO'   THEN 'ENVÍO ESTÁNDAR - 5-7 días'
                                   ELSE                               'ENVÍO REGULAR - 7-10 días' ).

    out->write( |Cliente: { tipo_cliente }| ).
    out->write( |Prioridad: { prioridad }| ).
    out->write( | | ).



 "=================================================================
    " 3. DO - Generar números de factura consecutivos
    "=================================================================
    out->write( '=== DO: GENERAR 5 NÚMEROS DE FACTURA ===' ).
    DATA(numero_factura) = 10001.

    DO 5 TIMES.
      out->write( |Factura { sy-index }: FAC-{ numero_factura }| ).  " sy-index = vuelta actual
      numero_factura += 1.
    ENDDO.
    out->write( | | ).


    "=================================================================
    " 4. WHILE - Procesar pagos hasta saldar la deuda
    "=================================================================
    out->write( '=== WHILE: PROCESAR PAGOS HASTA COMPLETAR DEUDA ===' ).
    DATA(deuda_total) = 5000.
    DATA(pago) = 1500.                                 " cada pago es de 1500
    DATA(pago_acumulado) = 0.

    WHILE pago_acumulado < deuda_total.
      pago_acumulado += pago.
      out->write( |Pago { sy-index }: { pago } - Acumulado: { pago_acumulado }| ).
    ENDWHILE.
    out->write( '¡Deuda completamente pagada!' ).
    out->write( | | ).


    "=================================================================
    " 5. LOOP - Total de ventas recorriendo una tabla interna
    "=================================================================
    out->write( '=== LOOP: CALCULAR VENTAS POR VENDEDOR ===' ).
    TYPES: BEGIN OF venta,
             vendedor TYPE string,
             monto    TYPE i,
           END OF venta.
    DATA ventas TYPE STANDARD TABLE OF venta WITH EMPTY KEY.

    ventas = VALUE #( ( vendedor = 'Juan'  monto = 1000 )
                      ( vendedor = 'Maria' monto = 1500 )
                      ( vendedor = 'Juan'  monto = 2000 )
                      ( vendedor = 'Maria' monto = 500 ) ).

    DATA(total_ventas) = 0.
    LOOP AT ventas INTO DATA(venta).
      total_ventas += venta-monto.
      out->write( |{ venta-vendedor }: { venta-monto }| ).
    ENDLOOP.
    out->write( |Total de ventas: { total_ventas }| ).
    out->write( | | ).




    "=================================================================
    " 9. TRY - Validar la conversión de un monto (manejo de errores)
    "=================================================================
    out->write( '=== TRY: CONVERTIR MONTO DE STRING A NÚMERO ===' ).
    DATA(monto_texto) = `1500.50`.                     " cantidad como texto
    DATA monto_numero TYPE p LENGTH 8 DECIMALS 2.
    DATA error TYPE REF TO cx_sy_conversion_error.     " la usan los dos CATCH: se declara una vez

    TRY.
        monto_numero = monto_texto.
        out->write( |✓ Conversión exitosa: { monto_numero }| ).

        IF monto_numero <= 0.                          " validar que sea positivo
          out->write( '✗ Error: El monto debe ser mayor a cero' ).
        ELSE.
          out->write( |Monto válido para procesamiento: { monto_numero }| ).
        ENDIF.
      CATCH cx_sy_conversion_error INTO error.
        out->write( |✗ Error de conversión: { error->get_text( ) }| ).
    ENDTRY.
    out->write( | | ).

    " Ejemplo con un dato inválido
    out->write( '--- Ejemplo con dato inválido ---' ).
    monto_texto = `ABC123`.
    TRY.
        monto_numero = monto_texto.
        out->write( |Conversión exitosa: { monto_numero }| ).
      CATCH cx_sy_conversion_error INTO error.
        out->write( |✗ No se pudo convertir "{ monto_texto }" a número| ).
        out->write( |  Razón: { error->get_longtext( ) }| ).
    ENDTRY.

  ENDMETHOD.




ENDCLASS.
