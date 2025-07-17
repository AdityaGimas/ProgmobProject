import 'package:flutter/material.dart';
import '../screen/login.dart';
import '../screen/register.dart';
import '../screen/dashboard.dart';

/// Enum halaman-halaman aplikasi
enum AppPage {
  login,
  register,
  dashboard,
}

class AppRouterDelegate extends RouterDelegate<AppPage>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppPage> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  AppPage _currentPage = AppPage.login;

  @override
  AppPage get currentConfiguration => _currentPage;

  // Method untuk update halaman
  void _setNewPage(AppPage page) {
    _currentPage = page;
    notifyListeners();
  }

  // Navigasi ke halaman-halaman
  void goToRegister() => _setNewPage(AppPage.register);
  void goToDashboard() => _setNewPage(AppPage.dashboard);
  void goToLogin() => _setNewPage(AppPage.login);

  @override
  Widget build(BuildContext context) {
    List<Page> pages = [];

    switch (_currentPage) {
      case AppPage.login:
        pages.add(MaterialPage(
          key: const ValueKey('LoginPage'),
          child: LoginPage(
            onLoginSuccess: goToDashboard,
            onGoToRegister: goToRegister,
          ),
        ));
        break;
      case AppPage.register:
        pages.add(MaterialPage(
          key: const ValueKey('RegisterPage'),
          child: RegisterPage(
            onRegisterSuccess: goToLogin,
          ),
        ));
        break;
      case AppPage.dashboard:
        pages.add(MaterialPage(
          key: const ValueKey('DashboardPage'),
          child: DashboardPage(
            onLogout: goToLogin,
          ),
        ));
        break;
    }

    return Navigator(
      key: navigatorKey,
      pages: pages,
      onPopPage: (route, result) {
        if (!route.didPop(result)) return false;

        // Jika sedang di register atau dashboard, kembali ke login
        if (_currentPage == AppPage.register || _currentPage == AppPage.dashboard) {
          goToLogin();
        }

        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(AppPage configuration) async {
    _currentPage = configuration;
  }
}
