// lib/main.dart - Fixed version
import 'package:exam_pilot/splash_screen.dart';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:google_fonts/google_fonts.dart';

import 'screens/dashboard_screen.dart';



void main() {

  runApp(const ProviderScope(child: ExamPilotAI()));

}



class ExamPilotAI extends StatelessWidget {

  const ExamPilotAI({super.key});



  @override

  Widget build(BuildContext context) {

    return MaterialApp(

      title: 'ExamPilot AI',

      debugShowCheckedModeBanner: false,

      theme: ThemeData(

        useMaterial3: true,

        brightness: Brightness.dark,

        colorScheme: const ColorScheme.dark(

          primary: Color(0xFF2F6B8F), // Sophisticated muted blue

          secondary: Color(0xFF6B8C9E), // Soft steel blue

          tertiary: Color(0xFFD4A373), // Warm amber for accents

          surface: Color(0xFF1C2128), // Dark gray with blue undertone

          background: Color(0xFF12161C), // Very dark gray

          error: Color(0xFFD97A5C), // Warm error tone

          onPrimary: Colors.white,

          onSecondary: Colors.white,

          onSurface: Colors.white,

          onBackground: Colors.white,

        ),

        scaffoldBackgroundColor: const Color(0xFF12161C),

        cardTheme: CardThemeData(

          elevation: 0,

          shape: RoundedRectangleBorder(

            borderRadius: BorderRadius.circular(20),

          ),

          color: const Color(0xFF1C2128),

        ),

        appBarTheme: const AppBarTheme(

          elevation: 0,

          backgroundColor: Colors.transparent,

          centerTitle: false,

        ),

        textTheme: GoogleFonts.interTextTheme(

          ThemeData.dark().textTheme,

        ).copyWith(

          headlineMedium: GoogleFonts.poppins(fontWeight: FontWeight.w600),

          headlineSmall: GoogleFonts.poppins(fontWeight: FontWeight.w600),

          titleLarge: GoogleFonts.poppins(fontWeight: FontWeight.w500),

        ),

      ),

      home: const SplashScreen(),

    );

  }

}