import 'package:flutter/material.dart';
import 'package:ndege/screens/homescreen.dart';

void main() => runApp(const SkyBookApp());

class SkyBookApp extends StatelessWidget {
  const SkyBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SkyBook',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Roboto', useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}
