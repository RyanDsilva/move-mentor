import 'package:flutter/material.dart';
import 'package:movementor/screens/base.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MoveMentor());
}

class MoveMentor extends StatelessWidget {
  const MoveMentor({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('MoveMentor'),
        ),
        body: const BaseScreen(),
      ),
    );
  }
}
