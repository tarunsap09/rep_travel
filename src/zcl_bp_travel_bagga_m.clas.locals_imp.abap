CLASS lhc_ZI_TRAVEL_BAGGA_M DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_travel_bagga_m RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR zi_travel_bagga_m RESULT result.
    METHODS accepttravel FOR MODIFY
      IMPORTING keys FOR ACTION zi_travel_bagga_m~accepttravel RESULT result.

    METHODS copytravel FOR MODIFY
      IMPORTING keys FOR ACTION zi_travel_bagga_m~copytravel.

    METHODS recalctotprice FOR MODIFY
      IMPORTING keys FOR ACTION zi_travel_bagga_m~recalctotprice.

    METHODS rejecttravel FOR MODIFY
      IMPORTING keys FOR ACTION zi_travel_bagga_m~rejecttravel RESULT result.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_travel_bagga_m RESULT result.
    METHODS validatecustomer FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_travel_bagga_m~validatecustomer.
    METHODS validatebookingfee FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_travel_bagga_m~validatebookingfee.

    METHODS validatecurrencycode FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_travel_bagga_m~validatecurrencycode.

    METHODS validatedates FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_travel_bagga_m~validatedates.

    METHODS validatestatus FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_travel_bagga_m~validatestatus.
    METHODS earlynumbering_cba_booking FOR NUMBERING
      IMPORTING entities FOR CREATE zi_travel_bagga_m\_booking.
    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE zi_travel_bagga_m.

ENDCLASS.

CLASS lhc_ZI_TRAVEL_BAGGA_M IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD earlynumbering_create.
****This method is used for creating the travel number
    DATA:lt_travel TYPE TABLE  FOR MAPPED EARLY zi_travel_bagga_m,
         ls_travel LIKE LINE OF lt_travel.

    CLEAR:ls_travel,lt_travel[].

    DATA(lt_entities) = entities[].


    DELETE lt_entities WHERE TravelId IS NOT INITIAL.


***  use the number range object for getting the next number
    TRY.
        cl_numberrange_runtime=>number_get(
          EXPORTING
            nr_range_nr       = '01'
            object            = '/DMO/TRV_M'
            quantity          = CONV #( lines( lt_entities ) )

          IMPORTING
            number            = DATA(lv_number)
            returncode        =  DATA(lv_code)
            returned_quantity = DATA(lv_qty)
        ).
      CATCH cx_nr_object_not_found.
      CATCH cx_number_ranges INTO DATA(io_error).
***      pass the failed messages to framework

        LOOP AT lt_entities ASSIGNING FIELD-SYMBOL(<fs_entity1>).

***      failed is used to give the reference of key field
          APPEND VALUE #( %cid = <fs_entity1>-%cid
                          %key = <fs_entity1>-%key )
                  TO failed-zi_travel_bagga_m.

*** reported  is used for reporting the message to front end
          APPEND VALUE #( %cid = <fs_entity1>-%cid
                        %key   = <fs_entity1>-%key
                        %msg   = io_error )
                TO reported-zi_travel_bagga_m.
        ENDLOOP.
        EXIT.
    ENDTRY.


**get the current number
    DATA(lv_curr_number) = lv_number - lv_qty.
    LOOP AT lt_entities ASSIGNING FIELD-SYMBOL(<fs_entity>).
      lv_curr_number = lv_curr_number + 1.

      ls_travel = VALUE #( %cid = <fs_entity>-%cid
                            TravelID = lv_curr_number ).

      APPEND ls_travel TO mapped-zi_travel_bagga_m.

    ENDLOOP.

*    MODIFY AUGMENTING ENTITIES OF /dmo/i_travel_m
*      ENTITY travel
*        CREATE FROM CORRESPONDING #( lt_travel  ).
*      ls_travel-%cid = <fs_entity>-%cid.
*      ls_travel-TravelID = lv_curr_number.
*      INSERT ls_travel INTO TABLE mapped-zi_travel_bagga_m.
*      lv_curr_number += 1.

*    ENDLOOP.


  ENDMETHOD.

  METHOD earlynumbering_cba_Booking.
***  %cid_ref and travel id belongs to parent which is travel entity
****  and %target contains the fields for the booking
**this method is used for bokking . this is used to generate the booking number
    DATA:lv_max_number TYPE /dmo/booking_id.

***now we have to read the data of booking related to travel id and then find max booking id
***LINK IS USED WHEN WE NEED SOURCE AND TARGET FIELD WHICH IS ASSOCIATED BY ASSOCATION
****LIKE HERE TRAVEL ID AND BOOKING ID AND WE DON'T REQUIRE OTHER FIELDS'
****read the data from the database
    READ ENTITIES OF zi_travel_bagga_m IN LOCAL MODE
    ENTITY zi_travel_bagga_m BY \_Booking
    ALL FIELDS WITH CORRESPONDING #( entities )
    LINK DATA(lt_link_data).

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_group_entities>)
                                             GROUP BY <ls_group_entities>-TravelID.
***get the max number from database table corresponding to travel id for booking

      lv_max_number =  REDUCE #( INIT lv_max = CONV /dmo/booking_id( '0' )
                                               FOR ls_link IN lt_link_data USING KEY entity
                                               WHERE ( source-TravelID = <ls_group_entities>-TravelID )
                                               NEXT lv_max = COND /dmo/booking_id( WHEN lv_max > ls_link-target-BookingID THEN lv_max ELSE ls_link-target-BookingID ) ).

****      get the max number based on current entity for booking
      lv_max_number = REDUCE #( INIT lv_max = lv_max_number
                                              FOR ls_entity IN entities USING KEY entity
                                              WHERE ( TravelID = <ls_group_entities>-TravelID )
                                              FOR ls_booking IN ls_entity-%target
                                              NEXT lv_max = COND /dmo/booking_id( WHEN lv_max < ls_booking-BookingId THEN ls_booking-BookingId
                                                                                  ELSE lv_max ) ) .

      LOOP AT   <ls_group_entities>-%target ASSIGNING FIELD-SYMBOL(<lfs_booking>) .
        APPEND CORRESPONDING #( <lfs_booking> ) TO mapped-zi_booking_bagga_m ASSIGNING FIELD-SYMBOL(<lfs_mapped>).
        IF <lfs_booking>-BookingID IS INITIAL.
          lv_max_number = lv_max_number + 10.

          <lfs_mapped>-BookingID = lv_max_number.
        ENDIF.

      ENDLOOP.

    ENDLOOP.


  ENDMETHOD.

  METHOD acceptTravel.
  MODIFY ENTITIES OF zi_travel_bagga_m IN LOCAL MODE
  ENTITY zi_travel_bagga_m
  UPDATE FIELDS ( OverallStatus )
  WITH VALUE #( FOR key IN keys ( %tky = key-%tky overallstatus = 'A' ) )
  REPORTED DATA(LT_REPORT_ACCEPT)
  FAILED DATA(LT_FAIL_ACCEPT).

  READ ENTITIES OF zi_travel_bagga_m IN LOCAL MODE
  ENTITY zi_travel_bagga_m
  ALL FIELDS WITH CORRESPONDING #( keys )
  RESULT DATA(lt_travel_r).

  RESULT = VALUE #( FOR ls_travel IN lt_travel_r ( %tky = ls_travel-%tky %param = ls_travel ) ).

  ENDMETHOD.

  METHOD copyTravel.
***  cid should be filled for factory action
****this action should be used for the  copy the instance
    DATA: lt_travel       TYPE TABLE FOR CREATE zi_travel_bagga_m,
          lt_booking_cba  TYPE TABLE FOR CREATE zi_travel_bagga_m\_Booking,
          lt_bookingsuppl TYPE TABLE FOR CREATE zi_booking_bagga_m\_Bookingsuppl.
****we have to create the new record based on existing record
    READ TABLE keys ASSIGNING FIELD-SYMBOL(<ls_without_cid>) WITH KEY %cid = ''.
    ASSERT <ls_without_cid> IS NOT ASSIGNED.
****  read the travel entity
    READ ENTITIES OF zi_travel_bagga_m IN LOCAL MODE
    ENTITY zi_travel_bagga_m
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_travel_r)
    FAILED DATA(lt_failed).
***read the booking entity
    READ ENTITIES OF zi_travel_bagga_m IN LOCAL MODE
    ENTITY zi_travel_bagga_m BY \_Booking
    ALL FIELDS WITH CORRESPONDING #( lt_travel_r )
    RESULT DATA(lt_booking_r).
***read the booking supplement entity
    READ ENTITIES OF zi_travel_bagga_m IN LOCAL MODE
    ENTITY zi_booking_bagga_m BY \_Bookingsuppl
    ALL FIELDS WITH CORRESPONDING #( lt_booking_r )
    RESULT DATA(lt_bookingsuppl_r).


    LOOP AT lt_travel_r ASSIGNING FIELD-SYMBOL(<ls_travel_r>).
**  APPEND INITIAL LINE TO lt_travel ASSIGNING FIELD-SYMBOL(<ls_travel>).
**  <ls_travel>-%cid = keys[ KEY entity TravelId = <ls_travel_r>-TravelID ]-%cid.
**   <ls_travel>-%data = CORRESPONDING #( <ls_travel_r> EXCEPT TravelId ) .

      APPEND VALUE #(  %cid = keys[ KEY entity TravelId = <ls_travel_r>-TravelID ]-%cid
                        %data = CORRESPONDING #( <ls_travel_r> EXCEPT TravelId )
                         )
                        TO lt_travel ASSIGNING FIELD-SYMBOL(<ls_travel>).
      <ls_travel>-BeginDate = cl_abap_context_info=>get_system_date( ).
      <ls_travel>-EndDate = cl_abap_context_info=>get_system_date( ) + 30.
      <ls_travel>-overallStatus = 'O'.

      APPEND VALUE #( %cid_ref = <ls_travel>-%cid ) TO lt_booking_cba ASSIGNING FIELD-SYMBOL(<ls_booking_cba>).
      LOOP AT lt_booking_r ASSIGNING FIELD-SYMBOL(<ls_booking_r>) USING KEY entity WHERE TravelID = <ls_travel_r>-TravelID.
        APPEND VALUE #( %cid = <ls_travel>-%cid && <ls_booking_r>-BookingId
                        %data = CORRESPONDING #( <ls_booking_r> EXCEPT TravelId   ) )
                        TO <ls_booking_cba>-%target ASSIGNING FIELD-SYMBOL(<ls_booking_n>).
        <ls_booking_n>-BookingStatus = 'N'.

        APPEND VALUE #( %cid_ref = <ls_booking_n>-%cid ) TO lt_bookingsuppl ASSIGNING FIELD-SYMBOL(<ls_bookingsuppl>).
        LOOP AT lt_bookingsuppl_r  ASSIGNING FIELD-SYMBOL(<ls_booksuppl_r>)
                                    USING KEY entity
                                     WHERE TravelId = <ls_travel_r>-TravelId
                                     AND   BookingId = <ls_booking_r>-BookingId .

          APPEND  VALUE #( %cid = <ls_travel>-%cid && <ls_booking_r>-BookingId && <ls_booksuppl_r>-BookingSupplementId
                           %data = CORRESPONDING #( <ls_booksuppl_r> EXCEPT TravelId  BookingId ) )
                           TO <ls_bookingsuppl>-%target ASSIGNING FIELD-SYMBOL(<ls_bookingsuppl_n>).
        ENDLOOP.
      ENDLOOP.
    ENDLOOP.

*******  Now we have to modify all the three tables into database
    MODIFY ENTITIES OF zi_travel_bagga_m IN LOCAL MODE
    ENTITY zi_travel_bagga_m
    CREATE FIELDS ( AgencyId CustomerId BeginDate EndDate BookingFee TotalPrice CurrencyCode Description OverallStatus ) with lt_travel
    CREATE BY \_Booking
    FIELDS ( BookingId BookingDate CustomerId CarrierId ConnectionId FlightDate FlightPrice CurrencyCode BookingStatus )
    with lt_booking_cba
    ENTITY zi_booking_bagga_m
    CREATE BY \_Bookingsuppl
    FIELDS ( BookingSupplementId SupplementId Price CurrencyCode  ) with lt_bookingsuppl
    MAPPED DATA(lt_mapped)
    FAILED DATA(lt_failed_mod)
    REPORTED DATA(lt_reported_mod).

    mapped-zi_travel_bagga_m = lt_mapped-zi_travel_bagga_m.
**    mapped-zi_booking_bagga_m = lt_mapped-zi_booking_bagga_m.
**    mapped-zi_booksuppl_bagga_m = lt_mapped-zi_booksuppl_bagga_m.

  ENDMETHOD.

  METHOD recalcTotPrice.
  ENDMETHOD.

  METHOD rejectTravel.
***  this action button is used to change the overallstatus to rejected of a instance
    MODIFY ENTITIES OF zi_travel_bagga_m IN LOCAL MODE
  ENTITY zi_travel_bagga_m
  UPDATE FIELDS ( OverallStatus )
  WITH VALUE #( FOR key IN keys ( %tky = key-%tky overallstatus = 'X' ) )
  REPORTED DATA(LT_REPORT_ACCEPT)
  FAILED DATA(LT_FAIL_ACCEPT).

  READ ENTITIES OF zi_travel_bagga_m IN LOCAL MODE
  ENTITY zi_travel_bagga_m
  ALL FIELDS WITH CORRESPONDING #( keys )
  RESULT DATA(lt_travel_r).

  RESULT = VALUE #( FOR ls_travel IN lt_travel_r ( %tky = ls_travel-%tky %param = ls_travel ) ).
  ENDMETHOD.

  METHOD get_instance_features.
****  this feature control is used to hide the button in UI like accept travel and reject travel and also booking assocation

READ ENTITIES OF zi_travel_bagga_m IN LOCAL MODE
ENTITY zi_travel_bagga_m
FIELDS ( TravelID OverallStatus )
WITH CORRESPONDING #( keys )
RESULT DATA(lt_travel_r)
FAILED failed.

  result = VALUE #( FOR ls_travel IN lt_travel_r
                      ( %tky                   = ls_travel-%tky
                        %action-acceptTravel   = COND #( WHEN ls_travel-OverallStatus <> 'A' " if travel status is not accept then enable the button accept
                                                          THEN if_abap_behv=>fc-o-enabled
                                                          ELSE if_abap_behv=>fc-o-disabled )
                        %action-rejectTravel   = COND #( WHEN ls_travel-OverallStatus <> 'X'  "if travel status is accept then enable the button reject
                                                          THEN if_abap_behv=>fc-o-enabled
                                                          ELSE if_abap_behv=>fc-o-disabled )
                        %assoc-_Booking        = COND #( WHEN ls_travel-OverallStatus = 'X'   "if travel status is rejected then disable the association booking
                                                          THEN if_abap_behv=>fc-o-disabled
                                                          ELSE if_abap_behv=>fc-o-enabled )
                       ) ).

  ENDMETHOD.

  METHOD validateCustomer.

***  we are validating the customer id . we are checking wheather customer id is available in the system
  READ ENTITIES OF zi_travel_bagga_m in LOCAL MODE
  ENTITY zi_travel_bagga_m
  FIELDS ( CustomerID )
  WITH CORRESPONDING #( keys )
  RESULT DATA(lt_travel).

  data: lt_customer type SORTED TABLE OF /dmo/customer WITH UNIQUE KEY customer_id.

  lt_customer = CORRESPONDING #(  lt_travel DISCARDING DUPLICATES MAPPING customer_id = CustomerID EXCEPT * ).

  DELETE lt_customer WHERE customer_id IS INITIAL.

  IF lt_customer IS NOT INITIAL.
    SELECT FROM /dmo/customer FIELDS customer_id
      FOR ALL ENTRIES IN @lt_customer
      WHERE customer_id = @lt_customer-customer_id
      INTO TABLE @DATA(lt_customer_db).
  ENDIF.

  LOOP AT lt_travel INTO DATA(ls_travel).
    IF ls_travel-CustomerID IS NOT INITIAL AND
       NOT line_exists( lt_customer_db[ customer_id = ls_travel-CustomerID ] ).
      APPEND VALUE #( %key = ls_travel-%key ) TO failed-zi_travel_bagga_m.
      APPEND VALUE #( %key = ls_travel-%key
                     %element-CustomerID = if_abap_behv=>mk-on
                      %msg = new_message_with_text(
                               severity = if_abap_behv_message=>severity-error
                               text     =  |Customer id { ls_travel-CustomerID } does not exist|
                             )
                            ) TO reported-zi_travel_bagga_m.
    ENDIF.
  ENDLOOP.

*    READ ENTITIES OF zi_travel_bagga_m IN LOCAL MODE
*    ENTITY zi_travel_bagga_m
*    FIELDS ( CustomerID )
*    WITH CORRESPONDING #( keys )
*    failed failed.
*    SELECT SINGLE FROM /dmo/customer
*    LOOP AT lt_travel INTO DATA(ls_travel).
*      SELECT SINGLE FROM /dmo/customer
*      APPEND VALUE #( %key = ls_travel-%key ) TO failed-zi_travel_bagga_m.
*      APPEND VALUE #( %key = ls_travel-%key
*                      %element-CustomerID = if_abap_behv=>mk-on
*                       %msg = new_message_with_text(
*                             severity = if_abap_behv_message=>severity-error
*                             text     =  |Customer id { ls_travel-CustomerID } does not exist|
*                           ) )  + ls_travel-CustomerID + is invalid' |  )   TO reported-zi_travel_bagga_m.
*    ENDIF.
*  ENDLOOP.



  ENDMETHOD.

  METHOD validateBookingFee.
  ENDMETHOD.

  METHOD validateCurrencyCode.
  ENDMETHOD.

  METHOD validateDates.

****  read the entities from the database
  READ ENTITIES OF zi_travel_bagga_m in LOCAL MODE
  ENTITY zi_travel_bagga_m
  FIELDS ( BeginDate EndDate )
  with CORRESPONDING #( keys )
   RESULT DATA(lt_travels).
*****check if the begin date greater then end date then give error message

   LOOP AT LT_TRAVELS INTO DATA(LS_TRAVEL).
     IF LS_TRAVEL-ENDDATE <= LS_TRAVEL-BEGINDATE.
      APPEND VALUE #( %tky = LS_TRAVEL-%tky ) TO failed-zi_travel_bagga_m.
      APPEND VALUE #( %tky = LS_TRAVEL-%tky
                      %element-begindate = if_abap_behv=>mk-on
                      %element-enddate  = if_abap_behv=>mk-on
                      %msg = NEW /dmo/cm_flight_messages( textid = /dmo/cm_flight_messages=>begin_date_bef_end_date
                                                          severity = if_abap_behv_message=>severity-error
                                                          begin_date = LS_TRAVEL-BEGINDATE
                                                          end_date   = LS_TRAVEL-ENDDATE )
                    ) TO reported-zi_travel_bagga_m.
       ELSEIF ls_travel-BeginDate < cl_abap_context_info=>get_system_date( ).
      APPEND VALUE #( %tky = LS_TRAVEL-%tky ) TO failed-zi_travel_bagga_m.
      APPEND VALUE #( %tky = LS_TRAVEL-%tky
                      %element-begindate = if_abap_behv=>mk-on
                      %element-enddate  = if_abap_behv=>mk-on
                      %msg = NEW /dmo/cm_flight_messages( textid = /dmo/cm_flight_messages=>begin_date_on_or_bef_sysdate
                                                          severity = if_abap_behv_message=>severity-error )
                    ) TO reported-zi_travel_bagga_m.

     ENDIF.
   ENDLOOP.


  ENDMETHOD.

  METHOD validateStatus.
  READ ENTITIES OF zi_travel_bagga_m IN LOCAL MODE
  ENTITY zi_travel_bagga_m
  FIELDS ( OverallStatus )
  WITH CORRESPONDING #( KEYS )
  RESULT DATA(LT_TRAVELS).

  LOOP AT lt_travels INTO data(ls_travels).

  CASE ls_travels-OverallStatus.
  WHEN  'O'. " OPEN
  WHEN  'A'. " ACCEPTED
  WHEN  'X'.  " Cancelled

  WHEN OTHERS.
  APPEND VALUE #( %tky = ls_travels-%tky ) TO failed-zi_travel_bagga_m.
      APPEND VALUE #( %tky = ls_travels-%tky
                      %element-OverallStatus = if_abap_behv=>mk-on
                      %msg = NEW /dmo/cm_flight_messages( textid = /dmo/cm_flight_messages=>status_invalid
                                                          severity = if_abap_behv_message=>severity-error
                                                          status = ls_travels-OverallStatus  )
                    ) TO reported-zi_travel_bagga_m.
  ENDCASE.

  ENDLOOP.

  ENDMETHOD.

ENDCLASS.
