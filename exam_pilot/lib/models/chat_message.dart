// lib/models/chat_message.dart
enum MessageType { user, ai, insight }

class ChatMessage {
  final String id;
  final String text;
  final MessageType type;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata; // e.g., { "pyqCount": 3, "topic": "Newton's 3rd Law" }

  ChatMessage({
    required this.id,
    required this.text,
    required this.type,
    required this.timestamp,
    this.metadata,
  });

  factory ChatMessage.user(String text) => ChatMessage(
    id: DateTime.now().millisecondsSinceEpoch.toString(),
    text: text,
    type: MessageType.user,
    timestamp: DateTime.now(),
  );

  factory ChatMessage.ai(String text) => ChatMessage(
    id: DateTime.now().millisecondsSinceEpoch.toString(),
    text: text,
    type: MessageType.ai,
    timestamp: DateTime.now(),
  );

  factory ChatMessage.insight(String text, {Map<String, dynamic>? metadata}) => ChatMessage(
    id: DateTime.now().millisecondsSinceEpoch.toString(),
    text: text,
    type: MessageType.insight,
    timestamp: DateTime.now(),
    metadata: metadata,
  );
}