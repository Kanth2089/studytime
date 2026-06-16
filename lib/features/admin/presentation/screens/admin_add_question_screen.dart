import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/language_selector.dart';
import '../../../exams/data/exams_service.dart';
import '../../../exams/domain/question_model.dart';

class AdminAddQuestionScreen extends StatefulWidget {
  const AdminAddQuestionScreen({super.key});

  @override
  State<AdminAddQuestionScreen> createState() => _AdminAddQuestionScreenState();
}

class _AdminAddQuestionScreenState extends State<AdminAddQuestionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _examsService = ExamsService();

  String _selectedCategory = 'Police';

  // Controller fields
  final _questionEnController = TextEditingController();
  final _questionTeController = TextEditingController();

  final List<TextEditingController> _optionsEnControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<TextEditingController> _optionsTeControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );

  int _correctOptionIndex = 0;

  final _explanationEnController = TextEditingController();
  final _explanationTeController = TextEditingController();

  bool _isSaving = false;

  @override
  void dispose() {
    _questionEnController.dispose();
    _questionTeController.dispose();
    for (var c in _optionsEnControllers) {
      c.dispose();
    }
    for (var c in _optionsTeControllers) {
      c.dispose();
    }
    _explanationEnController.dispose();
    _explanationTeController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    final newQuestion = QuestionModel(
      id: 'q_${const Uuid().v4()}',
      category: _selectedCategory,
      questionEn: _questionEnController.text.trim(),
      questionTe: _questionTeController.text.trim(),
      optionsEn: _optionsEnControllers.map((c) => c.text.trim()).toList(),
      optionsTe: _optionsTeControllers.map((c) => c.text.trim()).toList(),
      correctOptionIndex: _correctOptionIndex,
      explanationEn: _explanationEnController.text.trim(),
      explanationTe: _explanationTeController.text.trim(),
    );

    try {
      await _examsService.addQuestion(newQuestion);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Question added successfully!"),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: $e"),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final List<String> categories = [
      'Police',
      'Banking',
      'Railway',
      'SSC',
      'Groups',
      'TSPSC',
      'APPSC',
      'UPSC',
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          loc.translate('add_question'),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 16,
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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GlassContainer(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Category Selector
                          DropdownButtonFormField<String>(
                            initialValue: _selectedCategory,
                            decoration: const InputDecoration(
                              labelText: "Exam Category",
                            ),
                            dropdownColor: AppColors.darkNavBg,
                            items: categories.map((cat) {
                              return DropdownMenuItem(
                                value: cat,
                                child: Text(cat),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                  _selectedCategory = val;
                                });
                              }
                            },
                          ),
                          const SizedBox(height: 16),

                          // English Question
                          TextFormField(
                            controller: _questionEnController,
                            decoration: const InputDecoration(
                              labelText: "Question Text (English)",
                            ),
                            maxLines: 2,
                            validator: (val) =>
                                val == null || val.isEmpty ? "Required" : null,
                          ),
                          const SizedBox(height: 12),

                          // Telugu Question
                          TextFormField(
                            controller: _questionTeController,
                            decoration: const InputDecoration(
                              labelText: "Question Text (తెలుగు)",
                            ),
                            maxLines: 2,
                            validator: (val) =>
                                val == null || val.isEmpty ? "Required" : null,
                          ),
                          const Divider(height: 32, color: Colors.white10),

                          // 4 Options English
                          const Text(
                            "Options (English)",
                            style: TextStyle(
                              color: AppColors.skyBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...List.generate(4, (index) {
                            final label = String.fromCharCode(65 + index);
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: TextFormField(
                                controller: _optionsEnControllers[index],
                                decoration: InputDecoration(
                                  labelText: "Option $label",
                                ),
                                validator: (val) => val == null || val.isEmpty
                                    ? "Required"
                                    : null,
                              ),
                            );
                          }),

                          const Divider(height: 32, color: Colors.white10),

                          // 4 Options Telugu
                          const Text(
                            "Options (తెలుగు)",
                            style: TextStyle(
                              color: AppColors.skyBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...List.generate(4, (index) {
                            final label = String.fromCharCode(65 + index);
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: TextFormField(
                                controller: _optionsTeControllers[index],
                                decoration: InputDecoration(
                                  labelText: "Option $label",
                                ),
                                validator: (val) => val == null || val.isEmpty
                                    ? "Required"
                                    : null,
                              ),
                            );
                          }),

                          const Divider(height: 32, color: Colors.white10),

                          // Correct Option Index selector
                          DropdownButtonFormField<int>(
                            initialValue: _correctOptionIndex,
                            decoration: const InputDecoration(
                              labelText: "Correct Option Key",
                            ),
                            dropdownColor: AppColors.darkNavBg,
                            items: const [
                              DropdownMenuItem(
                                value: 0,
                                child: Text("Option A"),
                              ),
                              DropdownMenuItem(
                                value: 1,
                                child: Text("Option B"),
                              ),
                              DropdownMenuItem(
                                value: 2,
                                child: Text("Option C"),
                              ),
                              DropdownMenuItem(
                                value: 3,
                                child: Text("Option D"),
                              ),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                  _correctOptionIndex = val;
                                });
                              }
                            },
                          ),
                          const SizedBox(height: 16),

                          // English Explanation
                          TextFormField(
                            controller: _explanationEnController,
                            decoration: const InputDecoration(
                              labelText: "Explanation (English)",
                            ),
                            maxLines: 2,
                            validator: (val) =>
                                val == null || val.isEmpty ? "Required" : null,
                          ),
                          const SizedBox(height: 12),

                          // Telugu Explanation
                          TextFormField(
                            controller: _explanationTeController,
                            decoration: const InputDecoration(
                              labelText: "Explanation (తెలుగు)",
                            ),
                            maxLines: 2,
                            validator: (val) =>
                                val == null || val.isEmpty ? "Required" : null,
                          ),
                          const SizedBox(height: 24),

                          // Save Button
                          ElevatedButton(
                            onPressed: _isSaving ? null : _save,
                            child: _isSaving
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.0,
                                    ),
                                  )
                                : Text(loc.translate('save')),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
