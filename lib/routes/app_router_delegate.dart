import 'dart:io';
import 'package:flutter/material.dart';
import '../screen/login.dart';
import '../screen/register.dart';
import '../screen/dashboard.dart';
import '../screen/profil.dart';
import 'page_manager.dart';

/// Enum halaman aplikasi
enum AppPage {
  login,
  register,
  dashboard,
  profil,
  viewProfilePicture,
}

class AppRouterDelegate extends RouterDelegate<AppPage>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppPage> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final PageManager pageManager;

  AppRouterDelegate(this.pageManager) {
    pageManager.addListener(_onPageChanged);
  }

  AppPage _currentPage = AppPage.login;
  String _email = "";
  bool _showViewProfile = false;
  File? _imageFile;

  @override
  AppPage get currentConfiguration => _currentPage;

  void _setNewPage(AppPage page) {
    _currentPage = page;
    notifyListeners();
  }

  void goToRegister() => _setNewPage(AppPage.register);
  void goToDashboard() => _setNewPage(AppPage.dashboard);
  void goToLogin() {
    _imageFile = null;
    _showViewProfile = false;
    _setNewPage(AppPage.login);
  }
  void goToProfil() => _setNewPage(AppPage.profil);

  void goToViewProfile(File imageFile) {
    _imageFile = imageFile;
    _showViewProfile = true;
    notifyListeners();
  }

  void closeViewProfile() {
    _showViewProfile = false;
    notifyListeners();
  }

  void handleLogin(String email) {
    _email = email;
    goToDashboard();
  }

  void _onPageChanged() {
    final newPage = pageManager.currentPage;
    final args = pageManager.arguments;

    if (newPage == AppPage.viewProfilePicture && args is File) {
      goToViewProfile(args);
    } else {
      _setNewPage(newPage);
    }
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
          onGoToProfil: () => goToProfil(),
        ),
      ));
    }

    if (_currentPage == AppPage.profil) {
      pages.add(MaterialPage(
        key: const ValueKey('ProfilPage'),
        child: ProfilPage(
          pageManager: pageManager,
        ),
      ));
      }

    return Navigator(
      key: navigatorKey,
      pages: pages,
      onPopPage: (route, result) {
        if (!route.didPop(result)) return false;

        if (_showViewProfile) {
          closeViewProfile();
          return true;
        }

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
