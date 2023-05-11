import 'package:flutter/material.dart';
import 'package:v2rayadmin/view/pages/mainPage.dart';

import '../main.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const MainPage());
      // case '/login' : return MaterialPageRoute(builder:(_)=>const LoginPage());
      // case '/profile' : return MaterialPageRoute(builder:(_)=>profile_page());
      // case '/load' : return MaterialPageRoute(builder:(_)=>load_page());
      // case '/updatePage' : return MaterialPageRoute(builder:(_)=>update_page());
      // case '/home':
      //   return MaterialPageRoute(
      //     builder: (_) => HomePage(),
      //   );
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
