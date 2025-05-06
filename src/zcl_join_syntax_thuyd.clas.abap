CLASS zcl_join_syntax_thuyd DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_join_syntax_thuyd IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    SELECT FROM /dmo/carrier INNER JOIN /dmo/connection
*    SELECT FROM /dmo/carrier AS a INNER JOIN /dmo/connection AS c
             ON /dmo/carrier~carrier_id = /dmo/connection~carrier_id

         FIELDS /dmo/carrier~carrier_id,
                /dmo/carrier~name AS carrier_name,
                /dmo/connection~connection_id,
                /dmo/connection~airport_from_id,
                /dmo/connection~airport_to_id

          WHERE /dmo/carrier~currency_code = 'EUR'
           INTO TABLE @DATA(result).

    out->write(
      EXPORTING
        data   = result
        name   = 'RESULT'
    ).

  ENDMETHOD.
ENDCLASS.
