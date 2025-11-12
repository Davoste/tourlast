class Passenger {
  final String title;
  final String firstName;
  final String lastName;
  final String type;
  final String eTicket;

  Passenger({
    required this.title,
    required this.firstName,
    required this.lastName,
    required this.type,
    required this.eTicket,
  });

  factory Passenger.fromJson(Map<String, dynamic> json) {
    return Passenger(
      title: json['PassengerTitle'],
      firstName: json['PassengerFirstName'],
      lastName: json['PassengerLastName'],
      type: json['PassengerType'],
      eTicket: json['eTicketNumber'],
    );
  }

  String get fullName => '$title $firstName $lastName';
}

class BaggageOption {
  final String id;
  final String description;
  final double price;

  BaggageOption({
    required this.id,
    required this.description,
    required this.price,
  });

  factory BaggageOption.fromJson(Map<String, dynamic> json) {
    return BaggageOption(
      id: json['ServiceId'],
      description: json['Description'],
      price: double.parse(json['ServiceCost']['Amount']),
    );
  }
}

class TripDetails {
  final String origin;
  final String destination;
  final String departure;
  final String arrival;
  final String flightNumber;
  final String airlineCode;
  final String airlineName;
  final int durationMinutes;
  final String cabin;
  final double totalFare;
  final List<Passenger> passengers;
  final List<BaggageOption> baggageOptions;

  TripDetails({
    required this.origin,
    required this.destination,
    required this.departure,
    required this.arrival,
    required this.flightNumber,
    required this.airlineCode,
    required this.airlineName,
    required this.durationMinutes,
    required this.cabin,
    required this.totalFare,
    required this.passengers,
    required this.baggageOptions,
  });

  factory TripDetails.fromJson(Map<String, dynamic> json, String airlineName) {
    final travel =
        json['TripDetailsResponse']['TripDetailsResult']['TravelItinerary'];
    final itinerary = travel['ItineraryInfo'];
    final reservation = itinerary['ReservationItems'][0]['ReservationItem'];
    final pricing = itinerary['ItineraryPricing'];

    final passengers =
        (itinerary['CustomerInfos'] as List)
            .map((e) => Passenger.fromJson(e['CustomerInfo']))
            .toList();

    final baggage =
        (itinerary['ExtraServices']['Services'] as List)
            .map((e) => BaggageOption.fromJson(e['Service']))
            .toList();

    return TripDetails(
      origin: travel['Origin'],
      destination: travel['Destination'],
      departure: reservation['DepartureDateTime'],
      arrival: reservation['ArrivalDateTime'],
      flightNumber: reservation['FlightNumber'],
      airlineCode: reservation['MarketingAirlineCode'],
      airlineName: airlineName,
      durationMinutes: int.parse(reservation['JourneyDuration']),
      cabin: reservation['CabinClassText'],
      totalFare: double.parse(pricing['TotalFare']['Amount']),
      passengers: passengers,
      baggageOptions: baggage,
    );
  }
}
