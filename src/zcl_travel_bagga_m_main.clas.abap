CLASS zcl_travel_bagga_m_main DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_TRAVEL_BAGGA_M_MAIN IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

************************************************        1.Read operations

***one way to read by specifying the fields to be read in control structure
**READ ENTITY zi_travel_bagga_m
**from VALUE #( ( %key-TravelId = '0000004254'
**                %control = VALUE #( AgencyId = if_abap_behv=>mk-on
**                                    CustomerId = if_abap_behv=>mk-on
**                                    BeginDate  = if_abap_behv=>mk-on
**                                    EndDate    = if_abap_behv=>mk-on
**                                    BookingFee = if_abap_behv=>mk-on
**                                    CurrencyCode = if_abap_behv=>mk-on
**                                                                     ) ) )
**RESULT DATA(lt_read_result)
**FAILED DATA(lt_failed)
**REPORTED DATA(lt_reported).

****Another way to read the fields without control structure,
**READ ENTITY zi_travel_bagga_m
**FIELDS ( AgencyId CreatedAt CustomerId )
**WITH VALUE #( ( TravelId = '0000004254' ) )
**RESULT DATA(lt_read_result)
**FAILED DATA(lt_failed)
**REPORTED DATA(lt_reported).



***one more way to read all the fields
**READ ENTITY zi_travel_bagga_m
**ALL FIELDS WITH


***read the assocation entity data like booking
***
***READ ENTITY zi_travel_bagga_m
***by \_Booking
***ALL FIELDS WITH
***VALUE #( ( TravelId = '0000004254' ) )
***RESULT DATA(lt_booking)
***FAILED data(lt_failed)
***REPORTED data(lt_reported).

***long syntax for read
***we can read multiple entities in a one statement
**    READ ENTITIES OF zi_travel_bagga_m
**    ENTITY zi_travel_bagga_m
**    ALL FIELDS WITH VALUE #( ( Travelid = '0000004254' ) )
**    RESULT DATA(lt_travel)
**    ENTITY zi_booking_bagga_m
**    ALL FIELDS WITH VALUE #( ( %key-Travelid = '0000004254'
**                               %key-BookingId = '10' ) )
**    RESULT DATA(lt_booking)
**    FAILED DATA(lt_failed)
**    REPORTED DATA(lt_reported).


***to read the data using dynamicaly created table
    DATA:lt_optab          TYPE abp_behv_retrievals_tab,
         lt_travel         TYPE TABLE FOR READ IMPORT zi_travel_bagga_m,
         lt_travel_result  TYPE TABLE FOR READ RESULT zi_travel_bagga_m,
         lt_booking        TYPE TABLE FOR READ IMPORT zi_travel_bagga_m\_Booking,
         lt_booking_result TYPE TABLE FOR READ RESULT zi_travel_bagga_m\_Booking.

**lt_travel = VALUE #( ( %key-TravelId = '0000004254'
**                %control = VALUE #( AgencyId = if_abap_behv=>mk-on
**                                    CustomerId = if_abap_behv=>mk-on
**                                    BeginDate  = if_abap_behv=>mk-on
**                                    EndDate    = if_abap_behv=>mk-on
**                                    BookingFee = if_abap_behv=>mk-on
**                                    CurrencyCode = if_abap_behv=>mk-on
**                                                                     ) ) ).
**  lt_optab =  VALUE #( ( op = if_abap_behv=>op-r-read
**                         entity_name = 'ZI_TRAVEL_BAGGA_M'
**                         instances = REF #( lt_travel )
**                         results = REF #( lt_travel_result ) ) ).
**
**    READ ENTITIES OPERATIONS lt_optab FAILED DATA(lt_failed).



***Now we do read and read by assocation two operations in a single step
***
***    lt_travel = VALUE #( ( %key-TravelId = '00000005'
***                    %control = VALUE #( AgencyId = if_abap_behv=>mk-on
***                                        CustomerId = if_abap_behv=>mk-on
***                                        BeginDate  = if_abap_behv=>mk-on
***                                        EndDate    = if_abap_behv=>mk-on
***                                        BookingFee = if_abap_behv=>mk-on
***                                        CurrencyCode = if_abap_behv=>mk-on
***                                                                         ) ) ).
***    lt_booking  = VALUE #( ( %key-TravelId = '00000005'
****                           %key-BookingId = '10'
***                             %control = VALUE #( BookingDate = if_abap_behv=>mk-on
***                                                 FlightPrice = if_abap_behv=>mk-on
***                                                 CurrencyCode = if_abap_behv=>mk-on   )     ) ) .
***
***    lt_optab =  VALUE #( ( op = if_abap_behv=>op-r-read
***                           entity_name = 'ZI_TRAVEL_BAGGA_M'
***                           instances = REF #( lt_travel )
***                           results = REF #( lt_travel_result ) )
***
***                           ( op = if_abap_behv=>op-r-read_ba
***                           entity_name = 'ZI_TRAVEL_BAGGA_M'
***                           sub_name = '_BOOKING'
***                           instances = REF #( lt_BOOKING )
***                           results = REF #( lt_BOOKING_result ) )
***
***
***                           ).
***
***    READ ENTITIES OPERATIONS lt_optab FAILED DATA(lt_failed).
***
***
***
***
***
***    IF lt_failed IS NOT INITIAL.
***      out->write( 'Error occurred' ).
***    ELSE.
***      out->write( lt_travel_result ).
***      out->write( 'BOOKING' ).
***      out->write( lt_BOOKING_result ).
***    ENDIF.
****    IF lt_failed IS NOT INITIAL.
****      out->write( 'Error occurred' ).
****    ELSE.
****      out->write( lt_booking ).
****
****    ENDIF.




************************************************************************   2.Write operations

****Modify operation

******MODIFY ENTITY zi_travel_bagga_m
******CREATE FROM VALUE #(
******( %cid = 'cid1'
******  %data = VALUE #( AgencyId = '070004'
******                     CustomerId = '00000251'
******                     BeginDate = '20190101'
******                     EndDate = '20190201'
******                     BookingFee = '1024'
******                     CurrencyCode = 'EUR'
******                     TotalPrice = '0'
******                     )
******                  %control = VALUE #(
******                     AgencyId = cl_abap_behv=>flag_changed
******                     CustomerId = cl_abap_behv=>flag_changed
******                     BeginDate = cl_abap_behv=>flag_changed
******                     EndDate = cl_abap_behv=>flag_changed
******                     BookingFee = cl_abap_behv=>flag_changed
******                     CurrencyCode = cl_abap_behv=>flag_changed
******
******                      TotalPrice = cl_abap_behv=>flag_changed
******                      ) ) )
******CREATE BY \_Booking
******FROM VALUE #( ( %cid_ref = 'cid1'
******                %target = VALUE #(  (  %cid = 'cid11'
******                                   %data = VALUE #(
******                                               ConnectionId = '0001'
******                                               FlightDate = '20190201'
******                                               FlightPrice = '100'
******                                               )
******                                    %control = VALUE #(
******                                               ConnectionId = cl_abap_behv=>flag_changed
******                                               FlightDate = cl_abap_behv=>flag_changed
******                                               FlightPrice = cl_abap_behv=>flag_changed
******                                              )  ) ) )
******
******
******                                                )
******MAPPED DATA(ls_mapped)
******FAILED DATA(ls_failed)
******REPORTED DATA(ls_reported).
******
******IF ls_failed IS NOT INITIAL.
******      out->write( 'Error occurred' ).
******    ELSE.
******      out->write( ls_mapped ).
******      commit ENTITIES.
******    ENDIF.

****Delete Operation

**MODIFY ENTITY zi_travel_bagga_m
**DELETE FROM VALUE #( ( TravelId = '0000004254' ) )
**FAILED DATA(lt_failed)
**REPORTED DATA(lt_reported).
**
**IF lt_failed IS NOT INITIAL.
**      out->write( 'Error occurred' ).
**    ELSE.
**      out->write( 'Success' ).
**      commit ENTITIES.
**    ENDIF.


*******CREATE WITH AUTOFILL CID
****AUTO FILL CID WORKS ONLY WITH SINGLE ENTITY ITS NOT WORKING WITH ASSOCATION


****MODIFY ENTITY zi_travel_bagga_m
****CREATE AUTO FILL CID WITH VALUE #( ( %data-BeginDate = '20251011'
****                                     %control-BeginDate = cl_abap_behv=>flag_changed )
****                                     )
****MAPPED DATA(ls_mapped1)
****FAILED DATA(ls_failed1)
****REPORTED DATA(ls_reported1).
****
****IF ls_failed1 IS NOT INITIAL.
****      out->write( 'Error occurred' ).
****    ELSE.
****      out->write( ls_mapped1 ).
****      commit ENTITIES.
****    ENDIF.



**************************************************************2 Update operation
***************************when we use fields then we don't require control structure'

***MODIFY ENTITIES OF zi_travel_bagga_m
***ENTITY zi_travel_bagga_m
***UPDATE FIELDS ( BeginDate )
***WITH VALUE #( ( TravelId = '0000004254'
***                BeginDate = '20251011' ) )
***ENTITY zi_travel_bagga_m
***DELETE FROM VALUE #( ( TravelId = '0000004253' ) )
***FAILED DATA(lt_failed)
***REPORTED DATA(lt_reported).


**************second option for update
MODIFY ENTITY zi_travel_bagga_m
UPDATE SET FIELDS WITH VALUE #( ( %key-TravelId = '0000004253'
                                   BeginDate = '20251110'  ) )

FAILED DATA(lt_failed)
REPORTED DATA(lt_reported).

IF lt_failed IS NOT INITIAL.
      out->write( 'Error occurred' ).
    ELSE.
      out->write( 'Success' ).
      commit ENTITIES.
    ENDIF.



  ENDMETHOD.
ENDCLASS.
