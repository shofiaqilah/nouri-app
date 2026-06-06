import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  static const _green = Color(0xFF4CAF50);
  static const _orange = Color(0xFFFF7043);
  static const _bg = Color(0xFFFAFAFA);
  static const _textPrimary = Color(0xFF212121);
  static const _textSecondary = Color(0xFF757575);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 48),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button
                GestureDetector(
                  onTap: () => Get.back(),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 20,
                    color: _textPrimary,
                  ),
                ),

                const SizedBox(height: 36),

                const Text(
                  'Create\naccount.',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: _textPrimary,
                    height: 1.15,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Start your nutrition journey today.',
                  style: TextStyle(fontSize: 14, color: _textSecondary),
                ),

                const SizedBox(height: 48),

                // Email field
                _buildLabel('Email'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _emailController,
                  hint: 'you@example.com',
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Email wajib diisi';
                    if (!val.contains('@')) return 'Format email tidak valid';
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Password field
                _buildLabel('Password'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _passwordController,
                  hint: 'Minimal 6 karakter',
                  obscure: true,
                  validator: (val) {
                    if (val == null || val.isEmpty)
                      return 'Password wajib diisi';
                    if (val.length < 6) return 'Password minimal 6 karakter';
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Confirm password field
                _buildLabel('Konfirmasi Password'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _confirmPasswordController,
                  hint: 'Ulangi password',
                  obscure: true,
                  validator: (val) {
                    if (val == null || val.isEmpty)
                      return 'Konfirmasi password wajib diisi';
                    if (val != _passwordController.text) {
                      return 'Password tidak cocok';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 36),

                // Register button
                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                controller.register(
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text,
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _green,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: _green.withOpacity(0.5),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: controller.isLoading.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Sign up',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Login link
                Center(
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: RichText(
                      text: const TextSpan(
                        text: 'Already have an account? ',
                        style: TextStyle(color: _textSecondary, fontSize: 14),
                        children: [
                          TextSpan(
                            text: 'Log in',
                            style: TextStyle(
                              color: _orange,
                              fontWeight: FontWeight.w600,
                            ),
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
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: _textPrimary,
        letterSpacing: 0.2,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(fontSize: 15, color: _textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: _textSecondary, fontSize: 15),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _green, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _orange),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _orange, width: 1.5),
        ),
      ),
    );
  }
}
