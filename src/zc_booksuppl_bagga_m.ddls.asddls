@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption view for Booking supplement'
@Metadata.ignorePropagatedAnnotations: false
@Metadata.allowExtensions: true
define view entity ZC_BOOKSUPPL_BAGGA_M as projection on ZI_BOOKSUPPL_BAGGA_M
{
    key TravelId,
    key BookingId,
    key BookingSupplementId,
    @ObjectModel.text.element: [ 'SupplementDesc' ]
    SupplementId,
    _SupplementText.Description as SupplementDesc :localized,
    Price,
    CurrencyCode,
    LastChangedAt,
    /* Associations */
    _Booking : redirected to parent ZC_BOOKING_BAGGA_M ,
    _Supplement,
    _SupplementText,
    _Travel : redirected to ZC_TRAVEL_BAGGA_M 
}
