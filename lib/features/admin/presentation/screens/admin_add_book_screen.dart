import 'dart:async';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/language_selector.dart';
import '../../../books/data/books_service.dart';
import '../../../books/domain/book_model.dart';

class AdminAddBookScreen extends StatefulWidget {
  const AdminAddBookScreen({super.key});

  @override
  State<AdminAddBookScreen> createState() => _AdminAddBookScreenState();
}

class _AdminAddBookScreenState extends State<AdminAddBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final _booksService = BooksService();

  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _sizeController = TextEditingController(text: "12.0 MB");
  String _selectedCategory = 'Police';

  double _uploadProgress = 0.0;
  bool _isUploading = false;
  bool _isSaving = false;
  String? _uploadedUrl;

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _sizeController.dispose();
    super.dispose();
  }

  // Simulated PDF upload
  void _simulateUpload() {
    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
    });

    Timer.periodic(const Duration(milliseconds: 150), (timer) {
      setState(() {
        _uploadProgress += 0.05;
        if (_uploadProgress >= 1.0) {
          _uploadProgress = 1.0;
          _isUploading = false;
          _uploadedUrl = "https://example.com/books/${widget.hashCode}.pdf";
          timer.cancel();
        }
      });
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    if (_uploadedUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please upload a PDF file first"),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final newBook = BookModel(
      id: 'b_${const Uuid().v4()}',
      title: _titleController.text.trim(),
      author: _authorController.text.trim(),
      category: _selectedCategory,
      pdfUrl: _uploadedUrl!,
      fileSize: _sizeController.text.trim(),
      isFavorite: false,
      isDownloaded: false,
    );

    try {
      await _booksService.addBook(newBook);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Book registered successfully!"),
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
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          loc.translate('add_book'),
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
                          // Book Title
                          TextFormField(
                            controller: _titleController,
                            decoration: const InputDecoration(
                              labelText: "Book Title",
                            ),
                            validator: (val) =>
                                val == null || val.isEmpty ? "Required" : null,
                          ),
                          const SizedBox(height: 16),

                          // Author
                          TextFormField(
                            controller: _authorController,
                            decoration: const InputDecoration(
                              labelText: "Author Name",
                            ),
                            validator: (val) =>
                                val == null || val.isEmpty ? "Required" : null,
                          ),
                          const SizedBox(height: 16),

                          // Category select
                          DropdownButtonFormField<String>(
                            initialValue: _selectedCategory,
                            decoration: const InputDecoration(
                              labelText: "Category",
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

                          // File Size
                          TextFormField(
                            controller: _sizeController,
                            decoration: const InputDecoration(
                              labelText: "File Size (e.g. 5.4 MB)",
                            ),
                            validator: (val) =>
                                val == null || val.isEmpty ? "Required" : null,
                          ),
                          const SizedBox(height: 24),

                          // Simulated PDF Upload
                          if (_isUploading)
                            Container(
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.white10),
                              ),
                              child: Stack(
                                children: [
                                  FractionallySizedBox(
                                    widthFactor: _uploadProgress,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: AppColors.accentGradient,
                                        ),
                                        borderRadius: BorderRadius.circular(11),
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      "Uploading PDF: ${(_uploadProgress * 100).toInt()}%",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else if (_uploadedUrl != null)
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.success.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.success),
                              ),
                              child: Row(
                                children: const [
                                  Icon(
                                    Icons.check_circle,
                                    color: AppColors.success,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "PDF Uploaded Successfully!",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
                            OutlinedButton.icon(
                              onPressed: _simulateUpload,
                              icon: const Icon(Icons.cloud_upload_outlined),
                              label: const Text("Select and Upload PDF File"),
                            ),

                          const SizedBox(height: 32),

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
