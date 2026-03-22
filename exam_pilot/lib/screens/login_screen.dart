// lib/screens/login_screen.dart
import 'package:exam_pilot/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';
// TODO: Jab Signup Screen ready ho jaye, ise uncomment karna
// import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  // ✨ NEW STATE VARIABLE FOR LOADING ✨
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // BACKGROUND IMAGE
          Positioned.fill(
            child: Image.asset(
              'assets/images/login_base.png', // Check image path
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35.0),
                child: Column(
                  children: [
                    // Dynamic Spacing (Login ka purana sorted spacing)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: isKeyboardOpen ? 120 : 320,
                      curve: Curves.easeOut,
                    ),

                    const Text(
                      'Login',
                      style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 30),

                    // FIELDS
                    _buildInputField(hint: "Username", icon: Icons.person_outline),
                    const SizedBox(height: 15),
                    _buildInputField(
                      hint: "*********",
                      icon: Icons.lock_outline,
                      isPassword: true,
                      isPasswordVisible: _isPasswordVisible,
                      onToggle: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                    ),

                    const SizedBox(height: 35),

                    // 🔥 UPDATED LOGIN BUTTON -> Navigates to Dashboard with Loading
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        // Agar Loading chal rahi hai toh click disable kar do
                        onPressed: _isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E3A8A),
                          disabledBackgroundColor: const Color(0xFF1E3A8A).withOpacity(0.5), // Disabled look
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        // ✨ DYNAMIC CONTENT BASED ON LOADING ✨
                        child: _isLoading
                            ? const Center(
                          child: SizedBox(
                            height: 25,
                            width: 25,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          ),
                        )
                            : const Text(
                          'Sign in',
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // REGISTER OPTION -> Navigates to Signup
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account? ", style: TextStyle(color: Colors.white70)),
                        GestureDetector(
                          onTap: () {
                            // Signup screen par le jao
                            // Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupScreen()));
                            print("Navigating to Signup...");
                          },
                          child: const Text(
                            "Register",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✨ NEW FUNCTION FOR LOADING LOGIC ✨
  void _handleLogin() async {
    // 1. Loading Start karo
    setState(() {
      _isLoading = true;
    });

    // 2. Jan-bujh kar delay add karo (Hackathon ke liye fake api call experience)
    await Future.delayed(const Duration(seconds: 2));

    // 3. TODO: Yahan Dashboard ka Navigation logic rahega
     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DashboardScreen()));
    print("Fake API Done. Navigating to Dashboard...");

    // 4. Loading End karo (Agar navigation proper pushReplacement karoge toh iski zaroorat nahi padegi)
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Input Field Widget (Same as before)
  Widget _buildInputField({required String hint, required IconData icon, bool isPassword = false, bool isPasswordVisible = false, VoidCallback? onToggle}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white24),
      ),
      child: TextField(
        obscureText: isPassword && !isPasswordVisible,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white60),
          prefixIcon: Icon(icon, color: Colors.white70),
          suffixIcon: isPassword ? IconButton(icon: Icon(isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.white70), onPressed: onToggle) : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        ),
      ),
    );
  }
}