// ─── Track by Route ──────────────────────────────────────────────────────────
import 'package:flutter/material.dart';

import '../../app_router.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';

class TrackByRouteScreen extends StatefulWidget {
  const TrackByRouteScreen({super.key});

  @override
  State<TrackByRouteScreen> createState() => _TrackByRouteState();
}

class _TrackByRouteState extends State<TrackByRouteScreen> {
  int _tab = 0;

  static const _recentRoutes = [
    {'from': 'Bukuru exp', 'to': 'Vom Junction'},
    {'from': 'Gyel junc', 'to': 'Old Airport'},
  ];
  static const _savedRoutes = [
    {'from': 'Bus M024', 'to': 'Zawan Junc'},
    {'from': 'Bus M007', 'to': 'Lamingo Juth'},
    {'from': 'Bus M032', 'to': 'Vom'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          GreenHeader(title: 'Track by Route'),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LocationInputCard(
                    onTrack: () =>
                        Navigator.pushNamed(context, AppRouter.liveTracking),
                  ),
                  // Tabs
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        _TabBtn(
                            label: 'Recent Search',
                            active: _tab == 0,
                            onTap: () => setState(() => _tab = 0)),
                        const SizedBox(width: 20),
                        _TabBtn(
                            label: 'Saved Bus Route',
                            active: _tab == 1,
                            onTap: () => setState(() => _tab = 1)),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: (_tab == 0 ? _recentRoutes : _savedRoutes)
                          .map((s) => _RouteListItem(
                        from: s['from']!,
                        to: s['to']!,
                        isBus: _tab == 1,
                        onTap: () => Navigator.pushNamed(
                            context, AppRouter.liveTracking),
                      ))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// ─── Shared Widgets ──────────────────────────────────────────────────────────
class _TabBtn extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _TabBtn(
      {required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          const SizedBox(height: 12),
          Text(label,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight:
                  active ? FontWeight.w700 : FontWeight.w500,
                  color: active
                      ? AppColors.primary
                      : AppColors.textSecondary)),
          const SizedBox(height: 8),
          if (active)
            Container(
                height: 2,
                width: 100,
                color: AppColors.primary)
        ],
      ),
    );
  }
}

class _RouteListItem extends StatelessWidget {
  final String from;
  final String to;
  final bool isBus;
  final VoidCallback? onTap;
  const _RouteListItem(
      {required this.from,
        required this.to,
        this.isBus = false,
        this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2))
          ],
        ),
        child: Row(
          children: [
            Icon(
              isBus
                  ? Icons.directions_bus_rounded
                  : Icons.location_on_outlined,
              color: AppColors.primary,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      fontFamily: 'PlusJakartaSans'),
                  children: [
                    TextSpan(text: from),
                    const TextSpan(
                        text: '  →  ',
                        style: TextStyle(color: AppColors.textHint)),
                    TextSpan(text: to),
                  ],
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }
}