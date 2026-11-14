import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'bloc/cart_bloc.dart';
import 'bloc/cart_event.dart';
import 'bloc/cart_page_bloc.dart';
import 'cubit/cart_page_cubit.dart';
import 'models/cart.dart';
import 'riverpod/cart_page_riverpod.dart';
import 'setstate/cart_page_setstate.dart';

void main() {
  Bloc.observer = _AppBlocObserver();
  runApp(
    // ProviderScope wraps the whole tree so Riverpod providers are accessible.
    const ProviderScope(child: CartApp()),
  );
}

class CartApp extends StatelessWidget {
  const CartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'One Cart, Four Ways',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('One Cart, Four Ways'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Lab 9 — State Management',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            _NavButton(
              label: 'setState',
              color: Theme.of(context).colorScheme.primaryContainer,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => const SetStateCartPage(),
                ),
              ),
            ),
            _NavButton(
              label: 'Riverpod',
              color: Theme.of(context).colorScheme.secondaryContainer,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => const RiverpodCartPage(),
                ),
              ),
            ),
            _NavButton(
              label: 'Cubit',
              color: Theme.of(context).colorScheme.tertiaryContainer,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => const CubitCartPage(),
                ),
              ),
            ),
            _NavButton(
              label: 'Bloc',
              color: Theme.of(context).colorScheme.errorContainer,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => const BlocCartPage(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.label,
    required this.color,
    required this.onPressed,
  });

  final String label;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: FilledButton.tonal(
        style: FilledButton.styleFrom(
          backgroundColor: color,
          minimumSize: const Size(220, 52),
        ),
        onPressed: onPressed,
        child: Text(label, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}

/// Logs every Bloc transition and Cubit emission to the console.
class _AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    debugPrint('[${bloc.runtimeType}] ${change.currentState.runtimeType} → '
        '${change.nextState.runtimeType}');
  }

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);
    debugPrint('[${bloc.runtimeType}] event: ${transition.event.runtimeType}');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    debugPrint('[${bloc.runtimeType}] error: $error');
    super.onError(bloc, error, stackTrace);
  }
}
