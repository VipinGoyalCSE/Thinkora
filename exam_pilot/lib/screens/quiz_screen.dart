import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/api_service.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<dynamic> _questions = [];
  int _currentIndex = 0;
  int _score = 0;
  bool _loading = false;
  bool _isConfiguring = true;
  String? _selectedOption;
  bool _isAnswered = false;

  Future<void> _fetchQuiz(int count) async {
    setState(() { _loading = true; _isConfiguring = false; });
    try {
      final response = await http.post(
        Uri.parse("${ApiService.baseUrl}/generate_quiz"),
        body: jsonEncode({"count": count}),
        headers: {"Content-Type": "application/json", "ngrok-skip-browser-warning": "true"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<dynamic> tempQuestions = [];

        if (data is List) {
          tempQuestions = data;
        } else if (data is Map) {
          var root = data['quiz'] ?? data['questions'] ?? data;
          if (root is List) {
            tempQuestions = root;
          } else if (root is Map) {
            root.forEach((key, value) {
              if (value is Map && value.containsKey('question')) tempQuestions.add(value);
            });
          }
        }
        setState(() { _questions = tempQuestions; _loading = false; });
      }
    } catch (e) {
      setState(() { _loading = false; });
    }
  }

  // ✨ FIXED: SUPER-SMART ANSWER MATCHING LOGIC ✨
  void _handleAnswer(String selectedOpt) async {
    if (_isAnswered || _questions.isEmpty) return;

    var currentQ = _questions[_currentIndex];

    // 1. Cleaning: Remove spaces and convert to lowercase
    String userSelection = selectedOpt.trim().toLowerCase();
    String correctAnswer = (currentQ['answer'] ?? "").toString().trim().toLowerCase();

    // 2. Option Letter Check (A, B, C, D fallback)
    int selectedIndex = (currentQ['options'] as List).indexOf(selectedOpt);
    String selectedLetter = String.fromCharCode(97 + selectedIndex); // 'a', 'b', etc.

    // 3. Match Logic: Text Match OR Letter Match OR "Option A" style match
    bool isCorrect = (userSelection == correctAnswer) ||
        (correctAnswer == selectedLetter) ||
        (correctAnswer == "option $selectedLetter") ||
        (correctAnswer.startsWith(selectedLetter) && correctAnswer.length < 3);

    setState(() {
      _selectedOption = selectedOpt;
      _isAnswered = true;
      if (isCorrect) _score++;
    });

    // Report to backend for Weak Points (Optional)
    if (!isCorrect) {
      http.post(Uri.parse("${ApiService.baseUrl}/report_error"),
          body: jsonEncode({"question": currentQ['question'], "topic": currentQ['topic'] ?? "General"}),
          headers: {"Content-Type": "application/json"});
    }

    await Future.delayed(const Duration(milliseconds: 1500));

    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedOption = null;
        _isAnswered = false;
      });
    } else {
      _showResultDialog();
    }
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1C2128),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("Quiz Complete! 🎯", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Text("You scored $_score out of ${_questions.length}", style: const TextStyle(color: Colors.white70, fontSize: 18)),
        actions: [
          TextButton(onPressed: () { Navigator.pop(context); Navigator.pop(context); }, child: const Text("Exit to Dashboard")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF12161C),
      body: _isConfiguring ? _buildConfigUI() : (_loading ? _buildLoader() : _buildQuizUI()),
    );
  }

  // --- UI COMPONENTS (PREMIUM DESIGN UNCHANGED) ---

  Widget _buildConfigUI() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF1A212A), Color(0xFF12161C)])),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.bolt_rounded, size: 80, color: Color(0xFF2F6B8F)),
        const SizedBox(height: 20),
        Text("Thinkora Quiz", style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 50),
        _buildConfigButton("Quick Sprint (5 Qs)", 5),
        const SizedBox(height: 15),
        _buildConfigButton("Deep Dive (10 Qs)", 10),
      ]),
    );
  }

  Widget _buildConfigButton(String label, int count) {
    return SizedBox(width: 280, height: 60, child: ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2F6B8F), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
      onPressed: () => _fetchQuiz(count),
      child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    ));
  }

  Widget _buildLoader() {
    return const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      CircularProgressIndicator(color: Color(0xFF2F6B8F)),
      SizedBox(height: 20),
      Text("AI is analyzing your notes...", style: TextStyle(color: Colors.white70)),
    ]));
  }

  Widget _buildQuizUI() {
    if (_questions.isEmpty) return const Center(child: Text("Error: No Data", style: TextStyle(color: Colors.white)));
    var q = _questions[_currentIndex];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text("Q ${_currentIndex + 1}/${_questions.length}", style: const TextStyle(color: Colors.white54)),
            Text("Score: $_score", style: const TextStyle(color: Color(0xFF2F6B8F), fontWeight: FontWeight.bold)),
          ]),
          const SizedBox(height: 10),
          LinearProgressIndicator(value: (_currentIndex + 1) / _questions.length, backgroundColor: Colors.white10, color: const Color(0xFF2F6B8F)),
          const SizedBox(height: 40),
          Text(q['question'] ?? "", style: GoogleFonts.poppins(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600)),
          const SizedBox(height: 35),
          Expanded(
            child: ListView.builder(
              itemCount: (q['options'] as List).length,
              itemBuilder: (context, index) {
                String opt = q['options'][index].toString();
                bool isSelected = _selectedOption == opt;

                // UI Color Logic
                Color borderCol = Colors.white10;
                if (_isAnswered) {
                  String cleanOpt = opt.trim().toLowerCase();
                  String cleanAns = (q['answer'] ?? "").toString().trim().toLowerCase();
                  bool isThisCorrect = (cleanOpt == cleanAns) || (cleanAns == String.fromCharCode(97 + index));

                  if (isThisCorrect) borderCol = Colors.greenAccent;
                  else if (isSelected) borderCol = Colors.redAccent;
                } else if (isSelected) {
                  borderCol = const Color(0xFF2F6B8F);
                }

                return GestureDetector(
                  onTap: () => _handleAnswer(opt),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(bottom: 18),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isSelected ? borderCol.withOpacity(0.1) : const Color(0xFF1C2128),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: borderCol, width: 2),
                    ),
                    child: Text(opt, style: const TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                );
              },
            ),
          ),
        ]),
      ),
    );
  }
}