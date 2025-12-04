CLASS zcl_data_generator_bagga DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_DATA_GENERATOR_BAGGA IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
  " delete existing entries in the database table

    DELETE FROM ztravel_BAGGA_m.

    DELETE FROM zBOOKING_BAGGA_m.

    DELETE FROM zbooksuppl_BAGGA.

    COMMIT WORK.

    " insert travel demo data

    INSERT ztravel_BAGGA_m FROM (

        SELECT *

          FROM /dmo/travel_m

      ).

    COMMIT WORK.



    " insert booking demo data

    INSERT zbooking_bagga_m FROM (

        SELECT *

          FROM   /dmo/booking_m

*            JOIN ztravel_tech_m AS z

*            ON   booking~travel_id = z~travel_id



      ).

    COMMIT WORK.

    INSERT zbooksuppl_bagga FROM (

        SELECT *

          FROM   /dmo/booksuppl_m

*            JOIN ztravel_tech_m AS z

*            ON   booking~travel_id = z~travel_id



      ).

    COMMIT WORK.



    out->write( 'Travel and booking demo data inserted.').



  ENDMETHOD.
ENDCLASS.
