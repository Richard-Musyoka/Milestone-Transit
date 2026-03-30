import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/otp_screen.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/home/search_bus_screen.dart';
import 'screens/tracking/track_select_screen.dart';
import 'screens/tracking/track_by_route_screen.dart';
import 'screens/tracking/track_by_bus_screen.dart';
import 'screens/tracking/live_tracking_screen.dart';
import 'screens/tracking/selected_route_screen.dart';
import 'screens/topup/topup_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/profile/edit_profile_screen.dart';
import 'screens/profile/settings_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String otp = '/otp';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String searchBus = '/search-bus';
  static const String trackSelect = '/track-select';
  static const String trackByRoute = '/track-by-route';
  static const String trackByBus = '/track-by-bus';
  static const String liveTracking = '/live-tracking';
  static const String selectedRoute = '/selected-route';
  static const String topup = '/topup';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String settings = '/settings';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _fade(const SplashScreen());
      case onboarding:
        return _fade(const OnboardingScreen());
      case login:
        return _slide(const LoginScreen());
      case register:
        return _slide(const RegisterScreen());
      case otp:
        return _slide(const OtpScreen());
      case forgotPassword:
        return _slide(const ForgotPasswordScreen());
      case home:
        return _fade(const HomeScreen());
      case searchBus:
        return _slide(const SearchBusScreen());
      case trackSelect:
        return _slide(const TrackSelectScreen());
      case trackByRoute:
        return _slide(const TrackByRouteScreen());
      case trackByBus:
        return _slide(const TrackByBusScreen());
      case liveTracking:
        return _slide(const LiveTrackingScreen());
      case selectedRoute:
        return _slide(const SelectedRouteScreen());
      case topup:
        return _slide(const TopupScreen());
      case profile:
        return _slide(const ProfileScreen());
      case editProfile:
        return _slide(const EditProfileScreen());
      case AppRouter.settings:
        return _slide(const SettingsScreen());
      default:
        return _fade(const SplashScreen());
    }
  }

  static PageRoute _fade(Widget page) => PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 350),
      );

  static PageRoute _slide(Widget page) => PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, anim, __, child) => SlideTransition(
          position: Tween<Offset>(
                  begin: const Offset(1, 0), end: Offset.zero)
              .animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 300),
      );
}
