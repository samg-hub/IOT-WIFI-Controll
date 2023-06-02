import 'package:flutter/material.dart';
import 'package:sbukBot/routing/routeGenerator.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "SBUK Bot",
      theme: ThemeData.dark(),
      initialRoute: '/',
      // the routes are defined in generateRoute method
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}