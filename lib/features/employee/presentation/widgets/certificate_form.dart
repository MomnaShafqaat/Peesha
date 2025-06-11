import 'package:flutter/material.dart';
import 'package:peesha/features/employee/data/certificate.dart';

class CertificateForm extends StatelessWidget {
  final int index;
  final Certificate certificate;
  final Function(Certificate) onUpdate;
  final VoidCallback onDelete;

  const CertificateForm({
    super.key,
    required this.index,
    required this.certificate,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController(text: certificate.title);
    final orgController = TextEditingController(text: certificate.organization);
    final issueController = TextEditingController(text: certificate.issueDate);
    final expiryController = TextEditingController(text: certificate.expiryDate);
    final urlController = TextEditingController(text: certificate.certificateUrl);

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
                const Text('Certificate', style: TextStyle(fontWeight: FontWeight.bold)),
                IconButton(icon: const Icon(Icons.delete), onPressed: onDelete),
              ],
            ),
            _buildTextField(titleController, 'Title', isRequired: true),
            _buildTextField(orgController, 'Organization', isRequired: true),
            _buildTextField(issueController, 'Issue Date'),
            _buildTextField(expiryController, 'Expiry Date'),
            _buildTextField(urlController, 'Certificate URL (optional)'),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  onUpdate(Certificate(
                    title: titleController.text,
                    organization: orgController.text,
                    issueDate: issueController.text,
                    expiryDate: expiryController.text,
                    certificateUrl: urlController.text,
                  ));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Certificate updated')),
                  );
                },
                child: const Text('Update'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool isRequired = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
        validator: (value) {
          if (isRequired && (value == null || value.isEmpty)) {
            return 'This field is required';
          }
          return null;
        },
      ),
    );
  }
}
