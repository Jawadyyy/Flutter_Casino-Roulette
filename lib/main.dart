import 'package:flutter/material.dart';
import 'spin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Roulette',
      theme: ThemeData(),
      home: const SpinWheel(),
    );
  }
}
