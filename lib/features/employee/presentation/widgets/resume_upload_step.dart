import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart'; // To preview PDF in browser

class ResumeUploadStep extends StatefulWidget {
  final Function(String resumeUrl, String fileName) onResumeSelected;
  final VoidCallback onNext;

  const ResumeUploadStep({
    super.key,
    required this.onResumeSelected,
    required this.onNext,
  });

  @override
  State<ResumeUploadStep> createState() => _ResumeUploadStepState();
}

class _ResumeUploadStepState extends State<ResumeUploadStep> {
  bool _isUploading = false;
  String? _fileName;
  String? _resumeUrl;

  Future<void> _pickAndUploadFile() async {
    final result = await FilePicker.platform.pickFiles(
      withReadStream: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      final fileName = file.name;

      try {
        setState(() => _isUploading = true);

        final cloudName = 'dzqvnnsyj'; // your Cloudinary cloud name
        final uploadPreset = 'resume_upload'; // your preset (must be unsigned)

        final url = Uri.parse(
            'https://api.cloudinary.com/v1_1/$cloudName/auto/upload');

        final request = http.MultipartRequest('POST', url)
          ..fields['upload_preset'] = uploadPreset
          ..files.add(
            http.MultipartFile(
              'file',
              file.readStream!,
              file.size,
              filename: fileName,
            ),
          );

        final response = await request.send();

        if (response.statusCode == 200) {
          final resStr = await response.stream.bytesToString();
          final data = json.decode(resStr);
          final secureUrl = data['secure_url'];

          setState(() {
            _fileName = fileName;
            _resumeUrl = secureUrl;
          });

          widget.onResumeSelected(secureUrl, fileName);
        } else {
          throw Exception('Failed to upload. Code: ${response.statusCode}');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: $e')),
        );
      } finally {
        setState(() => _isUploading = false);
      }
    }
  }

  void _showPreviewModal() {
    if (_resumeUrl != null) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Preview Resume"),
          content: SizedBox(
            height: 400,
            child: Center(
              child: TextButton.icon(
                icon: Icon(Icons.open_in_new),
                label: const Text("Open Resume in Browser"),
                onPressed: () async {
                  if (await canLaunchUrl(Uri.parse(_resumeUrl!))) {
                    launchUrl(Uri.parse(_resumeUrl!),
                        mode: LaunchMode.externalApplication);
                  }
                },
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasResume = _resumeUrl != null;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Upload Your Resume", style: TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _pickAndUploadFile,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade100,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.upload_file, color: Colors.blue),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        _fileName ?? "Select Resume",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    if (hasResume) ...[
                      const SizedBox(width: 10),
                      IconButton(
                        icon: const Icon(Icons.visibility),
                        tooltip: "Preview",
                        onPressed: _showPreviewModal,
                      )
                    ]
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: hasResume && !_isUploading ? widget.onNext : null,
              child: _isUploading
                  ? const SizedBox(
                  height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text("Continue"),
            ),
          ],
        ),
      ),
    );
  }
}
