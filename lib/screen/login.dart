import 'package:flutter/material.dart';
import '../controllers/login_controller.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onLoginSuccess;
  final VoidCallback onGoToRegister;

  const LoginPage({
    super.key,
    required this.onLoginSuccess,
    required this.onGoToRegister,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _controller = LoginController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              SizedBox(
                height: screenHeight * 0.35,
                width: double.infinity,
                child: Image.asset(
                  'images/login.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: Container(color: Colors.black.withOpacity(0.4)),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 500),
                  height: screenHeight * 0.7,
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                  ),
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: screenHeight * 0.65),
                      child: IntrinsicHeight(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Welcome Back",
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2F2F2F),
                                ),
                              ),
                              const SizedBox(height: 24),
                              TextFormField(
                                controller: _controller.emailController,
                                validator: _controller.validateEmail,
                                decoration: _inputDecoration("Email Address"),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _controller.passwordController,
                                validator: _controller.validatePassword,
                                obscureText: true,
                                decoration: _inputDecoration("Password"),
                              ),
                              const SizedBox(height: 8),
                              const Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  "Lupa password?",
                                  style: TextStyle(color: Color(0xFFF5A94D)),
                                ),
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      widget.onLoginSuccess();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFF5A94D),
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: const Text(
                                    "Sign In",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Center(child: Text("Atau masuk dengan")),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () {},
                                      icon: Image.asset('images/google.png', height: 20),
                                      label: const Text("Google"),
                                      style: OutlinedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () {},
                                      icon: Image.asset('images/facebook.png', height: 20),
                                      label: const Text("Facebook"),
                                      style: OutlinedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              Center(
                                child: GestureDetector(
                                  onTap: widget.onGoToRegister,
                                  child: const Text.rich(
                                    TextSpan(
                                      text: "Belum punya akun? ",
                                      children: [
                                        TextSpan(
                                          text: "Daftar sekarang",
                                          style: TextStyle(color: Color(0xFFF5A94D)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Color(0xFF6D6D6D)),
      filled: true,
      fillColor: const Color(0xFFF9E8D9),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E2E2)),
      ),
    );
  }
}
