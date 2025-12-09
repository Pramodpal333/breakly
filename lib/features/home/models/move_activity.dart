import 'package:flutter/material.dart';

class MoveActivity {
  final String title;
  final String description;
  final IconData icon;
  final bool isStealth; // True if can be done without standing up

  MoveActivity({
    required this.title,
    required this.description,
    required this.icon,
    this.isStealth = false,
  });
}
