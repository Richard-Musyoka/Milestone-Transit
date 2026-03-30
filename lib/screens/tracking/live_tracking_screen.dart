import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';

class LiveTrackingScreen extends StatelessWidget {
  const LiveTrackingScreen({super.key});

  static const _stops = [
    {'name': 'Terminos Bus Station', 'time': '8:50am', 'status': 'Arrived', 'delay': false, 'done': true},
    {'name': 'Old Juth Station', 'time': '9:23am', 'dist': '550m', 'status': 'On Time', 'delay': false, 'done': true},
    {'name': 'British Junction', 'time': '9:47am', 'dist': '2km', 'status': '3min Delay', 'delay': true, 'done': false, 'current': true},
    {'name': 'Old Airport', 'time': '9:52am', 'dist': '3km', 'status': '5min Delay', 'delay': true, 'done': false},
    {'name': 'Building Material', 'time': '9:58am', 'dist': '4.1km', 'status': 'On Time', 'delay': false, 'done': false},
    {'name': 'Gyel', 'time': '10:10am', 'dist': '6.3km', 'status': 'On Time', 'delay': false, 'done': false},
    {'name': 'Vom Junction', 'time': '10:30am', 'dist': '14.3km', 'status': 'On Time', 'delay': false, 'done': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          GreenHeader(title: 'Live Tracking'),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location info card
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
                            Column(
                              children: [
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
                                    color:
                                        AppColors.primary.withOpacity(0.4)),
                                const Icon(Icons.location_on,
                                    color: AppColors.primary, size: 14),
                              ],
                            ),
                            const SizedBox(width: 12),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('British',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(height: 8),
                                Text('Zawan Junc',
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
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.chipBg,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Text('Bus  ',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textSecondary)),
                              const Text('M007, M032, M009...',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600)),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.warning.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text('In Transit',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.warning)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Route timeline
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: const Text('Commuter Line Route',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary)),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: List.generate(_stops.length, (i) {
                        final s = _stops[i];
                        final isLast = i == _stops.length - 1;
                        final done = s['done'] as bool;
                        final delay = s['delay'] as bool;
                        final isCurrent = s['current'] == true;

                        return IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 24,
                                child: Column(
                                  children: [
                                    Container(
                                      width: 14,
                                      height: 14,
                                      decoration: BoxDecoration(
                                        color: done || isCurrent
                                            ? AppColors.primary
                                            : Colors.white,
                                        border: Border.all(
                                            color: AppColors.primary,
                                            width: 2),
                                        shape: BoxShape.circle,
                                      ),
                                      child: isCurrent
                                          ? const Icon(
                                              Icons.directions_bus,
                                              color: Colors.white,
                                              size: 8)
                                          : null,
                                    ),
                                    if (!isLast)
                                      Expanded(
                                        child: Container(
                                          width: 2,
                                          color: done
                                              ? AppColors.primary
                                              : AppColors.border,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(s['name'] as String,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: done || isCurrent
                                                      ? AppColors.textPrimary
                                                      : AppColors.textSecondary)),
                                          if (s.containsKey('dist'))
                                            Text(s['dist'] as String,
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    color:
                                                        AppColors.textHint)),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(s['time'] as String,
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight:
                                                      FontWeight.w600)),
                                          Text(s['status'] as String,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: delay
                                                      ? AppColors.delay
                                                      : AppColors.onTime)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
