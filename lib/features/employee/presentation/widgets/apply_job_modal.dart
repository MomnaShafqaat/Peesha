import 'package:flutter/material.dart';

class ApplyJobModal extends StatelessWidget {
  final VoidCallback onUploadResume;
  final VoidCallback onUsePeeshaResume;

  const ApplyJobModal({
    super.key,
    required this.onUploadResume,
    required this.onUsePeeshaResume,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Apply for Job'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton.icon(
            onPressed: onUploadResume,
            icon: const Icon(Icons.upload_file),
            label: const Text('Upload Resume'),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: onUsePeeshaResume,
            icon: const Icon(Icons.description),
            label: const Text('Use Peesha Resume'),
          ),
        ],
      ),
    );
  }
}