*"* use this source file for your ABAP unit test classes
class ltcl_test definition final for testing
  duration short
  risk level harmless.

  private section.
    methods:
      test_get_name for testing raising cx_static_check.

      METHODS setup.
      METHODS test_get_currency for testing.

      DATA carrier TYPE REF TO lcl_carrier.
endclass.


class ltcl_test implementation.

  method test_get_name.

  DATA(name) = me->carrier->get_name(  ) .

  cl_abap_unit_assert=>assert_not_initial(
  act = name
  msg = `Result of method get_name(  )`
  quit = if_abap_unit_constant=>quit-no
  ).

  endmethod.

  method setup.
  " read arbitrary carrier_id from db table
      SELECT SINGLE
      FROM /dmo/carrier
      FIELDS carrier_id
      INTO @DATA(carrier_id).

      if sy-subrc <> 0.

          cl_abap_unit_assert=>skip(
          msg = `No data in /dmo/carrier`
          detail = `Test requires at least one entry in db table /dmo/carrier`
           ).

      endif.

      TRY.
        me->carrier = NEW lcl_carrier( carrier_id ).
      CATCH cx_abap_invalid_value.

      cl_abap_unit_assert=>fail(
        msg = `Cannot create instance of lcl_carrier`
        detail = `Constructor of lcl_carrier raises an exception when it should not`
       ).

       ENDTRY.

       cl_abap_unit_assert=>assert_bound(
       EXPORTING
       act = me->carrier
       msg = `Cannot create instance of lcl_carrier`
        ).

  endmethod.

  method test_get_currency.
    cl_abap_unit_assert=>assert_not_initial(
    act = me->carrier->get_currency( )
    msg = `Result of method get_currency( )`
    quit = if_abap_unit_constant=>quit-no
     ).
  endmethod.

endclass.
