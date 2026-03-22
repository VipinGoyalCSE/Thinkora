import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/uploaded_document.dart';

class DocumentStatusTile extends StatelessWidget {
  final UploadedDocument doc;

  const DocumentStatusTile({super.key, required this.doc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2128),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Icon based on status
          _buildStatusIcon(),
          const SizedBox(width: 12),
          // Document name and status details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doc.name,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                _buildStatusText(),
              ],
            ),
          ),
          // Action button if needed (e.g., retry)
          if (doc.status == DocumentStatus.error)
            IconButton(
              icon: const Icon(Icons.refresh, color: Color(0xFFD97A5C), size: 18),
              onPressed: () {},
            ),
        ],
      ),
    );
  }

  Widget _buildStatusIcon() {
    switch (doc.status) {
      case DocumentStatus.uploading:
        return const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2F6B8F)),
          ),
        );
      case DocumentStatus.processing:
        return Shimmer.fromColors(
          baseColor: const Color(0xFF2F6B8F).withOpacity(0.4),
          highlightColor: const Color(0xFF2F6B8F).withOpacity(0.8),
          child: Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
        );
      case DocumentStatus.processed:
        return const Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 20);
      case DocumentStatus.error:
        return const Icon(Icons.error, color: Color(0xFFD97A5C), size: 20);
    }
  }

  Widget _buildStatusText() {
    switch (doc.status) {
      case DocumentStatus.uploading:
        return Text(
          'Uploading...',
          style: GoogleFonts.inter(fontSize: 12, color: Colors.white60),
        );
      case DocumentStatus.processing:
        return Text(
          'Scanning for topics...',
          style: GoogleFonts.inter(fontSize: 12, color: Colors.white60),
        );
      case DocumentStatus.processed:
        return Text(
          'Analyzed (${doc.topicsFound} Topics Found)',
          style: GoogleFonts.inter(
            fontSize: 12,
            color: const Color(0xFF4CAF50),
            fontWeight: FontWeight.w500,
          ),
        );
      case DocumentStatus.error:
        return Text(
          doc.errorMessage ?? 'Upload failed',
          style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFFD97A5C)),
        );
    }
  }
}