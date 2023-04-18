import 'package:flutter/material.dart';
import 'package:movementor/screens/introduction.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MoveMentor());
}

class MoveMentor extends StatelessWidget {
  const MoveMentor({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MoveMentor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.orange.shade600,
      ),
      home: const IntroductionScreen(),
    );
  }
}
