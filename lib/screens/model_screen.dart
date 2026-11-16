import 'package:flutter/material.dart';

import '../services/classifier.dart';

class ModelScreen extends StatelessWidget {
  const ModelScreen({super.key, required this.classifier});

  final Classifier classifier;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Model Info')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Model Information',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            _InfoCard(
              label: 'Number of Classes',
              value: classifier.labels.length.toString(),
            ),
            const SizedBox(height: 12),
            _InfoCard(
              label: 'Input Size',
              value: '${Classifier.inputSize} × ${Classifier.inputSize} pixels',
            ),
            const SizedBox(height: 12),
            _InfoCard(label: 'Model File', value: 'model_unquant.tflite'),
            const SizedBox(height: 32),
            Text('Classes', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            ...classifier.labels.asMap().entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(child: Text((entry.key).toString())),
                        const SizedBox(width: 16),
                        Text(
                          entry.value,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 32),
            Text(
              'Design Credit',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Custom Flutter Design\nTrainable Machine Image Classifier Lab 10',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(value, style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}
