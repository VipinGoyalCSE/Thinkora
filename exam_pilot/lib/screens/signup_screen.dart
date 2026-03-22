// lib/screens/signup_screen.dart
// lib/screens/signup_screen.dart
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. Automatic screen shrink band karo.
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // BASE IMAGE BACKGROUND (Illustration + circles + base text)
          Positioned.fill(
            child: Image.asset(
              'assets/images/signup_base.png', // Base image name check kar lena
              fit: BoxFit.cover,
            ),
          ),

          // 2. FORM ELEMENTS
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  reverse: true, // Keyboard khulne par niche se scroll karega smooth shift ke liye
                  // Keyboard height detect karke space banao
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight, // Poori screen use karo
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start, // Top se align karo
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ✨ FIXED SPACE ADDED: Illustration ke niche gaps chamkao.
                        // Ise jab keyboard band ho toh fields smoothly exact position par honge,
                        // 'Register now' text ko cover nahi karega.
                        // Agar lagta hai ki gap abhi bhi kam hai toh isse 400 kar dena.
                        const SizedBox(height: 380),

                        // Hum upar se 'Signup' ya 'Register now' wala Text remove kar chuke hain.
                        // Baki Fields ka look chamkana (Darker semi-transparent for text clarity over image)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 35.0),
                          child: Column(
                            children: [
                              _buildPremiumInputField(
                                controller: _usernameController,
                                hint: "Username",
                                icon: Icons.person_outline,
                              ),
                              const SizedBox(height: 15),
                              _buildPremiumInputField(
                                controller: _passwordController,
                                hint: "*********",
                                icon: Icons.lock_outline,
                                isPassword: true,
                                isPasswordVisible: _isPasswordVisible,
                                onToggle: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                              const SizedBox(height: 15),
                              _buildPremiumInputField(
                                controller: _emailController,
                                hint: "Email",
                                icon: Icons.email_outlined,
                              ),
                              const SizedBox(height: 35),

                              // SIGN UP BUTTON
                              SizedBox(
                                width: double.infinity,
                                height: 55,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1E3A8A), // Solid deep blue
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    elevation: 8,
                                  ),
                                  child: const Text(
                                    'Sign up',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Sabse niche extra spacing
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Common Premium Input Widget (Semi-transparent with subtle border)
  Widget _buildPremiumInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? onToggle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3), // Darker glass look for clarity over illustration text
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white24),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword && !isPasswordVisible,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white60),
          prefixIcon: Icon(icon, color: Colors.white70),
          suffixIcon: isPassword
              ? IconButton(
            icon: Icon(
              isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.white70,
            ),
            onPressed: onToggle,
          )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        ),
      ),
    );
  }
}