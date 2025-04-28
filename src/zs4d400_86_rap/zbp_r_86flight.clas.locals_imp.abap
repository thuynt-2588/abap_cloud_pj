CLASS LHC_ZR_86FLIGHT DEFINITION INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR Flight
        RESULT result,
      checkSemanticKey FOR VALIDATE ON SAVE
            IMPORTING keys FOR Flight~checkSemanticKey,
      getCities FOR DETERMINE ON SAVE
            IMPORTING keys FOR Flight~getCities.
ENDCLASS.

CLASS LHC_ZR_86FLIGHT IMPLEMENTATION.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
  ENDMETHOD.
  METHOD checkSemanticKey.

    DATA read_keys   TYPE TABLE FOR READ IMPORT ZR_86FLIGHT.
    DATA connections TYPE TABLE FOR READ RESULT ZR_86FLIGHT.

    read_keys = CORRESPONDING #( keys ).

    READ ENTITIES OF ZR_86FLIGHT IN LOCAL MODE
           ENTITY Flight
           FIELDS ( uuid Carrid Connid )
             WITH read_keys
           RESULT connections.

    LOOP AT connections INTO DATA(connection).
      SELECT FROM z86flight
        FIELDS uuid
        WHERE carrid     = @connection-Carrid
          AND connid     = @connection-Connid
          AND uuid       <> @connection-uuid
      UNION
      SELECT FROM z86flight
        FIELDS uuid
        WHERE carrid     = @connection-Carrid
          AND connid     = @connection-Connid
          AND uuid       <> @connection-uuid
      INTO TABLE @DATA(check_result).

      IF check_result IS NOT INITIAL.
      DATA(message) = me->new_message(
                        id       = 'ZS4D400_86'
                        number   = '001'
                        severity = ms-error
                        v1       = connection-Carrid
                        v2       = connection-Connid ).

      DATA reported_record LIKE LINE OF reported-flight.

        reported_record-%tky = connection-%tky.
        reported_record-%msg = message.
        reported_record-%element-Carrid = if_abap_behv=>mk-on.
        reported_record-%element-Connid = if_abap_behv=>mk-on.

        APPEND reported_record TO reported-flight.

        DATA failed_record LIKE LINE OF failed-flight.

        failed_record-%tky = connection-%tky.
        APPEND failed_record TO failed-flight.

        ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD getCities.
    DATA: read_data TYPE TABLE FOR READ RESULT zr_86flight.

  READ ENTITIES OF zr_86flight IN LOCAL MODE
  ENTITY Flight
  FIELDS ( AirportFrom AirportTo )
  WITH CORRESPONDING #( keys )
  RESULT read_data.

  LOOP AT read_data INTO DATA(connection).
  SELECT SINGLE
    FROM /dmo/i_airport
    FIELDS City, CountryCode
    WHERE AirportID = @connection-AirportFrom
    INTO ( @connection-CityFrom, @connection-CountryTo ).

  SELECT SINGLE
    FROM /dmo/i_airport
    FIELDS City, CountryCode
    WHERE AirportID = @connection-AirportTo
    INTO ( @connection-CityTo, @connection-CountryTo ).

  MODIFY read_data FROM connection.
ENDLOOP.

DATA update_data type TABLE FOR update zr_86flight.
update_data = CORRESPONDING #( read_data ).

  ENDMETHOD.

ENDCLASS.
