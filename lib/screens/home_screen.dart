import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key? key,
    required this.onTakePhoto,
    required this.onChooseGallery,
    required this.onDownloadImage,
    required this.lastResult,
  }) : super(key: key);

  final VoidCallback onTakePhoto;
  final VoidCallback onChooseGallery;
  final VoidCallback onDownloadImage;
  final String? lastResult;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Image Sources',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onTakePhoto,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Take a Photo'),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onChooseGallery,
              icon: const Icon(Icons.photo_library),
              label: const Text('Choose from Gallery'),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onDownloadImage,
              icon: const Icon(Icons.download),
              label: const Text('Download an Image'),
            ),
            const SizedBox(height: 48),
            if (lastResult != null) ...[
              Text(
                'Last Result',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(lastResult!),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
