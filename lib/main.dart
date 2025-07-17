import 'package:flutter/material.dart';
import 'routes/app_router_delegate.dart';

void main() {
  runApp(const BaliDestinasiApp());
}

class BaliDestinasiApp extends StatelessWidget {
  const BaliDestinasiApp({super.key});

  @override
  Widget build(BuildContext context) {
    final routerDelegate = AppRouterDelegate();

    return MaterialApp.router(
      title: 'Bali Destinasi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Arial',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFF5A94D)),
        useMaterial3: true,
      ),
      routerDelegate: routerDelegate,
      routeInformationParser: _NoOpParser(), 
    );
  }
}

class _NoOpParser extends RouteInformationParser<AppPage> {
  @override
  Future<AppPage> parseRouteInformation(RouteInformation routeInformation) async {
    return AppPage.login;
  }
}
