import 'package:flutter/material.dart';
import 'package:peesha/features/employee/data/experience.dart';
import 'form_text_field.dart';
import 'package:peesha/features/employee/data/experience.dart';

class ExperienceForm extends StatefulWidget {
  final int index;
  final Experience experience;
  final ValueChanged<Experience> onChanged;
  final VoidCallback onDelete;

  const ExperienceForm({
    super.key,
    required this.index,
    required this.experience,
    required this.onChanged,
    required this.onDelete,
  });

  @override
  State<ExperienceForm> createState() => _ExperienceFormState();
}

class _ExperienceFormState extends State<ExperienceForm> {
  late TextEditingController titleController;
  late TextEditingController companyController;
  late TextEditingController locationController;
  late TextEditingController websiteController;
  late TextEditingController typeController;
  late TextEditingController startDateController;
  late TextEditingController endDateController;
  late TextEditingController descriptionController;
  late TextEditingController referenceNameController;
  late TextEditingController referenceEmailController;
  late TextEditingController referencePositionController;
  late TextEditingController referencePhoneController;

  bool isCurrent = false;
  bool isRemote = false;
  bool isHybrid = false;

  @override
  void initState() {
    super.initState();
    final e = widget.experience;
    titleController = TextEditingController(text: e.jobTitle);
    companyController = TextEditingController(text: e.company);
    locationController = TextEditingController(text: e.location);
    websiteController = TextEditingController(text: e.companyWebsite ?? '');
    typeController = TextEditingController(text: e.employmentType);
    startDateController = TextEditingController(text: e.startDate);
    endDateController = TextEditingController(text: e.endDate ?? '');
    descriptionController = TextEditingController(text: e.description);
    isCurrent = e.isCurrent;
    isRemote = e.isRemote;
    isHybrid = e.isHybrid;
    referenceNameController = TextEditingController(text: e.reference?.name ?? '');
    referencePositionController = TextEditingController(text: e.reference?.position ?? '');
    referenceEmailController = TextEditingController(text: e.reference?.contactEmail ?? '');
    referencePhoneController = TextEditingController(text: e.reference?.phone ?? '');
  }

  void _updateExperience() {
    widget.onChanged(
      Experience(
        jobTitle: titleController.text,
        company: companyController.text,
        location: locationController.text,
        companyWebsite: websiteController.text,
        employmentType: typeController.text,
        startDate: startDateController.text,
        endDate: isCurrent ? null : endDateController.text,
        isCurrent: isCurrent,
        description: descriptionController.text,
        isRemote: isRemote,
        isHybrid: isHybrid,
        reference: referenceNameController.text.isNotEmpty
            ? ReferencePerson(
          name: referenceNameController.text,
          position: referencePositionController.text,
          contactEmail: referenceEmailController.text,
          phone: referencePhoneController.text,
        )
            : null,
      ),
    );
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
                const Text('Experience', style: TextStyle(fontWeight: FontWeight.bold)),
                IconButton(icon: const Icon(Icons.delete), onPressed: widget.onDelete),
              ],
            ),
            FormTextField(controller: titleController, label: 'Job Title'),
            FormTextField(controller: companyController, label: 'Company'),
            FormTextField(controller: locationController, label: 'Location'),
            FormTextField(controller: websiteController, label: 'Company Website'),
            FormTextField(controller: typeController, label: 'Employment Type'),
            Row(
              children: [
                Expanded(child: FormTextField(controller: startDateController, label: 'Start Date')),
                const SizedBox(width: 16),
                Expanded(
                  child: isCurrent
                      ?  TextField(
                    decoration: InputDecoration(labelText: 'End Date'),
                    enabled: false,
                    controller: TextEditingController(text: 'Present'),
                  )
                      : FormTextField(controller: endDateController, label: 'End Date'),
                ),
              ],
            ),
            Row(
              children: [
                Checkbox(value: isCurrent, onChanged: (v) => setState(() => isCurrent = v ?? false)),
                const Text('Currently working here'),
              ],
            ),
            FormTextField(controller: descriptionController, label: 'Description', maxLines: 2),
            Row(
              children: [
                Checkbox(value: isRemote, onChanged: (v) => setState(() => isRemote = v ?? false)),
                const Text('Remote'),
                Checkbox(value: isHybrid, onChanged: (v) => setState(() => isHybrid = v ?? false)),
                const Text('Hybrid'),
              ],
            ),
            const Divider(),
            const Text('Reference', style: TextStyle(fontWeight: FontWeight.bold)),
            FormTextField(controller: referenceNameController, label: 'Name'),
            FormTextField(controller: referencePositionController, label: 'Position'),
            FormTextField(controller: referenceEmailController, label: 'Email'),
            FormTextField(controller: referencePhoneController, label: 'Phone'),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: _updateExperience,
                child: const Text('Update'),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    companyController.dispose();
    locationController.dispose();
    websiteController.dispose();
    typeController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    descriptionController.dispose();
    referenceNameController.dispose();
    referenceEmailController.dispose();
    referencePositionController.dispose();
    referencePhoneController.dispose();
    super.dispose();
  }
}
