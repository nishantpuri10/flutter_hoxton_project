import 'dart:async';
import 'package:flutter/material.dart';

class NewsCarousel extends StatefulWidget {
  const NewsCarousel({super.key});

  @override
  State<NewsCarousel> createState() => _NewsCarouselState();
}

class _NewsCarouselState extends State<NewsCarousel> {
  final _controller = PageController();
  int _currentPage = 0;
  Timer? _timer;

  static const _articles = [
    _Article(
      title: 'How to Maximise Your 401(k) Contributions Throughout the Tax Year',
      description:
          "With the 2024 tax deadline now in the rear-view mirror, it's time to turn our attention towards it.",
      bgColor: Color(0xFFD4C5B0),
      imagePath: 'assets/images/image1.png',
    ),
    _Article(
      title: 'Understanding Tax Relief: Are You Leaving Money on the Table?',
      description:
          'Many people pay more tax than they need to. Tax relief exists to reduce what you owe, but ...',
      bgColor: Color(0xFFB8C9C4),
    ),
    _Article(
      title: 'How to Avoid Falling Victim to Investment Scams',
      description:
          'At Hoxton Wealth, we are committed to helping you secure your financial future.',
      bgColor: Color(0xFFC5C0BB),
    ),
    _Article(
      title: 'Time in the Market: The Key to Long-Term Financial Growth',
      description:
          'Investing can feel uncertain, especially when markets fall. Everyone knows the adage of ...',
      bgColor: Color(0xFF8A9BA8),
    ),
    _Article(
      title: "Non-residents' Guide to Double Taxation: How to Avoid Overpaying",
      description:
          'Moving abroad can come with financial benefits, but it also raises important tax questions.',
      bgColor: Color(0xFFB0B8C4),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      final next = (_currentPage + 1) % _articles.length;
      _controller.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 108,
            child: PageView.builder(
              controller: _controller,
              itemCount: _articles.length,
              onPageChanged: (i) => setState(() => _currentPage = i),
              itemBuilder: (context, i) => _buildArticleTile(_articles[i]),
            ),
          ),
          const SizedBox(height: 10),
          _buildDots(),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildArticleTile(_Article article) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: article.imagePath != null
                ? Image.asset(
                    article.imagePath!,
                    width: 88,
                    height: 80,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: 88,
                    height: 80,
                    color: article.bgColor,
                    child: const Icon(
                      Icons.article_outlined,
                      color: Colors.white54,
                      size: 28,
                    ),
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  article.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF111111),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  article.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF888888),
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_articles.length, (i) {
        final isActive = i == _currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 20 : 7,
          height: 7,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: isActive
                ? const Color(0xFF0B3535)
                : const Color(0xFFCCCCCC),
          ),
        );
      }),
    );
  }
}

class _Article {
  final String title;
  final String description;
  final Color bgColor;
  final String? imagePath;
  const _Article({
    required this.title,
    required this.description,
    required this.bgColor,
    this.imagePath,
  });
}
