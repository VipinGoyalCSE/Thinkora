// lib/widgets/memory_header.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MemoryHeader extends StatefulWidget {
  final String recallText;
  final bool isActive;

  const MemoryHeader({
    super.key,
    required this.recallText,
    this.isActive = true,
  });

  @override
  State<MemoryHeader> createState() => _MemoryHeaderState();
}

class _MemoryHeaderState extends State<MemoryHeader> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF2C7DA0).withOpacity(0.2),
                const Color(0xFF1E2A3A),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            border: Border(
              bottom: BorderSide(
                color: const Color(0xFF2C7DA0).withOpacity(0.3),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              Transform.scale(
                scale: _pulseAnimation.value,
                child: const Icon(
                  Icons.psychology,
                  color: Color(0xFF2C7DA0),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.recallText,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (widget.isActive)
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2C7DA0),
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}