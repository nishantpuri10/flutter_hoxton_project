import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_colors.dart';
import 'home_screen.dart';

enum _StepState { inactive, loading, done }

enum _Phase {
  settingProfile,   // ⟳ Profile | ○ Dashboard
  profileDone,      // ✅ Profile | ○ Dashboard  — "It will only take a moment"
  settingDashboard, // ✅ Profile | ⟳ Dashboard  — "You're nearly there..."
  allDone,          // ✅ Profile | ✅ Dashboard  — "Your personalized dashboard is ready!"
}

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  _Phase _phase = _Phase.settingProfile;
  int _dotCount = 1;

  @override
  void initState() {
    super.initState();
    _runSequence();
    _animateDots();
  }

  void _animateDots() async {
    while (mounted && _phase != _Phase.allDone) {
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted || _phase == _Phase.allDone) break;
      setState(() => _dotCount = (_dotCount % 3) + 1);
    }
  }

  Future<void> _runSequence() async {
    // Phase 1: Setting Profile (spinner)
    await Future.delayed(const Duration(milliseconds: 2200));
    if (!mounted) return;
    setState(() => _phase = _Phase.profileDone);

    // Phase 2: Profile done — brief hold before dashboard starts
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _phase = _Phase.settingDashboard);

    // Phase 3: Setting Up Dashboard (spinner) — subtitle → "You're nearly there..."
    await Future.delayed(const Duration(milliseconds: 2200));
    if (!mounted) return;
    setState(() => _phase = _Phase.allDone);

    // Phase 4: All done — hold then navigate to home
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const HomeScreen(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 600),
      ),
      (route) => false,
    );
  }

  String _getFirstName(String email) {
    final username = email.split('@').first;
    if (username.isEmpty) return '';
    return username[0].toUpperCase() + username.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final email = context.read<AuthProvider>().pendingEmail;
    final firstName = _getFirstName(email);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          _buildDecorativeCorners(),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTitle(),
                  const SizedBox(height: 12),
                  _buildSubtitle(firstName),
                  const SizedBox(height: 36),
                  _buildStep(
                    label: _phase == _Phase.settingProfile
                        ? 'Setting Profile'
                        : 'Profile Complete',
                    state: _stepStateFor(
                      loadingPhase: _Phase.settingProfile,
                      doneAfter: _Phase.profileDone,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildStep(
                    label: 'Setting Up Your Dashboard',
                    state: _stepStateFor(
                      loadingPhase: _Phase.settingDashboard,
                      doneAfter: _Phase.allDone,
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

  // Returns the correct StepState based on current phase
  _StepState _stepStateFor({
    required _Phase loadingPhase,
    required _Phase doneAfter,
  }) {
    if (_phase.index >= doneAfter.index) return _StepState.done;
    if (_phase == loadingPhase) return _StepState.loading;
    return _StepState.inactive;
  }

  Widget _buildTitle() {
    final isDone = _phase == _Phase.allDone;

    if (isDone) {
      return const Text(
        'Your personalized\ndashboard is ready!',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.white,
          fontSize: 28,
          fontWeight: FontWeight.w700,
          height: 1.3,
        ),
      );
    }

    const style = TextStyle(
      color: AppColors.white,
      fontSize: 28,
      fontWeight: FontWeight.w700,
      height: 1.3,
    );

    // Dots in a fixed-width SizedBox so "dashboard" never shifts
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'We are building your',
          textAlign: TextAlign.center,
          style: style,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            const Text('dashboard', style: style),
            SizedBox(
              width: 36, // wide enough for "..." — never shrinks
              child: Text(
                '.' * _dotCount,
                style: style,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSubtitle(String firstName) {
    final String text;
    if (_phase == _Phase.allDone) {
      text = 'All set!';
    } else if (_phase == _Phase.settingDashboard) {
      text = 'You\'re nearly there...';
    } else {
      text = firstName.isNotEmpty
          ? 'It will only take a moment, $firstName.'
          : 'It will only take a moment.';
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (child, anim) =>
          FadeTransition(opacity: anim, child: child),
      child: Text(
        text,
        key: ValueKey(text),
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.white.withValues(alpha: 0.65),
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildStep({
    required String label,
    required _StepState state,
  }) {
    final isInactive = state == _StepState.inactive;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 400),
      opacity: isInactive ? 0.35 : 1.0,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildStepIcon(state),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: isInactive
                  ? AppColors.white.withValues(alpha: 0.5)
                  : AppColors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIcon(_StepState state) {
    if (state == _StepState.loading) {
      return const SizedBox(
        width: 24,
        height: 24,
        child: _SpokeSpinner(),
      );
    }

    if (state == _StepState.done) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 24,
        height: 24,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.white,
        ),
        child: const Icon(
          Icons.check_rounded,
          size: 14,
          color: Color(0xFF033839),
        ),
      );
    }

    // Inactive — empty circle
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.4),
          width: 1.5,
        ),
      ),
    );
  }

  Widget _buildDecorativeCorners() {
    return Stack(
      children: [
        Positioned(
          top: -40,
          left: -40,
          child: Opacity(
            opacity: 0.08,
            child: Image.asset('assets/images/image.png', width: 200),
          ),
        ),
        Positioned(
          bottom: -50,
          right: -60,
          child: Opacity(
            opacity: 0.08,
            child: Image.asset('assets/images/image.png', width: 240),
          ),
        ),
      ],
    );
  }
}

// ── Spoke-style spinner ────────────────────────────────────────────────────
class _SpokeSpinner extends StatefulWidget {
  const _SpokeSpinner();

  @override
  State<_SpokeSpinner> createState() => _SpokeSpinnerState();
}

class _SpokeSpinnerState extends State<_SpokeSpinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => CustomPaint(
        painter: _SpokePainter(_ctrl.value),
      ),
    );
  }
}

class _SpokePainter extends CustomPainter {
  final double progress;

  const _SpokePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    const spokes = 8;
    final cx = size.width / 2;
    final cy = size.height / 2;
    final outerR = size.width / 2;
    final innerR = outerR * 0.42;
    final strokeW = size.width * 0.13;

    final activeSpoke = (progress * spokes).floor() % spokes;

    final paint = Paint()
      ..strokeWidth = strokeW
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < spokes; i++) {
      final angle = (i / spokes) * 2 * math.pi - math.pi / 2;
      final behind = (activeSpoke - i + spokes) % spokes;
      final opacity = (1.0 - (behind / spokes) * 0.85).clamp(0.15, 1.0);

      paint.color = Colors.white.withValues(alpha: opacity);

      final sx = cx + innerR * math.cos(angle);
      final sy = cy + innerR * math.sin(angle);
      final ex = cx + outerR * math.cos(angle);
      final ey = cy + outerR * math.sin(angle);

      canvas.drawLine(Offset(sx, sy), Offset(ex, ey), paint);
    }
  }

  @override
  bool shouldRepaint(_SpokePainter old) => old.progress != progress;
}
