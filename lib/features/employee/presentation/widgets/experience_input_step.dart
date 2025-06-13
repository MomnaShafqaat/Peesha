import 'package:flutter/material.dart';

class ExperienceInputStep extends StatefulWidget {
  final Function(String title, String company) onExperienceEntered;
  final VoidCallback onNext;
  final VoidCallback onBack; // <-- Add this

  const ExperienceInputStep({
    super.key,
    required this.onExperienceEntered,
    required this.onNext,
    required this.onBack, // <-- Add this
  });

  @override
  State<ExperienceInputStep> createState() => _ExperienceInputStepState();
}

class _ExperienceInputStepState extends State<ExperienceInputStep> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();

  void _submitExperience() {
    if (_formKey.currentState!.validate()) {
      widget.onExperienceEntered(
        _titleController.text.trim(),
        _companyController.text.trim(),
      );
      widget.onNext();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _companyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Enter Job Experience", style: TextStyle(fontSize: 20)),
              const SizedBox(height: 20),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Job Title"),
                validator: (value) =>
                value == null || value.isEmpty ? 'Please enter job title' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _companyController,
                decoration: const InputDecoration(labelText: "Company Name"),
                validator: (value) =>
                value == null || value.isEmpty ? 'Please enter company name' : null,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: widget.onBack,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text("Back"),
                  ),
                  ElevatedButton.icon(
                    onPressed: _submitExperience,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text("Next"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
