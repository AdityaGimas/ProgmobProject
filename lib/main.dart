import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'routes/app_router_delegate.dart';
import 'routes/page_manager.dart'; 

void main() {
  runApp(const BaliDestinasiApp());
}

class BaliDestinasiApp extends StatelessWidget {
  const BaliDestinasiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PageManager(), 
      child: Builder(
        builder: (context) {
          final pageManager = context.read<PageManager>();
          final routerDelegate = AppRouterDelegate(pageManager);

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
        },
      ),
    );
  }
}

class _NoOpParser extends RouteInformationParser<AppPage> {
  @override
  Future<AppPage> parseRouteInformation(RouteInformation routeInformation) async {
    return AppPage.login;
  }
}
