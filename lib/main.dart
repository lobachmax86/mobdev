import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'main_screen.dart';
import 'second_screen.dart';

void main() {
  runApp(const MyApp());
}

// Глобальный роутер
final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainScreen(),
    ),
    GoRoute(
      path: '/second',
      builder: (context, state) => const SecondScreen(),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}
