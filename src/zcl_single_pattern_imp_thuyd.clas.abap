CLASS zcl_single_pattern_imp_thuyd DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_single_pattern_imp_thuyd IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    DATA connection TYPE REF TO lcl_connection.


* Debug the method to show that the class always returns the same object
* for the same combination of airline and flight number


    connection = lcl_connection=>get_connection( airlineid = 'LH' connectionnumber = '0400' ).


    connection = lcl_connection=>get_connection( airlineid = 'LH' connectionnumber = '0400' ).


  ENDMETHOD.
ENDCLASS.
