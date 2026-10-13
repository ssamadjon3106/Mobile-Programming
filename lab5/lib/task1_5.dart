import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: RootScreen()));

class BackOrExitButton extends StatelessWidget {
  const BackOrExitButton({super.key});

  @override
  Widget build(BuildContext context) {
    if (Navigator.canPop(context)) {
      return ElevatedButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Back'),
      );
    } else {
      return const ElevatedButton(
        onPressed: null,
        child: Text('Nothing to go back to'),
      );
    }
  }
}

class RootScreen extends StatelessWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Root')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const BackOrExitButton(),
            const SizedBox(height: 16),
            ElevatedButton(
              child: const Text('Open second screen'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SecondScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Second')),
      body: const Center(
        child: BackOrExitButton(),
      ),
    );
  }
}
