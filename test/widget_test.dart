import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:progmob_kelompok/main.dart';

void main() {
  testWidgets('Login page loads correctly', (WidgetTester tester) async {
    // Jalankan app dan render
    await tester.pumpWidget(const BaliDestinasiApp());
    await tester.pumpAndSettle();

    // Verifikasi bahwa teks login muncul
    expect(find.text('Selamat Datang'), findsOneWidget);

    // Verifikasi input Email & Password
    expect(find.widgetWithText(TextField, 'Email'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Password'), findsOneWidget);

    // Verifikasi tombol Login
    expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);

    // Verifikasi link untuk daftar
    expect(find.textContaining('Daftar'), findsWidgets);
  });
}
