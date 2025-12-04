@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'consumption model booking approver'
////@Metadata.ignorePropagatedAnnotations: true
@UI.headerInfo: {
    typeName: 'Booking',
    typeNamePlural: 'Bookings',
    title: {
        type: #STANDARD,
        label: 'Booking',
        value: 'BookingId'
    }
}
@Search.searchable: true
define view entity ZC_BOOKING_BAGGA_APPROVER 
as projection on ZI_BOOKING_BAGGA_M
{
@UI.facet: [{
       id: 'Booking',
       purpose: #STANDARD,
       position:10 ,
       label: 'Booking',
       type:  #IDENTIFICATION_REFERENCE
   } ]
   
   @Search.defaultSearchElement: true
 @UI:{ lineItem: [{ position: 10 }] ,
        identification: [{ position: 10 }] }
    key TravelId,
     @UI:{ lineItem: [{ position: 20 }] ,
        identification: [{ position: 20 }] }
  @Search.defaultSearchElement: true
    key BookingId,
    @UI:{ lineItem: [{ position: 30 }] ,
        identification: [{ position: 30 }] } 
    BookingDate,
     @UI:{ lineItem: [{ position: 40 }],
        identification: [{ position: 40 }] }
  @Consumption.valueHelpDefinition: [{ entity: {
      name: '/DMO/I_CUSTOMER',
      element: 'CustomerID'
  } }]
  @ObjectModel.text.element: [ 'CustomerName' ]
  @Search.defaultSearchElement: true
    CustomerId,
  _Customer.FirstName as CustomerName,
    @UI:{ lineItem: [{ position: 50 }],
        identification: [{ position: 50 }] }
  @Search.defaultSearchElement: true
  @Consumption.valueHelpDefinition: [{ entity: {
    name: '/DMO/I_Carrier',
    element: 'AirlineID'
} }]
@ObjectModel.text.element: [ 'CarrierName' ]
    CarrierId,
    _Carrier.Name as CarrierName,
    @UI:{ lineItem: [{ position: 60 }],
        identification: [{ position: 60 }] }
   @Consumption.valueHelpDefinition: [{ entity: {
    name: '/DMO/I_Flight',
    element: 'ConnectionID'
},
additionalBinding: [{
      
       localElement: 'ConnectionId',
       element: 'ConnectionID' },
      {
      
       localElement: 'CarrierId',
       element: 'AirlineID' },
       
       {
      
       localElement: 'CurrencyCode',
       element: 'CurrencyCode' },
       {
      
       localElement: 'FlightPrice',
       element: 'Price' }
   
   ] }]
    ConnectionId,
     @UI:{ lineItem: [{ position: 70 }],
        identification: [{ position: 70 }] }
   @Consumption.valueHelpDefinition: [{ entity: {
    name: '/DMO/I_Flight',
    element: 'FlightDate'
},
additionalBinding: [{
      
       localElement: 'FlightDate',
       element: 'FlightDate' },
      {
      
       localElement: 'CarrierId',
       element: 'AirlineID' },
       
       {
      
       localElement: 'CurrencyCode',
       element: 'CurrencyCode' },
       {
      
       localElement: 'FlightPrice',
       element: 'Price' }
   
   ] }]      
    FlightDate,
     @UI:{ lineItem: [{ position: 80 }],
        identification: [{ position: 80 }] }
     @Semantics.amount.currencyCode: 'CurrencyCode'         
    FlightPrice,
     @UI:{ lineItem: [{ position: 90 }],
        identification: [{ position: 90 }] }
  @Consumption.valueHelpDefinition: [{ entity: {
  name: 'I_Currency',
  element: 'Currency'
  } }]
    CurrencyCode,
      @UI:{ lineItem: [{ position: 100 }],
       identification: [{ position: 100 }]}
  @UI.textArrangement: #TEXT_ONLY
  @Consumption.valueHelpDefinition: [{ entity: {
    name: '/DMO/I_Booking_Status_VH',
    element: 'BookingStatus'
} }]
@ObjectModel.text.element: [ 'BookingStatusText' ]
    BookingStatus,
    _Booking_Status._Text.Text as BookingStatusText :localized,
    @UI.hidden: true
    LastChangedAt,
    /* Associations */
    _Bookingsuppl,
    _Booking_Status,
    _Carrier,
    _Connection,
    _Customer,
    _Travel : redirected to parent ZC_TRAVEL_BAGGA_APPROVER
}
