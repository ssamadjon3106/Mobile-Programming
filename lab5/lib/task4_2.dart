import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => const HomeScreen(),
      '/square': (context) => const SquareScreen(),
    },
  ));
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('1'),
              onPressed: () {
                Navigator.pushNamed(context, '/square', arguments: 1);
              },
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              child: const Text('2'),
              onPressed: () {
                Navigator.pushNamed(context, '/square', arguments: 2);
              },
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              child: const Text('3'),
              onPressed: () {
                Navigator.pushNamed(context, '/square', arguments: 3);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SquareScreen extends StatelessWidget {
  const SquareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final number = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
      appBar: AppBar(title: const Text('Square')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Number: $number', style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 12),
            Text(
              'Square: ${number * number}',
              style: const TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
