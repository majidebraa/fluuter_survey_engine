import 'package:flutter/material.dart';

import '../../common/app_colors.dart';
import '../../common/custom_text.dart';


class PanelCard extends StatefulWidget {
  final String? title;
  final List<Widget> children;

  const PanelCard({super.key, this.title, required this.children});

  @override
  State<PanelCard> createState() => _PanelCardState();
}

class _PanelCardState extends State<PanelCard> {
  bool _collapsed = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: AppColors.whiteColor,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          // 🔹 HEADER
          InkWell(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            onTap: () => setState(() => _collapsed = !_collapsed),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: CustomText(
                      text: widget.title ?? '',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                      textAlign: TextAlign.right,
                    ),
                  ),
                  AnimatedRotation(
                    turns: _collapsed ? 0.0 : 0.5,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(
                      Icons.expand_more,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 🔹 BODY
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            crossFadeState: _collapsed
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Column(
                children: widget.children.map((child) {
                  // Wrap each child to force rebuild even if hidden
                  return Builder(builder: (_) => child);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
