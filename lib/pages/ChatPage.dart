import 'package:flutter/material.dart';
import 'package:flutter_application_2/services/chat.dart';

class ChatPage extends StatefulWidget {
  final String? initialUserMessage;
  const ChatPage({super.key, this.initialUserMessage});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _controller = TextEditingController();
  final _store = ChatStore.instance;
  final _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // Inicializar la IA
    _store.initAI(userName: "Don Arturo");

    // Si entró con un primer mensaje desde Home
    final init = widget.initialUserMessage?.trim();
    if (init != null && init.isNotEmpty) {
      _handleInitialMessage(init);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _handleInitialMessage(String message) async {
    _store.addUser(message);
    _store.addBot("Pensando...");
    _scrollToBottom();
    
    final response = await _store.sendToAI(message);
    
    if (mounted) {
      setState(() {
        // Reemplazar el mensaje de "Pensando..." con la respuesta real
        _store.messages.removeLast();
        _store.addBot(response ?? "Perdón, no le entendí bien.");
      });
      _scrollToBottom();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent + 120,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  void _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _store.addUser(text);
      _controller.clear();
      _isLoading = true;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    // Enviar a la IA y obtener respuesta
    final response = await _store.sendToAI(text);
    
    if (mounted) {
      setState(() {
        _store.addBot(response ?? "Perdón, no le entendí bien.");
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFFFF7EF);
    const accent = Color(0xFFB85C38);
    const textDark = Color(0xFF3B2B22);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        title: const Text("Chat de ayuda"),
        foregroundColor: textDark,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              itemCount: _store.messages.length,
              itemBuilder: (context, i) {
                final m = _store.messages[i];
                final align =
                    m.isUser ? Alignment.centerRight : Alignment.centerLeft;
                final bubbleColor = m.isUser
                    ? accent.withOpacity(0.18)
                    : Colors.white.withOpacity(0.85);

                return Align(
                  alignment: align,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    constraints: const BoxConstraints(maxWidth: 320),
                    decoration: BoxDecoration(
                      color: bubbleColor,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.9),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      m.text,
                      style: const TextStyle(fontSize: 18, color: textDark),
                    ),
                  ),
                );
              },
            ),
          ),

          // Input
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.75),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: Colors.white.withOpacity(0.9),
                  width: 1.2,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _send(),
                      style: const TextStyle(fontSize: 18, color: textDark),
                      decoration: InputDecoration(
                        hintText: "Escribe tu mensaje…",
                        hintStyle: TextStyle(
                          fontSize: 17,
                          color: textDark.withOpacity(0.55),
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: _send,
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: accent.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.send_rounded,
                          size: 26, color: accent),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}