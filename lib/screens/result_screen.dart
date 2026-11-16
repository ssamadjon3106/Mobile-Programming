import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../services/classifier.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({
    super.key,
    required this.imageBytes,
    required this.predictions,
    required this.source,
  });

  final Uint8List imageBytes;
  final List<Prediction> predictions;
  final String source;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
        leading: BackButton(onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Source: $source',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.memory(imageBytes, fit: BoxFit.contain),
            ),
            const SizedBox(height: 32),
            Text(
              'Classification Results',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ...predictions.asMap().entries.map((entry) {
              final index = entry.key;
              final pred = entry.value;
              final percentage = (pred.confidence * 100).toStringAsFixed(1);
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        pred.label,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: index == 0
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: pred.confidence,
                        minHeight: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '$percentage%',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: index == 0
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
