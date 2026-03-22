import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/uploaded_document.dart';
import '../services/api_service.dart';
import 'dart:math';

final uploadedDocumentsProvider = StateNotifierProvider<UploadNotifier, List<UploadedDocument>>((ref) {
  return UploadNotifier();
});

class UploadNotifier extends StateNotifier<List<UploadedDocument>> {
  UploadNotifier() : super([]);

  // 🚀 UPDATED: Ab ye category bhi lega (Syllabus, Notes, ya PYQs)
  Future<void> addDocument(String name, String category, String filePath) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();

    final newDoc = UploadedDocument(
      id: id,
      name: name,
      category: category,
      uploadedAt: DateTime.now(),
      status: DocumentStatus.uploading,
    );

    state = [...state, newDoc];

    try {
      // 🚀 FIX: Ab yahan 2 arguments bhej rahe hain
      final String result = await ApiService.uploadPDF(filePath, category);

      if (result == "Success") {
        state = state.map((doc) {
          if (doc.id == id) {
            return doc.copyWith(
              status: DocumentStatus.processed,
              topicsFound: Random().nextInt(10) + 5,
            );
          }
          return doc;
        }).toList();
      } else {
        _handleError(id, "Upload Failed on Server");
      }
    } catch (e) {
      print("Upload Error: $e");
      _handleError(id, e.toString());
    }
  }

  void _handleError(String id, String message) {
    state = state.map((doc) {
      if (doc.id == id) {
        return doc.copyWith(
          status: DocumentStatus.error,
          errorMessage: message,
        );
      }
      return doc;
    }).toList();
  }
}