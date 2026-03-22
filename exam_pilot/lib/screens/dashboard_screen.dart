import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/api_service.dart';
import 'chat_screen.dart';
import 'quiz_screen.dart';
import 'knowledge_vault_screen.dart';
import '../widgets/bottom_navigation_bar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isLoading = true;
  double _progress = 0.0;
  Map<String, dynamic> _insights = {
    "pyq_mastery": "0%",
    "streak": 7,
    "blindspot": "None",
    "recommendation": "Upload notes to start AI analysis!"
  };

  @override
  void initState() {
    super.initState();
    _fetchStats();
  }

  Future<void> _fetchStats() async {
    try {
      final res = await http.get(
        Uri.parse("${ApiService.baseUrl}/dashboard_stats"),
        headers: {
          "ngrok-skip-browser-warning": "true",
          "Content-Type": "application/json",
        },
      ).timeout(const Duration(seconds: 8));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (mounted) {
          setState(() {
            _progress = (data['progress'] ?? 0.0).toDouble();
            _insights = data['insights'] ?? _insights;
            _isLoading = false;
          });
        }
      } else {
        _handleError("Error");
      }
    } catch (e) {
      _handleError(e.toString());
    }
  }

  void _handleError(String error) {
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117), // Deeper Midnight Blue
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF2F6B8F)))
          : Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF0D1117),
              const Color(0xFF161B22),
              const Color(0xFF0D1117),
            ],
          ),
        ),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: _fetchStats,
            color: const Color(0xFF2F6B8F),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 30),
                  _buildProgressBanner(),
                  const SizedBox(height: 35),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('AI Analysis',
                          style: GoogleFonts.poppins(
                              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                      const Icon(Icons.auto_awesome, color: Color(0xFF2F6B8F), size: 20),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildInsightsGrid(),
                  const SizedBox(height: 25),
                  _buildActionCard(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: 0,
          onTap: (index) {
            if (index == 1) Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatScreen()));
            if (index == 2) Navigator.push(context, MaterialPageRoute(builder: (_) => const KnowledgeVaultScreen()));
          }),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Welcome back,', style: GoogleFonts.poppins(fontSize: 14, color: Colors.white38, fontWeight: FontWeight.w500)),
          Text('Vipin 👋', style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
        ]),
        Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1C2128),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              child: const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 26),
            ),
            Positioned(
              right: 12, top: 12,
              child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFF2F6B8F), shape: BoxShape.circle)),
            )
          ],
        )
      ],
    );
  }

  Widget _buildProgressBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1C2128), Color(0xFF0D1117)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFF2F6B8F).withOpacity(0.3)),
        boxShadow: [
          BoxShadow(color: const Color(0xFF2F6B8F).withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10))
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('SYLLABUS MASTERY', style: GoogleFonts.poppins(color: const Color(0xFF2F6B8F), fontWeight: FontWeight.bold, letterSpacing: 1.2, fontSize: 12)),
                const SizedBox(height: 8),
                Text('Keep pushing, Vipin!', style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                const Text('AI is tracking your learning curve.', style: TextStyle(color: Colors.white38, fontSize: 13)),
              ],
            ),
          ),
          Stack(alignment: Alignment.center, children: [
            SizedBox(
              width: 80, height: 80,
              child: CircularProgressIndicator(
                  value: _progress,
                  strokeWidth: 10,
                  strokeCap: StrokeCap.round,
                  backgroundColor: Colors.white10,
                  color: const Color(0xFF2F6B8F)),
            ),
            Text('${(_progress * 100).toInt()}%', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
          ]),
        ],
      ),
    );
  }

  Widget _buildInsightsGrid() {
    return Row(
      children: [
        Expanded(child: _insightCard('📊', 'PYQ Mastery', _insights['pyq_mastery'] ?? '0%', const Color(0xFF2F6B8F))),
        const SizedBox(width: 16),
        Expanded(child: _insightCard('🔥', 'Daily Streak', '${_insights['streak'] ?? 7} Days', Colors.orangeAccent)),
      ],
    );
  }

  Widget _insightCard(String icon, String title, String val, Color accent) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2128),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: accent.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: Text(icon, style: const TextStyle(fontSize: 20)),
          ),
          const SizedBox(height: 16),
          Text(title, style: GoogleFonts.poppins(color: Colors.white38, fontSize: 12, fontWeight: FontWeight.w500)),
          const SizedBox(height: 2),
          Text(val, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
        ],
      ),
    );
  }

  Widget _buildActionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2F6B8F).withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF2F6B8F).withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(backgroundColor: Color(0xFF2F6B8F), child: Icon(Icons.psychology, color: Colors.white)),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Next AI Goal', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
                    Text(_insights['recommendation'] ?? 'Analyze notes for better scores.',
                        style: const TextStyle(color: Colors.white70, fontSize: 13), overflow: TextOverflow.ellipsis),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2F6B8F),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const QuizScreen())),
              child: Text('Start Smart Quiz', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }
}