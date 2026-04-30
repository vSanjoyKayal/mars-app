import 'package:flutter/material.dart';
import '../theme/app_styles.dart';

class InfoItem extends StatelessWidget {

  final String title;
  final String value;

  const InfoItem({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          title.toUpperCase(),
          style: AppTextStyles.infoTitle,
        ),

        const SizedBox(height: 4),

        Text(
          value.toUpperCase(),
          style: AppTextStyles.infoValue,
        ),
      ],
    );
  }
}