CLASS zcl_string_functions_thuyd DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_string_functions_thuyd IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA text   TYPE string VALUE `  Let's talk about ABAP  `.
    DATA result TYPE i.

    out->write(  text ).

    result = find( val = text sub = 'A' ).
*
*    result = find( val = text sub = 'A' case = abap_false ).
*
*    result = find( val = text sub = 'A' case = abap_false occ =  -1 ).
*    result = find( val = text sub = 'A' case = abap_false occ =  -2 ).
*    result = find( val = text sub = 'A' case = abap_false occ =   2 ).
*
*    result = find( val = text sub = 'A' case = abap_false occ = 2 off = 10 ).
*    result = find( val = text sub = 'A' case = abap_false occ = 2 off = 10 len = 4 ).

    out->write( |RESULT = { result } | ).

  ENDMETHOD.
ENDCLASS.
