import 'package:flutter/material.dart';

class TramiteTile {
  final String title;
  final IconData icon;
  final Color color;
  final String routeName;

  const TramiteTile({
    required this.title,
    required this.icon,
    required this.color,
    required this.routeName,
  });
}