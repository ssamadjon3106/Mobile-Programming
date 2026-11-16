import 'package:flutter/material.dart';

import '../main.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({
    super.key,
    required this.entries,
    required this.onEntryTap,
  });

  final List<HistoryEntry> entries;
  final Function(HistoryEntry) onEntryTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: entries.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No classifications yet',
                    style: Theme.of(context).textTheme.bodyLarge
                        ?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[entries.length - 1 - index];
                final topLabel = entry.predictions.first.label;
                final topPercentage = (entry.predictions.first.confidence * 100)
                    .toStringAsFixed(1);

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: MemoryImage(entry.imageBytes),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text(
                      topLabel,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('$topPercentage% • ${entry.source}'),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () => onEntryTap(entry),
                  ),
                );
              },
            ),
    );
  }
}
