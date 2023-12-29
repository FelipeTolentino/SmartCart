import 'package:flutter/material.dart';
import 'package:smartcart/screens/home_screen.dart';

void main() {
  runApp(
      SmartCart()
    );
}

class SmartCart extends StatelessWidget {
  const SmartCart({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const NewCartScreen(),
    );
  }
}
