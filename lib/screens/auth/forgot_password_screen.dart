import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _formKey         = GlobalKey<FormState>();
  bool _isLoading        = false;
  bool _sent             = false;

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
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) setState(() { _isLoading = false; _sent = true; });
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
                      // Back + brand row
                      Row(children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(Icons.arrow_back_ios_new,
                                color: Colors.white, size: 18),
                          ),
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
                      const Text('Forgot\nPassword? 🔐',
                          style: TextStyle(color: Colors.white, fontSize: 36,
                              fontWeight: FontWeight.w800, height: 1.2)),
                      const SizedBox(height: 8),
                      Text('We\'ll send a reset link to your email',
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
                          padding: const EdgeInsets.fromLTRB(28, 40, 28, 24),
                          child: _sent
                              ? _SuccessState(
                                  email: _emailController.text,
                                  onBack: () =>
                                      Navigator.pop(context))
                              : Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Info card
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: AppColors.accentLight
                                              .withOpacity(
                                                  Theme.of(context).brightness ==
                                                          Brightness.dark
                                                      ? 0.1
                                                      : 1),
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          border: Border.all(
                                              color: AppColors.accent
                                                  .withOpacity(0.3)),
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Icon(
                                                Icons.info_outline_rounded,
                                                color: AppColors.primary,
                                                size: 20),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Text(
                                                'Enter your registered email and we\'ll send you a link to reset your password.',
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall
                                                        ?.color,
                                                    fontSize: 13,
                                                    height: 1.5),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      const SizedBox(height: 28),

                                      // Email field label
                                      _FieldLabel('Email address'),
                                      const SizedBox(height: 8),

                                      // Email field — same style as Login
                                      TextFormField(
                                        controller: _emailController,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        validator: (v) {
                                          if (v == null || v.isEmpty)
                                            return 'Please enter your email';
                                          if (!v.contains('@'))
                                            return 'Enter a valid email';
                                          return null;
                                        },
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.color,
                                            fontWeight: FontWeight.w500),
                                        decoration: InputDecoration(
                                          hintText: 'you@example.com',
                                          prefixIcon: Container(
                                            margin: const EdgeInsets.all(12),
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.dark
                                                    ? AppColors.darkChipBg
                                                    : AppColors.lightChipBg,
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            child: const Icon(
                                                Icons.mail_outline_rounded,
                                                color: AppColors.primary,
                                                size: 18),
                                          ),
                                        ),
                                      ),

                                      const SizedBox(height: 32),

                                      // Submit button — same gradient as Login
                                      _isLoading
                                          ? Container(
                                              width: double.infinity,
                                              height: 54,
                                              decoration: BoxDecoration(
                                                  color: AppColors.primary,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          14)),
                                              child: const Center(
                                                  child: SizedBox(
                                                      width: 24,
                                                      height: 24,
                                                      child:
                                                          CircularProgressIndicator(
                                                              color: Colors
                                                                  .white,
                                                              strokeWidth:
                                                                  2.5))),
                                            )
                                          : GestureDetector(
                                              onTap: _handleSubmit,
                                              child: Container(
                                                width: double.infinity,
                                                height: 54,
                                                decoration: BoxDecoration(
                                                  gradient:
                                                      const LinearGradient(
                                                          colors: [
                                                            Color(0xFF1B5E20),
                                                            Color(0xFF2E7D32)
                                                          ],
                                                          begin: Alignment
                                                              .centerLeft,
                                                          end: Alignment
                                                              .centerRight),
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: AppColors.primary
                                                            .withOpacity(0.35),
                                                        blurRadius: 16,
                                                        offset: const Offset(
                                                            0, 6))
                                                  ],
                                                ),
                                                child: const Center(
                                                  child: Text('Send Reset Link',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          letterSpacing: 0.5)),
                                                ),
                                              ),
                                            ),

                                      const SizedBox(height: 32),

                                      // Back to login
                                      Center(
                                        child: GestureDetector(
                                          onTap: () =>
                                              Navigator.pop(context),
                                          child: RichText(
                                            text: TextSpan(
                                              text: 'Remember your password?  ',
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
                                                        fontWeight:
                                                            FontWeight.w700,
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

// ── Success state shown after email is sent ───────────────────────────────────
class _SuccessState extends StatelessWidget {
  final String email;
  final VoidCallback onBack;
  const _SuccessState({required this.email, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
              color: AppColors.accentLight, shape: BoxShape.circle),
          child: const Icon(Icons.mark_email_read_rounded,
              color: AppColors.primary, size: 48),
        ),
        const SizedBox(height: 28),
        const Text('Check your email',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.primary)),
        const SizedBox(height: 12),
        Text(
          'We sent a password reset link to\n$email',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).textTheme.bodySmall?.color,
              height: 1.6),
        ),
        const SizedBox(height: 40),
        GestureDetector(
          onTap: onBack,
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
            child: const Center(
              child: Text('Back to Login',
                  style: TextStyle(
                      color: Colors.white, fontSize: 16,
                      fontWeight: FontWeight.w700, letterSpacing: 0.5)),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Field label (same as Login) ───────────────────────────────────────────────
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
