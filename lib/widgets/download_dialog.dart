import 'package:flutter/material.dart';

class DownloadImageDialog extends StatefulWidget {
  const DownloadImageDialog({Key? key}) : super(key: key);

  @override
  State<DownloadImageDialog> createState() => _DownloadImageDialogState();
}

class _DownloadImageDialogState extends State<DownloadImageDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Download Image'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          hintText: 'Enter image URL',
          border: OutlineInputBorder(),
        ),
        maxLines: null,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _controller.text.isEmpty
              ? null
              : () => Navigator.pop(context, _controller.text),
          child: const Text('Download'),
        ),
      ],
    );
  }
}
