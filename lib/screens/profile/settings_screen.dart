import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = false;
  bool _locationAccess = true;

  // --- ADVANCED "PULL-UP" BOTTOM SHEETS ---

  void _showPullUpMenu({required String title, required Widget content}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppColors.card(context), // Dynamic Card Color
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 12,
            bottom: MediaQuery.of(context).padding.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: AppColors.textHintOf(context), // Dynamic Hint Color
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              title,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimaryOf(context)), // Dynamic Text
            ),
            const SizedBox(height: 16),
            content,
          ],
        ),
      ),
    );
  }

  void _showLanguagePullUp() {
    _showPullUpMenu(
      title: 'Select Language',
      content: Column(
        children: ['English', 'French', 'Spanish'].map((lang) {
          return ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(lang,
                style: TextStyle(color: AppColors.textPrimaryOf(context))),
            trailing: lang == 'English'
                ? const Icon(Icons.check_circle, color: AppColors.primary)
                : null,
            onTap: () => Navigator.pop(context),
          );
        }).toList(),
      ),
    );
  }

  void _showInfoPullUp(String title, String body) {
    _showPullUpMenu(
      title: title,
      content: Text(
        body,
        style: TextStyle(
            fontSize: 15,
            height: 1.6,
            color: AppColors.textSecondaryOf(context)),
      ),
    );
  }

  void _showAppearancePullUp() {
    _showPullUpMenu(
      title: 'Appearance',
      content: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.light_mode, color: Colors.orange),
            title: Text('Light Mode',
                style: TextStyle(color: AppColors.textPrimaryOf(context))),
            onTap: () {
              if (themeProvider.isDarkMode) themeProvider.toggleTheme();
              Navigator.pop(context);
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.dark_mode, color: Colors.indigo),
            title: Text('Dark Mode',
                style: TextStyle(color: AppColors.textPrimaryOf(context))),
            onTap: () {
              if (!themeProvider.isDarkMode) themeProvider.toggleTheme();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: themeProvider,
        builder: (context, child) {
          return Scaffold(
            backgroundColor: AppColors.bg(context), // Fixed: Use bg(context)
            body: Column(
              children: [
                const GreenHeader(title: 'Settings'),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _SettingsCard(children: [
                        _SettingsNavItem(
                          label: 'Favourite Stops',
                          value: 'Anglo Jos',
                          onTap: () => _showInfoPullUp(
                              'Favourite Stops', 'You have 1 favourite stop.'),
                        ),
                        const _CardDivider(),
                        _SettingsNavItem(
                          label: 'Language',
                          value: 'English',
                          onTap: _showLanguagePullUp,
                        ),
                        const _CardDivider(),
                        _SettingsNavItem(
                          label: 'Privacy Policy',
                          value: 'Read',
                          onTap: () => _showInfoPullUp('Privacy Policy',
                              'We protect your data with end-to-end encryption.'),
                        ),
                        const _CardDivider(),
                        _SettingsNavItem(
                          label: 'Appearance',
                          value: themeProvider.isDarkMode
                              ? 'Dark Mode'
                              : 'Light Mode',
                          onTap: _showAppearancePullUp,
                        ),
                      ]),
                      const SizedBox(height: 16),
                      _SettingsCard(children: [
                        _SettingsToggleItem(
                          title: 'Notifications',
                          subtitle: "Keep posted on station openings.",
                          value: _notifications,
                          onChanged: (v) => setState(() => _notifications = v),
                        ),
                        const _CardDivider(),
                        _SettingsToggleItem(
                          title: 'Location access',
                          subtitle: 'To find the nearest bus stop',
                          value: _locationAccess,
                          onChanged: (v) => setState(() => _locationAccess = v),
                        ),
                      ]),
                      const SizedBox(height: 16),
                      _SettingsCard(children: [
                        _SettingsActionItem(
                          label: 'Clear search history',
                          onTap: () => _showInfoPullUp(
                              'History', 'Search history cleared.'),
                        ),
                      ]),
                      const SizedBox(height: 16),
                      _SettingsCard(children: [
                        _InfoItem(
                          label: 'About',
                          onTap: () => _showInfoPullUp('About App',
                              'Metro Transit v1.0.4 - Built for 2026.'),
                        ),
                        const _CardDivider(),
                        _InfoItem(
                          label: 'Developers',
                          onTap: () => _showInfoPullUp('Developers',
                              'Built by Milestone Transit Engineering.'),
                        ),
                      ]),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}

// --- REUSABLE COMPONENTS (Fixed for AppTheme integration) ---

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderOf(context), width: 0.8),
      ),
      child: Column(children: children),
    );
  }
}

class _SettingsNavItem extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;
  const _SettingsNavItem(
      {required this.label, required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Expanded(
                child: Text(label,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimaryOf(context)))),
            Text(value,
                style: TextStyle(
                    fontSize: 14, color: AppColors.textSecondaryOf(context))),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right,
                color: AppColors.textHintOf(context), size: 20),
          ],
        ),
      ),
    );
  }
}

class _SettingsToggleItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsToggleItem(
      {required this.title,
        required this.subtitle,
        required this.value,
        required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimaryOf(context))),
                const SizedBox(height: 4),
                Text(subtitle,
                    style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondaryOf(context),
                        height: 1.4)),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Switch.adaptive(
              value: value, onChanged: onChanged, activeColor: AppColors.primary),
        ],
      ),
    );
  }
}

class _SettingsActionItem extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _SettingsActionItem({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(label,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.primary)),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _InfoItem({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            const Icon(Icons.info_outline_rounded,
                color: AppColors.primary, size: 22),
            const SizedBox(width: 12),
            Text(label,
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary)),
          ],
        ),
      ),
    );
  }
}

class _CardDivider extends StatelessWidget {
  const _CardDivider();
  @override
  Widget build(BuildContext context) => Divider(
      height: 1,
      indent: 16,
      endIndent: 16,
      thickness: 0.5,
      color: AppColors.borderOf(context));
}