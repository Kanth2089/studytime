import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/language_selector.dart';
import '../providers/exams_provider.dart';

class ExamResultScreen extends StatelessWidget {
  const ExamResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final examsProvider = Provider.of<ExamsProvider>(context);
    final result = examsProvider.lastResult;
    final questions = examsProvider.questions;
    final userAnswers = result?.userAnswers ?? {};

    // In case no results loaded
    if (result == null) {
      return Scaffold(
        backgroundColor: AppColors.darkBg,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "No exam results available.",
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Go Back"),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          loc.translate('instant_result'),
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
                  // Performance Glass card
                  GlassContainer(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.stars_rounded,
                          color: AppColors.warning,
                          size: 60,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          loc.translate('instant_result'),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildResultMetric(
                              loc.translate('score'),
                              "${result.score}",
                            ),
                            _buildResultMetric(
                              loc.translate('correct_answers'),
                              "${result.correctAnswers}",
                            ),
                            _buildResultMetric(
                              loc.translate('wrong_answers'),
                              "${result.wrongAnswers}",
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.speed,
                              color: AppColors.skyBlue,
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "${loc.translate('accuracy')}: ${result.accuracy.toStringAsFixed(1)}%",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.skyBlue,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Questions Review list header
                  const Text(
                    "Question Review",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Display list of all questions with highlighting
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: questions.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final question = questions[index];
                      final isTelugu = loc.locale == 'te';

                      final questionText = isTelugu
                          ? question.questionTe
                          : question.questionEn;
                      final options = isTelugu
                          ? question.optionsTe
                          : question.optionsEn;
                      final explanationText = isTelugu
                          ? question.explanationTe
                          : question.explanationEn;

                      final int? selectedOption = userAnswers[question.id];
                      final bool isCorrect =
                          selectedOption == question.correctOptionIndex;

                      return GlassContainer(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Question header with index & state badge
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Question ${index + 1}",
                                  style: const TextStyle(
                                    color: AppColors.skyBlue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isCorrect
                                        ? AppColors.success.withValues(
                                            alpha: 0.15,
                                          )
                                        : AppColors.error.withValues(
                                            alpha: 0.15,
                                          ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    isCorrect ? "Correct" : "Incorrect",
                                    style: TextStyle(
                                      color: isCorrect
                                          ? AppColors.success
                                          : AppColors.error,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Question Text
                            Text(
                              questionText,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // 4 options with color highlights
                            ...List.generate(4, (oIdx) {
                              final optionChar = String.fromCharCode(65 + oIdx);
                              final bool isSelected = selectedOption == oIdx;
                              final bool isAnswerKey =
                                  question.correctOptionIndex == oIdx;

                              Color itemBg = Colors.white.withValues(
                                alpha: 0.02,
                              );
                              Color borderCol = Colors.white.withValues(
                                alpha: 0.08,
                              );
                              Color textCol = AppColors.textPrimary;
                              IconData? icon;

                              if (isAnswerKey) {
                                // Correct option is highlighted Green
                                itemBg = AppColors.success.withValues(
                                  alpha: 0.15,
                                );
                                borderCol = AppColors.success;
                                textCol = Colors.white;
                                icon = Icons.check_circle;
                              } else if (isSelected) {
                                // Selected wrong option is highlighted Red
                                itemBg = AppColors.error.withValues(
                                  alpha: 0.15,
                                );
                                borderCol = AppColors.error;
                                textCol = Colors.white;
                                icon = Icons.cancel;
                              }

                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: itemBg,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: borderCol),
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 12,
                                      backgroundColor: isAnswerKey
                                          ? AppColors.success
                                          : (isSelected
                                                ? AppColors.error
                                                : Colors.white12),
                                      child: Text(
                                        optionChar,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        options[oIdx],
                                        style: TextStyle(
                                          color: textCol,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                    if (icon != null)
                                      Icon(
                                        icon,
                                        color: isAnswerKey
                                            ? AppColors.success
                                            : AppColors.error,
                                        size: 16,
                                      ),
                                  ],
                                ),
                              );
                            }),
                            const SizedBox(height: 12),

                            // Detailed Explanation
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.04),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.06),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    loc.translate('explanation'),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: AppColors.skyBlue,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    explanationText,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Back button
                  ElevatedButton(
                    onPressed: () {
                      examsProvider.resetExam();
                      // Pop back to dashboard
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: Text(loc.translate('back_to_dashboard')),
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

  Widget _buildResultMetric(String title, String val) {
    return Column(
      children: [
        Text(
          val,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
