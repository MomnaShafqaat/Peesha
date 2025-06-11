import 'package:flutter/material.dart';

class FormTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool isRequired;
  final bool isEmail;
  final bool isPhone;
  final int maxLines;

  const FormTextField({
    super.key,
    required this.controller,
    required this.label,
    this.isRequired = false,
    this.isEmail = false,
    this.isPhone = false,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        maxLines: maxLines,
        keyboardType: isEmail
            ? TextInputType.emailAddress
            : isPhone
            ? TextInputType.phone
            : TextInputType.text,
        validator: (value) {
          final trimmed = value?.trim() ?? '';
          if (isRequired && trimmed.isEmpty) {
            return 'This field is required';
          }
          if (isEmail && !RegExp(r'^.+@.+\..+$').hasMatch(trimmed)) {
            return 'Enter a valid email';
          }
          return null;
        },
      ),
    );
  }
}
