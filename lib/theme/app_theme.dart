import 'package:flutter/material.dart';

class AppColors {
  // Brand greens
  static const Color primary      = Color(0xFF1B5E20);
  static const Color primaryMid   = Color(0xFF2E7D32);
  static const Color accent       = Color(0xFF4CAF50);
  static const Color accentLight  = Color(0xFFE8F5E9);

  // Semantic
  static const Color onTime   = Color(0xFF2E7D32);
  static const Color delay    = Color(0xFFE53935);
  static const Color orange   = Color(0xFFFF6F00);
  static const Color warning  = Color(0xFFFF6F00); // alias for orange

  // Light palette
  static const Color lightBg            = Color(0xFFF5F7F5);
  static const Color lightSurface       = Color(0xFFFFFFFF);
  static const Color lightCard          = Color(0xFFF8FAF8);
  static const Color lightBorder        = Color(0xFFE0E5E0);
  static const Color lightChipBg        = Color(0xFFEEF4EE);
  static const Color lightTextPrimary   = Color(0xFF1A1A1A);
  static const Color lightTextSecondary = Color(0xFF555555);
  static const Color lightTextHint      = Color(0xFFAAAAAA);

  // Dark palette
  static const Color darkBg            = Color(0xFF0F1A10);
  static const Color darkSurface       = Color(0xFF1A2B1B);
  static const Color darkCard          = Color(0xFF1E2F1F);
  static const Color darkBorder        = Color(0xFF2E442F);
  static const Color darkChipBg        = Color(0xFF1E3020);
  static const Color darkTextPrimary   = Color(0xFFF0F4F0);
  static const Color darkTextSecondary = Color(0xFFB0BCB0);
  static const Color darkTextHint      = Color(0xFF6A7A6A);

  // Static aliases — const-safe, default to light palette.
  // Use these anywhere a const Color is required (TextStyle, BoxDecoration, etc.)
  static const Color background    = lightBg;
  static const Color border        = lightBorder;
  static const Color chipBg        = lightChipBg;
  static const Color textPrimary   = lightTextPrimary;
  static const Color textSecondary = lightTextSecondary;
  static const Color textHint      = lightTextHint;

  // Context-aware getters — use in build() methods for proper dark-mode support
  static Color bg(BuildContext ctx)              => _d(ctx) ? darkBg            : lightBg;
  static Color surface(BuildContext ctx)         => _d(ctx) ? darkSurface       : lightSurface;
  static Color card(BuildContext ctx)            => _d(ctx) ? darkCard          : lightCard;
  static Color borderOf(BuildContext ctx)        => _d(ctx) ? darkBorder        : lightBorder;
  static Color chipBgOf(BuildContext ctx)        => _d(ctx) ? darkChipBg        : lightChipBg;
  static Color textPrimaryOf(BuildContext ctx)   => _d(ctx) ? darkTextPrimary   : lightTextPrimary;
  static Color textSecondaryOf(BuildContext ctx) => _d(ctx) ? darkTextSecondary : lightTextSecondary;
  static Color textHintOf(BuildContext ctx)      => _d(ctx) ? darkTextHint      : lightTextHint;

  static bool _d(BuildContext ctx) =>
      Theme.of(ctx).brightness == Brightness.dark;
}



class AppTheme {
  static ThemeData get theme => _build(Brightness.light);

  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark()  => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark    = brightness == Brightness.dark;
    final bg        = isDark ? AppColors.darkBg            : AppColors.lightBg;
    final surface   = isDark ? AppColors.darkSurface       : AppColors.lightSurface;
    final card      = isDark ? AppColors.darkCard          : AppColors.lightCard;
    final border    = isDark ? AppColors.darkBorder        : AppColors.lightBorder;
    final chipBg    = isDark ? AppColors.darkChipBg        : AppColors.lightChipBg;
    final txtPri    = isDark ? AppColors.darkTextPrimary   : AppColors.lightTextPrimary;
    final txtSec    = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final txtHint   = isDark ? AppColors.darkTextHint      : AppColors.lightTextHint;
    final fillColor = isDark ? AppColors.darkCard          : const Color(0xFFF8FAF8);

    return ThemeData(
      useMaterial3: false,
      brightness: brightness,
      fontFamily: 'PlusJakartaSans',
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: bg,
      cardColor: card,
      dividerColor: border,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: AppColors.primary,
        onPrimary: Colors.white,
        secondary: AppColors.accent,
        onSecondary: Colors.white,
        error: AppColors.delay,
        onError: Colors.white,
        background: bg,
        onBackground: txtPri,
        surface: surface,
        onSurface: txtPri,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
          textStyle: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 0.3),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: BorderSide(color: border),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.primary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: fillColor,
        hintStyle: TextStyle(color: txtHint, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: border, width: 1)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.delay, width: 1)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.delay, width: 1.5)),
        errorStyle: const TextStyle(
            color: AppColors.delay, fontSize: 12, fontWeight: FontWeight.w500),
      ),
      textTheme: TextTheme(
        bodyLarge:  TextStyle(color: txtPri,  fontSize: 15),
        bodyMedium: TextStyle(color: txtPri,  fontSize: 14),
        bodySmall:  TextStyle(color: txtSec,  fontSize: 12),
        labelSmall: TextStyle(color: txtHint, fontSize: 11),
      ),
      iconTheme: IconThemeData(color: txtSec),
      cardTheme: CardTheme(
        color: card,
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: border, width: 0.8)),
      ),
    );
  }
}

// 1. The State Manager for your Theme
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleTheme() {
    _themeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}

// Global instance just for easy access in this example
// (In a real app, use the `provider` package or GetIt)
final themeProvider = ThemeProvider();

