// lib/widgets/subject_progress_card.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/subject_model.dart';

class SubjectProgressCard extends StatelessWidget {
  final Subject subject;
  const SubjectProgressCard({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2A3A),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(subject.icon, style: const TextStyle(fontSize: 28)),
              if (subject.pyqFrequency > 7)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE76F51).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'High PYQ',
                    style: GoogleFonts.inter(fontSize: 8, color: const Color(0xFFE76F51)),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            subject.name,
            style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: subject.progress,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2C7DA0)),
              minHeight: 4,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(subject.progress * 100).toInt()}%',
                style: GoogleFonts.inter(fontSize: 11, color: Colors.white60),
              ),
              if (subject.blindspots.isNotEmpty)
                Text(
                  '${subject.blindspots.length} blindspot',
                  style: GoogleFonts.inter(fontSize: 10, color: const Color(0xFFE76F51)),
                ),
            ],
          ),
        ],
      ),
    );
  }
}