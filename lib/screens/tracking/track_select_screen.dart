import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For Haptic Feedback
import '../../theme/app_theme.dart';
import '../../app_router.dart';
import '../../widgets/common_widgets.dart';

class TrackSelectScreen extends StatelessWidget {
  const TrackSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeProvider,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: AppColors.bg(context),
          body: Column(
            children: [
              // Clean Header Integration
              const GreenHeader(title: '', showBack: false),

              // Branded Welcome Section
              _buildHeader(context),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Modern Search Bar (Interactive)
                      _buildSearchBar(context),

                      const SizedBox(height: 20),

                      // Refined Promo Banner
                      _buildPromoBanner(context),

                      const SizedBox(height: 32),

                      Text(
                        'Select Tracking Option',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                          color: AppColors.textPrimaryOf(context),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Enhanced Options
                      _TrackOption(
                        label: 'Track by Route',
                        subLabel: 'Find buses by destination',
                        icon: Icons.route_rounded,
                        onTap: () {
                          HapticFeedback.lightImpact();
                          Navigator.pushNamed(context, AppRouter.trackByRoute);
                        },
                      ),

                      const SizedBox(height: 12),

                      _TrackOption(
                        label: 'Track by Bus Number',
                        subLabel: 'Enter specific bus ID',
                        icon: Icons.directions_bus_rounded,
                        onTap: () {
                          HapticFeedback.lightImpact();
                          Navigator.pushNamed(context, AppRouter.trackByBus);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const AppBottomNav(currentIndex: 1),
            ],
          ),
        );
      },
    );
  }

  // --- Header UI ---
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.primary,
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBrandText(),
              CircleAvatar(
                radius: 22,
                backgroundColor: Colors.white.withOpacity(0.2),
                child: const Icon(Icons.person_rounded, color: Colors.white, size: 24),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Hello, Chundung',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
          Text(
            'Where would you like to go today?',
            style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandText() {
    return RichText(
      text: const TextSpan(
        style: TextStyle(fontFamily: 'PlusJakartaSans', fontWeight: FontWeight.w800, fontStyle: FontStyle.italic, fontSize: 16),
        children: [
          TextSpan(text: 'Mile', style: TextStyle(color: Colors.white)),
          TextSpan(text: 'Stone', style: TextStyle(color: Color(0xFF8BC34A))),
          TextSpan(text: ' Transit', style: TextStyle(color: Colors.white, fontStyle: FontStyle.normal)),
        ],
      ),
    );
  }

  // --- Search Bar UI ---
  Widget _buildSearchBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderOf(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: AppColors.primary, size: 22),
          const SizedBox(width: 12),
          Text(
            'Where are you going?',
            style: TextStyle(color: AppColors.textHintOf(context), fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  // --- Promo Banner UI ---
  Widget _buildPromoBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withBlue(100)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ride More, Pay Less',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  'Top up your Metro Card & save 20%',
                  style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
                ),
              ],
            ),
          ),
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              // Move your navigation logic here
              onTap: () {
                HapticFeedback.lightImpact();
                Navigator.pushNamed(context, AppRouter.topup);
              },
              borderRadius: BorderRadius.circular(10),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                child: Text(
                  'TopUp Now!', // The Text widget needs a String here
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

// --- Enhanced Track Option Widget ---
class _TrackOption extends StatelessWidget {
  final String label;
  final String subLabel;
  final IconData icon;
  final VoidCallback onTap;

  const _TrackOption({
    required this.label,
    required this.subLabel,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.card(context),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.borderOf(context), width: 1.5),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimaryOf(context),
                      ),
                    ),
                    Text(
                      subLabel,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondaryOf(context),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: AppColors.textHintOf(context), size: 24),
            ],
          ),
        ),
      ),
    );
  }
}