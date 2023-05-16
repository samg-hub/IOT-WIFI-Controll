import 'package:flutter/material.dart';
import 'package:v2rayadmin/routing/routeGenerator.dart';

Future<Null> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "appName",
      theme: ThemeData.dark(),
      initialRoute: '/',
      // the routes are defined in generateRoute method
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}