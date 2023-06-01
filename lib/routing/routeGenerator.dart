import 'package:flutter/material.dart';
import 'package:sbukBot/view/pages/mainPage.dart';
class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) =>  MainPage());
      default:
        return _errorRoute();
    }
  }
}

Route<dynamic> _errorRoute() {
  return MaterialPageRoute(
    builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('routing اشتباه'),
        ),
        body: const Center(
          child: Text('در مسیر دهی اشتباه کرده اید'),
        ),
      );
    },
  );
}
