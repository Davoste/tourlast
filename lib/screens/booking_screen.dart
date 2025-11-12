import 'package:flutter/material.dart';
import '../models/flight_search.dart';
import '../utils/time_formatter.dart';
import '../services/data_service.dart';
import 'payment_screen.dart'; // Import PaymentScreen

class BookingScreen extends StatefulWidget {
  final FlightOffer flight;
  final double basePrice;

  const BookingScreen({
    super.key,
    required this.flight,
    required this.basePrice,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final Set<String> _selectedBaggage = {};

  late double _totalPrice;

  @override
  void initState() {
    super.initState();
    _totalPrice = widget.basePrice;
  }

  void _updatePrice() {
    setState(() {
      _totalPrice = widget.basePrice + (_selectedBaggage.length * 25.0);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final segment = widget.flight.segments[0];
    final flightDate = _formatFlightDate(segment.departureTime);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1e293b)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Complete Booking',
          style: TextStyle(
            color: Color(0xFF1e293b),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildFlightSummary(segment, flightDate),
            const SizedBox(height: 20),
            _buildPassengerForm(),
            const SizedBox(height: 20),
            _buildBaggageSection(),
            const SizedBox(height: 20),
            _buildPriceSummary(),
            const SizedBox(height: 24),
            _gradientButton('Confirm Booking', _confirmBooking),
          ],
        ),
      ),
    );
  }

  // ── Flight Summary ─────────────────────────────────────────────
  Widget _buildFlightSummary(FlightSegment segment, String flightDate) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Row(
            children: [
              _airlineLogo(segment.airlineCode),
              const SizedBox(width: 12),
              Text(
                '${segment.airlineCode}${segment.flightNumber}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _cityTime(
                segment.departureAirport,
                TimeFormatter.formatTime(segment.departureTime),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      TimeFormatter.formatDuration(segment.durationMinutes),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748b),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Icon(
                      Icons.flight,
                      size: 18,
                      color: Color(0xFF64748b),
                    ),
                  ],
                ),
              ),
              _cityTime(
                segment.arrivalAirport,
                TimeFormatter.formatTime(segment.arrivalTime),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _infoChip('Class', widget.flight.cabin),
              _infoChip('Date', flightDate),
            ],
          ),
        ],
      ),
    );
  }

  // ── Passenger Form ─────────────────────────────────────────────
  Widget _buildPassengerForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Passenger Details',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _nameController,
              decoration: _inputDecoration('Full Name'),
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: _inputDecoration('Email Address'),
              validator: (v) => v!.contains('@') ? null : 'Invalid email',
            ),
          ],
        ),
      ),
    );
  }

  // ── Baggage Selection ──────────────────────────────────────────
  Widget _buildBaggageSection() {
    final baggageOptions = [
      'Carry-on Bag',
      'Checked Bag (23kg)',
      'Extra Legroom Seat',
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Add Extras (Optional)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...baggageOptions.map(
            (item) => CheckboxListTile(
              dense: true,
              title: Text('$item – \$25', style: const TextStyle(fontSize: 14)),
              value: _selectedBaggage.contains(item),
              onChanged: (v) {
                setState(() {
                  if (v == true) {
                    _selectedBaggage.add(item);
                  } else {
                    _selectedBaggage.remove(item);
                  }
                  _updatePrice();
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  // ── Price Summary ──────────────────────────────────────────────
  Widget _buildPriceSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          _priceRow('Base Fare', widget.basePrice),
          ..._selectedBaggage.map((item) => _priceRow(item, 25.0)),
          const Divider(height: 20),
          _priceRow('Total', _totalPrice, isTotal: true),
        ],
      ),
    );
  }

  // ── Confirm Booking → Go to Payment ───────────────────────────
  void _confirmBooking() {
    if (!_formKey.currentState!.validate()) return;

    final segment = widget.flight.segments[0];
    final flightInfo =
        '${segment.airlineCode}${segment.flightNumber}\n'
        '${segment.departureAirport} to ${segment.arrivalAirport}\n'
        'Dep: ${TimeFormatter.formatTime(segment.departureTime)}';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => PaymentScreen(
              totalAmount: _totalPrice,
              passengerName: _nameController.text,
              flightInfo: flightInfo,
            ),
      ),
    );
  }

  // ── Helper Widgets ─────────────────────────────────────────────
  String _formatFlightDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      return '${_getMonth(date.month)} ${date.day}, ${date.year}';
    } catch (e) {
      return 'Date N/A';
    }
  }

  String _getMonth(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

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

  Widget _cityTime(String code, String time) {
    return Column(
      children: [
        Text(
          code,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 2),
        Text(
          time,
          style: const TextStyle(fontSize: 12, color: Color(0xFF64748b)),
        ),
      ],
    );
  }

  Widget _infoChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFf8faff),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text('$label: $value', style: const TextStyle(fontSize: 12)),
    );
  }

  Widget _priceRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            ),
          ),
          Text(
            isTotal
                ? '\$${_totalPrice.toStringAsFixed(2)}'
                : '\$${amount.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: isTotal ? const Color(0xFF667eea) : null,
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF94a3b8)),
      filled: true,
      fillColor: const Color(0xFFf8faff),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF667eea), width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  Widget _gradientButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Ink(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            ),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          child: Container(
            alignment: Alignment.center,
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

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
