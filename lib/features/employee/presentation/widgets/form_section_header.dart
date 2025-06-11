import 'package:flutter/material.dart';

class FormSectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onAdd;

  const FormSectionHeader({
    super.key,
    required this.title,
    this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          if (onAdd != null)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: onAdd,
            ),
        ],
      ),
    );
  }
}
