@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Approver travel consumption view'
////@Metadata.ignorePropagatedAnnotations: true
@Search.searchable: true
@UI.headerInfo: {
    typeName: 'Travel',
    typeNamePlural: 'Travels',
    title: {
        type: #STANDARD,
        label: 'Travel',
        value: 'TravelId'
    }
}
define root view entity ZC_TRAVEL_BAGGA_APPROVER
  provider contract transactional_query
  as projection on ZI_TRAVEL_BAGGA_M

{
      @UI.facet: [{
           id: 'Travel',
           purpose: #STANDARD,
           position:10 ,
           label: 'Travel',
           type:  #IDENTIFICATION_REFERENCE
       },
       {
           id: 'Booking',
           purpose: #STANDARD,
           position:20 ,
           label: 'Booking',
           type: #LINEITEM_REFERENCE,
           targetElement: '_Booking'
       }
       ]
      @Search.defaultSearchElement: true
      @UI: { lineItem: [{ position: 10, importance: #HIGH }],
            identification: [{ position: 10 }] }

  key TravelId,
      @UI: {  lineItem: [{ position: 20, importance: #HIGH }],
              selectionField: [{ position: 20 }],
              identification: [{ position: 20 }] }
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7
      @Consumption.valueHelpDefinition: [{entity: {
          name: '/DMO/I_AGENCY',
          element: 'AgencyID'
      }  }]

      @ObjectModel.text.element: [ 'AgencyName' ]
      AgencyId,
      _Agency.Name        as AgencyName,
      @UI:{ lineItem: [{ position: 40 }],
      selectionField: [{position: 40  }] }
      @Search.fuzzinessThreshold: 0.7
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity: {
          name: '/DMO/I_CUSTOMER',
          element: 'CustomerID'
      } }]
      @UI.identification: [{ position: 30 }]
      @ObjectModel.text.element: [ 'CustomerName' ]
      CustomerId,
      _Customer.FirstName as CustomerName,
      @UI.identification: [{ position: 40 }]
      BeginDate,
      @UI.identification: [{ position: 50 }]
      EndDate,
      @UI.lineItem: [{ position: 80 }]
      @UI.identification: [{ position: 60 }]
      @Semantics.amount.currencyCode: 'CurrencyCode'
      BookingFee,
      @UI.lineItem: [{ position: 90 }]
      @UI.identification: [{ position: 70 }]
      @Semantics.amount.currencyCode: 'CurrencyCode'
      TotalPrice,
      @Consumption.valueHelpDefinition: [{ entity: {
          name: 'I_Currency',
          element: 'Currency'
      } }]
      CurrencyCode,
      @UI.lineItem: [{ position: 110 }]
      @UI.identification: [{ position: 80 }]
      Description,
      @UI.identification: [{ position: 15 } ,
       { type:#FOR_ACTION, dataAction: 'acceptTravel', label: 'Accept Travel'  },
           { type:#FOR_ACTION, dataAction: 'rejectTravel', label: 'Reject Travel'  } ]
      @UI.lineItem: [{ position: 15  },
           { type:#FOR_ACTION, dataAction: 'acceptTravel', label: 'Accept Travel'  },
           { type:#FOR_ACTION, dataAction: 'rejectTravel', label: 'Reject Travel'  }
           ]
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7
      @Consumption.valueHelpDefinition: [{ entity: {
          name: '/DMO/I_Overall_Status_VH',
          element: 'OverallStatus'
      } }]
      @UI.selectionField: [{ position: 120  } ]
      @ObjectModel.text.element: [ 'OverallStatusText' ]
      OverallStatus,
      _Status._Text.Text  as OverallStatusText : localized,
      @UI.hidden: true
      CreatedBy,
      @UI.hidden:true
      CreatedAt,
      @UI.hidden:true
      LastChangedBy,
      LastChangedAt,
      /* Associations */
      _Agency,
      _Booking : redirected to composition child ZC_BOOKING_BAGGA_APPROVER,
      _Currency,
      _Customer,
      _Status

}
