import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/WideTile.dart';
import 'package:flutter_application_2/models/squareTile.dart';
import 'package:flutter_application_2/pages/Ayuda_redes.dart';
import 'package:flutter_application_2/pages/Sos_screen.dart';
import 'package:flutter_application_2/pages/Tramites_menu.dart';
import 'package:flutter_application_2/pages/goyo_page.dart';

class Homepage1 extends StatefulWidget {
  const Homepage1({super.key});

  @override
  State<Homepage1> createState() => _Homepage1State();
}

class _Homepage1State extends State<Homepage1> {
  final TextEditingController _chatController = TextEditingController();

  // Paleta
  static const bg = Color(0xFFFFF7EF);
  static const card = Color(0xFFFFE6D6);
  static const card2 = Color(0xFFFFF0D8);
  static const accent = Color(0xFFB85C38);
  static const textDark = Color(0xFF3B2B22);

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  void _openGoyo({String? initialMessage}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GoyoChatScreen(initialMessage: initialMessage),
      ),
    );
  }

  void _sendChat() {
    final text = _chatController.text.trim();
    if (text.isEmpty) return;

    _chatController.clear();
    FocusScope.of(context).unfocus();
    _openGoyo(initialMessage: text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
            child: Column(
              children: [
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: SquareTile(
                        title: "Trámites",
                        icon: Icons.assignment_rounded,
                        color: card,
                        accent: accent,
                        textDark: textDark,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const TramitesMenu()),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: SquareTile(
                        title: "Redes",
                        icon: Icons.wifi_rounded,
                        color: card2,
                        accent: accent,
                        textDark: textDark,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const AyudaRedes()),
                          );
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                WideTile(
                  title: "Ayuda",
                  subtitle: "Toca para abrir ayuda",
                  icon: Icons.support_agent_rounded,
                  color: card2,
                  accent: accent,
                  textDark: textDark,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SosScreen()),
                    );
                  },
                ),

                const SizedBox(height: 100),

                // 🎤 Micrófono → abre IA
                Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [accent, Color(0xFF9C4A2F)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: accent.withOpacity(0.35),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(100),
                      onTap: () => _openGoyo(),
                      child: const Center(
                        child: Icon(
                          Icons.mic_rounded,
                          size: 90,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),
                const Text(
                  "¿Necesitas ayuda?",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 10),

                // 💬 Chat → abre IA con mensaje
                Container(
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
                          controller: _chatController,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) => _sendChat(),
                          style: const TextStyle(fontSize: 18, color: textDark),
                          decoration: InputDecoration(
                            hintText: "Escribe aquí si no quieres hablar…",
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
                        onTap: _sendChat,
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: accent.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.send_rounded,
                            size: 26,
                            color: accent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}