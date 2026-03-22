enum DocumentStatus {
  uploading,
  processing,
  processed,
  error,
}

class UploadedDocument {
  final String id;
  final String name;
  final String category; // syllabus, pyqs, notes
  final DateTime uploadedAt;
  DocumentStatus status;
  int? topicsFound;
  String? errorMessage;

  UploadedDocument({
    required this.id,
    required this.name,
    required this.category,
    required this.uploadedAt,
    this.status = DocumentStatus.uploading,
    this.topicsFound,
    this.errorMessage,
  });

  UploadedDocument copyWith({
    DocumentStatus? status,
    int? topicsFound,
    String? errorMessage,
  }) {
    return UploadedDocument(
      id: id,
      name: name,
      category: category,
      uploadedAt: uploadedAt,
      status: status ?? this.status,
      topicsFound: topicsFound ?? this.topicsFound,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}