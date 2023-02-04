import 'screens/home/home.dart';
import 'package:flutter/material.dart';
import 'style.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Heatmap Demo',
      theme: appTheme,
      home: const Home(),
    );
  }
}
