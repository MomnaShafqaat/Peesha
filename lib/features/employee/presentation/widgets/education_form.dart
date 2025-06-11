import 'package:flutter/material.dart';
import 'package:peesha/features/employee/data/education.dart';
import 'form_text_field.dart';

class EducationForm extends StatefulWidget {
  final int index;
  final Education education;
  final ValueChanged<Education> onChanged;
  final VoidCallback onDelete;

  const EducationForm({
    super.key,
    required this.index,
    required this.education,
    required this.onChanged,
    required this.onDelete,
  });

  @override
  State<EducationForm> createState() => _EducationFormState();
}

class _EducationFormState extends State<EducationForm> {
  late TextEditingController levelController;
  late TextEditingController instituteController;
  late TextEditingController boardController;
  late TextEditingController countryController;
  late TextEditingController fieldController;
  late TextEditingController startDateController;
  late TextEditingController endDateController;
  late TextEditingController resultController;
  bool isOngoing = false;
  bool isInternational = false;

  @override
  void initState() {
    super.initState();
    final e = widget.education;
    levelController = TextEditingController(text: e.level);
    instituteController = TextEditingController(text: e.instituteName);
    boardController = TextEditingController(text: e.boardOrUniversity);
    countryController = TextEditingController(text: e.country);
    fieldController = TextEditingController(text: e.fieldOfStudy);
    startDateController = TextEditingController(text: e.startDate);
    endDateController = TextEditingController(text: e.endDate);
    resultController = TextEditingController(text: e.result);
    isOngoing = e.isOngoing;
    isInternational = e.isInternational;
  }

  void _updateEducation() {
    widget.onChanged(Education(
      level: levelController.text,
      instituteName: instituteController.text,
      boardOrUniversity: boardController.text,
      country: countryController.text,
      fieldOfStudy: fieldController.text,
      startDate: startDateController.text,
      endDate: isOngoing ? '' : endDateController.text,
      result: resultController.text,
      isOngoing: isOngoing,
      isInternational: isInternational,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Education', style: TextStyle(fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: widget.onDelete,
                ),
              ],
            ),
            FormTextField(controller: levelController, label: 'Education Level', isRequired: true),
            FormTextField(controller: instituteController, label: 'Institute Name', isRequired: true),
            FormTextField(controller: boardController, label: 'Board/University', isRequired: true),
            FormTextField(controller: countryController, label: 'Country', isRequired: true),
            FormTextField(controller: fieldController, label: 'Field of Study', isRequired: true),
            Row(
              children: [
                Expanded(
                  child: FormTextField(
                    controller: startDateController,
                    label: 'Start Date',
                    isRequired: true,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: isOngoing
                      ? TextFormField(
                    controller: TextEditingController(text: 'Present'),
                    enabled: false,
                    decoration: const InputDecoration(labelText: 'End Date'),
                  )
                      : FormTextField(controller: endDateController, label: 'End Date'),
                ),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: isOngoing,
                  onChanged: (value) {
                    setState(() => isOngoing = value ?? false);
                    _updateEducation();
                  },
                ),
                const Text('Currently studying here'),
                const Spacer(),
                Checkbox(
                  value: isInternational,
                  onChanged: (value) {
                    setState(() => isInternational = value ?? false);
                    _updateEducation();
                  },
                ),
                const Text('International education'),
              ],
            ),
            FormTextField(controller: resultController, label: 'Result/Grade', isRequired: true),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: _updateEducation,
                child: const Text('Update'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    levelController.dispose();
    instituteController.dispose();
    boardController.dispose();
    countryController.dispose();
    fieldController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    resultController.dispose();
    super.dispose();
  }
}
