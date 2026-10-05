import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: SettingsScreen()));
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  bool _agreedToTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('Dark Mode'),
              subtitle: const Text('Enable dark theme'),
              value: _darkMode,
              onChanged: (bool newValue) {
                setState(() {
                  _darkMode = newValue;
                });
              },
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: const Text('Agree to Terms'),
              subtitle: const Text('Accept terms and conditions'),
              value: _agreedToTerms,
              onChanged: (bool? newValue) {
                setState(() {
                  _agreedToTerms = newValue ?? false;
                });
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _agreedToTerms
                  ? () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Settings saved!')),
                      );
                    }
                  : null,
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
