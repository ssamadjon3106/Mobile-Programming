import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    onGenerateRoute: (settings) {
      if (settings.name == '/') {
        return MaterialPageRoute(builder: (c) => const HomeScreen());
      }
      if (settings.name == '/rate') {
        final movie = settings.arguments as String;
        return MaterialPageRoute<int>(
          builder: (c) => RateScreen(movie: movie),
        );
      }
      return null;
    },
  ));
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String _movie = 'Interstellar';
  String _text = 'Not rated yet';

  Future<void> _rateMovie() async {
    final rating = await Navigator.pushNamed<int>(
      context,
      '/rate',
      arguments: _movie,
    );
    if (rating == null) {
      return;
    }
    setState(() {
      _text = '$_movie: $rating/5';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_text, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _rateMovie,
              child: const Text('Rate movie'),
            ),
          ],
        ),
      ),
    );
  }
}

class RateScreen extends StatelessWidget {
  final String movie;
  const RateScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Rate $movie')),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 1; i <= 5; i++)
              IconButton(
                icon: const Icon(Icons.star, color: Colors.amber, size: 36),
                onPressed: () => Navigator.pop(context, i),
              ),
          ],
        ),
      ),
    );
  }
}
