// lib/widgets/blindspot_alert_card.dart
// lib/widgets/blindspot_alert_card.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/subject_model.dart';

class BlindspotAlertCard extends StatelessWidget {
  final List<Blindspot> blindspots;
  final String subjectName;

  const BlindspotAlertCard({super.key, required this.blindspots, required this.subjectName});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1C2128),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD4A373).withOpacity(0.4), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: const Color(0xFFD4A373), size: 20),
                const SizedBox(width: 8),
                Text(
                  'Blindspot Alert',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFD4A373),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '$subjectName has ${blindspots.length} high-priority topic${blindspots.length > 1 ? 's' : ''} with frequent PYQs',
              style: GoogleFonts.inter(fontSize: 14, color: Colors.white70),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: blindspots.map((b) => _blindspotChip(b)).toList(),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4A373),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  elevation: 0,
                ),
                child: Text('Generate Recovery Plan', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _blindspotChip(Blindspot blindspot) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFD4A373).withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '${blindspot.topic} (${(blindspot.probability * 100).toInt()}% PYQ)',
        style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFFD4A373)),
      ),
    );
  }
}