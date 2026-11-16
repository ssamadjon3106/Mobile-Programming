import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'services/classifier.dart';
import 'services/image_sources.dart';
import 'screens/welcome_screen.dart';
import 'screens/home_screen.dart';
import 'screens/result_screen.dart';
import 'screens/history_screen.dart';
import 'screens/model_screen.dart';
import 'theme/app_theme.dart';
import 'widgets/download_dialog.dart';

class HistoryEntry {
  const HistoryEntry({
    required this.imageBytes,
    required this.predictions,
    required this.source,
    required this.timestamp,
  });
  final Uint8List imageBytes;
  final List<Prediction> predictions;
  final String source;
  final DateTime timestamp;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Teachable Machine Classifier',
      theme: appTheme,
      home: const MainApp(),
    );
  }
}

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  Classifier? _classifier;
  bool _isLoading = true;
  int _selectedIndex = 1;
  final _imageSources = ImageSources();
  final List<HistoryEntry> _history = [];

  @override
  void initState() {
    super.initState();
    _loadClassifier();
  }

  Future<void> _loadClassifier() async {
    try {
      final classifier = await Classifier.load();
      setState(() {
        _classifier = classifier;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Failed to load classifier: $e');
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load model: $e')),
        );
      }
    }
  }

  Future<void> _classifyImage(Uint8List? bytes, String source) async {
    if (bytes == null || _classifier == null) return;

    try {
      final predictions = _classifier!.classify(bytes);
      _history.add(HistoryEntry(
        imageBytes: bytes,
        predictions: predictions,
        source: source,
        timestamp: DateTime.now(),
      ));

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ResultScreen(
              imageBytes: bytes,
              predictions: predictions,
              source: source,
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint('Classification error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _handleTakePhoto() async {
    final bytes = await _imageSources.fromCamera();
    await _classifyImage(bytes, 'Camera');
  }

  Future<void> _handleChooseGallery() async {
    final bytes = await _imageSources.fromGallery();
    await _classifyImage(bytes, 'Gallery');
  }

  Future<void> _handleDownloadImage() async {
    final url = await showDialog<String>(
      context: context,
      builder: (_) => const DownloadImageDialog(),
    );
    if (url == null) return;

    setState(() => _isLoading = true);
    try {
      final bytes = await _imageSources.fromUrl(url);
      setState(() => _isLoading = false);
      await _classifyImage(bytes, 'Downloaded');
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to download: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _classifier == null) {
      return Scaffold(
        body: WelcomeScreen(
          isLoading: _isLoading,
          labels: _classifier?.labels ?? [],
          onGetStarted: () {
            setState(() => _selectedIndex = 1);
          },
        ),
      );
    }

    final screens = [
      HistoryScreen(
        entries: _history,
        onEntryTap: (entry) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ResultScreen(
                imageBytes: entry.imageBytes,
                predictions: entry.predictions,
                source: entry.source,
              ),
            ),
          );
        },
      ),
      HomeScreen(
        onTakePhoto: _handleTakePhoto,
        onChooseGallery: _handleChooseGallery,
        onDownloadImage: _handleDownloadImage,
        lastResult: _history.isNotEmpty
            ? '${_history.last.predictions.first.label} (${(_history.last.predictions.first.confidence * 100).toStringAsFixed(1)}%)'
            : null,
      ),
      ModelScreen(classifier: _classifier!),
    ];

    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'Model'),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _classifier?.close();
    super.dispose();
  }
}
