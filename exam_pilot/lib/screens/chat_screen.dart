import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/chat_message.dart';
import '../widgets/memory_header.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/typing_indicator.dart';
import '../services/api_service.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}class _ChatScreenState extends ConsumerState<ChatScreen> {
  final List<ChatMessage> _messages = [];
  final List<Map<String, String>> _history = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;
  String _recallText = "Thinkora: Connected to Hindsight Memory";

  @override
  void initState() {
    super.initState();
    _addWelcomeMessage();
  }

  void _addWelcomeMessage() {
    const String welcome = "Hi! I'm Thinkora, your AI tutor created by Vipin & CodeMates. I have access to your Syllabus, Notes, and PYQs. How can I help?";
    setState(() {
      _messages.add(ChatMessage.ai(welcome));
      // Memory mein save karo
      _history.add({"role": "assistant", "content": welcome});
    });
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      // 1. UI update karo
      _messages.add(ChatMessage.user(text));
      // 2. Memory (History) update karo
      _history.add({"role": "user", "content": text});

      _controller.clear();
      _isTyping = true;
      _recallText = "Thinkora is searching your notes...";
    });
    _scrollToBottom();

    try {
      // 3. ACTUAL API CALL (Sending full history)
      final String aiReply = await ApiService.askAI(_history);

      setState(() {
        _isTyping = false;

        // 4. Check for special insight keywords
        if (aiReply.toLowerCase().contains('blindspot') || aiReply.toLowerCase().contains('recall')) {
          _messages.add(ChatMessage.insight(aiReply));
        } else {
          _messages.add(ChatMessage.ai(aiReply));
        }

        // 5. AI ka reply memory mein save karo
        _history.add({"role": "assistant", "content": aiReply});

        _recallText = "Memory Updated: Context saved.";
      });
    } catch (e) {
      setState(() {
        _isTyping = false;
        _messages.add(ChatMessage.ai("Connection Error: Python server se baat nahi ho pa rahi."));
      });
    }
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: Text(
          'Thinkora AI',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          MemoryHeader(recallText: _recallText, isActive: _isTyping),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isTyping && index == _messages.length) {
                  return const TypingIndicator();
                }
                return ChatBubble(message: _messages[index]);
              },
            ),
          ),
          _buildQuickReplies(),
          _buildInputField(),
        ],
      ),
    );
  }

  Widget _buildQuickReplies() {
    final chips = ['Show Syllabus', 'Analyze PYQs', 'Create Quiz'];
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: chips.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          return ActionChip(
            label: Text(
              chips[index],
              style: GoogleFonts.inter(fontSize: 12, color: Colors.white),
            ),
            backgroundColor: const Color(0xFF1E2A3A),
            onPressed: () {
              _controller.text = chips[index];
              _sendMessage();
            },
          );
        },
      ),
    );
  }

  Widget _buildInputField() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1E2A3A),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.attach_file, color: Colors.white60),
              onPressed: () {}, // Future: File upload shortcut
            ),
            Expanded(
              child: TextField(
                controller: _controller,
                style: GoogleFonts.inter(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Ask Thinkora...',
                  hintStyle: GoogleFonts.inter(color: Colors.white38),
                  filled: true,
                  fillColor: const Color(0xFF0F172A),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: const Color(0xFF2C7DA0),
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white, size: 18),
                onPressed: _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}