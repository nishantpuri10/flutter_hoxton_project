import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/home/home_header.dart';
import '../widgets/home/net_worth_chart.dart';
import '../widgets/home/assets_liabilities_summary.dart';
import '../widgets/home/assets_section.dart';
import '../widgets/home/liabilities_section.dart';
import '../widgets/home/wealthflow_card.dart';
import '../widgets/home/watchlist_card.dart';
import '../widgets/home/services_grid.dart';
import '../widgets/home/news_carousel.dart';
import '../widgets/home_bottom_nav.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color(0xFFDBF9F7),
      statusBarIconBrightness: Brightness.dark,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F5F4),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Extends behind the status bar
            Container(
              color: const Color(0xFFDBF9F7),
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).padding.top),
                  const HomeHeader(),
                  const NetWorthChart(),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const AssetsLiabilitiesSummary(),
            const AssetsSection(),
            const LiabilitiesSection(),
            const SizedBox(height: 6),
            const WealthFlowCard(),
            const WatchlistCard(),
            const ServicesGrid(),
            const NewsCarousel(),
            const SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: HomeBottomNav(
        selectedIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
      ),
    );
  }
}
