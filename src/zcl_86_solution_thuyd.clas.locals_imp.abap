*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

class lcl_carrier definition.

  public section.
  methods constructor
    IMPORTING i_carrier_id type /dmo/carrier_id
    RAISING cx_abap_invalid_value.

  METHODS get_name RETURNING VALUE(r_result) type /dmo/carrier_name.

  METHODS get_currency RETURNING VALUE(r_result) type /dmo/currency_code.

  protected section.
  private section.

  data carrier_data type /dmo/carrier.

endclass.

class lcl_carrier implementation.

    METHOD constructor.
        select SINGLE *
        from /dmo/carrier
        WHERE carrier_id = @i_carrier_id
        into @me->carrier_data.

        if sy-subrc <> 0.
            RAISE EXCEPTION TYPE cx_abap_invalid_value.
        endif.
    ENDMETHOD.

  method get_currency.
    r_result = me->carrier_data-currency_code.
  endmethod.

  method get_name.
    r_result = me->carrier_data-name.
  endmethod.

endclass.
