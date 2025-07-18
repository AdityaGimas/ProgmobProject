import 'dart:async';
import 'package:flutter/material.dart';
import 'app_router_delegate.dart'; // pastikan ini mengarah ke file enum AppPage kamu

class PageManager extends ChangeNotifier {
  late Completer<String> _completer;

  AppPage _currentPage = AppPage.dashboard;
  Object? _arguments;

  AppPage get currentPage => _currentPage;
  Object? get arguments => _arguments;

  void goTo(AppPage page, {Object? arguments}) {
    _currentPage = page;
    _arguments = arguments;
    notifyListeners();
  }

  Future<String> waitForResult() {
    _completer = Completer<String>();
    return _completer.future;
  }

  void returnData(String value) {
    if (!_completer.isCompleted) {
      _completer.complete(value);
    }
  }
}
