CLASS zcl_tcs_text_pool_thuyd DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_tcs_text_pool_thuyd IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
      CONSTANTS c_carrier_id type /dmo/carrier_id value 'LH'.

      TRY.

      DATA(carrier) = new lcl_carrier( c_carrier_id ).

      out->write( |'Carrier'(001){  carrier->get_name(  ) }'has currency'(002) {  carrier->get_currency(  ) } | ).

      CATCH cx_abap_invalid_value.
          out->write( | 'Carrier'(001) { c_carrier_id } 'does not exist.'(003) | ).
      ENDTRY.
  ENDMETHOD.
ENDCLASS.
