CLASS lhc_zi_booksuppl_bagga_m DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS valiatePrice FOR VALIDATE ON SAVE
      IMPORTING keys FOR ZI_BOOKSUPPL_BAGGA_M~valiatePrice.

    METHODS validateCurrencyCode FOR VALIDATE ON SAVE
      IMPORTING keys FOR ZI_BOOKSUPPL_BAGGA_M~validateCurrencyCode.

    METHODS validateSupplement FOR VALIDATE ON SAVE
      IMPORTING keys FOR ZI_BOOKSUPPL_BAGGA_M~validateSupplement.

ENDCLASS.

CLASS lhc_zi_booksuppl_bagga_m IMPLEMENTATION.

  METHOD valiatePrice.
  ENDMETHOD.

  METHOD validateCurrencyCode.
  ENDMETHOD.

  METHOD validateSupplement.
  ENDMETHOD.

ENDCLASS.

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
