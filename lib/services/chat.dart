class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime time;

  ChatMessage({required this.text, required this.isUser, DateTime? time})
      : time = time ?? DateTime.now();
}

/// Singleton simple (vive mientras la app esté abierta)
class ChatStore {
  ChatStore._();
  static final ChatStore instance = ChatStore._();

  final List<ChatMessage> messages = [];

  void addUser(String text) {
    messages.add(ChatMessage(text: text, isUser: true));
  }

  void addBot(String text) {
    messages.add(ChatMessage(text: text, isUser: false));
  }
}