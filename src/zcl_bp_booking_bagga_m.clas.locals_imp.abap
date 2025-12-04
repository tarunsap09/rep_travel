CLASS lhc_zi_booking_bagga_m DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS earlynumbering_cba_Bookingsupp FOR NUMBERING
      IMPORTING entities FOR CREATE ZI_BOOKING_BAGGA_M\_Bookingsuppl.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR ZI_BOOKING_BAGGA_M RESULT result.
    METHODS validateconnection FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_booking_bagga_m~validateconnection.

    METHODS validatecurrencycode FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_booking_bagga_m~validatecurrencycode.

    METHODS validatecustomer FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_booking_bagga_m~validatecustomer.

    METHODS validateflightprice FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_booking_bagga_m~validateflightprice.

    METHODS validatestatus FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_booking_bagga_m~validatestatus.

ENDCLASS.

CLASS lhc_zi_booking_bagga_m IMPLEMENTATION.

  METHOD earlynumbering_cba_Bookingsupp.
  data:max_booking_id type /dmo/booking_supplement_id.

***  read the database values for booking supplement
READ ENTITIES OF zi_travel_bagga_m IN LOCAL MODE
ENTITY zi_booking_bagga_m by \_Bookingsuppl
FROM CORRESPONDING #( entities )
LINK DATA(lt_link).

LOOP AT entities ASSIGNING FIELD-SYMBOL(<lfs_booking>)
                            GROUP BY <lfs_booking>-%tky.
****         get highest booking supplement id from the database entries
   max_booking_id = REDUCE  #( INIT MAX = CONV /dmo/booking_supplement_id( '0' )
                              FOR link IN lt_link USING KEY entity WHERE ( source-%tky = <lfs_booking>-%tky )
                                  NEXT MAX = COND /dmo/booking_supplement_id( WHEN link-target-BookingSupplementID > MAX
                                                                                    THEN link-target-BookingSupplementID
                                                                                    ELSE MAX ) )  .
****     get the highest assignment supplement id from te incoming entries
 max_booking_id  = REDUCE #( INIT MAX = max_booking_id
                             FOR entity in entities USING KEY entity
                             WHERE ( %tky = <lfs_booking>-%tky )
                             for target in entity-%target
                             NEXT MAX = COND #( WHEN target-BookingSupplementID > MAX
                                                THEN target-BookingSupplementID
                                                 ELSE MAX ) ).


****assign new booking supplement id

LOOP AT <lfs_booking>-%target ASSIGNING FIELD-SYMBOL(<lfs_booking_supp>).
APPEND CORRESPONDING #( <lfs_booking_supp> ) to mapped-zi_booksuppl_bagga_m ASSIGNING FIELD-SYMBOL(<lfs_booksuppl>).
if <lfs_booking_supp>-BookingSupplementId is  INITIAL.
max_booking_id = max_booking_id + 1.
<lfs_booksuppl>-BookingSupplementId = max_booking_id.

ENDIF.

ENDLOOP.
    ENDLOOP.


  ENDMETHOD.

  METHOD get_instance_features.

***if booking status is cancelled then there is no meaning to provide booking supplement so we
***are disable the booking supplement
  READ ENTITIES OF zi_travel_bagga_m IN LOCAL MODE
  ENTITY zi_travel_bagga_m BY \_Booking
  FIELDS ( TravelId BookingStatus ) WITH CORRESPONDING #( keys )
  RESULT DATA(lt_booking)
  FAILED failed.

  RESULT = VALUE #( FOR LS_BOOKING IN LT_BOOKING
                 ( %tky = LS_BOOKING-%tky
                   %features-%assoc-_Bookingsuppl = COND #( WHEN LS_BOOKING-BookingStatus = 'X'
                                                             THEN IF_ABAP_BEHV=>FC-O-DISABLED
                                                             ELSE IF_ABAP_BEHV=>FC-O-enabled  ) )

  ).


  ENDMETHOD.

  METHOD validateConnection.
  ENDMETHOD.

  METHOD validateCurrencyCode.
  ENDMETHOD.

  METHOD validateCustomer.
  ENDMETHOD.

  METHOD validateFlightPrice.
  ENDMETHOD.

  METHOD validateStatus.
  ENDMETHOD.

ENDCLASS.

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
