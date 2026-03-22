import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import '../services/api_service.dart';
import '../widgets/bottom_navigation_bar.dart';

class KnowledgeVaultScreen extends StatefulWidget {
  const KnowledgeVaultScreen({super.key});

  @override
  State<KnowledgeVaultScreen> createState() => _KnowledgeVaultScreenState();
}

class _KnowledgeVaultScreenState extends State<KnowledgeVaultScreen> {
  bool _isUploading = false;
  String _statusMessage = "";
  Color _statusColor = Colors.white70;

  // 📤 Pick and Upload Logic with Filename Display
  Future<void> _pickAndUploadFile(String category) async {
    try {
      // 1. Pick PDF File
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.single.path != null) {
        String fileName = result.files.single.name; // ✨ Filename extract kiya
        String filePath = result.files.single.path!;

        setState(() {
          _isUploading = true;
          _statusMessage = "Uploading $fileName...";
          _statusColor = const Color(0xFF2F6B8F);
        });

        // 2. Prepare API Request
        var request = http.MultipartRequest(
            'POST',
            Uri.parse('${ApiService.baseUrl}/upload')
        );

        request.fields['category'] = category.toLowerCase();
        request.files.add(await http.MultipartFile.fromPath('file', filePath));

        // 3. Send to Backend (main.py)
        var response = await request.send();

        if (response.statusCode == 200) {
          setState(() {
            _statusMessage = "✅ $fileName uploaded successfully!";
            _statusColor = Colors.greenAccent;
          });
        } else {
          setState(() {
            _statusMessage = "❌ Failed to upload $fileName";
            _statusColor = Colors.redAccent;
          });
        }
      }
    } catch (e) {
      setState(() {
        _statusMessage = "⚠️ Error: $e";
        _statusColor = Colors.orangeAccent;
      });
    } finally {
      setState(() => _isUploading = false);
      // Status message ko 4 second baad hide kar do
      Future.delayed(const Duration(seconds: 4), () {
        if (mounted) setState(() => _statusMessage = "");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF12161C),
      appBar: AppBar(
        title: Text('Knowledge Vault',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 20)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Study Library',
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Upload your PDFs to train your AI tutor.',
                style: TextStyle(color: Colors.white54, fontSize: 14)),
            const SizedBox(height: 32),

            // --- Upload Cards ---
            _buildUploadCard('Syllabus', 'Upload course curriculum', Icons.list_alt_rounded, 'syllabus'),
            const SizedBox(height: 16),
            _buildUploadCard('Notes', 'Upload study notes/handouts', Icons.auto_stories_rounded, 'notes'),
            const SizedBox(height: 16),
            _buildUploadCard('PYQs', 'Upload previous year papers', Icons.history_edu_rounded, 'pyqs'),

            const SizedBox(height: 40),

            // --- Dynamic Status Indicator ---
            if (_isUploading)
              const Center(child: CircularProgressIndicator(color: Color(0xFF2F6B8F))),

            if (_statusMessage.isNotEmpty && !_isUploading)
              Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: _statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _statusColor.withOpacity(0.5)),
                  ),
                  child: Text(_statusMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: _statusColor, fontWeight: FontWeight.w600, fontSize: 14)),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: 2,
          onTap: (index) {
            if (index == 0) Navigator.pop(context); // Go back to Dashboard
          }
      ),
    );
  }

  Widget _buildUploadCard(String title, String subtitle, IconData icon, String category) {
    return InkWell(
      onTap: () => _isUploading ? null : _pickAndUploadFile(category),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1C2128),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: const Color(0xFF2F6B8F).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(15)
              ),
              child: Icon(icon, color: const Color(0xFF2F6B8F), size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.poppins(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(color: Colors.white38, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 16),
          ],
        ),
      ),
    );
  }
}