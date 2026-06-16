import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../localization/language_provider.dart';
import '../constants/app_colors.dart';

class LanguageSelector extends StatelessWidget {
  final bool isCompact;

  const LanguageSelector({super.key, this.isCompact = false});

  @override
  Widget build(BuildContext context) {
    final langProvider = Provider.of<LanguageProvider>(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 8 : 12,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border, width: 1.0),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: langProvider.currentLanguageCode,
          icon: Icon(
            Icons.language,
            size: isCompact ? 16 : 20,
            color: AppColors.skyBlue,
          ),
          dropdownColor: AppColors.darkNavBg,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: isCompact ? 12 : 14,
            fontWeight: FontWeight.w600,
          ),
          onChanged: (String? newValue) {
            if (newValue != null) {
              langProvider.changeLanguage(newValue);
            }
          },
          items: const [
            DropdownMenuItem<String>(value: 'en', child: Text(' English  ')),
            DropdownMenuItem<String>(value: 'te', child: Text(' తెలుగు  ')),
          ],
        ),
      ),
    );
  }
}
