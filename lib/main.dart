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
      // Кнопка действия внизу справа
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('Button pressed!');
        },
        child: const Icon(Icons.add),
      ),

      body: Column(
        children: [
          // Первый контейнер
          Container(
            width: double.infinity,
            height: 150,
            color: const Color.fromARGB(255, 54, 33, 243),
          ),

          // Ряд с тремя текстами
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              Text('Текст 1'),
              Text('Текст 2'),
              Text('Текст 3'),
            ],
          ),

          // Expanded растягивается, занимая доступное пространство
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                // Первый аватар (просто цвет)
                CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.orange,
                ),

                // Второй аватар с картинкой из интернета
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    'https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg',
                  ),
                ),
              ],
            ),
          ),

          // Второй контейнер
          Container(
            width: double.infinity,
            height: 100,
            color: const Color.fromARGB(255, 119, 76, 175),
          ),
        ],
      ),
    );
  }
}
