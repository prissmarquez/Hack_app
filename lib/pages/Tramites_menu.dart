import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/TrimteTile.dart';
import 'package:flutter_application_2/pages/TramiteCurp.dart';

class TramitesMenu extends StatefulWidget {
  const TramitesMenu({super.key});

  @override
  State<TramitesMenu> createState() => _TramitesMenuState();
}

class _TramitesMenuState extends State<TramitesMenu> {
  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFFFF7EF);
    const card = Color(0xFFFFE6D6);
    const card2 = Color(0xFFFFF0D8);
    const accent = Color(0xFFB85C38);
    const textDark = Color(0xFF3B2B22);

    final items = <TramiteTile>[
      const TramiteTile(title: 'CURP', icon: Icons.badge_rounded, color: card, routeName: ''),
      const TramiteTile(title: 'Pasaporte', icon: Icons.flight_takeoff_rounded, color: card2, routeName: ''),
      const TramiteTile(title: 'INE', icon: Icons.perm_identity_rounded, color: card2, routeName: ''),
      const TramiteTile(title: 'Pensión', icon: Icons.volunteer_activism_rounded, color: card, routeName: ''),
    ];

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: textDark),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                style: TextStyle(fontSize: 16, color: textDark.withOpacity(0.7)),
              ),
              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.search_rounded),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Buscar trámite (ej. CURP, INE...)',
                          border: InputBorder.none,
                        ),
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
                        // ✅ TODOS VAN A TRAMITECURP
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) =>  Tramitecurp()),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: tile.color,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: Colors.white.withOpacity(0.8), width: 1.2),
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
                              style: TextStyle(fontSize: 16, color: textDark.withOpacity(0.65)),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: null,
    );
  }
}