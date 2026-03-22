
import 'package:exam_pilot/screens/dashboard_screen.dart';
import 'package:exam_pilot/screens/signup_screen.dart';
import 'package:flutter/material.dart'; // Iska path check kar lena sahi hai ya nahi
import 'package:exam_pilot/screens/login_screen.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState(); // FIX: Semicolon added and super called correctly

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Image.asset(
          'assets/images/thinkora_splash.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}