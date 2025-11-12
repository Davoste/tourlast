import 'package:flutter/material.dart';
import 'package:ndege/screens/booking_screen.dart';

import '../services/data_service.dart';
import '../widgets/flight_card.dart';
import '../models/flight_search.dart';

class SearchResultsScreen extends StatefulWidget {
  final String? from;
  final String? to;

  const SearchResultsScreen({super.key, this.from, this.to});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  late Future<List<FlightOffer>> _flightsFuture;
  String _from = '';
  String _to = '';

  @override
  void initState() {
    super.initState();
    _from = widget.from?.toUpperCase() ?? '';
    _to = widget.to?.toUpperCase() ?? '';
    _flightsFuture = DataService.loadFlights().then((flights) {
      return flights.where((f) {
        final segment = f.segments[0];
        final matchesFrom = _from.isEmpty || segment.departureAirport == _from;
        final matchesTo = _to.isEmpty || segment.arrivalAirport == _to;
        return matchesFrom && matchesTo;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Flights ${_from.isEmpty ? '' : _from} to ${_to.isEmpty ? '' : _to}',
        ),
        backgroundColor: const Color(0xFFF8FAFF),
      ),
      backgroundColor: const Color(0xFFF8FAFF),
      body: FutureBuilder<List<FlightOffer>>(
        future: _flightsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final flights = snapshot.data!;
          if (flights.isEmpty) {
            return const Center(
              child: Text('No flights found', style: TextStyle(fontSize: 18)),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: flights.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final flight = flights[index];
              return FlightCard(
                flight: flight,
                basePrice: flight.totalFare,
                onBook: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => BookingScreen(
                            flight: flight,
                            basePrice: flight.totalFare,
                          ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  // void _showBookingDialog(FlightOffer flight) {
  //   final segment = flight.segments[0];
  //   showDialog(
  //     context: context,
  //     builder:
  //         (_) => AlertDialog(
  //           title: const Text('Booking Confirmed'),
  //           content: Text(
  //             'Flight ${segment.airlineCode}${segment.flightNumber}\n'
  //             '${segment.departureAirport} to ${segment.arrivalAirport}\n'
  //             'Dep: ${TimeFormatter.formatTime(segment.departureTime)}\n'
  //             'Arr: ${TimeFormatter.formatTime(segment.arrivalTime)}\n'
  //             'Total: \$${flight.totalFare}',
  //           ),
  //           actions: [
  //             TextButton(
  //               onPressed: () => Navigator.pop(context),
  //               child: const Text('OK'),
  //             ),
  //           ],
  //         ),
  //   );
  // }
}
