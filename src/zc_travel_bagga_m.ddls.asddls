@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption view for travel'
@Metadata.ignorePropagatedAnnotations: false
@Metadata.allowExtensions: true
define root view entity ZC_TRAVEL_BAGGA_M 
provider contract transactional_query
as projection on ZI_TRAVEL_BAGGA_M

{
    key TravelId,
   @ObjectModel.text.element: [ 'AgencyName' ]           
    AgencyId,
    _Agency.Name as AgencyName,
     @ObjectModel.text.element: [ 'CustomerName' ] 
    CustomerId,
    _Customer.LastName as CustomerName,
    BeginDate,
    EndDate,
    BookingFee,
    TotalPrice,
    CurrencyCode,
    Description,
    @ObjectModel.text.element: [ 'OveallStatusText' ]
    OverallStatus,
    _Status._Text.Text as OveallStatusText: localized,
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt,
    /* Associations */
    _Agency,
    _Booking: redirected to composition child ZC_BOOKING_BAGGA_M ,
    _Currency,
    _Customer,
    _Status
}
