import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/language_selector.dart';
import 'admin_add_question_screen.dart';
import 'admin_add_book_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    // Mock analytics stats
    final stats = [
      {
        'title': 'Total Questions',
        'val': '1,240',
        'icon': Icons.help_outline_rounded,
      },
      {'title': 'Total Books', 'val': '18', 'icon': Icons.menu_book_rounded},
      {
        'title': 'Generated Schedules',
        'val': '482',
        'icon': Icons.calendar_today_rounded,
      },
      {
        'title': 'Active Students',
        'val': '156',
        'icon': Icons.people_outline_rounded,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          loc.translate('admin_panel'),
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Banner info
                  GlassContainer(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: AppColors.skyBlue,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            loc.translate('admin_only'),
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Analytics Stats Grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.4,
                        ),
                    itemCount: stats.length,
                    itemBuilder: (context, index) {
                      final stat = stats[index];
                      return GlassContainer(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              stat['icon'] as IconData,
                              color: AppColors.skyBlue,
                              size: 24,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              stat['val'] as String,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              stat['title'] as String,
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Actions header
                  const Text(
                    "Database Management",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Management Buttons
                  _buildAdminActionTile(
                    context: context,
                    icon: Icons.question_answer_outlined,
                    title: loc.translate('add_question'),
                    desc:
                        "Inject bilingual multiple choice questions to exam collections",
                    targetScreen: const AdminAddQuestionScreen(),
                  ),
                  const SizedBox(height: 12),

                  _buildAdminActionTile(
                    context: context,
                    icon: Icons.library_add_outlined,
                    title: loc.translate('add_book'),
                    desc:
                        "Register new syllabus books and simulate PDF file downloads",
                    targetScreen: const AdminAddBookScreen(),
                  ),
                  const SizedBox(height: 12),

                  _buildAdminActionTile(
                    context: context,
                    icon: Icons.calendar_today_rounded,
                    title: loc.translate('add_timetable'),
                    desc:
                        "Configure general syllabus dates and topic lists template schedules",
                    targetScreen: Scaffold(
                      appBar: AppBar(
                        title: Text(loc.translate('add_timetable')),
                      ),
                      body: const Center(
                        child: Text(
                          "Syllabus Timetables are auto-managed by the system engine.",
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminActionTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String desc,
    required Widget targetScreen,
  }) {
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      child: InkWell(
        onTap: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => targetScreen));
        },
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.04),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.skyBlue, size: 24),
            ),
            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    desc,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.keyboard_arrow_right,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
