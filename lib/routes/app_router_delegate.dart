import 'package:flutter/material.dart';
import '../screen/login.dart';
import '../screen/register.dart';
import '../screen/dashboard.dart';
import 'page_manager.dart';

/// Enum halaman-halaman aplikasi
enum AppPage {
  login,
  register,
  dashboard,
}

class AppRouterDelegate extends RouterDelegate<AppPage>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppPage> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final PageManager pageManager;

  AppRouterDelegate(this.pageManager);

  AppPage _currentPage = AppPage.login;
  String _email = "";

  @override
  AppPage get currentConfiguration => _currentPage;

  void _setNewPage(AppPage page) {
    _currentPage = page;
    notifyListeners();
  }

  void goToRegister() => _setNewPage(AppPage.register);
  void goToDashboard() => _setNewPage(AppPage.dashboard);
  void goToLogin() => _setNewPage(AppPage.login);

  void handleLogin(String email) {
    _email = email;
    goToDashboard();
  }

  @override
  Widget build(BuildContext context) {
    List<Page> pages = [];

    if (_currentPage == AppPage.login) {
      pages.add(MaterialPage(
        key: const ValueKey('LoginPage'),
        child: LoginPage(
          onLoginSuccess: (email) => handleLogin(email),
          onGoToRegister: () => goToRegister(),
        ),
      ));
    }

    if (_currentPage == AppPage.register) {
      pages.add(MaterialPage(
        key: const ValueKey('RegisterPage'),
        child: RegisterPage(
          onRegisterSuccess: goToLogin,
        ),
      ));
    }

    if (_currentPage == AppPage.dashboard) {
      pages.add(MaterialPage(
        key: const ValueKey('DashboardPage'),
        child: DashboardPage(
          email: _email,
          onLogout: () {
            _email = "";
            goToLogin();
          },
        ),
      ));
    }

    return Navigator(
      key: navigatorKey,
      pages: pages,
      onPopPage: (route, result) {
        if (!route.didPop(result)) return false;

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
