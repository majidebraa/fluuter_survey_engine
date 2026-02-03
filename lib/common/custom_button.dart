import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'custom_text.dart';

class CustomButton extends StatelessWidget {
  final String? text;
  final VoidCallback? onClick; // Nullable to disable button
  final double width;
  final double height;
  final double cornerRadius;
  final Color textColor;
  final Color backgroundColor;
  final double fontSize;
  final bool isLoading;
  final bool isEnabled;
  final IconData? icon; // Optional icon

  const CustomButton({
    super.key,
    this.text,
    required this.onClick,
    this.width = 400,
    this.height = 55,
    this.cornerRadius = 8,
    this.textColor = AppColors.whiteColor,
    this.backgroundColor = AppColors.primaryColor,
    this.fontSize = 18,
    this.isLoading = false,
    this.isEnabled = true,
    this.icon, // New parameter
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: backgroundColor,
          strokeWidth: 2.0,
        ),
      );
    }

    return Opacity(
      opacity: isEnabled ? 1.0 : 0.9,
      child: SizedBox(
        width: width,
        height: height,
        child: ElevatedButton(
          onPressed: isEnabled ? onClick : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(cornerRadius),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    icon,
                    color: textColor,
                    size: fontSize + 10, // Slightly larger than text
                  ),
                ),
                const SizedBox(width: 8), // Space between icon and text
              ],
              CustomText(
                text: text ?? '',
                color: textColor,
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
