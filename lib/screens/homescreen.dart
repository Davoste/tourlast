import 'package:flutter/material.dart';
import 'package:ndege/screens/result_screen.dart';
import '../widgets/search_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // ── Header ─────────────────────────────────────
              Center(
                child: Column(
                  children: [
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            image: AssetImage('assets/logo/tourlast.png'),
                            height: 40,
                          ),
                          Text(
                            ' tourlast',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                              // foreground:
                              //     Paint()
                              //       ..shader = LinearGradient(
                              //         colors: [
                              //           Color(0xFF667eea),
                              //           Color(0xFF764ba2),
                              //         ],
                              //       ).createShader(
                              //         Rect.fromLTWH(0, 0, 200, 70),
                              //       ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Find your perfect flight',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 11, 12, 12),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── Search Card ─────────────────────────────────
              SearchCard(
                onSearch: (from, to) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SearchResultsScreen(from: from, to: to),
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
