import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../app_router.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _nameController     = TextEditingController();
  final _emailController    = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController  = TextEditingController();
  final _formKey            = GlobalKey<FormState>();
  bool _isLoading = false;

  late AnimationController _animCtrl;
  late Animation<double>   _fadeAnim;
  late Animation<Offset>   _slideAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnim  = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
            begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut));
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.pushNamed(context, AppRouter.otp);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        children: [
          // ── Same decorative circles as Login ──────────────────────
          Positioned(
            top: -60, right: -60,
            child: Container(width: 220, height: 220,
                decoration: BoxDecoration(shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.05))),
          ),
          Positioned(
            top: 80, right: 40,
            child: Container(width: 100, height: 100,
                decoration: BoxDecoration(shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.05))),
          ),
          Positioned(
            top: -20, left: -40,
            child: Container(width: 160, height: 160,
                decoration: BoxDecoration(shape: BoxShape.circle,
                    color: AppColors.accent.withOpacity(0.15))),
          ),

          SafeArea(
            child: Column(
              children: [
                // ── Green header zone ─────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(28, 32, 28, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Brand row
                      Row(children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.directions_bus_rounded,
                              color: Colors.white, size: 26),
                        ),
                        const SizedBox(width: 12),
                        RichText(
                          text: const TextSpan(children: [
                            TextSpan(text: 'Mile',
                                style: TextStyle(color: Colors.white,
                                    fontSize: 20, fontWeight: FontWeight.w800)),
                            TextSpan(text: 'Stone',
                                style: TextStyle(color: AppColors.accent,
                                    fontSize: 20, fontWeight: FontWeight.w800)),
                          ]),
                        ),
                      ]),
                      const SizedBox(height: 36),
                      const Text('Create\nAccount 🚌',
                          style: TextStyle(color: Colors.white, fontSize: 36,
                              fontWeight: FontWeight.w800, height: 1.2)),
                      const SizedBox(height: 8),
                      Text('Register and start your journey',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 15)),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // ── White sliding card (same as Login) ─────────────
                Expanded(
                  child: FadeTransition(
                    opacity: _fadeAnim,
                    child: SlideTransition(
                      position: _slideAnim,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(32)),
                        ),
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(28, 32, 28, 24),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Name
                                const _FieldLabel('Full name'),
                                const SizedBox(height: 8),
                                _InputField(
                                  controller: _nameController,
                                  hint: 'John Doe',
                                  icon: Icons.person_outline_rounded,
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty)
                                      return 'Please enter your name';
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),

                                // Email
                                const _FieldLabel('Email address'),
                                const SizedBox(height: 8),
                                _InputField(
                                  controller: _emailController,
                                  hint: 'you@example.com',
                                  icon: Icons.mail_outline_rounded,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (v) {
                                    if (v == null || v.isEmpty)
                                      return 'Please enter your email';
                                    if (!v.contains('@'))
                                      return 'Enter a valid email';
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),

                                // Password
                                const _FieldLabel('Password'),
                                const SizedBox(height: 8),
                                _PasswordField(
                                  controller: _passwordController,
                                  hint: 'Create a password',
                                  validator: (v) {
                                    if (v == null || v.isEmpty)
                                      return 'Please enter a password';
                                    if (v.length < 6)
                                      return 'Minimum 6 characters';
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),

                                // Confirm password
                                const _FieldLabel('Confirm password'),
                                const SizedBox(height: 8),
                                _PasswordField(
                                  controller: _confirmController,
                                  hint: 'Repeat your password',
                                  validator: (v) {
                                    if (v == null || v.isEmpty)
                                      return 'Please confirm your password';
                                    if (v != _passwordController.text)
                                      return 'Passwords do not match';
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 28),

                                // Register button
                                _isLoading
                                    ? Container(
                                        width: double.infinity, height: 54,
                                        decoration: BoxDecoration(
                                            color: AppColors.primary,
                                            borderRadius:
                                                BorderRadius.circular(14)),
                                        child: const Center(
                                            child: SizedBox(width: 24, height: 24,
                                                child: CircularProgressIndicator(
                                                    color: Colors.white,
                                                    strokeWidth: 2.5))),
                                      )
                                    : _GreenButton(
                                        label: 'Register',
                                        onTap: _handleRegister),

                                const SizedBox(height: 28),

                                // Divider
                                Row(children: [
                                  const Expanded(child: Divider(thickness: 1)),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14),
                                    child: Text('Or continue with',
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .textTheme
                                                .labelSmall
                                                ?.color,
                                            fontSize: 13)),
                                  ),
                                  const Expanded(child: Divider(thickness: 1)),
                                ]),

                                const SizedBox(height: 20),

                                // Social buttons
                                Row(children: [
                                  _SocialBtn(label: 'G',
                                      color: const Color(0xFFEA4335),
                                      onTap: () {}),
                                  const SizedBox(width: 12),
                                  _SocialBtn(label: 'f',
                                      color: const Color(0xFF1877F2),
                                      onTap: () {}),
                                  const SizedBox(width: 12),
                                  _SocialBtn(icon: Icons.apple,
                                      color: Colors.black, onTap: () {}),
                                ]),

                                const SizedBox(height: 32),

                                // Login link
                                Center(
                                  child: GestureDetector(
                                    onTap: () => Navigator.pushNamed(
                                        context, AppRouter.login),
                                    child: RichText(
                                      text: TextSpan(
                                        text: 'Already have an account?  ',
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.color,
                                            fontSize: 14),
                                        children: const [
                                          TextSpan(text: 'Login',
                                              style: TextStyle(
                                                  color: AppColors.primary,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 14)),
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
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shared sub-widgets (mirror of Login's private widgets) ────────────────────

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);
  @override
  Widget build(BuildContext context) => Text(text,
      style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).textTheme.bodyLarge?.color,
          letterSpacing: 0.2));
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const _InputField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(
          fontSize: 15,
          color: Theme.of(context).textTheme.bodyLarge?.color,
          fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: isDark ? AppColors.darkChipBg : AppColors.lightChipBg,
              borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: AppColors.primary, size: 18),
        ),
      ),
    );
  }
}

class _PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final String? Function(String?)? validator;
  const _PasswordField(
      {required this.controller, required this.hint, this.validator});

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscure,
      validator: widget.validator,
      style: TextStyle(
          fontSize: 15,
          color: Theme.of(context).textTheme.bodyLarge?.color,
          fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: widget.hint,
        prefixIcon: Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: isDark ? AppColors.darkChipBg : AppColors.lightChipBg,
              borderRadius: BorderRadius.circular(8)),
          child: const Icon(Icons.lock_outline_rounded,
              color: AppColors.primary, size: 18),
        ),
        suffixIcon: IconButton(
          icon: Icon(
              _obscure
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: isDark ? AppColors.darkTextHint : AppColors.lightTextHint,
              size: 20),
          onPressed: () => setState(() => _obscure = !_obscure),
        ),
      ),
    );
  }
}

class _GreenButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _GreenButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity, height: 54,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(
              color: AppColors.primary.withOpacity(0.35),
              blurRadius: 16, offset: const Offset(0, 6))],
        ),
        child: Center(
          child: Text(label,
              style: const TextStyle(
                  color: Colors.white, fontSize: 16,
                  fontWeight: FontWeight.w700, letterSpacing: 0.5)),
        ),
      ),
    );
  }
}

class _SocialBtn extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final Color color;
  final VoidCallback onTap;
  const _SocialBtn(
      {this.label, this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : Colors.white,
            border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                width: 1),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8, offset: const Offset(0, 2))],
          ),
          child: Center(
            child: icon != null
                ? Icon(icon, color: color, size: 22)
                : Text(label!,
                    style: TextStyle(
                        color: color,
                        fontSize: 18,
                        fontWeight: FontWeight.w800)),
          ),
        ),
      ),
    );
  }
}
