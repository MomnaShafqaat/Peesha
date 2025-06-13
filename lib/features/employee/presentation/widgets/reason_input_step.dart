import 'package:flutter/material.dart';

class ReasonInputStep extends StatefulWidget {
  final Function(String reason) onReasonEntered;
  final VoidCallback onNext;
  final VoidCallback onBack; // <-- Add this

  const ReasonInputStep({
    super.key,
    required this.onReasonEntered,
    required this.onNext,
    required this.onBack, // <-- Add this
  });

  @override
  State<ReasonInputStep> createState() => _ReasonInputStepState();
}

class _ReasonInputStepState extends State<ReasonInputStep> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _reasonController = TextEditingController();

  void _submitReason() {
    if (_formKey.currentState!.validate()) {
      widget.onReasonEntered(_reasonController.text.trim());
      widget.onNext();
    }
  }

  @override
  void dispose() {
    _reasonController.dispose();
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
                "Why are you applying for this job?",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _reasonController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: "Your reason",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter your reason'
                    : null,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: widget.onBack, // Back button
                    icon: const Icon(Icons.arrow_back),
                    label: const Text("Back"),
                  ),
                  ElevatedButton.icon(
                    onPressed: _submitReason,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text("Next"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
