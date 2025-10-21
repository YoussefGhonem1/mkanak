import 'package:flutter/material.dart';
import 'package:rento/src/shared/theme/app_colors.dart';

class CustomButtonOnboarding extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const CustomButtonOnboarding({
    super.key,
    required this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: AppColors.teal900,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.teal100, width: 2),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.teal100,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),

            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.teal900,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
