class Flights {
  AirSearchResponse airSearchResponse;

  Flights({required this.airSearchResponse});
}

class AirSearchResponse {
  String sessionId;
  AirSearchResult airSearchResult;

  AirSearchResponse({required this.sessionId, required this.airSearchResult});
}

class AirSearchResult {
  List<FareItineraryElement> fareItineraries;

  AirSearchResult({required this.fareItineraries});
}

class FareItineraryElement {
  FareItineraryFareItinerary fareItinerary;

  FareItineraryElement({required this.fareItinerary});
}

class FareItineraryFareItinerary {
  String directionInd;
  AirItineraryFareInfo airItineraryFareInfo;
  List<FareItineraryOriginDestinationOption> originDestinationOptions;
  dynamic isPassportMandatory;
  String sequenceNumber;
  String ticketType;
  String validatingAirlineCode;

  FareItineraryFareItinerary({
    required this.directionInd,
    required this.airItineraryFareInfo,
    required this.originDestinationOptions,
    required this.isPassportMandatory,
    required this.sequenceNumber,
    required this.ticketType,
    required this.validatingAirlineCode,
  });
}

class AirItineraryFareInfo {
  String divideInPartyIndicator;
  String fareSourceCode;
  List<dynamic> fareInfos;
  String fareType;
  String resultIndex;
  String isRefundable;
  ItinTotalFares itinTotalFares;
  List<FareBreakdown> fareBreakdown;
  bool splitItinerary;

  AirItineraryFareInfo({
    required this.divideInPartyIndicator,
    required this.fareSourceCode,
    required this.fareInfos,
    required this.fareType,
    required this.resultIndex,
    required this.isRefundable,
    required this.itinTotalFares,
    required this.fareBreakdown,
    required this.splitItinerary,
  });
}

class FareBreakdown {
  String fareBasisCode;
  List<Baggage> baggage;
  List<Baggage> cabinBaggage;
  PassengerFare passengerFare;
  PassengerTypeQuantity passengerTypeQuantity;
  PenaltyDetails penaltyDetails;

  FareBreakdown({
    required this.fareBasisCode,
    required this.baggage,
    required this.cabinBaggage,
    required this.passengerFare,
    required this.passengerTypeQuantity,
    required this.penaltyDetails,
  });
}

enum Baggage { SB }

class PassengerFare {
  BaseFare baseFare;
  BaseFare equivFare;
  BaseFare serviceTax;
  BaseFare surcharges;
  List<BaseFare> taxes;
  BaseFare totalFare;

  PassengerFare({
    required this.baseFare,
    required this.equivFare,
    required this.serviceTax,
    required this.surcharges,
    required this.taxes,
    required this.totalFare,
  });
}

class BaseFare {
  String amount;
  Currency currencyCode;
  String decimalPlaces;
  TaxCode? taxCode;

  BaseFare({
    required this.amount,
    required this.currencyCode,
    required this.decimalPlaces,
    this.taxCode,
  });
}

enum Currency { USD }

enum TaxCode { FLEX_FEE, TAX, TAX2 }

class PassengerTypeQuantity {
  Code code;
  int quantity;

  PassengerTypeQuantity({required this.code, required this.quantity});
}

enum Code { ADT, CHD, INF }

class PenaltyDetails {
  Currency currency;
  bool refundAllowed;
  String refundPenaltyAmount;
  bool changeAllowed;
  String changePenaltyAmount;

  PenaltyDetails({
    required this.currency,
    required this.refundAllowed,
    required this.refundPenaltyAmount,
    required this.changeAllowed,
    required this.changePenaltyAmount,
  });
}

class ItinTotalFares {
  BaseFare baseFare;
  BaseFare equivFare;
  BaseFare serviceTax;
  BaseFare totalTax;
  BaseFare totalFare;

  ItinTotalFares({
    required this.baseFare,
    required this.equivFare,
    required this.serviceTax,
    required this.totalTax,
    required this.totalFare,
  });
}

class FareItineraryOriginDestinationOption {
  List<OriginDestinationOptionOriginDestinationOption> originDestinationOption;
  int totalStops;

  FareItineraryOriginDestinationOption({
    required this.originDestinationOption,
    required this.totalStops,
  });
}

class OriginDestinationOptionOriginDestinationOption {
  FlightSegment flightSegment;
  String resBookDesigCode;
  String resBookDesigText;
  SeatsRemaining seatsRemaining;
  int stopQuantity;
  StopQuantityInfo stopQuantityInfo;

  OriginDestinationOptionOriginDestinationOption({
    required this.flightSegment,
    required this.resBookDesigCode,
    required this.resBookDesigText,
    required this.seatsRemaining,
    required this.stopQuantity,
    required this.stopQuantityInfo,
  });
}

class FlightSegment {
  String arrivalAirportLocationCode;
  DateTime arrivalDateTime;
  String cabinClassCode;
  String cabinClassText;
  String departureAirportLocationCode;
  DateTime departureDateTime;
  bool eticket;
  String journeyDuration;
  String flightNumber;
  String marketingAirlineCode;
  String marketingAirlineName;
  String marriageGroup;
  String mealCode;
  OperatingAirline operatingAirline;

  FlightSegment({
    required this.arrivalAirportLocationCode,
    required this.arrivalDateTime,
    required this.cabinClassCode,
    required this.cabinClassText,
    required this.departureAirportLocationCode,
    required this.departureDateTime,
    required this.eticket,
    required this.journeyDuration,
    required this.flightNumber,
    required this.marketingAirlineCode,
    required this.marketingAirlineName,
    required this.marriageGroup,
    required this.mealCode,
    required this.operatingAirline,
  });
}

class OperatingAirline {
  String code;
  String name;
  String equipment;
  String flightNumber;

  OperatingAirline({
    required this.code,
    required this.name,
    required this.equipment,
    required this.flightNumber,
  });
}

class SeatsRemaining {
  bool belowMinimum;
  int number;

  SeatsRemaining({required this.belowMinimum, required this.number});
}

class StopQuantityInfo {
  String arrivalDateTime;
  String departureDateTime;
  String duration;
  String locationCode;

  StopQuantityInfo({
    required this.arrivalDateTime,
    required this.departureDateTime,
    required this.duration,
    required this.locationCode,
  });
}
