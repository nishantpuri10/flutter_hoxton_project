import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          _buildDecorativeCorners(),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Pulsing logo
                ScaleTransition(
                  scale: _pulseAnimation,
                  child: Image.asset(
                    'assets/images/image.png',
                    width: 48,
                    height: 48,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 32),
                // Dots loading indicator
                _DotsLoader(),
              ],
            ),
          ),
        ],
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

class _DotsLoader extends StatefulWidget {
  @override
  State<_DotsLoader> createState() => _DotsLoaderState();
}

class _DotsLoaderState extends State<_DotsLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final delay = i / 3;
            final t = ((_controller.value - delay + 1) % 1);
            final opacity = t < 0.5
                ? (t * 2).clamp(0.3, 1.0)
                : ((1 - t) * 2).clamp(0.3, 1.0);
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white.withValues(alpha: opacity),
              ),
            );
          }),
        );
      },
    );
  }
}
