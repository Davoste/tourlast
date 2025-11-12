import 'package:flutter/material.dart';

/// Search card with **editable** From / To fields and **real icons**
class SearchCard extends StatefulWidget {
  final void Function(String from, String to) onSearch;

  const SearchCard({super.key, required this.onSearch});

  @override
  State<SearchCard> createState() => _SearchCardState();
}

class _SearchCardState extends State<SearchCard> {
  final _fromController = TextEditingController();
  final _toController = TextEditingController();

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          // From
          _editableRow(
            icon: Icons.flight_takeoff,
            gradient: const [Color(0xFF667eea), Color(0xFF764ba2)],
            controller: _fromController,
            hint: 'From (e.g. RTM)',
          ),
          const SizedBox(height: 16),

          // To
          _editableRow(
            icon: Icons.flight_land,
            gradient: const [Color(0xFF764ba2), Color(0xFF667eea)],
            controller: _toController,
            hint: 'To (e.g. STN)',
          ),
          const SizedBox(height: 16),

          // Date
          _readOnlyRow(
            icon: Icons.calendar_today,
            value: 'Dec 14, 2025',
            bgColor: const Color(0xFFf8faff),
          ),
          const SizedBox(height: 16),

          // Search Button
          _gradientButton('Search Flights', () {
            final from = _fromController.text.trim().toUpperCase();
            final to = _toController.text.trim().toUpperCase();

            if (from.isEmpty || to.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please enter both airports')),
              );
              return;
            }

            widget.onSearch(from, to);
          }),
        ],
      ),
    );
  }

  // ── Editable field (From / To) ─────────────────────────────────────
  Widget _editableRow({
    required IconData icon,
    required List<Color> gradient,
    required TextEditingController controller,
    required String hint,
  }) {
    return Row(
      children: [
        // Icon box with gradient background
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradient,
            ),
          ),
          child: Center(child: Icon(icon, color: Colors.white, size: 20)),
        ),
        const SizedBox(width: 12),

        // Text field
        Expanded(
          child: TextFormField(
            controller: controller,
            textCapitalization: TextCapitalization.characters,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1e293b),
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Color(0xFF94a3b8)),
              filled: true,
              fillColor: const Color(0xFFf8faff),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
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
                borderSide: const BorderSide(
                  color: Color(0xFF667eea),
                  width: 2,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Read-only field (Date) ───────────────────────────────────────
  Widget _readOnlyRow({
    required IconData icon,
    required String value,
    Color? bgColor,
  }) {
    return Row(
      children: [
        // Icon box
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: bgColor ?? const Color(0xFFf8faff),
          ),
          child: Center(
            child: Icon(icon, color: const Color(0xFF64748b), size: 20),
          ),
        ),
        const SizedBox(width: 12),

        // Read-only text
        Expanded(
          child: TextField(
            readOnly: true,
            controller: TextEditingController(text: value),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1e293b),
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFf8faff),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
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
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Gradient Search Button ─────────────────────────────────────
  Widget _gradientButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
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
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            ),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(16),
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

  // ── Card Shadow & Background ───────────────────────────────────
  BoxDecoration _cardDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: const Color(0xFF667eea).withOpacity(0.1),
        blurRadius: 20,
        offset: const Offset(0, 4),
      ),
    ],
  );
}
