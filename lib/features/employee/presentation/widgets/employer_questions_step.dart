import 'package:flutter/material.dart';

class EmployerQuestionsStep extends StatefulWidget {
  final Function(String availability, String experience) onQuestionsAnswered;
  final VoidCallback onBack;
  final VoidCallback onNext;

  const EmployerQuestionsStep({
    super.key,
    required this.onQuestionsAnswered,
    required this.onBack,
    required this.onNext,
  });

  @override
  State<EmployerQuestionsStep> createState() => _EmployerQuestionsStepState();
}

class _EmployerQuestionsStepState extends State<EmployerQuestionsStep> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _availabilityController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();

  void _submitAnswers() {
    if (_formKey.currentState!.validate()) {
      widget.onQuestionsAnswered(
        _availabilityController.text.trim(),
        _experienceController.text.trim(),
      );
      widget.onNext(); // Go to ReasonInputStep
    }
  }

  @override
  void dispose() {
    _availabilityController.dispose();
    _experienceController.dispose();
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
              const Text(
                "Answer These Questions from the Employer",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _availabilityController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: "Please list 2-3 dates and time ranges where you could do an interview",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _experienceController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: "Describe your experience related to this or a similar job",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value == null || value.isEmpty ? 'This field is required' : null,
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
                    onPressed: _submitAnswers,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text("Continue"),
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
