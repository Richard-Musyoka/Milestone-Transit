import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../app_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardData> _pages = [
    _OnboardData(
      icon: Icons.access_time_rounded,
      iconBg: Color(0xFFE8F5E9),
      title: 'Real-Time Awareness',
      description:
          'Get real-time updates on bus routes, schedules, and arrival times across Plateau State.',
    ),
    _OnboardData(
      icon: Icons.near_me_rounded,
      iconBg: Color(0xFFE8F5E9),
      title: 'Easy Navigation',
      description:
          'Search routes, discover nearby bus stops, and choose the best way to get to your destination.',
    ),
    _OnboardData(
      icon: Icons.notifications_active_rounded,
      iconBg: Color(0xFFE8F5E9),
      title: 'Alerts & Convenience',
      description:
          'Receive alerts for arrivals, delays, and route changes so you can plan your journey better.',
    ),
  ];

  void _next() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut);
    } else {
      Navigator.pushReplacementNamed(context, AppRouter.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, AppRouter.login),
                child: const Text('Skip',
                    style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline)),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: _pages.length,
                itemBuilder: (_, i) => _OnboardPage(data: _pages[i]),
              ),
            ),
            // Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_pages.length, (i) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: i == _currentPage ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: i == _currentPage
                        ? AppColors.primary
                        : AppColors.border,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ElevatedButton(
                onPressed: _next,
                child: Text(
                    _currentPage == _pages.length - 1
                        ? 'Get Started'
                        : 'Next'),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _OnboardData {
  final IconData icon;
  final Color iconBg;
  final String title;
  final String description;
  const _OnboardData(
      {required this.icon,
      required this.iconBg,
      required this.title,
      required this.description});
}

class _OnboardPage extends StatelessWidget {
  final _OnboardData data;
  const _OnboardPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              color: data.iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(data.icon, color: AppColors.primary, size: 80),
          ),
          const SizedBox(height: 40),
          Text(data.title,
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 14),
          Text(data.description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                  height: 1.6)),
        ],
      ),
    );
  }
}
