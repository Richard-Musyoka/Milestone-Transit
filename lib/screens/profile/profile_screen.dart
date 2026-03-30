import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_theme.dart';
import '../../app_router.dart';
import '../../widgets/common_widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Enhanced Notification States
  bool _arrivalAlerts = true;
  bool _maintenanceAlerts = true;
  bool _promoAlerts = false;

  void _vibrate() => HapticFeedback.lightImpact();

  // --- 1. ENHANCED NOTIFICATION PULL-UP ---
  void _showNotificationSettings() {
    _vibrate();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Container(
          decoration: BoxDecoration(
            color: AppColors.surface(context),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _pullHandle(context),
              Text('Notification Center', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimaryOf(context))),
              const SizedBox(height: 12),
              _buildToggleItem(setSheetState, 'Arrival Alerts', 'Notify when your bus is 2 stops away.', _arrivalAlerts, (v) => _arrivalAlerts = v),
              _buildToggleItem(setSheetState, 'System Updates', 'Service changes and route maintenance.', _maintenanceAlerts, (v) => _maintenanceAlerts = v),
              _buildToggleItem(setSheetState, 'Milestone Offers', 'Discounts and partner rewards.', _promoAlerts, (v) => _promoAlerts = v),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // --- 2. COMPREHENSIVE FAQ PULL-UP ---
  void _showFAQs() {
    _vibrate();
    final faqs = [
      {'q': 'How do fare zones work?', 'a': 'Milestone Transit uses a 3-zone system. Your fare is calculated based on the number of zones you cross during your trip.'},
      {'q': 'Can I use one card for multiple people?', 'a': 'No, each passenger must have a dedicated Milestone Smart Card or QR ticket for insurance and tracking purposes.'},
      {'q': 'What is the "Tap & Go" policy?', 'a': 'Simply tap your device at the entrance. The system automatically calculates the lowest possible fare for your journey.'},
      {'q': 'Is there a student discount?', 'a': 'Yes! Students under 24 are eligible for a 40% discount. Upload your ID in the "Personal Info" section to apply.'},
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(color: AppColors.surface(context), borderRadius: const BorderRadius.vertical(top: Radius.circular(32))),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _pullHandle(context),
            Text('Help & Support', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimaryOf(context))),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: faqs.length,
                itemBuilder: (context, i) => Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    iconColor: AppColors.primary,
                    title: Text(faqs[i]['q']!, style: TextStyle(color: AppColors.textPrimaryOf(context), fontWeight: FontWeight.w700, fontSize: 15)),
                    children: [Padding(padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16), child: Text(faqs[i]['a']!, style: TextStyle(color: AppColors.textSecondaryOf(context), height: 1.5)))],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- 3. NEW CONTACT US PULL-UP ---
  void _showContactUs() {
    _vibrate();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(color: AppColors.surface(context), borderRadius: const BorderRadius.vertical(top: Radius.circular(32))),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _pullHandle(context),
            Text('Contact Milestone', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimaryOf(context))),
            const SizedBox(height: 24),
            _contactTile(Icons.chat_bubble_outline_rounded, 'Live Chat', 'Average wait: 2 mins', () {}),
            _contactTile(Icons.phone_in_talk_outlined, 'Call Support', 'Available 24/7', () {}),
            _contactTile(Icons.email_outlined, 'Email Us', 'Response within 24h', () {}),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeProvider,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: AppColors.bg(context),
          body: Column(
            children: [
              const GreenHeader(title: 'My Profile', showBack: false),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      _buildProfileHeader(context),
                      const SizedBox(height: 24),
                      _buildMainOptions(context),
                      const SizedBox(height: 40),
                      Text('Milestone Transit Corporation © 2026', style: TextStyle(color: AppColors.textHintOf(context), fontSize: 11, letterSpacing: 1)),
                    ],
                  ),
                ),
              ),
              const AppBottomNav(currentIndex: 3),
            ],
          ),
        );
      },
    );
  }

  // --- REUSABLE COMPONENTS ---

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderOf(context)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(radius: 35, backgroundColor: AppColors.primary.withOpacity(0.1), child: const Icon(Icons.person_rounded, size: 40, color: AppColors.primary)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Chundung Zong', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimaryOf(context))),
                    Text('chunzon4@gmail.com', style: TextStyle(color: AppColors.textSecondaryOf(context), fontSize: 13)),
                  ],
                ),
              ),
              IconButton(onPressed: () => Navigator.pushNamed(context, AppRouter.editProfile), icon: const Icon(Icons.edit_note_rounded, color: AppColors.primary))
            ],
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 15), child: Divider()),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Loyalty Level: Gold', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
              Text('420 Points', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondaryOf(context))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainOptions(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppColors.card(context), borderRadius: BorderRadius.circular(24), border: Border.all(color: AppColors.borderOf(context))),
      child: Column(
        children: [
          _menuTile(context, Icons.notifications_none_rounded, 'Notifications', onTap: _showNotificationSettings),
          _menuTile(context, Icons.credit_card_rounded, 'Card Top-Up', route: '/topup'),
          _menuTile(context, Icons.help_outline_rounded, 'FAQs', onTap: _showFAQs),
          _menuTile(context, Icons.headset_mic_outlined, 'Contact Us', onTap: _showContactUs),
          _menuTile(context, Icons.settings_outlined, 'Settings', route: '/settings'),
          _menuTile(context, Icons.logout_rounded, 'Log Out', isDestructive: true, onTap: () => _showLogoutDialog(context)),
        ],
      ),
    );
  }

  Widget _menuTile(BuildContext context, IconData icon, String label, {String? route, VoidCallback? onTap, bool isDestructive = false}) {
    return ListTile(
      onTap: () {
        _vibrate();
        if (onTap != null) onTap();
        else if (route != null) Navigator.pushNamed(context, route);
      },
      leading: Icon(icon, color: isDestructive ? Colors.redAccent : AppColors.primary),
      title: Text(label, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: isDestructive ? Colors.redAccent : AppColors.textPrimaryOf(context))),
      trailing: Icon(Icons.chevron_right_rounded, size: 20, color: AppColors.textHintOf(context)),
    );
  }

  Widget _buildToggleItem(StateSetter setSheetState, String title, String sub, bool val, Function(bool) onChanged) {
    return SwitchListTile.adaptive(
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimaryOf(context))),
      subtitle: Text(sub, style: TextStyle(fontSize: 12, color: AppColors.textSecondaryOf(context))),
      value: val,
      activeColor: AppColors.primary,
      onChanged: (v) {
        _vibrate();
        setSheetState(() => onChanged(v));
        setState(() => onChanged(v));
      },
    );
  }

  Widget _contactTile(IconData icon, String title, String sub, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, color: AppColors.primary, size: 20)),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimaryOf(context))),
      subtitle: Text(sub, style: TextStyle(fontSize: 12, color: AppColors.textSecondaryOf(context))),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
    );
  }

  Widget _pullHandle(BuildContext context) => Center(child: Container(width: 40, height: 4, margin: const EdgeInsets.only(bottom: 20), decoration: BoxDecoration(color: AppColors.textHintOf(context).withOpacity(0.3), borderRadius: BorderRadius.circular(10))));

  void _showLogoutDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => AlertDialog(
      backgroundColor: AppColors.surface(context),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Confirm Logout'),
      content: const Text('Are you sure you want to log out?'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        TextButton(onPressed: () => Navigator.pushNamedAndRemoveUntil(context, AppRouter.login, (r) => false), child: const Text('Log Out', style: TextStyle(color: Colors.redAccent))),
      ],
    ));
  }
}