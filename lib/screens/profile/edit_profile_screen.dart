import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          GreenHeader(title: 'Edit Profile'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 46,
                          backgroundColor: AppColors.chipBg,
                          child: const Icon(Icons.person,
                              color: AppColors.primary, size: 48),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.camera_alt_rounded,
                                color: Colors.white, size: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  _FieldLabel('Name'),
                  const SizedBox(height: 6),
                  TextField(
                    controller:
                        TextEditingController(text: 'Chundung Zong'),
                    decoration: const InputDecoration(),
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 16),

                  _FieldLabel('Email'),
                  const SizedBox(height: 6),
                  TextField(
                    controller: TextEditingController(
                        text: 'Chunzon4@gmail.com'),
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(),
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 16),

                  _FieldLabel('Password'),
                  const SizedBox(height: 6),
                  TextField(
                    controller:
                        TextEditingController(text: '***********'),
                    obscureText: true,
                    decoration: InputDecoration(
                      suffixIcon: const Icon(Icons.visibility_off_outlined,
                          color: AppColors.textHint, size: 20),
                    ),
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 16),

                  _FieldLabel('Phone Number'),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              color: AppColors.border, width: 1.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Text('+234',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600)),
                            const SizedBox(width: 4),
                            const Icon(Icons.arrow_drop_down,
                                color: AppColors.textHint, size: 20),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: TextEditingController(
                              text: '98760587'),
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(),
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Save'),
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

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary));
  }
}
