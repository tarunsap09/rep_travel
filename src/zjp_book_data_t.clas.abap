CLASS zjp_book_data_t DEFINITION
****class to insert the data into zjp_rap_book_t table
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZJP_BOOK_DATA_T IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
  DELETE FROM zjp_rap_book_t.
  insert  zjp_rap_book_t from (
  select from /dmo/booking
  FIELDS
  travel_id,
  booking_id,
  booking_date,
  customer_id,
  carrier_id,
  connection_id,
  flight_date,
  flight_price,
  currency_code
  ORDER BY booking_id UP TO 10 ROWS
  ).

  COMMIT  WORK.
  out->write( 'Booking data inserted' ).
  ENDMETHOD.
ENDCLASS.
