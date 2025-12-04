@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CONNECTION CDS'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

@UI.headerInfo: {
typeName: 'Connection',
typeNamePlural: 'Connections'
}
@Search.searchable: true
define view entity ZI_CONNECTION_BAGGA
  as select from /dmo/connection as Connection
  association [1..*] to ZI_FLIGHT_TECH_R1  as _Flight  on  $projection.CarrierId    = _Flight.CarrierId
                                                       and $projection.ConnectionId = _Flight.ConnectionId
  association [1]    to ZI_CARRIER_TECH_R1 as _Airline on  $projection.CarrierId = _Airline.CarrierId
{
      @UI.facet: [{ purpose: #STANDARD,id: 'Connection' ,type: #IDENTIFICATION_REFERENCE,
                    position: 10 , label: 'Connection Details' } ,
                   { id: 'Flight',purpose: #STANDARD, type: #LINEITEM_REFERENCE,
                    position: 20 , label: 'Flight Details', targetElement: '_Flight' }


                    ]
      @UI.lineItem: [{ position: 10, label: 'Airline Id'  }]
      @UI.identification: [{position: 10}]
      @Search.defaultSearchElement: true
      @ObjectModel.text.association: '_Airline'
  key carrier_id      as CarrierId,
      @UI.lineItem: [{ position: 20  }]
      @UI.identification: [{position: 20}]
      @Search.defaultSearchElement: true
  key connection_id   as ConnectionId,
      @UI.lineItem: [{ position: 30  }]
      @UI.identification: [{position: 30}]
      @Search.defaultSearchElement: true
      @UI.selectionField: [{ position: 10 }]
      airport_from_id as AirportFromId,
      @UI.lineItem: [{ position: 40  }]
      @UI.identification: [{position: 40}]
      @Search.defaultSearchElement: true
      @UI.selectionField: [{ position: 20  }]
      
      @Consumption.valueHelpDefinition: [{ entity: {
          name: 'ZI_AIRPORT_BAGGA_VH',
          element: 'AirportId'
      } }] 
      airport_to_id   as AirportToId,
      @UI.lineItem: [{ position: 50, label: 'Departure Time'  }]
      @UI.identification: [{position: 50}]
      departure_time  as DepartureTime,
      @UI.lineItem: [{ position: 60 , label: 'Arrival Time' }]
      @UI.identification: [{position: 60}]
      arrival_time    as ArrivalTime,
      @UI.identification: [{position: 70}]
      @Semantics.quantity.unitOfMeasure: 'DistanceUnit'
      distance        as Distance,
      distance_unit   as DistanceUnit,
       @Search.defaultSearchElement: true
      _Flight,
      @Search.defaultSearchElement: true
      _Airline
}
