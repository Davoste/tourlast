import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

class PaymentScreen extends StatefulWidget {
  final double totalAmount;
  final String passengerName;
  final String flightInfo;

  const PaymentScreen({
    super.key,
    required this.totalAmount,
    required this.passengerName,
    required this.flightInfo,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _nameController = TextEditingController();

  bool _isProcessing = false;
  late AnimationController _successController;

  @override
  void initState() {
    super.initState();
    _successController = AnimationController(vsync: this);
    _nameController.text = widget.passengerName;
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _nameController.dispose();
    _successController.dispose();
    super.dispose();
  }

  Future<void> _processPayment() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isProcessing = true);

    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isProcessing = false);

    // Show Lottie success animation
    _successController.forward().then((_) {
      Future.delayed(const Duration(seconds: 1), () {
        // Go back to home
        Navigator.popUntil(context, (route) => route.isFirst);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Payment successful! Your ticket has been sent to your email.',
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
          'Payment',
          style: TextStyle(
            color: Color(0xFF1e293b),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isProcessing ? _buildProcessing() : _buildForm(),
    );
  }

  // ── Processing with Lottie Success ─────────────────────────────────
  Widget _buildProcessing() {
    return Center(
      child: Lottie.asset(
        'assets/animation/success.json',
        controller: _successController,
        onLoaded: (composition) {
          _successController
            ..duration = composition.duration
            ..forward();
        },
      ),
    );
  }

  // ── Main Form ─────────────────────────────────────────────────────
  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _summaryCard(),
          const SizedBox(height: 20),
          _paymentMethods(),
          const SizedBox(height: 20),
          _cardForm(),
          const SizedBox(height: 24),
          _gradientButton(
            'Pay \$${widget.totalAmount.toStringAsFixed(2)}',
            _processPayment,
          ),
        ],
      ),
    );
  }

  // ── Booking Summary ───────────────────────────────────────────────
  Widget _summaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Booking Summary',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(widget.flightInfo, style: const TextStyle(fontSize: 14)),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Amount',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                '\$${widget.totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF667eea),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Payment Methods ───────────────────────────────────────────────
  Widget _paymentMethods() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pay with',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _methodButton(Icons.credit_card, 'Card', isSelected: true),
              _methodButton(Icons.apple, 'Apple Pay'),
              _methodButton(Icons.g_mobiledata, 'Google Pay'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _methodButton(IconData icon, String label, {bool isSelected = false}) {
    return GestureDetector(
      onTap: () {
        // Future: switch payment method
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$label selected (simulated)')));
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color:
                  isSelected
                      ? const Color(0xFF667eea).withOpacity(0.1)
                      : const Color(0xFFf8faff),
              borderRadius: BorderRadius.circular(14),
              border:
                  isSelected
                      ? Border.all(color: const Color(0xFF667eea), width: 1.5)
                      : null,
            ),
            child: Icon(
              icon,
              size: 28,
              color:
                  isSelected
                      ? const Color(0xFF667eea)
                      : const Color(0xFF64748b),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF64748b)),
          ),
        ],
      ),
    );
  }

  // ── Card Form ─────────────────────────────────────────────────────
  Widget _cardForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _cardNumberController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(19),
                _CardNumberFormatter(),
              ],
              decoration: _inputDecoration(
                'Card Number',
                '1234 5678 9012 3456',
              ),
              validator:
                  (v) =>
                      v!.replaceAll(' ', '').length == 16
                          ? null
                          : 'Enter 16 digits',
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _expiryController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                      _ExpiryFormatter(),
                    ],
                    decoration: _inputDecoration('MM/YY', '12/25'),
                    validator: (v) => v!.length == 5 ? null : 'MM/YY',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _cvvController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                    ],
                    decoration: _inputDecoration('CVV', '123'),
                    obscureText: true,
                    validator: (v) => v!.length >= 3 ? null : '3-4 digits',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _nameController,
              decoration: _inputDecoration('Name on Card'),
              validator: (v) => v!.isNotEmpty ? null : 'Required',
            ),
          ],
        ),
      ),
    );
  }

  // ── Pay Button ───────────────────────────────────────────────────
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

  // ── Input Decoration ─────────────────────────────────────────────
  InputDecoration _inputDecoration(String hint, [String? example]) {
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
      suffixText: example,
      suffixStyle: const TextStyle(color: Color(0xFFcbd5e1), fontSize: 12),
    );
  }

  // ── Card Shadow ──────────────────────────────────────────────────
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

// ── Formatters ───────────────────────────────────────────────────
class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text.replaceAll(' ', '');
    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if ((i + 1) % 4 == 0 && i != text.length - 1) buffer.write(' ');
    }
    final string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}

class _ExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text;
    if (text.length > 2 && !text.contains('/')) {
      text = '${text.substring(0, 2)}/${text.substring(2)}';
    }
    return newValue.copyWith(
      text: text.length > 5 ? text.substring(0, 5) : text,
    );
  }
}
