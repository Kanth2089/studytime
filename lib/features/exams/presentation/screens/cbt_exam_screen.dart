import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/language_selector.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/exams_provider.dart';
import 'exam_result_screen.dart';

class CbtExamScreen extends StatelessWidget {
  final String categoryName;

  const CbtExamScreen({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final examsProvider = Provider.of<ExamsProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final userId = authProvider.currentUser?.uid ?? 'guest_user';

    final questions = examsProvider.questions;
    final currentIdx = examsProvider.currentIndex;
    final isLastQuestion = currentIdx == questions.length - 1;

    // Show loading
    if (examsProvider.isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.darkBg,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Show error
    if (examsProvider.errorMessage != null && questions.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.darkBg,
        appBar: AppBar(
          title: Text(categoryName),
          backgroundColor: Colors.transparent,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              examsProvider.errorMessage!,
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    if (questions.isEmpty) {
      return const Scaffold(
        backgroundColor: AppColors.darkBg,
        body: Center(child: Text("No questions loaded.")),
      );
    }

    final question = questions[currentIdx];
    final selectedOption = examsProvider.selectedAnswers[question.id];

    // Select text language based on current app locale
    final isTelugu = loc.locale == 'te';
    final questionText = isTelugu ? question.questionTe : question.questionEn;
    final options = isTelugu ? question.optionsTe : question.optionsEn;

    return WillPopScope(
      onWillPop: () async {
        // Confirm exit
        final exit = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: AppColors.darkNavBg,
            title: const Text(
              "Exit Exam?",
              style: TextStyle(color: Colors.white),
            ),
            content: const Text(
              "Are you sure you want to exit? Your progress will be lost.",
              style: TextStyle(color: AppColors.textSecondary),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  examsProvider.resetExam();
                  Navigator.of(context).pop(true);
                },
                child: const Text(
                  "Exit",
                  style: TextStyle(color: AppColors.error),
                ),
              ),
            ],
          ),
        );
        return exit ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            "$categoryName Exam",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          actions: [
            // Timer details
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.error.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.timer, color: AppColors.error, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    examsProvider.formattedTime,
                    style: const TextStyle(
                      color: AppColors.error,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            const LanguageSelector(isCompact: true),
            const SizedBox(width: 12),
          ],
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
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Question Count Indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${loc.translate('question')} ${currentIdx + 1} of ${questions.length}",
                          style: const TextStyle(
                            color: AppColors.skyBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Submit Button
                        ElevatedButton(
                          onPressed: () =>
                              _showSubmitDialog(context, examsProvider, userId),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.success,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                          ),
                          child: Text(
                            loc.translate('submit_exam'),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Question Card
                    Expanded(
                      child: GlassContainer(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              flex: 3,
                              child: SingleChildScrollView(
                                child: Text(
                                  questionText,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ),
                            const Divider(color: Colors.white10),
                            const SizedBox(height: 12),

                            // MCQ Options
                            Expanded(
                              flex: 7,
                              child: ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: 4,
                                separatorBuilder: (_, _) =>
                                    const SizedBox(height: 12),
                                itemBuilder: (context, idx) {
                                  final optionChar = String.fromCharCode(
                                    65 + idx,
                                  ); // A, B, C, D
                                  final isSelected = selectedOption == idx;

                                  return InkWell(
                                    onTap: () {
                                      examsProvider.selectOption(
                                        question.id,
                                        idx,
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? AppColors.skyBlue.withValues(
                                                alpha: 0.15,
                                              )
                                            : Colors.white.withValues(
                                                alpha: 0.04,
                                              ),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: isSelected
                                              ? AppColors.skyBlue
                                              : Colors.white.withValues(
                                                  alpha: 0.1,
                                                ),
                                          width: isSelected ? 1.5 : 1.0,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 14,
                                            backgroundColor: isSelected
                                                ? AppColors.skyBlue
                                                : Colors.white12,
                                            child: Text(
                                              optionChar,
                                              style: TextStyle(
                                                color: isSelected
                                                    ? Colors.black
                                                    : Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 14),
                                          Expanded(
                                            child: Text(
                                              options[idx],
                                              style: TextStyle(
                                                color: isSelected
                                                    ? Colors.white
                                                    : AppColors.textPrimary,
                                                fontSize: 14,
                                              ),
                                            ),
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
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Navigation buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlinedButton(
                          onPressed: currentIdx > 0
                              ? () => examsProvider.previousQuestion()
                              : null,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                          child: Text(
                            loc.translate('previous'),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        OutlinedButton(
                          onPressed: !isLastQuestion
                              ? () => examsProvider.nextQuestion()
                              : null,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                          child: Text(
                            loc.translate('next'),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Grid numbers palette
                    const Divider(color: Colors.white10),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 44,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: questions.length,
                        itemBuilder: (context, index) {
                          final isCurrent = index == currentIdx;
                          final isAnswered = examsProvider.selectedAnswers
                              .containsKey(questions[index].id);

                          return GestureDetector(
                            onTap: () {
                              examsProvider.jumpToQuestion(index);
                            },
                            child: Container(
                              width: 36,
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isCurrent
                                    ? AppColors.skyBlue
                                    : (isAnswered
                                          ? AppColors.skyBlue.withValues(
                                              alpha: 0.25,
                                            )
                                          : Colors.white.withValues(
                                              alpha: 0.05,
                                            )),
                                border: Border.all(
                                  color: isCurrent
                                      ? Colors.transparent
                                      : Colors.white24,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "${index + 1}",
                                style: TextStyle(
                                  color: isCurrent
                                      ? Colors.black
                                      : Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSubmitDialog(
    BuildContext context,
    ExamsProvider examsProvider,
    String userId,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.darkNavBg,
        title: const Text(
          "Submit Exam?",
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          "You have answered ${examsProvider.selectedAnswers.length} out of ${examsProvider.questions.length} questions.\nAre you sure you want to submit?",
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(); // pop dialog
              await examsProvider.submitExam(userId);

              if (context.mounted) {
                // Navigate to Results page replacement
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const ExamResultScreen()),
                );
              }
            },
            child: const Text(
              "Submit",
              style: TextStyle(
                color: AppColors.success,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
