CLASS zcl_86_solution_thuyd DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_86_solution_thuyd IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
      SELECT FROM /dmo/connection
        FIELDS *
        INTO TABLE @DATA(connections).

*      connection_list = connection_list.

      out->write( connections ).
    ENDMETHOD.
ENDCLASS.
