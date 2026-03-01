import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/HomeTile.dart';
import 'package:flutter_application_2/pages/Ayuda_redes.dart';
import 'package:flutter_application_2/pages/Sos_screen.dart';
import 'package:flutter_application_2/pages/Tramites_menu.dart';
import 'package:flutter_application_2/pages/goyo_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 1.08,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final tile = items[index];
                    return InkWell(
                      borderRadius: BorderRadius.circular(22),
                      onTap: () {
                        if (tile.title == 'Ayuda') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const SosScreen()),
                          );
                        } else if (tile.title == 'Trámites') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const TramitesMenu()),
                          );
                        } else if (tile.title == 'Redes') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const AyudaRedes()),
                          );
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: tile.color,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.8),
                            width: 1.2,
                          ),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.75),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(tile.icon, size: 30, color: accent),
                            ),
                            const Spacer(),
                            Text(
                              tile.title,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: textDark,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Toca para abrir',
                              style: TextStyle(
                                fontSize: 16,
                                color: textDark.withOpacity(0.65),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 180,
            height: 180,
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
                  color: accent.withOpacity(0.4),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(100),
                onTap: () {
                  // 👇 Aquí abrimos la pantalla donde vive la IA
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const GoyoChatScreen()),
                  );
                },
                child: const Center(
                  child: Icon(
                    Icons.mic_rounded,
                    size: 100,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            "¿Necesitas ayuda?",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
