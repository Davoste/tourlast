class FlightSearch {
  final List<FlightOffer> offers;

  FlightSearch({required this.offers});

  factory FlightSearch.fromJson(Map<String, dynamic> json) {
    final List<dynamic> fareItineraries =
        json['AirSearchResponse']['AirSearchResult']['FareItineraries'];

    final offers = fareItineraries.map((e) => FlightOffer.fromJson(e)).toList();

    return FlightSearch(offers: offers);
  }
}

class FlightOffer {
  final String fareSourceCode;
  final double totalFare;
  final String cabin;
  final List<FlightSegment> segments;

  FlightOffer({
    required this.fareSourceCode,
    required this.totalFare,
    required this.cabin,
    required this.segments,
  });

  factory FlightOffer.fromJson(Map<String, dynamic> json) {
    final fareInfo = json['FareItinerary']['AirItineraryFareInfo'];
    final segmentsJson =
        json['FareItinerary']['OriginDestinationOptions'][0]['OriginDestinationOption'];

    return FlightOffer(
      fareSourceCode: fareInfo['FareSourceCode'],
      totalFare: double.parse(
        fareInfo['ItinTotalFares']['TotalFare']['Amount'],
      ),
      cabin: segmentsJson[0]['FlightSegment']['CabinClassText'],
      segments:
          (segmentsJson as List)
              .map((e) => FlightSegment.fromJson(e['FlightSegment']))
              .toList(),
    );
  }
}

class FlightSegment {
  final String departureAirport;
  final String arrivalAirport;
  final String departureTime;
  final String arrivalTime;
  final String flightNumber;
  final String airlineCode;
  final int durationMinutes;

  FlightSegment({
    required this.departureAirport,
    required this.arrivalAirport,
    required this.departureTime,
    required this.arrivalTime,
    required this.flightNumber,
    required this.airlineCode,
    required this.durationMinutes,
  });

  factory FlightSegment.fromJson(Map<String, dynamic> json) {
    return FlightSegment(
      departureAirport: json['DepartureAirportLocationCode'],
      arrivalAirport: json['ArrivalAirportLocationCode'],
      departureTime: json['DepartureDateTime'],
      arrivalTime: json['ArrivalDateTime'],
      flightNumber: json['FlightNumber'],
      airlineCode: json['MarketingAirlineCode'],
      durationMinutes: int.parse(json['JourneyDuration']),
    );
  }
}
