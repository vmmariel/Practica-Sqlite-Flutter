import 'package:flutter/material.dart';

/// Identidad visual de la aplicacion: paleta "Mauve Minimal".
///
/// Tonos neutros con malvas y rosas empolvados, superficies planas y
/// separadores finos en lugar de tarjetas elevadas.
class AppTheme {
  AppTheme._();

  static const Color malva = Color(0xFF7E5E85);
  static const Color rosaEmpolvado = Color(0xFFC9A9B4);
  static const Color malvaSuave = Color(0xFFEFE6F0);
  static const Color fondo = Color(0xFFFAF7F9);
  static const Color superficie = Color(0xFFFFFFFF);
  static const Color borde = Color(0xFFE9E1E6);
  static const Color textoPrincipal = Color(0xFF2E2930);
  static const Color textoSecundario = Color(0xFF786E7C);
  static const Color rojoError = Color(0xFFA8536B);

  /// Nombre de la familia tipografica. Queda en null para usar la fuente
  /// del sistema; se cambia a 'Manrope' si se incluyen los archivos en
  /// assets/fonts y se declaran en pubspec.yaml.
  static const String? familia = null;

  static ThemeData get claro {
    const esquema = ColorScheme.light(
      primary: malva,
      onPrimary: Colors.white,
      secondary: rosaEmpolvado,
      onSecondary: textoPrincipal,
      surface: superficie,
      onSurface: textoPrincipal,
      error: rojoError,
      onError: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: familia,
      colorScheme: esquema,
      scaffoldBackgroundColor: fondo,
      dividerColor: borde,

      appBarTheme: const AppBarTheme(
        backgroundColor: fondo,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: textoPrincipal,
          fontSize: 24,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.3,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: superficie,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        hintStyle: const TextStyle(color: textoSecundario),
        labelStyle: const TextStyle(color: textoSecundario),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borde),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borde),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: malva, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: rojoError),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: rojoError, width: 1.5),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: malva,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: textoSecundario),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: superficie,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: textoPrincipal,
        contentTextStyle: const TextStyle(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}