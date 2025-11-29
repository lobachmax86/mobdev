import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Main Screen (GoRouter)')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.push('/second'); // переход через GoRouter
          },
          child: const Text("Перейти на '/second'"),
        ),
      ),
    );
  }
}
