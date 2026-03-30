import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../app_router.dart';
import '../../widgets/common_widgets.dart';

class SelectedRouteScreen extends StatefulWidget {
  const SelectedRouteScreen({super.key});

  @override
  State<SelectedRouteScreen> createState() => _SelectedRouteScreenState();
}

class _SelectedRouteScreenState extends State<SelectedRouteScreen> {
  String _selectedFilter = 'All Bus';

  static const _buses = [
    {
      'id': 'Bus M007',
      'from': 'Terminos',
      'to': 'Lamingo Juth',
      'depart': '8:30am',
      'arrive': '8:50am',
      'duration': '20min',
      'crowd': 'low',
      'status': 'On Time',
      'delay': false,
    },
    {
      'id': 'Bus M025',
      'from': 'Bukuru',
      'to': 'Anglo Jos',
      'depart': '8:40am',
      'arrive': '9:05am',
      'duration': '25min',
      'crowd': 'high',
      'status': 'Delay 2 min',
      'delay': true,
    },
    {
      'id': 'Bus M032',
      'from': 'British',
      'to': 'Vom Junction',
      'depart': '8:55am',
      'arrive': '9:30am',
      'duration': '35min',
      'crowd': 'mid',
      'status': 'On Time',
      'delay': false,
    },
  ];

  static const _filters = ['All Bus', '8am-10am', '10am-12pm', '12pm-02pm'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          GreenHeader(
            title: 'Selected Bus Route',
            trailing: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.tune, color: Colors.white, size: 20),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location card
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 12)
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Location',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800)),
                            Icon(Icons.edit_outlined,
                                color: AppColors.textHint, size: 20),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Column(children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: AppColors.primary, width: 2),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Container(
                                  width: 2,
                                  height: 20,
                                  color: AppColors.primary.withOpacity(0.4)),
                              const Icon(Icons.location_on,
                                  color: AppColors.primary, size: 14),
                            ]),
                            const SizedBox(width: 12),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Current Location',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(height: 10),
                                Text('Lamingo Juth',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.swap_vert,
                                  color: Colors.white, size: 18),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Sort by + filters
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        const Text('Sort by',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w800)),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {},
                          child: const Text('See all',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 36,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: _filters.map((f) {
                        final active = _selectedFilter == f;
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _selectedFilter = f),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: active
                                  ? AppColors.primary
                                  : Colors.white,
                              border: Border.all(
                                  color: active
                                      ? AppColors.primary
                                      : AppColors.border,
                                  width: 1.5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(f,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: active
                                        ? Colors.white
                                        : AppColors.textSecondary)),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Bus list
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: _buses
                          .map((b) => BusRouteCard(
                                busId: b['id'] as String,
                                from: b['from'] as String,
                                to: b['to'] as String,
                                departTime: b['depart'] as String,
                                arriveTime: b['arrive'] as String,
                                duration: b['duration'] as String,
                                crowdLevel: b['crowd'] as String,
                                status: b['status'] as String,
                                isDelay: b['delay'] as bool,
                                onTap: () => Navigator.pushNamed(
                                    context, AppRouter.liveTracking),
                              ))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          const AppBottomNav(currentIndex: 1),
        ],
      ),
    );
  }
}
