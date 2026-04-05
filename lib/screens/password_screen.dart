import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_colors.dart';
import 'loading_screen.dart';

class PasswordScreen extends StatefulWidget {
  const PasswordScreen({super.key});

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final _passwordCtrl = TextEditingController();
  bool _obscure = true;
  String _password = '';

  // Requirements
  bool get _hasLength => _password.length >= 8 && _password.length <= 16;
  bool get _hasNumber => _password.contains(RegExp(r'[0-9]'));
  bool get _hasSpecial => _password.contains(RegExp(r'[!#@$%^&*(),.?:{}|<>]'));
  bool get _hasUpper => _password.contains(RegExp(r'[A-Z]'));
  bool get _hasLower => _password.contains(RegExp(r'[a-z]'));
  bool get _allMet => _hasLength && _hasNumber && _hasSpecial && _hasUpper && _hasLower;

  @override
  void dispose() {
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSetPassword() async {
    if (!_allMet) return;
    final auth = context.read<AuthProvider>();
    try {
      final success = await auth.completeLogin(password: _password);
      if (!mounted) return;
      if (success) {
        Navigator.of(context).pushAndRemoveUntil(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const LoadingScreen(),
            transitionsBuilder: (_, anim, __, child) =>
                FadeTransition(opacity: anim, child: child),
            transitionDuration: const Duration(milliseconds: 400),
          ),
          (route) => false,
        );
      }
    } catch (_) {
      if (!mounted) return;
      auth.resetStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: _buildBottomButton(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),
              _buildTitle(),
              const SizedBox(height: 32),
              _buildPasswordField(),
              const SizedBox(height: 24),
              _buildRequirements(),
              const SizedBox(height: 24),
              _buildSecurityNote(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Set Password',
          style: TextStyle(
            color: AppColors.lightTitle,
            fontSize: 32,
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Create a strong password to secure your account.',
          style: TextStyle(
            color: AppColors.lightSubtitle,
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Password',
          style: TextStyle(
            color: AppColors.lightLabel,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _passwordCtrl,
          obscureText: _obscure,
          autofocus: true,
          onChanged: (v) => setState(() => _password = v),
          style: const TextStyle(
            color: AppColors.lightTitle,
            fontSize: 15,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.lightInputBg,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscure
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColors.lightRequirementUnmet,
                size: 20,
              ),
              onPressed: () => setState(() => _obscure = !_obscure),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(
                  color: AppColors.lightInputBorder, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(
                  color: AppColors.lightInputBorder, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(
                  color: AppColors.lightInputBorderFocus, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRequirements() {
    final items = [
      ('8-16 characters only', _hasLength),
      ('Atleast 1 number', _hasNumber),
      ('Atleast 1 special character like !#@\$', _hasSpecial),
      ('Atleast 1 upper case character', _hasUpper),
      ('Atleast 1 lower case character', _hasLower),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Password Requirements:',
          style: TextStyle(
            color: AppColors.lightTitle,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: item.$2
                        ? AppColors.lightRequirementMet
                        : Colors.transparent,
                    border: Border.all(
                      color: item.$2
                          ? AppColors.lightRequirementMet
                          : AppColors.lightRequirementUnmet,
                      width: 1.5,
                    ),
                  ),
                  child: item.$2
                      ? const Icon(Icons.check,
                          size: 12, color: AppColors.white)
                      : null,
                ),
                const SizedBox(width: 12),
                Text(
                  item.$1,
                  style: TextStyle(
                    color: item.$2
                        ? AppColors.lightTitle
                        : AppColors.lightSubtitle,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityNote() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.lock_outline,
          color: AppColors.lightRequirementMet,
          size: 20,
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Text(
            'We use bank-grade encryption and multi-layer protection to keep your financial data safe from day one.',
            style: TextStyle(
              color: AppColors.lightSubtitle,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButton() {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: (_allMet && !auth.isLoading) ? _onSetPassword : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lightButtonBg,
                  disabledBackgroundColor:
                      AppColors.lightButtonBg.withValues(alpha: 0.4),
                  foregroundColor: AppColors.lightButtonText,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: auth.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.white,
                        ),
                      )
                    : const Text(
                        'Set Password',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                        ),
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}
