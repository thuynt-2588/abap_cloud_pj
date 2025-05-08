*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
*class lcl_flight definition create private.
*class lcl_flight definition create private.
CLASS lcl_flight DEFINITION ABSTRACT.

  PUBLIC SECTION.

    TYPES: BEGIN OF st_connection_details,
             airport_from_id TYPE /dmo/airport_from_id,
             airport_to_id   TYPE /dmo/airport_to_id,
             departure_time  TYPE /dmo/flight_departure_time,
             arrival_time    TYPE /dmo/flight_departure_time,
             duration        TYPE i,
           END OF st_connection_details.

    DATA carrier_id    TYPE /dmo/carrier_id       READ-ONLY.
    DATA connection_id TYPE /dmo/connection_id    READ-ONLY.
    DATA flight_date   TYPE /dmo/flight_date      READ-ONLY.

    METHODS constructor IMPORTING i_carrier_id    TYPE string
                                  i_connection_id TYPE string
                                  i_flight_date   TYPE string.

    METHODS get_connection_details
      RETURNING
        VALUE(r_result) TYPE st_connection_details.

    METHODS get_description
      RETURNING
        VALUE(r_result) TYPE string_table.

  PROTECTED SECTION.

    DATA planetype          TYPE /dmo/plane_type_id.
    DATA connection_details TYPE st_connection_details.

  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_flight IMPLEMENTATION.


  METHOD constructor.
    me->carrier_id    = I_carrier_id.
    me->connection_id = i_connection_id.
    me->flight_date   = i_flight_date.
  ENDMETHOD.


  METHOD get_connection_details.

  ENDMETHOD.

  METHOD get_description.
    DATA txt TYPE string.

    txt = 'Flight &carrid& &connid& on &date& from &from& to &to&'(001).
    txt = replace( val = txt sub = '&carrid&' with = carrier_id ).
    txt = replace( val = txt sub = '&connid&' with = connection_id ).
    txt = replace( val = txt sub = '&date&'   with = |{ flight_date DATE = USER }| ).
    txt = replace( val = txt sub = '&from&'   with = connection_details-airport_from_id ).
    txt = replace( val = txt sub = '&to&'     with = connection_details-airport_to_id ).

    APPEND txt TO r_result.
    APPEND |{ 'Planetype:'(002)      } { planetype  } | TO r_result.
  ENDMETHOD.

ENDCLASS.

CLASS lcl_passenger_flight DEFINITION INHERITING FROM lcl_flight.

  PUBLIC SECTION.

    METHODS get_description REDEFINITION.
    METHODS constructor IMPORTING i_carrier_id    TYPE string
                                  i_connection_id TYPE string
                                  i_flight_date   TYPE string.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_passenger_flight IMPLEMENTATION.
  METHOD constructor.
    super->constructor(
     i_carrier_id    = i_carrier_id
     i_connection_id = i_connection_id
     i_flight_date   = i_flight_date
   ).
  ENDMETHOD.
  METHOD get_description.
    r_result = super->get_description( ).
  ENDMETHOD.

ENDCLASS.

CLASS lcl_cargo_flight DEFINITION INHERITING FROM lcl_flight.

  PUBLIC SECTION.

    METHODS get_description REDEFINITION.
    METHODS constructor IMPORTING i_carrier_id    TYPE string
                                  i_connection_id TYPE string
                                  i_flight_date   TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_cargo_flight IMPLEMENTATION.
  METHOD constructor.
    super->constructor(
      i_carrier_id    = i_carrier_id
      i_connection_id = i_connection_id
      i_flight_date   = i_flight_date
    ).
  ENDMETHOD.

  METHOD get_description.
    r_result = super->get_description( ).
  ENDMETHOD.

ENDCLASS.
