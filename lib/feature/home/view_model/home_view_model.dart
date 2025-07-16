import 'package:flutter/material.dart';

//https://pub.dev/packages/webview_flutter
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

/// ViewModel for the HomeView.
/// You can use this class to manage the state.
/// riverpod, bloc, or other state management solutions can also be used.
///
class HomeViewModel extends ChangeNotifier {
  int _counter = 0;
  int get counter => _counter;

  /// Increments the counter and notifies listeners.
  void increment() {
    _counter++;
    notifyListeners();
  }
}
