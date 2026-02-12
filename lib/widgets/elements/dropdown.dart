import 'package:flutter/material.dart';

import '../../common/app_colors.dart';
import '../../common/app_strings.dart';
import '../base_reactive_widget.dart';

class DropdownWidget extends ReactiveSurveyWidget {
  final void Function(dynamic)? onChanged; // <-- ADDED

  const DropdownWidget({
    super.key,
    required super.el,
    required super.engine,
    this.onChanged, // <-- ADDED
  });

  @override
  State<DropdownWidget> createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends ReactiveSurveyWidgetState<DropdownWidget> {
  @override
  Widget buildContent(BuildContext context) {
    final choices = widget.el.choices ?? const [];
    final current = value;

    final safeValue = choices.contains(current) ? current : null;

    if (!isVisible) return const SizedBox.shrink();

    final ro = isReadOnly;

    final borderColor =
        ro ? AppColors.greyReadOnlyColor : AppColors.primaryColor;

    final bgColor = ro ? AppColors.greyColor : AppColors.whiteColor;

    final textColor = ro ? AppColors.greyColor : AppColors.blackColor;

    final iconColor = ro ? Colors.grey : AppColors.primaryColor;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: bgColor,
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<dynamic>(
                isExpanded: true,
                menuMaxHeight: 300,
                value: safeValue,
                icon: Icon(Icons.arrow_drop_down, color: iconColor),
                hint: Text(
                  AppStrings.select,
                  style: TextStyle(color: textColor),
                ),
                items: choices.map((c) {
                  return DropdownMenuItem(
                    value: c,
                    child: Text(
                      c.toString(),
                      style: TextStyle(color: textColor),
                    ),
                  );
                }).toList(),
                onChanged: ro
                    ? null
                    : (v) {
                        // Prevent dropdown overlay glitch
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (widget.onChanged != null) {
                            widget.onChanged!(
                                v); // <-- NEW: matrix handles update
                          } else {
                            setValue(v); // <-- normal dropdown
                          }
                        });
                      },
              ),
            ),
          ),
          if (error != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(error!, style: const TextStyle(color: Colors.red)),
            ),
        ],
      ),
    );
  }
}
