CLASS zcl_sorted_hashed_tables_thuyd DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_sorted_hashed_tables_thuyd IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

* Run this class using the ABAP Profiler to measure relative access times for standard, sorted, and hashed tables


    data(flights) = new lcl_flights( ).
    flights->access_standard( ).
    flights->access_sorted( ).
    flights->access_hashed( ).


    out->write( |Done| ).
  ENDMETHOD.
ENDCLASS.
