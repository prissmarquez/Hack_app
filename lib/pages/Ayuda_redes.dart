import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class RedesHelpScreen extends StatelessWidget {
  const RedesHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFFFF7EF);
    const card = Color(0xFFFFE6D6);
    const card2 = Color(0xFFFFF0D8);
    const textDark = Color(0xFF3B2B22);
    const accent = Color(0xFFB85C38);

    final tutorials = <_Tutorial>[
      const _Tutorial(
        title: 'Crear cuenta de Gmail',
        subtitle: 'Paso a paso para abrir tu correo',
        icon: Icons.email_rounded,
        color: card,
        youtubeVideoId: 'https://youtu.be/C9Q_lSTlvKM?si=3B_o8OWLq_o0Tuiy',
      ),
      const _Tutorial(
        title: 'Crear WhatsApp',
        subtitle: 'Instalar y activar con tu número',
        icon: Icons.chat_rounded,
        color: card2,
        youtubeVideoId: 'https://youtu.be/4kLhrZVrl28?si=MGmVgYfwgHrb0I9C',
      ),
      const _Tutorial(
        title: 'Crear Facebook',
        subtitle: 'Registrarte y configurar tu perfil',
        icon: Icons.people_alt_rounded,
        color: card2,
        youtubeVideoId: 'https://youtu.be/lrANVVQV5tE?si=k-F7bMlTdm8A25RF',
      ),
      
    ];

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text('¿Necesitas ayuda con las redes?'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Elige un tutorial para verlo dentro de la app.',
            style: TextStyle(fontSize: 16, color: textDark.withOpacity(0.75)),
          ),
          const SizedBox(height: 12),

          ...tutorials.map(
            (t) => _TutorialCard(
              tutorial: t,
              accent: accent,
              textDark: textDark,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TutorialVideoScreen(tutorial: t),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TutorialCard extends StatelessWidget {
  final _Tutorial tutorial;
  final Color accent;
  final Color textDark;
  final VoidCallback onTap;

  const _TutorialCard({
    required this.tutorial,
    required this.accent,
    required this.textDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: tutorial.color,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.75),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(tutorial.icon, color: accent, size: 30),
        ),
        title: Text(
          tutorial.title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        subtitle: Text(
          tutorial.subtitle,
          style: TextStyle(color: textDark.withOpacity(0.7)),
        ),
        trailing: const Icon(Icons.play_circle_fill_rounded, size: 34),
        onTap: onTap,
      ),
    );
  }
}

class TutorialVideoScreen extends StatefulWidget {
  final _Tutorial tutorial;
  const TutorialVideoScreen({super.key, required this.tutorial});

  @override
  State<TutorialVideoScreen> createState() => _TutorialVideoScreenState();
}

class _TutorialVideoScreenState extends State<TutorialVideoScreen> {
  late final YoutubePlayerController _yt;

  @override
  void initState() {
    super.initState();

    _yt = YoutubePlayerController.fromVideoId(
      videoId: widget.tutorial.youtubeVideoId,
      autoPlay: false,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        strictRelatedVideos: true,
      ),
    );
  }

  @override
  void dispose() {
    _yt.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const textDark = Color(0xFF3B2B22);

    return Scaffold(
      appBar: AppBar(title: Text(widget.tutorial.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              widget.tutorial.subtitle,
              style: TextStyle(fontSize: 16, color: textDark.withOpacity(0.75)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            AspectRatio(
              aspectRatio: 16 / 9,
              child: YoutubePlayer(controller: _yt),
            ),
            const SizedBox(height: 12),
            const Text(
              'Tip: Si algo no te sale, pausa el video y repite el paso con calma.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _Tutorial {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String youtubeVideoId;

  const _Tutorial({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.youtubeVideoId,
  });
}