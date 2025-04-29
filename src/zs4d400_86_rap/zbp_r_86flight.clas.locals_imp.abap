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

* Message 001: Flight Number &1 &2 already exists!
    DATA read_keys_001   TYPE TABLE FOR READ IMPORT ZR_86FLIGHT.
    DATA connections_001 TYPE TABLE FOR READ RESULT ZR_86FLIGHT.

    read_keys_001 = CORRESPONDING #( keys ).

    READ ENTITIES OF ZR_86FLIGHT IN LOCAL MODE
           ENTITY Flight
           FIELDS ( uuid Carrid Connid )
             WITH read_keys_001
           RESULT connections_001.

    LOOP AT connections_001 INTO DATA(connection_001).
      SELECT FROM z86flight
        FIELDS uuid
        WHERE carrid     = @connection_001-Carrid
          AND connid     = @connection_001-Connid
          AND uuid       <> @connection_001-uuid
      UNION
      SELECT FROM z86flight
        FIELDS uuid
        WHERE carrid     = @connection_001-Carrid
          AND connid     = @connection_001-Connid
          AND uuid       <> @connection_001-uuid
      INTO TABLE @DATA(check_result).

      IF check_result IS NOT INITIAL.
      DATA(message_001) = me->new_message(
                        id       = 'ZMC_ZS4D400_86_THUYD'
                        number   = '001'
                        severity = ms-error
                        v1       = connection_001-Carrid
                        v2       = connection_001-Connid ).

      DATA reported_record_001 LIKE LINE OF reported-flight.

        reported_record_001-%tky = connection_001-%tky.
        reported_record_001-%msg = message_001.
        reported_record_001-%element-Carrid = if_abap_behv=>mk-on.
        reported_record_001-%element-Connid = if_abap_behv=>mk-on.

        APPEND reported_record_001 TO reported-flight.

        DATA failed_record_001 LIKE LINE OF failed-flight.

        failed_record_001-%tky = connection_001-%tky.
        APPEND failed_record_001 TO failed-flight.

        ENDIF.

    ENDLOOP.

* Message 002: Airline &1 does not exist!
    DATA read_keys_002   TYPE TABLE FOR READ IMPORT ZR_86FLIGHT.
    DATA connections_002 TYPE TABLE FOR READ RESULT ZR_86FLIGHT.

    read_keys_002 = CORRESPONDING #( keys ).

    READ ENTITIES OF ZR_86FLIGHT IN LOCAL MODE
           ENTITY Flight
           FIELDS ( Carrid )
             WITH read_keys_002
           RESULT connections_002.

    LOOP AT Connections_002 INTO DATA(connection_002).
      SELECT SINGLE
        FROM /dmo/i_carrier
        FIELDS @abap_true
        WHERE AirlineID = @connection_002-Carrid
        INTO @DATA(exists).

      IF exists <> abap_true.
        DATA(message_002) = me->new_message(
                        id       = 'ZMC_ZS4D400_86_THUYD'
                        number   = '002'
                        severity = ms-error
                        v1       = connection_002-Carrid ).

        DATA reported_record_002 LIKE LINE OF reported-flight.

        reported_record_002-%tky = connection_002-%tky.
        reported_record_002-%msg = message_002.
        reported_record_002-%element-Carrid = if_abap_behv=>mk-on.
        reported_record_002-%element-Connid = if_abap_behv=>mk-on.

        APPEND reported_record_002 TO reported-flight.

        DATA failed_record_002 LIKE LINE OF failed-flight.

        failed_record_002-%tky = connection_002-%tky.
        APPEND failed_record_002 TO failed-flight.
      ENDIF.
    ENDLOOP.

* Message 003: Departure and destination airports  must not be the same.
    DATA read_keys_003   TYPE TABLE FOR READ IMPORT ZR_86FLIGHT.
    DATA connections_003 TYPE TABLE FOR READ RESULT ZR_86FLIGHT.

    read_keys_003 = CORRESPONDING #( keys ).

  READ ENTITIES OF ZR_86FLIGHT IN LOCAL MODE
           ENTITY Flight
           FIELDS ( AirportFrom AirportTo )
             WITH read_keys_003
           RESULT connections_003.

  LOOP AT connections_003 INTO DATA(connection_003).
  IF connection_003-airportfrom = connection_003-airportto.
    DATA(message_003) = me->new_message(
                      id       = 'ZMC_ZS4D400_86_THUYD'
                      number   = '003'
                      severity = ms-error ).

    DATA reported_record_003 LIKE LINE OF reported-flight.

        reported_record_003-%tky = connection_003-%tky.
        reported_record_003-%msg = message_003.

        APPEND reported_record_003 TO reported-flight.

        DATA failed_record_003 LIKE LINE OF failed-flight.

        failed_record_003-%tky = connection_003-%tky.
        APPEND failed_record_003 TO failed-flight.
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
