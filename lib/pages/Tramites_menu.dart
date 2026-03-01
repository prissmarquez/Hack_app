import 'package:flutter/material.dart';

// IMPORTA TUS PANTALLAS REALES
import 'curp_help_screen.dart';
import 'pasaporte_help_screen.dart';
import 'ine_help_screen.dart';
import 'pension_help_screen.dart';

class TramitesMenuPage extends StatelessWidget {
  const TramitesMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFFFF7EF);
    const card = Color(0xFFFFE6D6);
    const card2 = Color(0xFFFFF0D8);
    const accent = Color(0xFFB85C38);
    const textDark = Color(0xFF3B2B22);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text("Te ayudo con tus trámites"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childAspectRatio: 1.05,
          children: [

            // -------- CURP --------
            _buildTile(
              context,
              title: "CURP",
              icon: Icons.badge_rounded,
              color: card,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CurpHelpScreen(),
                  ),
                );
              },
            ),

            // -------- PASAPORTE --------
            _buildTile(
              context,
              title: "Pasaporte",
              icon: Icons.flight_takeoff_rounded,
              color: card2,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PasaporteHelpScreen(),
                  ),
                );
              },
            ),

            // -------- INE --------
            _buildTile(
              context,
              title: "INE",
              icon: Icons.perm_identity_rounded,
              color: card2,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const IneHelpScreen(),
                  ),
                );
              },
            ),

            // -------- PENSIÓN --------
            _buildTile(
              context,
              title: "Pensión",
              icon: Icons.volunteer_activism_rounded,
              color: card,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PensionHelpScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    const accent = Color(0xFFB85C38);
    const textDark = Color(0xFF3B2B22);

    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(22),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 40, color: accent),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: textDark,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "Toca para abrir",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}