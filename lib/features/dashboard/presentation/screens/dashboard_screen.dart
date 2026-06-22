import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/language_selector.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../../../timetable/presentation/screens/timetable_screen.dart';
import '../../../books/presentation/screens/books_screen.dart';
import '../../../exams/presentation/screens/exams_list_screen.dart';
import '../../../admin/presentation/screens/admin_dashboard_screen.dart';
import '../../../timetable/presentation/providers/timetable_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.currentUser != null) {
        Provider.of<TimetableProvider>(
          context,
          listen: false,
        ).loadActiveTimetable(authProvider.currentUser!.uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;
    final timetableProvider = Provider.of<TimetableProvider>(context);
    final activeTimetable = timetableProvider.activeTimetable;

    final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final todayDays = activeTimetable?.days.where((d) => d.date == todayStr).toList() ?? [];

    Widget studyFocusWidget;
    if (activeTimetable == null) {
      studyFocusWidget = GlassContainer(
        padding: const EdgeInsets.all(16),
        borderRadius: 20,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.calendar_today_rounded, color: AppColors.skyBlue, size: 20),
                const SizedBox(width: 8),
                Text(
                  loc.translate('timetable_card'),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              loc.translate('no_timetable'),
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const TimetableScreen()),
                );
              },
              icon: const Icon(Icons.flash_on, size: 16),
              label: Text(loc.translate('generate_timetable'), style: const TextStyle(fontSize: 12)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
          ],
        ),
      );
    } else if (todayDays.isEmpty) {
      studyFocusWidget = GlassContainer(
        padding: const EdgeInsets.all(16),
        borderRadius: 20,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.calendar_today_rounded, color: AppColors.skyBlue, size: 20),
                const SizedBox(width: 8),
                Text(
                  loc.translate('timetable_card'),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              "No study tasks scheduled for today (${DateFormat('dd MMM yyyy').format(DateTime.now())}). Enjoy your rest or plan ahead!",
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const TimetableScreen()),
                );
              },
              icon: const Icon(Icons.calendar_month, size: 16),
              label: const Text("View Timetable", style: TextStyle(fontSize: 12)),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
          ],
        ),
      );
    } else {
      studyFocusWidget = GlassContainer(
        padding: const EdgeInsets.all(16),
        borderRadius: 20,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.calendar_today_rounded, color: AppColors.skyBlue, size: 20),
                    SizedBox(width: 8),
                    Text(
                      "Today's Study Focus",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Text(
                  activeTimetable.examCategory,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.skyBlue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...todayDays.map((item) {
              final originalIndex = activeTimetable.days.indexOf(item);
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.access_time, size: 12, color: AppColors.textSecondary),
                              const SizedBox(width: 4),
                              Text(
                                item.time,
                                style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.subject,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            item.topic,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.skyBlue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Checkbox(
                      value: item.isCompleted,
                      activeColor: AppColors.success,
                      checkColor: Colors.white,
                      onChanged: (val) {
                        if (originalIndex != -1) {
                          timetableProvider.toggleDay(originalIndex);
                        }
                      },
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          loc.translate('dashboard'),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.skyBlue,
                child: Text(
                  user?.name.isNotEmpty == true
                      ? user!.name[0].toUpperCase()
                      : 'S',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          const LanguageSelector(isCompact: true),
          const SizedBox(width: 12),
        ],
      ),
      drawer: _buildDrawer(context, user, loc, authProvider),
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
          CustomPaint(size: Size.infinite, painter: ExamBackgroundPainter()),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 10),
                  GlassContainer(
                    padding: const EdgeInsets.all(20),
                    borderRadius: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hello, ${user?.name ?? 'Student'}!",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${loc.translate('goal')}: ${user?.selectedGoal ?? 'Police SI'}",
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.skyBlue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(
                              Icons.local_fire_department,
                              color: AppColors.warning,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "${user?.studyStreak ?? 0} ${loc.translate('days')} ${loc.translate('streak')}",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  studyFocusWidget,
                  const SizedBox(height: 24),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.15,
                    children: [
                      _buildDashboardCard(
                        context: context,
                        icon: Icons.calendar_today_rounded,
                        title: loc.translate('timetable_card'),
                        desc: loc.translate('timetable_desc'),
                        targetScreen: const TimetableScreen(),
                      ),
                      _buildDashboardCard(
                        context: context,
                        icon: Icons.assignment_turned_in_outlined,
                        title: loc.translate('exams_card'),
                        desc: loc.translate('exams_desc'),
                        targetScreen: const ExamsListScreen(),
                      ),
                      _buildDashboardCard(
                        context: context,
                        icon: Icons.menu_book_sharp,
                        title: loc.translate('books_card'),
                        desc: loc.translate('books_desc'),
                        targetScreen: const BooksScreen(),
                      ),
                      _buildDashboardCard(
                        context: context,
                        icon: Icons.person_rounded,
                        title: loc.translate('profile_card'),
                        desc: loc.translate('profile_desc'),
                        targetScreen: const ProfileScreen(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const AdminDashboardScreen(),
                        ),
                      );
                    },
                    child: GlassContainer(
                      borderRadius: 16,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.admin_panel_settings_outlined,
                            color: AppColors.skyBlue,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            loc.translate('admin_panel'),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.skyBlue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String desc,
    required Widget targetScreen,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => targetScreen));
      },
      child: GlassContainer(
        borderRadius: 16,
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.skyBlue.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 22, color: AppColors.skyBlue),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, user, loc, authProvider) {
    return Drawer(
      child: Container(
        color: AppColors.darkBg,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: AppColors.border)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: AppColors.skyBlue,
                      child: Text(
                        user?.name.isNotEmpty == true
                            ? user!.name[0].toUpperCase()
                            : 'S',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      user?.name ?? 'Student Name',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      user?.email ?? 'email@domain.com',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.dashboard, color: AppColors.skyBlue),
                title: Text(
                  loc.translate('dashboard'),
                  style: const TextStyle(color: Colors.white),
                ),
                onTap: () => Navigator.of(context).pop(),
              ),
              ListTile(
                leading: const Icon(
                  Icons.admin_panel_settings,
                  color: AppColors.skyBlue,
                ),
                title: Text(
                  loc.translate('admin_panel'),
                  style: const TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const AdminDashboardScreen(),
                    ),
                  );
                },
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 12.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () async {
                        await authProvider.logout();
                        if (context.mounted) {
                          Navigator.of(context).pushReplacementNamed('/');
                        }
                      },
                      icon: const Icon(Icons.logout),
                      label: Text(loc.translate('logout')),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error.withValues(alpha: 0.8),
                        foregroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      loc.translate('select_language'),
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Center(child: LanguageSelector()),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExamBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.skyBlue.withValues(alpha: 0.04)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    for (double i = 0; i < size.width; i += 40) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += 40) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }

    final capPaint = Paint()
      ..color = AppColors.skyBlue.withValues(alpha: 0.06)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final capPath = Path();
    capPath.moveTo(size.width * 0.2, size.height * 0.7);
    capPath.lineTo(size.width * 0.45, size.height * 0.62);
    capPath.lineTo(size.width * 0.7, size.height * 0.7);
    capPath.lineTo(size.width * 0.45, size.height * 0.78);
    capPath.close();

    capPath.moveTo(size.width * 0.32, size.height * 0.725);
    capPath.lineTo(size.width * 0.32, size.height * 0.8);
    capPath.quadraticBezierTo(
      size.width * 0.45,
      size.height * 0.88,
      size.width * 0.58,
      size.height * 0.8,
    );
    capPath.lineTo(size.width * 0.58, size.height * 0.725);

    capPath.moveTo(size.width * 0.45, size.height * 0.7);
    capPath.lineTo(size.width * 0.68, size.height * 0.71);
    capPath.lineTo(size.width * 0.68, size.height * 0.77);

    canvas.drawPath(capPath, capPaint);

    final bookPath = Path();
    bookPath.moveTo(size.width * 0.8, size.height * 0.15);
    bookPath.lineTo(size.width * 0.92, size.height * 0.1);
    bookPath.lineTo(size.width * 0.92, size.height * 0.3);
    bookPath.lineTo(size.width * 0.8, size.height * 0.35);
    bookPath.close();

    bookPath.moveTo(size.width * 0.8, size.height * 0.15);
    bookPath.lineTo(size.width * 0.68, size.height * 0.1);
    bookPath.lineTo(size.width * 0.68, size.height * 0.3);
    bookPath.lineTo(size.width * 0.8, size.height * 0.35);

    canvas.drawPath(bookPath, capPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
