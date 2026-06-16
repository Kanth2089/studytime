import 'package:flutter/material.dart';

class AppColors {
  // Dark Blue backgrounds
  static const Color darkBg = Color(0xFF071224);
  static const Color darkCard = Color(0x1F1E293B);
  static const Color darkNavBg = Color(0xFF0B192E);
  
  // Sky Blue Accents
  static const Color skyBlue = Color(0xFF00D2FF);
  static const Color skyBlueDark = Color(0xFF0088CC);
  static const Color skyBlueLight = Color(0xFFE0F7FA);

  // General colors
  static const Color primary = Color(0xFF00B0FF);
  static const Color textPrimary = Color(0xFFF1F5F9);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color border = Color(0x2400D2FF);
  static const Color borderLight = Color(0x1AFFFFFF);

  // Success, Warning, Info, Error
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  
  // Glassmorphic Gradients
  static const List<Color> bgGradient = [
    Color(0xFF050B14),
    Color(0xFF0F2038),
    Color(0xFF071224),
  ];

  static const List<Color> glassGradient = [
    Color(0x33FFFFFF),
    Color(0x0AFFFFFF),
  ];

  static const List<Color> accentGradient = [
    Color(0xFF00B0FF),
    Color(0xFF00E5FF),
  ];
}
