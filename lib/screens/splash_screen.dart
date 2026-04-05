import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'loading_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Phase 1 — logo fade in
  late AnimationController _fadeCtrl;

  // Phase 2 — logo slides left + "HoxtonWealth" types in
  late AnimationController _slideCtrl;
  late Animation<double> _logoOffset;
  late Animation<double> _brandReveal;
  late Animation<double> _brandOpacity;

  // Phase 3 — title text reveals ("Take Control" → rest)
  late AnimationController _titleCtrl;

  // Phase 4 — title + logo row slides to top
  late AnimationController _moveCtrl;

  // Phase 5 — feature items stagger in + button fades in
  late AnimationController _featuresCtrl;

  @override
  void initState() {
    super.initState();

    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _slideCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _logoOffset = Tween<double>(begin: 0.0, end: -68.0).animate(
      CurvedAnimation(parent: _slideCtrl, curve: Curves.easeInOut),
    );
    _brandReveal = CurvedAnimation(
      parent: _slideCtrl,
      curve: const Interval(0.15, 1.0, curve: Curves.easeOut),
    );
    _brandOpacity = CurvedAnimation(
      parent: _slideCtrl,
      curve: const Interval(0.1, 0.45, curve: Curves.easeIn),
    );

    _titleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _moveCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );

    _featuresCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _runSequence();
  }

  Future<void> _runSequence() async {
    // Phase 1: logo fades in
    await _fadeCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 800));

    // Phase 2: logo slides left + brand types in
    await _slideCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 1000));

    // Phase 3: title text reveals
    await _titleCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 300));

    // Phase 4: title moves to top
    await _moveCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 200));

    // Phase 5: features stagger in
    await _featuresCtrl.forward();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _slideCtrl.dispose();
    _titleCtrl.dispose();
    _moveCtrl.dispose();
    _featuresCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final safeTop = MediaQuery.of(context).padding.top;

    // Title animates from vertical center to top
    final titleStartTop = screenHeight * 0.30;
    final titleEndTop = safeTop + 24.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          _buildDecorativeCorners(),

          // ── Logo + HoxtonWealth row ──────────────────────────────────
          Center(
            child: AnimatedBuilder(
              animation: Listenable.merge([_fadeCtrl, _slideCtrl, _titleCtrl]),
              builder: (context, _) {
                // Fade out logo row as title starts appearing
                final logoRowOpacity =
                    (1.0 - _titleCtrl.value * 2.5).clamp(0.0, 1.0) *
                        _fadeCtrl.value;

                return Opacity(
                  opacity: logoRowOpacity,
                  child: SizedBox(
                    width: 260,
                    height: 48,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          left: 90 + _logoOffset.value,
                          top: 0,
                          child: Image.asset(
                            'assets/images/image.png',
                            width: 40,
                            height: 48,
                            fit: BoxFit.contain,
                          ),
                        ),
                        if (_slideCtrl.value > 0)
                          Positioned(
                            left: 90 + _logoOffset.value + 48,
                            top: 0,
                            bottom: 0,
                            child: Opacity(
                              opacity: _brandOpacity.value,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: _TypedText(
                                  text: 'HoxtonWealth',
                                  progress: _brandReveal.value,
                                  style: const TextStyle(
                                    color: AppColors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
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

          // ── Title: "Take Control…" ───────────────────────────────────
          AnimatedBuilder(
            animation: Listenable.merge([_titleCtrl, _moveCtrl]),
            builder: (context, _) {
              if (_titleCtrl.value == 0) return const SizedBox.shrink();

              final currentTop = titleStartTop +
                  (titleEndTop - titleStartTop) *
                      CurvedAnimation(
                        parent: _moveCtrl,
                        curve: Curves.easeInOut,
                      ).value;

              return Positioned(
                top: currentTop,
                left: 24,
                right: 24,
                child: _buildTitle(),
              );
            },
          ),

          // ── Feature items ────────────────────────────────────────────
          AnimatedBuilder(
            animation: _featuresCtrl,
            builder: (context, _) {
              if (_featuresCtrl.value == 0) return const SizedBox.shrink();
              return Positioned(
                top: titleEndTop + 190,
                left: 24,
                right: 24,
                child: _buildFeatures(),
              );
            },
          ),

          // ── Get started button ───────────────────────────────────────
          AnimatedBuilder(
            animation: _featuresCtrl,
            builder: (context, _) {
              final buttonOpacity =
                  ((_featuresCtrl.value - 0.8) / 0.2).clamp(0.0, 1.0);
              if (buttonOpacity == 0) return const SizedBox.shrink();
              return Positioned(
                bottom: 40,
                left: 24,
                right: 24,
                child: Opacity(
                  opacity: buttonOpacity,
                  child: _buildGetStartedButton(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ── Title widget ──────────────────────────────────────────────────────
  Widget _buildTitle() {
    return AnimatedBuilder(
      animation: _titleCtrl,
      builder: (context, _) {
        const takeControl = 'Take Control';
        const rest = ' of Your\nWealth with Hoxton\nWealth App';

        // "Take Control" types in from 0 → 0.45 of controller
        final tcProgress = (_titleCtrl.value / 0.45).clamp(0.0, 1.0);
        // Rest types in from 0.45 → 1.0 of controller
        final restProgress =
            ((_titleCtrl.value - 0.45) / 0.55).clamp(0.0, 1.0);

        final tcVisible =
            (tcProgress * takeControl.length).ceil().clamp(0, takeControl.length);
        final restVisible =
            (restProgress * rest.length).ceil().clamp(0, rest.length);

        const whiteStyle = TextStyle(
          color: AppColors.white,
          fontSize: 34,
          fontWeight: FontWeight.w700,
          height: 1.25,
        );
        const accentStyle = TextStyle(
          color: AppColors.accent,
          fontSize: 34,
          fontWeight: FontWeight.w700,
          height: 1.25,
        );
        const hiddenStyle = TextStyle(
          color: Colors.transparent,
          fontSize: 34,
          fontWeight: FontWeight.w700,
          height: 1.25,
        );

        return RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: takeControl.substring(0, tcVisible),
                style: whiteStyle,
              ),
              TextSpan(
                text: takeControl.substring(tcVisible),
                style: hiddenStyle,
              ),
              TextSpan(
                text: rest.substring(0, restVisible),
                style: accentStyle,
              ),
              TextSpan(
                text: rest.substring(restVisible),
                style: hiddenStyle,
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Feature list ──────────────────────────────────────────────────────
  static const _features = [
    (Icons.pie_chart_outline_rounded, 'Organize Your Finances in One Place'),
    (Icons.language_rounded, 'Track Your Financial Performance'),
    (Icons.headset_mic_outlined, 'Free, Intuitive, and Backed by\nFinancial Experts'),
    (Icons.send_rounded, 'Plan Your Financial Future'),
    (Icons.verified_user_outlined, 'Security You Can Trust'),
  ];

  Widget _buildFeatures() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(_features.length, (i) {
        // Stagger: each item starts 0.16 apart
        final start = i * 0.16;
        final end = (start + 0.35).clamp(0.0, 1.0);
        final itemOpacity =
            ((_featuresCtrl.value - start) / (end - start)).clamp(0.0, 1.0);

        return Opacity(
          opacity: itemOpacity,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 22),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF0F4040),
                  ),
                  child: Icon(
                    _features[i].$1,
                    color: AppColors.accent,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    _features[i].$2,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  // ── Get started button ─────────────────────────────────────────────────
  Widget _buildGetStartedButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: OutlinedButton(
        onPressed: () {
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => const LoadingScreen(),
              transitionsBuilder: (_, anim, __, child) =>
                  FadeTransition(opacity: anim, child: child),
              transitionDuration: const Duration(milliseconds: 500),
            ),
          );
        },
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.white, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: const Text(
          'Get started',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }

  // ── Decorative corners ─────────────────────────────────────────────────
  Widget _buildDecorativeCorners() {
    return Stack(
      children: [
        Positioned(
          top: -40,
          left: -40,
          child: Opacity(
            opacity: 0.08,
            child: Image.asset(
              'assets/images/image.png',
              width: 200,
              height: 200,
            ),
          ),
        ),
        Positioned(
          bottom: -50,
          right: -60,
          child: Opacity(
            opacity: 0.08,
            child: Image.asset(
              'assets/images/image.png',
              width: 240,
              height: 240,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Inline typed text helper ───────────────────────────────────────────────
class _TypedText extends StatelessWidget {
  final String text;
  final double progress;
  final TextStyle? style;

  const _TypedText({
    required this.text,
    required this.progress,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final visible = (progress * text.length).ceil().clamp(0, text.length);
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: text.substring(0, visible), style: style),
          TextSpan(
            text: text.substring(visible),
            style: style?.copyWith(color: Colors.transparent),
          ),
        ],
      ),
    );
  }
}
