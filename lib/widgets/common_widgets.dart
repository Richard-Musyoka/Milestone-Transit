import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// ─── Green Status Bar Header ───────────────────────────────────────────────
class GreenHeader extends StatelessWidget {
  final String title;
  final bool showBack;
  final Widget? trailing;
  const GreenHeader({
    super.key,
    required this.title,
    this.showBack = true,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        left: 16,
        right: 16,
        bottom: 16,
      ),
      child: Row(
        children: [
          if (showBack)
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.arrow_back_ios_new,
                    color: Colors.white, size: 18),
              ),
            ),
          if (showBack) const SizedBox(width: 12),
          Expanded(
            child: Text(title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800)),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

// ─── Bottom Navigation Bar ─────────────────────────────────────────────────
class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  const AppBottomNav({super.key, required this.currentIndex});

  static const _items = [
    {'icon': Icons.home_rounded,        'label': 'Home',    'route': '/home'},
    {'icon': Icons.location_on_rounded, 'label': 'Track',   'route': '/track-select'},
    {'icon': Icons.credit_card_rounded, 'label': 'TopUp',   'route': '/topup'},
    {'icon': Icons.person_rounded,      'label': 'Profile', 'route': '/profile'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 12,
              offset: const Offset(0, -3))
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_items.length, (i) {
              final active = i == currentIndex;
              return GestureDetector(
                onTap: () {
                  if (!active) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      _items[i]['route'] as String,
                          (r) => false,
                    );
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: active ? AppColors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _items[i]['icon'] as IconData,
                        color: active
                            ? Colors.white
                            : AppColors.lightTextHint,
                        size: 22,
                      ),
                      if (active) ...[
                        const SizedBox(width: 6),
                        Text(
                          _items[i]['label'] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

// ─── Auth Input Field ──────────────────────────────────────────────────────
class AuthInputField extends StatefulWidget {
  final String hint;
  final IconData icon;
  final bool isPassword;
  final TextEditingController? controller;
  final TextInputType keyboardType;

  const AuthInputField({
    super.key,
    required this.hint,
    required this.icon,
    this.isPassword = false,
    this.controller,
    this.keyboardType = TextInputType.text,
  });

  @override
  State<AuthInputField> createState() => _AuthInputFieldState();
}

class _AuthInputFieldState extends State<AuthInputField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.isPassword && _obscure,
      keyboardType: widget.keyboardType,
      style: const TextStyle(
          fontSize: 14, color: AppColors.lightTextPrimary),
      decoration: InputDecoration(
        hintText: widget.hint,
        prefixIcon: Icon(widget.icon, color: AppColors.primary, size: 20),
        suffixIcon: widget.isPassword
            ? IconButton(
          icon: Icon(
            _obscure ? Icons.visibility_off : Icons.visibility,
            color: AppColors.lightTextHint,
            size: 20,
          ),
          onPressed: () => setState(() => _obscure = !_obscure),
        )
            : null,
      ),
    );
  }
}

// ─── Section Header ────────────────────────────────────────────────────────
class SectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;
  const SectionHeader(
      {super.key, required this.title, this.action, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.lightTextPrimary)),
        if (action != null)
          GestureDetector(
            onTap: onAction,
            child: Text(action!,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary)),
          ),
      ],
    );
  }
}

// ─── Status Badge ──────────────────────────────────────────────────────────
class StatusBadge extends StatelessWidget {
  final String label;
  final bool isDelay;
  const StatusBadge({super.key, required this.label, this.isDelay = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isDelay
            ? AppColors.delay.withOpacity(0.1)
            : AppColors.onTime.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: isDelay ? AppColors.delay : AppColors.onTime,
        ),
      ),
    );
  }
}

// ─── Location Input Card ───────────────────────────────────────────────────
class LocationInputCard extends StatelessWidget {
  final TextEditingController? fromController;
  final TextEditingController? toController;
  final VoidCallback? onSwap;
  final VoidCallback? onTrack;
  final String buttonLabel;

  const LocationInputCard({
    super.key,
    this.fromController,
    this.toController,
    this.onSwap,
    this.onTrack,
    this.buttonLabel = 'Track Bus',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 3))
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      border:
                      Border.all(color: AppColors.primary, width: 2),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                      width: 2,
                      height: 24,
                      color: AppColors.primary.withOpacity(0.3)),
                  const Icon(Icons.location_on,
                      color: AppColors.primary, size: 16),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  children: [
                    TextField(
                      controller: fromController,
                      decoration: const InputDecoration(
                        hintText: 'From',
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                      ),
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: toController,
                      decoration: const InputDecoration(
                        hintText: 'To',
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                      ),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onSwap,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.swap_vert,
                      color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ElevatedButton(
            onPressed: onTrack,
            child: Text(buttonLabel),
          ),
        ],
      ),
    );
  }
}

// ─── Bus Route Card ────────────────────────────────────────────────────────
class BusRouteCard extends StatelessWidget {
  final String busId;
  final String from;
  final String to;
  final String departTime;
  final String arriveTime;
  final String duration;
  final String crowdLevel;
  final String status;
  final bool isDelay;
  final VoidCallback? onTap;

  const BusRouteCard({
    super.key,
    required this.busId,
    required this.from,
    required this.to,
    required this.departTime,
    required this.arriveTime,
    required this.duration,
    this.crowdLevel = 'low',
    required this.status,
    this.isDelay = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(busId,
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary)),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(from,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(width: 6),
                Expanded(
                  child: Row(
                    children: [
                      const Expanded(
                          child: Divider(
                              color: AppColors.lightBorder, thickness: 1)),
                      Container(
                        margin:
                        const EdgeInsets.symmetric(horizontal: 6),
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle),
                        child: const Icon(Icons.person_pin_circle,
                            color: Colors.white, size: 12),
                      ),
                      const Expanded(
                          child: Divider(
                              color: AppColors.lightBorder, thickness: 1)),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                Text(to,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(departTime,
                    style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.lightTextSecondary)),
                Text(duration,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w700)),
                Text(arriveTime,
                    style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.lightTextSecondary)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text('Crowd Level',
                    style: TextStyle(
                        fontSize: 12,
                        color: AppColors.lightTextSecondary)),
                const SizedBox(width: 8),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: crowdLevel == 'low'
                          ? 0.2
                          : crowdLevel == 'mid'
                          ? 0.55
                          : 0.85,
                      backgroundColor: AppColors.lightBorder,
                      color: crowdLevel == 'low'
                          ? AppColors.onTime
                          : crowdLevel == 'mid'
                          ? AppColors.orange
                          : AppColors.delay,
                      minHeight: 6,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                StatusBadge(label: status, isDelay: isDelay),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

