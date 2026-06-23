import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ── Paleta GameZone ───────────────────────────────────────────
  static const Color primaryColor   = Color(0xFF4A148C); // morado README
  static const Color bgPrimary      = Color(0xFF0A0A0F);
  static const Color bgSecondary    = Color(0xFF12121A);
  static const Color bgCard         = Color(0xFF1A1A26);
  static const Color bgCardLight    = Color(0xFF22223A);

  static const Color neonPurple     = Color(0xFFB347FF);
  static const Color neonBlue       = Color(0xFF00D4FF);
  static const Color neonGreen      = Color(0xFF00FF88);
  static const Color neonPink       = Color(0xFFFF2D78);
  static const Color neonOrange     = Color(0xFFFF6B00);

  static const Color textPrimary    = Color(0xFFF0F0FF);
  static const Color textSecondary  = Color(0xFF9090B0);
  static const Color textMuted      = Color(0xFF505070);
  static const Color borderColor    = Color(0xFF2A2A40);

  // ── TEMA OSCURO (por defecto) ──────────────────────────────────
  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: bgPrimary,
    colorScheme: const ColorScheme.dark(
      primary: neonPurple,
      secondary: neonBlue,
      surface: bgSecondary,
      error: neonPink,
    ),
    textTheme: GoogleFonts.rajdhaniTextTheme(
      const TextTheme(
        displayLarge:  TextStyle(color: textPrimary, fontSize: 32, fontWeight: FontWeight.w700),
        displayMedium: TextStyle(color: textPrimary, fontSize: 24, fontWeight: FontWeight.w700),
        displaySmall:  TextStyle(color: textPrimary, fontSize: 20, fontWeight: FontWeight.w600),
        headlineMedium:TextStyle(color: textPrimary, fontSize: 18, fontWeight: FontWeight.w600),
        titleLarge:    TextStyle(color: textPrimary, fontSize: 16, fontWeight: FontWeight.w600),
        titleMedium:   TextStyle(color: textSecondary, fontSize: 14),
        bodyLarge:     TextStyle(color: textPrimary, fontSize: 15),
        bodyMedium:    TextStyle(color: textSecondary, fontSize: 13),
        labelLarge:    TextStyle(color: textPrimary, fontSize: 14, fontWeight: FontWeight.w700),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: bgPrimary,
      elevation: 0,
      centerTitle: false,
      foregroundColor: textPrimary,
      titleTextStyle: TextStyle(
        color: textPrimary, fontSize: 20,
        fontWeight: FontWeight.w700, letterSpacing: 1,
      ),
      iconTheme: IconThemeData(color: textPrimary),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: bgSecondary,
      selectedItemColor: neonPurple,
      unselectedItemColor: textMuted,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: neonPurple,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: neonPurple,
        side: const BorderSide(color: neonPurple, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: bgCard,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: neonPurple, width: 2),
      ),
      labelStyle: const TextStyle(color: textSecondary),
      hintStyle: const TextStyle(color: textMuted),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    cardTheme: CardThemeData(
      color: bgCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: borderColor),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected) ? neonPurple : textMuted,
      ),
      trackColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected)
            ? neonPurple.withValues(alpha: 0.4)
            : bgCardLight,
      ),
    ),
    dividerColor: borderColor,
    iconTheme: const IconThemeData(color: textSecondary),
  );

  // ── TEMA CLARO ──────────────────────────────────────────────────
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF5F5FA),
      colorScheme: const ColorScheme.light(
        primary: neonPurple,
        secondary: neonBlue,
        surface: Colors.white,
        error: neonPink,
      ),
      textTheme: GoogleFonts.rajdhaniTextTheme(
        const TextTheme(
          displayLarge:  TextStyle(color: Color(0xFF1A1A2E), fontSize: 32, fontWeight: FontWeight.w700),
          displayMedium: TextStyle(color: Color(0xFF1A1A2E), fontSize: 24, fontWeight: FontWeight.w700),
          displaySmall:  TextStyle(color: Color(0xFF1A1A2E), fontSize: 20, fontWeight: FontWeight.w600),
          headlineMedium:TextStyle(color: Color(0xFF1A1A2E), fontSize: 18, fontWeight: FontWeight.w600),
          titleLarge:    TextStyle(color: Color(0xFF2D2D44), fontSize: 16, fontWeight: FontWeight.w600),
          titleMedium:   TextStyle(color: Color(0xFF555577), fontSize: 14),
          bodyLarge:     TextStyle(color: Color(0xFF1A1A2E), fontSize: 15),
          bodyMedium:    TextStyle(color: Color(0xFF555577), fontSize: 13),
          labelLarge:    TextStyle(color: Color(0xFF1A1A2E), fontSize: 14, fontWeight: FontWeight.w700),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        foregroundColor: Color(0xFF1A1A2E),
        titleTextStyle: TextStyle(
          color: Color(0xFF1A1A2E),
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: 1,
        ),
        iconTheme: IconThemeData(color: Color(0xFF1A1A2E)),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: neonPurple,
        unselectedItemColor: Color(0xFF9999BB),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: neonPurple,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: neonPurple,
          side: const BorderSide(color: neonPurple, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFD0D0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFD0D0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: neonPurple, width: 2),
        ),
        labelStyle: const TextStyle(color: Color(0xFF555577)),
        hintStyle: const TextStyle(color: Color(0xFF9999BB)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFE8E8F0)),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? neonPurple : const Color(0xFF9999BB),
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? neonPurple.withValues(alpha: 0.4)
              : const Color(0xFFD0D0E0),
        ),
      ),
      dividerColor: const Color(0xFFE8E8F0),
      iconTheme: const IconThemeData(color: Color(0xFF555577)),
    );
  }
}

// ── Helpers de decoración (adaptados al contexto) ────────────────────

/// Fondo de tarjeta con borde neón. Si se pasa [context], el color de fondo
BoxDecoration neonCardDecoration({
  Color glowColor = AppTheme.neonPurple,
  double radius = 16,
  BuildContext? context,
}) {
  final isDark = context == null || Theme.of(context).brightness == Brightness.dark;
  final bgColor = isDark ? AppTheme.bgCard : Colors.white;
  final borderColor = glowColor.withValues(alpha: 0.3);
  final shadowColor = glowColor.withValues(alpha: 0.07);

  return BoxDecoration(
    color: bgColor,
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: borderColor),
    boxShadow: [BoxShadow(color: shadowColor, blurRadius: 12)],
  );
}

/// Botón con degradado neón y sombra (no cambia con el tema).
BoxDecoration neonButtonDecoration({Color color = AppTheme.neonPurple}) {
  return BoxDecoration(
    gradient: LinearGradient(
      colors: [color, color.withValues(alpha: 0.7)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(12),
    boxShadow: [BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 15, offset: const Offset(0, 4))],
  );
}