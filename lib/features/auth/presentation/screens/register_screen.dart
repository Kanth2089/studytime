import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/language_selector.dart';
import '../providers/auth_provider.dart';
import 'email_verification_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String _selectedGoal = 'Police SI';
  final bool _obscurePassword = true;

  final List<String> _goals = [
    'Police SI',
    'Police Constable',
    'Groups',
    'Banking',
    'Railway',
    'SSC',
    'UPSC',
    'TSPSC',
    'APPSC',
    'Defence',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.registerUser(
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      selectedGoal: _selectedGoal,
    );

    if (success && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const EmailVerificationScreen()),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage ?? "Registration failed"),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
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
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Language Selector Header
                    Align(
                      alignment: Alignment.topRight,
                      child: const LanguageSelector(),
                    ),
                    const SizedBox(height: 10),

                    // Title
                    Text(
                      loc.translate('register'),
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: AppColors.skyBlue.withValues(alpha: 0.5),
                                blurRadius: 12,
                              ),
                            ],
                          ),
                    ),
                    const SizedBox(height: 24),

                    // Registration Glass Card
                    GlassContainer(
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Name input
                            TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                labelText: loc.translate('name'),
                                prefixIcon: const Icon(
                                  Icons.person_outline,
                                  color: AppColors.skyBlue,
                                ),
                              ),
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return loc.translate('field_required');
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Email input
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: loc.translate('email'),
                                prefixIcon: const Icon(
                                  Icons.email_outlined,
                                  color: AppColors.skyBlue,
                                ),
                              ),
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return loc.translate('field_required');
                                }
                                if (!val.contains('@') || !val.contains('.')) {
                                  return loc.translate('invalid_email');
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Goal selection dropdown
                            DropdownButtonFormField<String>(
                              initialValue: _selectedGoal,
                              decoration: InputDecoration(
                                labelText: loc.translate('select_goal'),
                                prefixIcon: const Icon(
                                  Icons.flag_outlined,
                                  color: AppColors.skyBlue,
                                ),
                              ),
                              dropdownColor: AppColors.darkNavBg,
                              items: _goals.map((String goal) {
                                return DropdownMenuItem<String>(
                                  value: goal,
                                  child: Text(goal),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    _selectedGoal = newValue;
                                  });
                                }
                              },
                            ),
                            const SizedBox(height: 16),

                            // Password input
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                labelText: loc.translate('password'),
                                prefixIcon: const Icon(
                                  Icons.lock_outline,
                                  color: AppColors.skyBlue,
                                ),
                              ),
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return loc.translate('field_required');
                                }
                                if (val.length < 6) {
                                  return loc.translate('short_password');
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Confirm Password input
                            TextFormField(
                              controller: _confirmPasswordController,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                labelText: loc.translate('confirm_password'),
                                prefixIcon: const Icon(
                                  Icons.lock_outline,
                                  color: AppColors.skyBlue,
                                ),
                              ),
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return loc.translate('field_required');
                                }
                                if (val != _passwordController.text) {
                                  return loc.translate('passwords_dont_match');
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),

                            // Register Button
                            ElevatedButton(
                              onPressed: authProvider.isLoading
                                  ? null
                                  : _submit,
                              child: authProvider.isLoading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                  : Text(loc.translate('register')),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Back to Login Link
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        loc.translate('already_have_account'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
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
