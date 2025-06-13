import 'package:flutter/material.dart';
import '../controllers/register_controller.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _controller = RegisterController();

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
          return Stack(children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
              child: SizedBox(
                height: screenHeight * 0.35,
                width: double.infinity,
                child: Image.asset(
                  'images/login.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned.fill(
              child: Container(color: Colors.black.withOpacity(0.3)),
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
                              "Daftar Akun",
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2F2F2F),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Mulai jelajahi keindahan Bali dengan akunmu sendiri.",
                              style: TextStyle(fontSize: 16, color: Color(0xFF6D6D6D)),
                            ),
                            const SizedBox(height: 24),

                            TextFormField(
                              controller: _controller.nameController,
                              validator: _controller.validateName,
                              decoration: _inputDecoration("Nama Lengkap"),
                            ),
                            const SizedBox(height: 16),

                            TextFormField(
                              controller: _controller.emailController,
                              validator: _controller.validateEmail,
                              decoration: _inputDecoration("Email"),
                            ),
                            const SizedBox(height: 16),

                            TextFormField(
                              controller: _controller.passwordController,
                              validator: _controller.validatePassword,
                              obscureText: true,
                              decoration: _inputDecoration("Password"),
                            ),
                            const SizedBox(height: 24),

                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Pendaftaran berhasil!")),
                                    );
                                    Navigator.pop(context);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFF5A94D),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                ),
                                child: const Text("Daftar", style: TextStyle(color: Colors.white)),
                              ),
                            ),
                            const SizedBox(height: 16),

                            Center(
                              child: GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: const Text.rich(
                                  TextSpan(
                                    text: "Sudah punya akun? ",
                                    children: [
                                      TextSpan(
                                        text: "Login sekarang",
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
          ]);
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
