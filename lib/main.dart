import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Основной каркас экрана
      body: Column(
        children: [
          // Первый контейнер
          Container(
            width: double.infinity, // по всей ширине экрана
            height: 150,
            color: Colors.blue,
          ),

          // Ряд с тремя текстами
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // можно поменять на spaceBetween, если нужно
            children: const [
              Text('Текст 1'),
              Text('Текст 2'),
              Text('Текст 3'),
            ],
          ),

          // Второй контейнер
          Container(
            width: double.infinity,
            height: 100,
            color: Colors.green,
          ),
        ],
      ),
    );
  }
}
