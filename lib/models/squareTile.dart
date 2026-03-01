
import 'package:flutter/material.dart';

class SquareTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final Color accent;
  final Color textDark;
  final VoidCallback onTap;

  const SquareTile({
    required this.title,
    required this.icon,
    required this.color,
    required this.accent,
    required this.textDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Container(
        height: 165,
        decoration: BoxDecoration(
          color: color,
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
              child: Icon(icon, size: 30, color: accent),
            ),
            const Spacer(),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
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
  }
}