import 'package:flutter/material.dart';

class TramitesMenu extends StatefulWidget {
  const TramitesMenu({super.key});

  @override
  State<TramitesMenu> createState() => _TramitesMenuState();
}

class _TramitesMenuState extends State<TramitesMenu> {
  @override
  Widget build(BuildContext context) {
    // Paleta cálida suave
    const bg = Color(0xFFFFF7EF); // crema
    const card = Color(0xFFFFE6D6); // durazno claro
    const card2 = Color(0xFFFFF0D8); // beige
    const accent = Color(0xFFB85C38); // terracota
    const textDark = Color(0xFF3B2B22);

    final items = <_TramiteTile>[
      const _TramiteTile(
        title: 'CURP',
        icon: Icons.badge_rounded,
        color: card,
        routeName: '/tramites/curp',
      ),
      const _TramiteTile(
        title: 'Pasaporte',
        icon: Icons.flight_takeoff_rounded,
        color: card2,
        routeName: '/tramites/pasaporte',
      ),
      const _TramiteTile(
        title: 'INE',
        icon: Icons.perm_identity_rounded,
        color: card2,
        routeName: '/tramites/ine',
      ),
      const _TramiteTile(
        title: 'Pensión',
        icon: Icons.volunteer_activism_rounded,
        color: card,
        routeName: '/tramites/pension',
      ),
    ];

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título
              const Text(
                'Te ayudo con tus trámites',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: textDark,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Elige uno para ver el tutorial y la página oficial.',
                style: TextStyle(
                  fontSize: 16,
                  color: textDark.withOpacity(0.7),
                ),
              ),

              const SizedBox(height: 16),

              // Search
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search_rounded),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        style: const TextStyle(
                          fontSize: 18,
                          height: 1.2,
                          color: textDark,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Buscar trámite (ej. CURP, INE...)',
                          hintStyle: TextStyle(fontSize: 18),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                        ),
                        // (Opcional) aquí luego filtramos items
                      ),
                    ),
                  ],
                ),
              ),

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
                        // Cambia a pushReplacement si no quieres "atrás"
                        Navigator.pushNamed(context, tile.routeName);
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
                  // Aquí irá la IA
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
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _TramiteTile {
  final String title;
  final IconData icon;
  final Color color;
  final String routeName;

  const _TramiteTile({
    required this.title,
    required this.icon,
    required this.color,
    required this.routeName,
  });
}