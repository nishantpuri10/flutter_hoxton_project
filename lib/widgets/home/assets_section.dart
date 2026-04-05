import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AssetsSection extends StatelessWidget {
  const AssetsSection({super.key});

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
          _buildHeader(),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          _buildAssetRow(
            svgPath: 'assets/images/cashaccounts.svg',
            label: 'Cash Accounts',
            amount: 'USD 0.00',
            showAdd: true,
          ),
          const Divider(height: 1, indent: 68, color: Color(0xFFF0F0F0)),
          _buildAssetRow(
            svgPath: 'assets/images/investments.svg',
            label: 'Investments',
            amount: 'USD 4,000,000.00',
            showAdd: false,
          ),
          const Divider(height: 1, indent: 68, color: Color(0xFFF0F0F0)),
          _buildAssetRow(
            svgPath: 'assets/images/pension.svg',
            label: 'Pensions',
            amount: 'USD 4,000,000.00',
            showAdd: false,
          ),
          const Divider(height: 1, indent: 68, color: Color(0xFFF0F0F0)),
          _buildAssetRow(
            svgPath: 'assets/images/properties.svg',
            label: 'Properties',
            amount: 'USD 0.00',
            showAdd: true,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Assets',
            style: TextStyle(
              color: Color(0xFF111111),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFDDDDDD)),
            ),
            child: const Icon(Icons.add, size: 16, color: Color(0xFF333333)),
          ),
        ],
      ),
    );
  }

  Widget _buildAssetRow({
    required String svgPath,
    required String label,
    required String amount,
    required bool showAdd,
    bool isLast = false,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFDBF9F7),
              border: Border.all(
                color: const Color(0xFF8FE0D8),
                width: 1.5,
              ),
            ),
            padding: const EdgeInsets.all(9),
            child: SvgPicture.asset(
              svgPath,
              // colorFilter: const ColorFilter.mode(
              //   // Color(0xFF8FE0D8),
              //   // BlendMode.srcIn,
              // ),
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 158, 157, 157),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  amount,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 7, 7, 7),
                    fontSize: 12,
                    fontWeight: FontWeight.w600
                  ),
                ),
              ],
            ),
          ),
          if (showAdd)
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF0B3535),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Text(
                'Add',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          else
            const Icon(Icons.chevron_right_rounded,
                color: Color(0xFF4E5357), size: 25),
        ],
      ),
    );
  }
}
