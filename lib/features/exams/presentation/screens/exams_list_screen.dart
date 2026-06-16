import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/language_selector.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/exams_provider.dart';
import 'cbt_exam_screen.dart';

class ExamsListScreen extends StatelessWidget {
  const ExamsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final examCategories = [
      {
        'name': 'Police',
        'icon': Icons.security_rounded,
        'desc': 'SI & Constable Mock Tests',
      },
      {
        'name': 'Banking',
        'icon': Icons.account_balance_rounded,
        'desc': 'IBPS, SBI PO & Clerk Prep',
      },
      {
        'name': 'Railway',
        'icon': Icons.train_rounded,
        'desc': 'RRB NTPC & Group D Exams',
      },
      {
        'name': 'SSC',
        'icon': Icons.assignment_ind_rounded,
        'desc': 'SSC CGL, CHSL Mock Papers',
      },
      {
        'name': 'Groups',
        'icon': Icons.group_work_rounded,
        'desc': 'State PSC Group 1 & 2',
      },
      {
        'name': 'TSPSC',
        'icon': Icons.location_city_rounded,
        'desc': 'Telangana State Exams',
      },
      {
        'name': 'APPSC',
        'icon': Icons.landscape_rounded,
        'desc': 'Andhra Pradesh State Exams',
      },
      {
        'name': 'UPSC',
        'icon': Icons.gavel_rounded,
        'desc': 'Civil Services Prelims CBT',
      },
    ];

    final authProvider = Provider.of<AuthProvider>(context);
    final userId = authProvider.currentUser?.uid ?? 'guest_user';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          loc.translate('exams_card'),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: const [LanguageSelector(isCompact: true), SizedBox(width: 12)],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: AppColors.bgGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          SafeArea(
            child: ListView.separated(
              padding: const EdgeInsets.all(20.0),
              itemCount: examCategories.length,
              separatorBuilder: (_, _) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final cat = examCategories[index];

                return GlassContainer(
                  padding: const EdgeInsets.all(16),
                  borderRadius: 16,
                  child: InkWell(
                    onTap: () {
                      final name = cat['name'] as String;
                      // Start exam session inside exams provider
                      Provider.of<ExamsProvider>(
                        context,
                        listen: false,
                      ).startExam(name, userId);

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => CbtExamScreen(categoryName: name),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.skyBlue.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            cat['icon'] as IconData,
                            size: 28,
                            color: AppColors.skyBlue,
                          ),
                        ),
                        const SizedBox(width: 16),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cat['name'] as String,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                cat['desc'] as String,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Icon(
                          Icons.arrow_forward_ios,
                          color: AppColors.skyBlue,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
