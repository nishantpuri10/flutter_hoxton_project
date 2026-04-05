import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const HomeBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              // Home
              _SvgNavItem(
                svgPath: 'assets/images/dashboard.svg',
                label: 'Home',
                selected: selectedIndex == 0,
                onTap: () => onTap(0),
              ),
              // Assets & Liabilities — SVG
              _SvgNavItem(
                svgPath: 'assets/images/assets_liabilities_nav.svg',
                label: 'Assets & Liabilities',
                selected: selectedIndex == 1,
                onTap: () => onTap(1),
              ),
              // WealthFlow — SVG
              _SvgNavItem(
                svgPath: 'assets/images/wealthflow_nav.svg',
                label: 'WealthFlow',
                selected: selectedIndex == 2,
                onTap: () => onTap(2),
              ),
              // My Hoxton
              _SvgNavItem(
                svgPath: 'assets/images/vector.svg',
                label: 'My Hoxton',
                selected: selectedIndex == 3,
                onTap: () => onTap(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class _SvgNavItem extends StatelessWidget {
  final String svgPath;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SvgNavItem({
    required this.svgPath,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? const Color(0xFF0B3535) : const Color(0xFFAAAAAA);
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              svgPath,
              width: 22,
              height: 20,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),
            const SizedBox(height: 3),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                style: TextStyle(
                  color: color,
                  fontSize: 10,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

