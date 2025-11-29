import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Second Screen (GoRouter)')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.pop(); // вернуться назад
          },
          child: const Text('Назад'),
        ),
      ),
    );
  }
}
