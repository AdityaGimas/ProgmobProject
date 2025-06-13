import 'package:flutter/material.dart';
import 'login.dart';

void main() {
  runApp(const BaliDestinasiApp());
}

class BaliDestinasiApp extends StatelessWidget {
  const BaliDestinasiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bali Destinasi mantap',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Arial',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFF5A94D)),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}