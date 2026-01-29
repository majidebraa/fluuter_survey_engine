import 'package:flutter/material.dart';

class PanelCard extends StatefulWidget {
  final String? title;
  final List<Widget> children;

  const PanelCard({
    Key? key,
    this.title,
    required this.children,
  }) : super(key: key);

  @override
  State<PanelCard> createState() => _PanelCardState();
}

class _PanelCardState extends State<PanelCard> {
  bool _collapsed = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // 🔹 HEADER
          InkWell(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(12),
            ),
            onTap: () {
              setState(() => _collapsed = !_collapsed);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title ?? '',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: _collapsed ? 0.0 : 0.5,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(Icons.expand_more),
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
              child: Column(children: widget.children),
            ),
          ),
        ],
      ),
    );
  }
}
