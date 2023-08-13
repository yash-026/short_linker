import 'package:flutter/material.dart';
import 'package:short_linker/screens/homescreen.dart';
import 'package:short_linker/themes/darktheme.dart';
import 'package:short_linker/themes/lighttheme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
      theme: lightTheme,
      darkTheme: darkTheme,
    );
  }
}

