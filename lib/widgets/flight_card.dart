import 'package:flutter/material.dart';
import '../models/flight_search.dart';
import '../utils/time_formatter.dart';
import '../services/data_service.dart';

class FlightCard extends StatelessWidget {
  final FlightOffer flight;
  final double basePrice;
  final VoidCallback onBook;

  const FlightCard({
    super.key,
    required this.flight,
    required this.basePrice,
    required this.onBook,
  });

  @override
  Widget build(BuildContext context) {
    final segment = flight.segments[0];
    final total = basePrice; // Baggage can be added later

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          // ── Airline + Price ─────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _airlineLogo(segment.airlineCode),
                  const SizedBox(width: 8),
                  Text(
                    segment.airlineCode,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                  ),
                ),
                child: Text(
                  '\$${total.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // ── Route & Duration ───────────────────────────────────
          Row(
            children: [
              _cityBadge(
                segment.departureAirport,
                TimeFormatter.formatTime(segment.departureTime),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      TimeFormatter.formatDuration(segment.durationMinutes),
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF64748b),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Icon(
                      Icons.flight,
                      size: 16,
                      color: Color(0xFF64748b),
                    ),
                  ],
                ),
              ),
              _cityBadge(
                segment.arrivalAirport,
                TimeFormatter.formatTime(segment.arrivalTime),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // ── Details ─────────────────────────────────────────────
          Row(
            children: [
              _miniBadge(
                'Dep',
                TimeFormatter.formatTime(segment.departureTime),
              ),
              const SizedBox(width: 8),
              _miniBadge('Arr', TimeFormatter.formatTime(segment.arrivalTime)),
              const SizedBox(width: 8),
              _miniBadge('Class', flight.cabin),
            ],
          ),
          const SizedBox(height: 12),

          // ── Action Buttons ──────────────────────────────────────
          Row(
            children: [
              Expanded(flex: 2, child: _gradientButton('Book Now', onBook)),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: const BorderSide(
                      color: Color(0xFF667eea),
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    '+ Hotel',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF667eea),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Airline Logo ─────────────────────────────────────────────
  Widget _airlineLogo(String code) {
    return FutureBuilder<String>(
      future: DataService.getAirlineLogo(code),
      builder: (context, snapshot) {
        final url = snapshot.data ?? '';
        return Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: const LinearGradient(
              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            ),
          ),
          child:
              url.isNotEmpty
                  ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      url,
                      width: 24,
                      height: 24,
                      fit: BoxFit.contain,
                    ),
                  )
                  : const Icon(Icons.flight, color: Colors.white, size: 18),
        );
      },
    );
  }

  // ── City + Time Badge ───────────────────────────────────────
  Widget _cityBadge(String code, String time) {
    return Column(
      children: [
        Text(
          code,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 2),
        Text(
          time,
          style: const TextStyle(fontSize: 11, color: Color(0xFF64748b)),
        ),
      ],
    );
  }

  // ── Mini Detail Badge ───────────────────────────────────────
  Widget _miniBadge(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFf8faff),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 10, color: Color(0xFF64748b)),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  // ── Gradient Book Button ─────────────────────────────────────
  Widget _gradientButton(String text, VoidCallback onPressed) {
    return SizedBox(
      height: 40,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Ink(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            ),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Container(
            alignment: Alignment.center,
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Card Style ───────────────────────────────────────────────
  BoxDecoration _cardDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: const Color(0xFF667eea).withOpacity(0.08),
        blurRadius: 12,
        offset: const Offset(0, 3),
      ),
    ],
  );
}
