import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../app_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    _fade = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _ctrl, curve: const Interval(0, 0.6)));
    _scale = Tween<double>(begin: 0.7, end: 1).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack));
    _ctrl.forward();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRouter.onboarding);
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        children: [
          // City silhouette background
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: 0.12,
              child: CustomPaint(
                size: Size(MediaQuery.of(context).size.width, 150),
                painter: _CitySkylinePainter(),
              ),
            ),
          ),
          Center(
            child: FadeTransition(
              opacity: _fade,
              child: ScaleTransition(
                scale: _scale,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(Icons.directions_bus_rounded,
                            color: Colors.white, size: 52),
                      ),
                    ),
                    const SizedBox(height: 24),
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'Mile',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'PlusJakartaSans',
                            ),
                          ),
                          TextSpan(
                            text: 'Stone',
                            style: TextStyle(
                              color: Color(0xFF8BC34A),
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'PlusJakartaSans',
                            ),
                          ),
                          TextSpan(
                            text: ' Transit',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'PlusJakartaSans',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Know your bus. Save your time.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 48),
                    SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white.withOpacity(0.6)),
                      ),
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
}

class _CitySkylinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    final buildings = [
      [0.0, 0.5, 0.08, 1.0],
      [0.06, 0.3, 0.06, 1.0],
      [0.11, 0.6, 0.07, 1.0],
      [0.17, 0.2, 0.05, 1.0],
      [0.21, 0.45, 0.08, 1.0],
      [0.3, 0.15, 0.06, 1.0],
      [0.35, 0.55, 0.09, 1.0],
      [0.43, 0.35, 0.07, 1.0],
      [0.49, 0.6, 0.08, 1.0],
      [0.56, 0.25, 0.06, 1.0],
      [0.61, 0.5, 0.09, 1.0],
      [0.69, 0.4, 0.07, 1.0],
      [0.75, 0.2, 0.06, 1.0],
      [0.8, 0.55, 0.08, 1.0],
      [0.87, 0.35, 0.07, 1.0],
      [0.93, 0.6, 0.07, 1.0],
    ];
    for (final b in buildings) {
      final x = b[0] * size.width;
      final h = b[1] * size.height;
      final w = b[2] * size.width;
      canvas.drawRect(
          Rect.fromLTWH(x, size.height - h, w, h), paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
