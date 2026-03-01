import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/HomeTile.dart';
import 'package:flutter_application_2/pages/Ayuda_redes.dart';
import 'package:flutter_application_2/pages/ChatPage.dart';
import '../services/voice_service.dart';
import 'package:flutter_application_2/pages/Sos_screen.dart';
import 'package:flutter_application_2/pages/Tramites_menu.dart';

class Homepage1 extends StatefulWidget {
  const Homepage1({super.key});

  @override
  State<Homepage1> createState() => _Homepage1State();
}

class _Homepage1State extends State<Homepage1> {
  final VoiceService _voiceService = VoiceService();
  String _personText = '';

  final TextEditingController _chatController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _voiceService.init(
      onSilence: () {
        setState(() {});
        if (_personText.isNotEmpty) {
          _voiceService.speak("Escuché que dijiste: $_personText");
        }
      },
    );
  }

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  void _toggleMic() async {
    if (_voiceService.isListening) {
      await _voiceService.stopListening();
      setState(() {});
    } else {
      await _voiceService.speak("");

      setState(() {
        _personText = "";
      });

      await _voiceService.startListening(
        onTextRecognized: (texto) {
          _personText = texto;
        },
      );
      setState(() {});
    }
  }

  void _sendChat() {
  final text = _chatController.text.trim();
  if (text.isEmpty) return;

  _chatController.clear();

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => ChatPage(initialUserMessage: text),
    ),
  );
}

  void _goToTile(BuildContext context, String title) {
    if (title == 'Ayuda') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SosScreen()),
      );
    } else if (title == 'Trámites') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TramitesMenu()),
      );
    } else if (title == 'Redes') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AyudaRedes()),
      );
    }
  }

  Widget _tileCard({
    required BuildContext context,
    required HomeTile tile,
    required Color accent,
    required Color textDark,
    double? height,
    bool fullWidth = false,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () => _goToTile(context, tile.title),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: tile.color,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: Colors.white.withOpacity(0.8),
            width: 1.2,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.75),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(tile.icon, size: 32, color: accent),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tile.title,
                    style: TextStyle(
                      fontSize: fullWidth ? 24 : 22,
                      fontWeight: FontWeight.w800,
                      color: textDark,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    fullWidth ? 'Toca para abrir ayuda' : 'Toca para abrir',
                    style: TextStyle(
                      fontSize: 16,
                      color: textDark.withOpacity(0.65),
                    ),
                  ),
                ],
              ),
            ),
            if (fullWidth)
              Icon(Icons.chevron_right_rounded,
                  size: 34, color: textDark.withOpacity(0.5)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Paleta cálida suave
    const bg = Color(0xFFFFF7EF); // crema
    const card = Color(0xFFFFE6D6); // durazno claro
    const card2 = Color(0xFFFFF0D8); // beige
    const accent = Color(0xFFB85C38); // terracota
    const textDark = Color(0xFF3B2B22);

    final items = <HomeTile>[
      HomeTile(title: 'Trámites', icon: Icons.assignment_rounded, color: card),
      HomeTile(title: 'Redes', icon: Icons.wifi_rounded, color: card2),
      HomeTile(title: 'Ayuda', icon: Icons.support_agent_rounded, color: card2),
    ];

    final tramites = items[0];
    final redes = items[1];
    final ayuda = items[2];

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
          child: Column(
            children: [
              // ====== BLOQUE DE TILES ======
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _tileCard(
                              context: context,
                              tile: tramites,
                              accent: accent,
                              textDark: textDark,
                              height: 160,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _tileCard(
                              context: context,
                              tile: redes,
                              accent: accent,
                              textDark: textDark,
                              height: 160,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Ayuda largo (ancho completo)
                      _tileCard(
                        context: context,
                        tile: ayuda,
                        accent: accent,
                        textDark: textDark,
                        height: 120,
                        fullWidth: true,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // ====== MICRÓFONO ======
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [
                      accent,
                      Color(0xFF9C4A2F),
                    ],
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
                    onTap: _toggleMic,
                    child: Center(
                      child: Icon(
                        _voiceService.isListening
                            ? Icons.stop_rounded
                            : Icons.mic_rounded,
                        size: 90,
                        color: _voiceService.isListening
                            ? Colors.redAccent
                            : Colors.white,
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

              // ====== CHAT ABAJO DEL MIC ======
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

              if (_personText.isNotEmpty) ...[
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Último mensaje: $_personText",
                    style: TextStyle(
                      fontSize: 15,
                      color: textDark.withOpacity(0.7),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}