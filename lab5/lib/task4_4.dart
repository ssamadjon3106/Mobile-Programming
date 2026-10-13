import 'package:flutter/material.dart';

class User {
  final String name;
  final int age;
  final String city;
  const User(this.name, this.age, this.city);
}

const users = [
  User('Ali', 20, 'Tashkent'),
  User('Madina', 22, 'Samarkand'),
  User('Bobur', 19, 'Bukhara'),
  User('Nilufar', 21, 'Andijan'),
];

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    onGenerateRoute: (settings) {
      if (settings.name == '/') {
        return MaterialPageRoute(builder: (c) => const UserListScreen());
      }
      if (settings.name == '/profile') {
        final args = settings.arguments;
        if (args is User) {
          return MaterialPageRoute(builder: (c) => ProfileScreen(user: args));
        }
        return MaterialPageRoute(builder: (c) => const ErrorScreen());
      }
      return null;
    },
  ));
}

class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: ListView(
        children: [
          for (final u in users)
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(u.name),
              onTap: () {
                Navigator.pushNamed(context, '/profile', arguments: u);
              },
            ),
          ListTile(
            leading: const Icon(Icons.warning),
            title: const Text('Open profile with wrong argument'),
            onTap: () {
              Navigator.pushNamed(context, '/profile', arguments: 'hello');
            },
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  final User user;
  const ProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(user.name)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Name: ${user.name}', style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 8),
            Text('Age: ${user.age}', style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 8),
            Text('City: ${user.city}', style: const TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: const Center(child: Text('Wrong arguments for this screen')),
    );
  }
}
