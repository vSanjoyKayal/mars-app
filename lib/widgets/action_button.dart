import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_styles.dart';

class ActionButton extends StatelessWidget {

  final String title;
  final String image;
  final VoidCallback onTap;

  const ActionButton({
    super.key,
    required this.title,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(

      onTap: onTap,

      child: Container(

        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),

        decoration: BoxDecoration(

          borderRadius: BorderRadius.circular(8),

          gradient: const LinearGradient(
            colors: [
              Color(0xFF0E5DB8),
              Color(0xFF082B63),
            ],
          ),

          border: Border.all(
            color: AppColors.border,
            width: 0.5,
          ),
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Image.asset(
              image,
              width: 24,
              height: 24,
            ),

            const SizedBox(width: 10),

            Text(
              title,
              style: AppTextStyles.buttonText,
            ),
          ],
        ),
      ),
    );
  }
}