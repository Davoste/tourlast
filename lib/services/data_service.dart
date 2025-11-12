import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/trip_details.dart';
import '../models/extra_services.dart';
import '../models/flight_search.dart';
import '../models/airline.dart';

class DataService {
  static final Map<String, String> _logoCache = {};

  static Future<TripDetails> loadTripWithExtras() async {
    final tripJson = await rootBundle.loadString(
      'assets/json/trip-details.json',
    );
    final extraJson = await rootBundle.loadString(
      'assets/json/extra-services.json',
    );
    final airlineJson = await rootBundle.loadString(
      'assets/json/airline-list.json',
    );

    final tripMap = json.decode(tripJson);
    final extraMap = json.decode(extraJson);
    final List<Airline> airlines =
        (json.decode(airlineJson) as List)
            .map((e) => Airline.fromJson(e))
            .toList();

    final airlineCode =
        tripMap['TripDetailsResponse']['TripDetailsResult']['TravelItinerary']['ItineraryInfo']['ReservationItems'][0]['ReservationItem']['MarketingAirlineCode'];

    final airline = airlines.firstWhere(
      (a) => a.code == airlineCode,
      orElse:
          () =>
              Airline(code: airlineCode, name: 'Unknown Airline', logoUrl: ''),
    );

    final trip = TripDetails.fromJson(tripMap, airline.name);
    final extra = ExtraServices.fromJson(extraMap);
    final allBaggage = {...trip.baggageOptions, ...extra.baggage}.toList();

    return TripDetails(
      origin: trip.origin,
      destination: trip.destination,
      departure: trip.departure,
      arrival: trip.arrival,
      flightNumber: trip.flightNumber,
      airlineCode: trip.airlineCode,
      airlineName: trip.airlineName,
      durationMinutes: trip.durationMinutes,
      cabin: trip.cabin,
      totalFare: trip.totalFare,
      passengers: trip.passengers,
      baggageOptions: allBaggage,
    );
  }

  static Future<List<FlightOffer>> loadFlights() async {
    final jsonString = await rootBundle.loadString('assets/json/flights.json');
    final map = json.decode(jsonString);
    final search = FlightSearch.fromJson(map);
    return search.offers;
  }

  static Future<String> getAirlineLogo(String code) async {
    if (_logoCache.containsKey(code)) return _logoCache[code]!;
    final jsonString = await rootBundle.loadString(
      'assets/json/airline-list.json',
    );
    final list = json.decode(jsonString) as List;
    final map = list.firstWhere(
      (e) => e['AirLineCode'] == code,
      orElse: () => null,
    );
    final url = map?['AirLineLogo'] ?? '';
    _logoCache[code] = url;
    return url;
  }
}
